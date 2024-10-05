#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 path_list.txt"
    exit 1
}

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Error: Missing path list file."
    usage
fi

# Assign the first argument to path_file
path_file="$1"

# Check if the provided file exists and is readable
if [ ! -f "$path_file" ]; then
    echo "Error: File '$path_file' does not exist or is not a regular file."
    exit 1
fi

# Get the current date in YYYYmmdd format
current_date=$(date +%Y%m%d)

echo "Starting the symlink creation process..."
echo "Reading paths from '$path_file'"
echo "Current Date for backups: $current_date"
echo "----------------------------------------"

# Read the file line by line
while IFS= read -r path || [ -n "$path" ]; do
    # Trim leading and trailing whitespace
    path=$(echo "$path" | xargs)

    # Skip empty lines or lines starting with '#'
    if [[ -z "$path" || "$path" == \#* ]]; then
        continue
    fi

    echo "Processing path: '$path'"

    # Define source and target paths
    source_path="$(pwd)/$path"
    target_path="$HOME/$path"

    # Check if the source file exists
    if [ ! -e "$source_path" ]; then
        echo "Warning: Source '$source_path' does not exist. Skipping."
        echo "----------------------------------------"
        continue
    fi

    # If the target exists (file, directory, or symlink), back it up
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        backup_path="${target_path}.${current_date}"
        echo "Existing '$target_path' found. Backing up to '$backup_path'."
        mv "$target_path" "$backup_path"
    fi

    # Ensure the parent directory exists
    target_dir=$(dirname "$target_path")
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory '$target_dir'."
        mkdir -p "$target_dir"
    fi

    # Create the symbolic link
    ln -sn "$source_path" "$target_path"
    echo "Created symlink: '$target_path' -> '$source_path'"
    echo "----------------------------------------"

done < "$path_file"

echo "Symlink creation process completed successfully."

