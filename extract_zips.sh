#!/bin/bash

# Find the first zip file in the current working directory
main_zip=$(find . -maxdepth 1 -name "*.zip" | head -n 1)

# If no zip file is found, exit with a message
if [ -z "$main_zip" ]; then
    echo "No zip file found in the current directory."
    exit 1
fi

echo "Found zip file: $main_zip"

# Extract the first word (letters) and number from the zip file name (e.g., "Lab1")
zip_base_name=$(basename "$main_zip" | grep -oE '^[A-Za-z]+[ ]?[0-9]+')

# If no matching string and number is found, default to "extracted"
if [ -z "$zip_base_name" ]; then
    zip_base_name="extracted"
fi

# Remove any spaces from the base name (e.g., turn "Lab 1" into "Lab1")
zip_base_name=$(echo "$zip_base_name" | tr -d ' ')

# Extract the main zip file to a folder named after the extracted portion of the zip file name
extracted_folder="./$zip_base_name"
unzip -q "$main_zip" -d "$extracted_folder"
echo "Extracted $main_zip to $extracted_folder"

# Check if the extracted content contains a folder or files
zip_folder=$(find "$extracted_folder" -mindepth 1 -maxdepth 1 -type d | head -n 1)

# If no folder is found, assume the zip contains files directly, and use extracted_folder as zip_folder
if [ -z "$zip_folder" ]; then
    echo "No folder found, assuming files were extracted directly."
    zip_folder="$extracted_folder"
else
    echo "Processing extracted folder: $zip_folder"
fi

# Create the 'submissions' folder inside the base folder
submissions_folder="$extracted_folder/submissions"
mkdir -p "$submissions_folder"

# Function to extract name from the zip file name
extract_name() {
    file_name="$1"
    # Use regex to match the last name and first name
    if [[ "$file_name" =~ -\ ([a-zA-Z]+),\ ([a-zA-Z]+)\ - ]]; then
        last_name="${BASH_REMATCH[1]}"
        first_name="${BASH_REMATCH[2]}"
        echo "${last_name}_${first_name}"
    else
        echo ""
    fi
}

# Loop through all zip files in the extracted folder
for file in "$zip_folder"/*.zip; do
    # Extract name from the file name
    folder_name=$(extract_name "$(basename "$file")")
    if [ -n "$folder_name" ]; then
        # Create a folder for each submission
        extract_folder_path="$submissions_folder/$folder_name"
        mkdir -p "$extract_folder_path"

        # Extract the zip file into the student's folder
        unzip -q "$file" -d "$extract_folder_path"
        echo "Extracted $(basename "$file") to $extract_folder_path"

        # Delete the zip file after successful extraction
        rm "$file"
        echo "Deleted $file after extraction"
    else
        echo "Could not extract name from $(basename "$file")"
    fi
done

# Delete the main zip file after successful extraction of its content
rm "$main_zip"
echo "Deleted main zip file: $main_zip"
