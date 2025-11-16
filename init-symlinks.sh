#!/bin/bash
set -e

usage() {
  echo "Usage: $0 path_list.txt"
  exit 1
}

[ "$#" -eq 1 ] || { echo "Error: Missing path list file."; usage; }

path_file="$1"
[ -f "$path_file" ] || { echo "Error: File '$path_file' does not exist or is not a regular file."; exit 1; }

current_date=$(date +%Y%m%d)

echo "Starting the symlink creation process..."
echo "Reading paths from '$path_file'"
echo "Current Date for backups: $current_date"
echo "----------------------------------------"

while IFS= read -r path || [ -n "$path" ]; do
  path=$(echo "$path" | xargs)
  [[ -z "$path" || "$path" == \#* ]] && continue

  echo "Processing path: '$path'"

  # Source path is always from the repo root
  source_path="$(pwd)/$path"
  # Normalize to avoid trailing slash issues
  source_path="${source_path%/}"

  # If the list item starts with termux-config/, drop that segment for $HOME
  if [[ "$path" == termux-config/* ]]; then
    target_rel="${path#termux-config/}"
  else
    target_rel="$path"
  fi
  # Normalize trailing slash for the link name
  target_rel="${target_rel%/}"

  target_path="$HOME/$target_rel"

  if [ ! -e "$source_path" ]; then
    echo "Warning: Source '$source_path' does not exist. Skipping."
    echo "----------------------------------------"
    continue
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="${target_path}.${current_date}"
    echo "Existing '$target_path' found. Backing up to '$backup_path'."
    mv "$target_path" "$backup_path"
  fi

  target_dir=$(dirname "$target_path")
  if [ ! -d "$target_dir" ]; then
    echo "Creating directory '$target_dir'."
    mkdir -p "$target_dir"
  fi

  ln -sn "$source_path" "$target_path"
  echo "Created symlink: '$target_path' -> '$source_path'"
  echo "----------------------------------------"

done < "$path_file"

echo "Symlink creation process completed successfully."
