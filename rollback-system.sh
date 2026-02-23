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
  echo "Rollback system files to their latest backup."
  echo "This script requires root privileges for system file operations."
  echo ""
  echo "Options:"
  echo "  --dry-run      Show what would be restored without making changes"
  echo "  --date DATE    Rollback to specific date (format: YYYYMMDD or YYYYMMDD{N})"
  echo "  --target PATH  Rollback only a specific target path (absolute path)"
  echo ""
  echo "Examples:"
  echo "  $0                                    # Rollback all latest backups"
  echo "  $0 --dry-run                          # Preview rollback actions"
  echo "  $0 --date 20260220                    # Rollback to specific date"
  echo "  $0 --target /usr/bin/m-utils          # Rollback only m-utils"
  exit 1
}

check_root() {
  if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" = false ]; then
    echo "Error: This script must be run with root privileges."
    echo "Please run with: sudo $0 $*"
    exit 1
  fi
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

scan_for_system_backups() {
  local backups=()
  
  echo "Scanning for system file backups..."
  echo "----------------------------------------"
  
  # Search in common system directories
  local search_dirs=(
    "/usr/bin"
    "/usr/local/bin"
    "/etc"
  )
  
  for search_dir in "${search_dirs[@]}"; do
    [ ! -d "$search_dir" ] && continue
    
    # Find all backup files (pattern: *.<date>[<counter>])
    while IFS= read -r -d '' backup; do
      local basename=$(basename "$backup")
      # Extract the original path by removing the timestamp suffix
      if [[ "$backup" =~ ^(.+)\.([0-9]{8}[0-9]*)$ ]]; then
        local original_path="${BASH_REMATCH[1]}"
        local timestamp="${BASH_REMATCH[2]}"
        
        # Validate timestamp (year should be 20xx)
        local year="${timestamp:0:4}"
        if [[ "$year" =~ ^20[0-9]{2}$ ]]; then
          backups+=("$original_path")
        fi
      fi
    done < <(find "$search_dir" -maxdepth 3 \( -type f -o -type l -o -type d \) -name "*.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]*" -print0 2>/dev/null)
  done
  
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
  done < <(scan_for_system_backups)
  
  if [ "${#targets[@]}" -eq 0 ]; then
    echo "No system backups found."
    return 0
  fi
  
  echo "Found ${#targets[@]} system file(s) with backups:"
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
  echo "Starting system file rollback process..."
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

cleanup_environment() {
  local env_file="/etc/environment"
  
  echo "----------------------------------------"
  echo "Cleaning up m-utils environment variables..."
  
  if grep -q "MUTILS_DOTFILES_DIR" "$env_file" 2>/dev/null; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY RUN] Would remove MUTILS_DOTFILES_DIR from /etc/environment"
    else
      # Remove the line containing MUTILS_DOTFILES_DIR
      sed -i '/MUTILS_DOTFILES_DIR/d' "$env_file"
      echo "✓ Removed MUTILS_DOTFILES_DIR from /etc/environment"
      echo "  Note: Restart shells for change to take effect"
    fi
  else
    echo "✓ No m-utils environment variables found"
  fi
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
  
  # Check for root privileges (unless dry-run)
  check_root "$@"
  
  print_header
  
  if [ -n "$SPECIFIC_TARGET" ]; then
    # Rollback specific target
    rollback_single_target "$SPECIFIC_TARGET"
  else
    # Rollback all backups - warn user if not dry-run
    if [ "$DRY_RUN" = false ]; then
      echo "⚠ WARNING: This will rollback ALL system files to their backups."
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
    
    # Clean up m-utils environment variables
    cleanup_environment
  fi
  
  print_footer
}

# Run main function
main "$@"
