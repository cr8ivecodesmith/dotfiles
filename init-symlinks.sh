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
  echo "Usage: $0 [--no-verify] path_list.txt"
  echo ""
  echo "Options:"
  echo "  --no-verify    Skip interactive prompts (batch mode)"
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

merge_directories() {
  local source_dir="$1"
  local target_dir="$2"
  
  echo "Merging contents from '$source_dir' to '$target_dir'..."
  
  # Copy all contents including hidden files, prioritizing source (dotfiles repo)
  # Using shell options to include hidden files
  shopt -s dotglob nullglob
  local files=("$source_dir"/*)
  shopt -u dotglob nullglob
  
  if [ ${#files[@]} -gt 0 ]; then
    if ! cp -rn "${files[@]}" "$target_dir/" 2>/dev/null; then
      echo "Warning: Some files may not have been copied during merge."
    fi
  else
    echo "Note: Source directory is empty, nothing to merge."
  fi
  
  echo "Merge completed."
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
  local source_path="${SCRIPT_DIR}/$path"
  normalize_path "$source_path"
}

resolve_target_path() {
  local path="$1"
  local target_rel
  
  # If the list item starts with termux-config/, drop that segment for $HOME
  if [[ "$path" == termux-config/* ]]; then
    target_rel="${path#termux-config/}"
  else
    target_rel="$path"
  fi
  
  target_rel=$(normalize_path "$target_rel")
  echo "$HOME/$target_rel"
}

# ============================================================================
# Symlink Handling Functions
# ============================================================================

handle_existing_symlink() {
  local target_path="$1"
  local source_path_abs="$2"
  local current_link=$(readlink -f "$target_path" 2>/dev/null || readlink "$target_path")
  
  if [ "$current_link" = "$source_path_abs" ]; then
    # Already pointing to the correct location
    echo "✓ Symlink already correct: '$target_path' -> '$source_path_abs'"
    return 0  # Skip - already correct
  elif [ ! -e "$current_link" ]; then
    # Broken symlink
    echo "⚠ Broken symlink detected: '$target_path' -> '$current_link'"
    local backup_path=$(generate_backup_path "$target_path")
    echo "Replacing broken symlink. Backing up to '$backup_path'."
    mv "$target_path" "$backup_path"
    return 1  # Proceed with symlink creation
  else
    # Points to wrong location
    echo "⚠ Symlink points to wrong location:"
    echo "  Current: '$target_path' -> '$current_link'"
    echo "  Expected: '$source_path_abs'"
    
    if prompt_yes_no "Replace with correct symlink?"; then
      local backup_path=$(generate_backup_path "$target_path")
      echo "Backing up to '$backup_path'."
      mv "$target_path" "$backup_path"
      return 1  # Proceed with symlink creation
    else
      echo "Skipping."
      return 0  # Skip
    fi
  fi
}

handle_existing_directory() {
  local target_path="$1"
  local source_path="$2"
  
  echo "⚠ Target directory exists: '$target_path'"
  
  # Check if directory has contents
  if [ -n "$(ls -A "$target_path" 2>/dev/null)" ]; then
    echo "Directory contains existing files."
    
    if prompt_yes_no "Merge existing directory contents into dotfiles before symlinking?"; then
      merge_directories "$target_path" "$source_path"
    fi
  fi
  
  if prompt_yes_no "Replace directory with symlink?"; then
    local backup_path=$(generate_backup_path "$target_path")
    echo "Backing up to '$backup_path'."
    mv "$target_path" "$backup_path"
    return 1  # Proceed with symlink creation
  else
    echo "Skipping."
    return 0  # Skip
  fi
}

handle_existing_file() {
  local target_path="$1"
  
  echo "⚠ Target exists: '$target_path'"
  
  if prompt_yes_no "Replace with symlink?"; then
    local backup_path=$(generate_backup_path "$target_path")
    echo "Backing up to '$backup_path'."
    mv "$target_path" "$backup_path"
    return 1  # Proceed with symlink creation
  else
    echo "Skipping."
    return 0  # Skip
  fi
}

handle_target() {
  local target_path="$1"
  local source_path="$2"
  
  # Safely get absolute path of source
  local source_path_abs
  if [ -e "$source_path" ]; then
    source_path_abs=$(readlink -f "$source_path")
  else
    # Source doesn't exist yet, construct absolute path manually
    source_path_abs="$source_path"
  fi
  
  if [ -L "$target_path" ]; then
    # Target is a symlink
    handle_existing_symlink "$target_path" "$source_path_abs"
    return $?
  elif [ -e "$target_path" ]; then
    # Target exists but is not a symlink
    if [ -d "$target_path" ] && [ -d "$source_path" ]; then
      # Both are directories
      handle_existing_directory "$target_path" "$source_path"
      return $?
    else
      # Regular file or mixed types
      handle_existing_file "$target_path"
      return $?
    fi
  fi
  
  return 1  # Target doesn't exist, proceed with creation
}

create_symlink() {
  local source_path="$1"
  local target_path="$2"
  local target_dir=$(dirname "$target_path")
  
  # Create parent directory if needed
  if [ ! -d "$target_dir" ]; then
    echo "Creating directory '$target_dir'."
    mkdir -p "$target_dir"
  fi
  
  # Create the symlink
  if ln -sn "$source_path" "$target_path"; then
    echo "✓ Created symlink: '$target_path' -> '$source_path'"
    return 0
  else
    echo "✗ Failed to create symlink: '$target_path' -> '$source_path'"
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
    # Skip was requested or already correct
    echo "----------------------------------------"
    return 0
  fi
  
  # Create the symlink
  create_symlink "$source_path" "$target_path"
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
  
  echo "Starting the symlink creation process..."
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
  
  [ -n "$path_file" ] || { echo "Error: Missing path list file."; usage; }
  [ -f "$path_file" ] || { echo "Error: File '$path_file' does not exist or is not a regular file."; exit 1; }
  
  print_header "$path_file"
  process_path_file "$path_file"
  
  echo "Symlink creation process completed successfully."
}

# Run main function
main "$@"
