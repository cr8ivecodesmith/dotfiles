#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Global variables
NO_VERIFY=false
CURRENT_DATE=$(date +%Y%m%d)

# ============================================================================
# Helper Functions
# ============================================================================

usage() {
  echo "Usage: $0 [--no-verify] [path_list.txt]"
  echo ""
  echo "Copy system configuration files to their system locations."
  echo "This script requires root privileges for system file operations."
  echo ""
  echo "Options:"
  echo "  --no-verify    Skip interactive prompts (batch mode)"
  echo ""
  echo "Arguments:"
  echo "  path_list.txt  Path list file (default: system-paths.txt)"
  exit 1
}

generate_backup_path() {
  local base_path="$1"
  local backup_path="${base_path}.${CURRENT_DATE}"
  local counter=1
  
  while [ -e "$backup_path" ]; do
    backup_path="${base_path}.${CURRENT_DATE}${counter}"
    ((counter++))
  done
  
  echo "$backup_path"
}

prompt_yes_no() {
  local prompt="$1"
  local response
  
  if [ "$NO_VERIFY" = true ]; then
    return 0  # Always yes in batch mode
  fi
  
  while true; do
    read -r -p "$prompt [y/n]: " response </dev/tty
    case "$response" in
      [Yy]|[Yy][Ee][Ss])
        return 0
        ;;
      [Nn]|[Nn][Oo])
        return 1
        ;;
      *)
        echo "Please answer yes or no."
        ;;
    esac
  done
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run with root privileges."
    echo "Please run with: sudo $0 $*"
    exit 1
  fi
}

normalize_path() {
  local path="$1"
  echo "${path%/}"
}

# ============================================================================
# Path Resolution Functions
# ============================================================================

resolve_source_path() {
  local path="$1"
  local source_path="${SCRIPT_DIR}/system/$path"
  normalize_path "$source_path"
}

resolve_target_path() {
  local path="$1"
  local target_path="/$path"
  normalize_path "$target_path"
}

# ============================================================================
# File Comparison Functions
# ============================================================================

files_are_identical() {
  local file1="$1"
  local file2="$2"
  
  # Both must exist
  [ -f "$file1" ] && [ -f "$file2" ] || return 1
  
  # Use cmp for binary-safe comparison
  cmp -s "$file1" "$file2"
  return $?
}

# ============================================================================
# Copy Handling Functions
# ============================================================================

handle_existing_file() {
  local target_path="$1"
  local source_path="$2"
  
  # Check if files are identical
  if files_are_identical "$source_path" "$target_path"; then
    echo "✓ File already up-to-date: '$target_path'"
    return 0  # Skip - already identical
  fi
  
  echo "⚠ Target exists and differs: '$target_path'"
  
  if prompt_yes_no "Replace with version from dotfiles?"; then
    local backup_path=$(generate_backup_path "$target_path")
    echo "Backing up to '$backup_path'."
    cp -a "$target_path" "$backup_path"
    return 1  # Proceed with copy
  else
    echo "Skipping."
    return 0  # Skip
  fi
}

handle_existing_directory() {
  local target_path="$1"
  local source_path="$2"
  
  echo "⚠ Target directory exists: '$target_path'"
  echo "Note: Directories cannot be idempotently copied."
  
  if prompt_yes_no "Backup and replace directory with version from dotfiles?"; then
    local backup_path=$(generate_backup_path "$target_path")
    echo "Backing up to '$backup_path'."
    cp -a "$target_path" "$backup_path"
    return 1  # Proceed with copy
  else
    echo "Skipping."
    return 0  # Skip
  fi
}

handle_target() {
  local target_path="$1"
  local source_path="$2"
  
  if [ -L "$target_path" ]; then
    # Target is a symlink - treat as file
    echo "⚠ Target is a symlink: '$target_path'"
    if prompt_yes_no "Replace symlink with actual file?"; then
      local backup_path=$(generate_backup_path "$target_path")
      echo "Backing up symlink to '$backup_path'."
      cp -a "$target_path" "$backup_path"
      rm "$target_path"
      return 1  # Proceed with copy
    else
      echo "Skipping."
      return 0  # Skip
    fi
  elif [ -d "$target_path" ]; then
    # Target is a directory
    if [ -d "$source_path" ]; then
      handle_existing_directory "$target_path" "$source_path"
      return $?
    else
      echo "⚠ Type mismatch: target is directory, source is file"
      echo "Skipping."
      return 0  # Skip
    fi
  elif [ -f "$target_path" ]; then
    # Target is a regular file
    if [ -f "$source_path" ]; then
      handle_existing_file "$target_path" "$source_path"
      return $?
    else
      echo "⚠ Type mismatch: target is file, source is directory"
      echo "Skipping."
      return 0  # Skip
    fi
  fi
  
  return 1  # Target doesn't exist, proceed with creation
}

copy_file() {
  local source_path="$1"
  local target_path="$2"
  local target_dir=$(dirname "$target_path")
  
  # Create parent directory if needed
  if [ ! -d "$target_dir" ]; then
    echo "Creating directory '$target_dir'."
    mkdir -p "$target_dir"
  fi
  
  # Copy the file/directory preserving attributes
  if cp -a "$source_path" "$target_path"; then
    echo "✓ Copied: '$source_path' -> '$target_path'"
    return 0
  else
    echo "✗ Failed to copy: '$source_path' -> '$target_path'"
    return 1
  fi
}

# ============================================================================
# Main Processing Functions
# ============================================================================

process_path_entry() {
  local path="$1"
  
  # Trim whitespace
  path=$(echo "$path" | xargs)
  
  # Skip empty lines and comments
  [[ -z "$path" || "$path" == \#* ]] && return 0
  
  echo "Processing path: '$path'"
  
  local source_path=$(resolve_source_path "$path")
  local target_path=$(resolve_target_path "$path")
  
  # Validate source exists
  if [ ! -e "$source_path" ]; then
    echo "Warning: Source '$source_path' does not exist. Skipping."
    echo "----------------------------------------"
    return 1
  fi
  
  # Handle existing target
  local handle_result
  handle_target "$target_path" "$source_path"
  handle_result=$?
  
  if [ $handle_result -eq 0 ]; then
    # Skip was requested or already up-to-date
    echo "----------------------------------------"
    return 0
  fi
  
  # Copy the file/directory
  copy_file "$source_path" "$target_path"
  echo "----------------------------------------"
  return 0
}

process_path_file() {
  local path_file="$1"
  
  while IFS= read -r path || [ -n "$path" ]; do
    process_path_entry "$path"
  done < "$path_file"
}

# ============================================================================
# Initialization and Main
# ============================================================================

print_header() {
  local path_file="$1"
  
  echo "Starting system file copy process..."
  echo "Reading paths from '$path_file'"
  echo "Current Date for backups: $CURRENT_DATE"
  if [ "$NO_VERIFY" = true ]; then
    echo "Mode: Batch (--no-verify enabled)"
  fi
  echo "----------------------------------------"
}

main() {
  # Parse arguments first (not in subshell to allow usage() to exit properly)
  local path_file=""
  
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --no-verify)
        NO_VERIFY=true
        shift
        ;;
      -h|--help)
        usage
        ;;
      -*)
        echo "Error: Unknown option '$1'"
        usage
        ;;
      *)
        path_file="$1"
        shift
        ;;
    esac
  done
  
  # Default to system-paths.txt if not specified
  if [ -z "$path_file" ]; then
    path_file="${SCRIPT_DIR}/system-paths.txt"
  fi
  
  [ -f "$path_file" ] || { echo "Error: File '$path_file' does not exist or is not a regular file."; exit 1; }
  
  # Check for root privileges
  check_root "$@"
  
  print_header "$path_file"
  process_path_file "$path_file"
  
  echo "System file copy process completed successfully."
}

# Run main function
main "$@"
