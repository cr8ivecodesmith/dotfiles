#!/bin/bash

# Global variables
DRY_RUN=false
SPECIFIC_DATE=""
SPECIFIC_TARGET=""

# ============================================================================
# Helper Functions
# ============================================================================

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Rollback symlinks to their latest backup."
  echo ""
  echo "Options:"
  echo "  --dry-run      Show what would be restored without making changes"
  echo "  --date DATE    Rollback to specific date (format: YYYYMMDD or YYYYMMDD{N})"
  echo "  --target PATH  Rollback only a specific target path"
  echo ""
  echo "Examples:"
  echo "  $0                           # Rollback all latest backups"
  echo "  $0 --dry-run                 # Preview rollback actions"
  echo "  $0 --date 20260220           # Rollback to specific date"
  echo "  $0 --target ~/.bashrc        # Rollback only .bashrc"
  exit 1
}

expand_home_path() {
  local path="$1"
  echo "${path/#\~/$HOME}"
}

# ============================================================================
# Backup Discovery Functions
# ============================================================================

find_latest_backup() {
  local base_path="$1"
  local pattern="${base_path}.[0-9]*"
  
  # Find all backups matching the pattern
  local backups=()
  while IFS= read -r -d '' backup; do
    backups+=("$backup")
  done < <(find "$(dirname "$base_path")" -maxdepth 1 -name "$(basename "$base_path").[0-9]*" -print0 2>/dev/null | sort -z -r)
  
  if [ "${#backups[@]}" -eq 0 ]; then
    return 1
  fi
  
  # If specific date requested, find that backup
  if [ -n "$SPECIFIC_DATE" ]; then
    for backup in "${backups[@]}"; do
      if [[ "$backup" =~ \.${SPECIFIC_DATE}[0-9]*$ ]]; then
        echo "$backup"
        return 0
      fi
    done
    return 1
  fi
  
  # Return the most recent backup (first in reverse sorted list)
  echo "${backups[0]}"
  return 0
}

scan_for_backups() {
  local search_dir="$HOME"
  local backups=()
  
  echo "Scanning for backups in '$search_dir'..."
  echo "----------------------------------------"
  
  # Find all backup files (pattern: *.<date>[<counter>])
  # More specific: must be exactly 8 digits, optionally followed by more digits
  while IFS= read -r -d '' backup; do
    local basename=$(basename "$backup")
    # Extract the original path by removing the timestamp suffix
    # Pattern: ends with .YYYYMMDD or .YYYYMMDD<digits>
    if [[ "$backup" =~ ^(.+)\.([0-9]{8}[0-9]*)$ ]]; then
      local original_path="${BASH_REMATCH[1]}"
      local timestamp="${BASH_REMATCH[2]}"
      
      # Additional validation: check if this looks like a real backup
      # (timestamp should be a reasonable date range, e.g., 2000-2099)
      local year="${timestamp:0:4}"
      if [[ "$year" =~ ^20[0-9]{2}$ ]]; then
        backups+=("$original_path")
      fi
    fi
  done < <(find "$search_dir" -maxdepth 5 \( -type f -o -type l -o -type d \) -name "*.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]*" -print0 2>/dev/null)
  
  # Remove duplicates and sort
  printf '%s\n' "${backups[@]}" | sort -u
}

# ============================================================================
# Restore Functions
# ============================================================================

remove_current_target() {
  local target_path="$1"
  
  if [ -L "$target_path" ]; then
    echo "Removing current symlink: '$target_path'"
  elif [ -e "$target_path" ]; then
    echo "Removing current file/directory: '$target_path'"
  fi
  
  rm -rf "$target_path"
}

restore_backup() {
  local backup_path="$1"
  local target_path="$2"
  
  # Validate backup exists
  if [ ! -e "$backup_path" ] && [ ! -L "$backup_path" ]; then
    echo "✗ Backup not found: '$backup_path'"
    return 1
  fi
  
  # Dry run mode
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would restore: '$backup_path' -> '$target_path'"
    if [ -L "$target_path" ]; then
      echo "  (Current symlink would be removed)"
    elif [ -e "$target_path" ]; then
      echo "  (Current file/directory would be replaced)"
    fi
    return 0
  fi
  
  # Remove current target if it exists
  if [ -L "$target_path" ] || [ -e "$target_path" ]; then
    remove_current_target "$target_path"
  fi
  
  # Restore from backup
  if mv "$backup_path" "$target_path"; then
    echo "✓ Restored: '$backup_path' -> '$target_path'"
    return 0
  else
    echo "✗ Failed to restore: '$backup_path' -> '$target_path'"
    return 1
  fi
}

# ============================================================================
# Rollback Processing Functions
# ============================================================================

rollback_single_target() {
  local target_path="$1"
  
  echo "Rollback target: '$target_path'"
  
  local backup=$(find_latest_backup "$target_path")
  if [ $? -eq 0 ]; then
    restore_backup "$backup" "$target_path"
    return $?
  else
    echo "✗ No backup found for '$target_path'"
    if [ -n "$SPECIFIC_DATE" ]; then
      echo "  (with date: $SPECIFIC_DATE)"
    fi
    return 1
  fi
}

rollback_all_backups() {
  local targets=()
  
  # Read scan results into array
  while IFS= read -r target; do
    [ -n "$target" ] && targets+=("$target")
  done < <(scan_for_backups)
  
  if [ "${#targets[@]}" -eq 0 ]; then
    echo "No backups found."
    return 0
  fi
  
  echo "Found ${#targets[@]} file(s) with backups:"
  echo ""
  
  local restored_count=0
  local failed_count=0
  local skipped_count=0
  
  for target in "${targets[@]}"; do
    local backup=$(find_latest_backup "$target")
    if [ $? -eq 0 ]; then
      if restore_backup "$backup" "$target"; then
        ((restored_count++))
      else
        ((failed_count++))
      fi
    else
      echo "⊘ No matching backup for: '$target'"
      ((skipped_count++))
    fi
    echo "----------------------------------------"
  done
  
  print_summary "$restored_count" "$failed_count" "$skipped_count"
}

# ============================================================================
# Output Functions
# ============================================================================

print_header() {
  echo "Starting rollback process..."
  if [ "$DRY_RUN" = true ]; then
    echo "Mode: DRY RUN (no changes will be made)"
  fi
  if [ -n "$SPECIFIC_DATE" ]; then
    echo "Target date: $SPECIFIC_DATE"
  fi
  echo "----------------------------------------"
}

print_summary() {
  local restored=$1
  local failed=$2
  local skipped=$3
  
  echo ""
  echo "Rollback Summary:"
  echo "  Restored: $restored"
  echo "  Failed: $failed"
  echo "  Skipped: $skipped"
}

print_footer() {
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "This was a dry run. No changes were made."
  fi
  echo "Rollback process completed."
}

main() {
  # Parse arguments (not in subshell to allow usage() to exit properly)
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --date)
        if [ -z "$2" ] || [[ "$2" == -* ]]; then
          echo "Error: --date requires a value"
          usage
        fi
        SPECIFIC_DATE="$2"
        shift 2
        ;;
      --target)
        if [ -z "$2" ] || [[ "$2" == -* ]]; then
          echo "Error: --target requires a value"
          usage
        fi
        SPECIFIC_TARGET="$2"
        shift 2
        ;;
      -h|--help)
        usage
        ;;
      -*)
        echo "Error: Unknown option '$1'"
        usage
        ;;
      *)
        echo "Error: Unexpected argument '$1'"
        usage
        ;;
    esac
  done
  
  print_header
  
  if [ -n "$SPECIFIC_TARGET" ]; then
    # Rollback specific target
    local target_path=$(expand_home_path "$SPECIFIC_TARGET")
    rollback_single_target "$target_path"
  else
    # Rollback all backups - warn user if not dry-run
    if [ "$DRY_RUN" = false ]; then
      echo "⚠ WARNING: This will rollback ALL symlinks to their backups."
      echo "Consider using --dry-run first to preview changes."
      echo ""
      read -r -p "Continue? [y/N]: " response </dev/tty
      case "$response" in
        [Yy]|[Yy][Ee][Ss])
          # Continue
          ;;
        *)
          echo "Rollback cancelled."
          exit 0
          ;;
      esac
      echo ""
    fi
    rollback_all_backups
  fi
  
  print_footer
}

# Run main function
main "$@"
