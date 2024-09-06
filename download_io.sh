#!/bin/bash

source .env
# ACTION: Define the base URL and credentials
base_url="https://cs.rit.edu/~csapx/SLI/Labs/01-Lsystem/"
username=$SLI_USER
password=$SLI_PASS

# ACTION: Define directory in which 'input' and 'output' must be loaded
cd Lab1/

# Create a function to handle both 'input' and 'output' directories
download_from_directory() {
    directory=$1
    full_url="${base_url}${directory}/"

    echo "Processing $directory directory..."

    # Create a local directory to store the downloaded files
    mkdir -p "$directory"

    # Use curl with authentication to download the index page and grep to extract valid links (excluding Parent Directory and unwanted tags)
    links=$(curl -s -u "$username:$password" "$full_url" | grep -o 'href="[^"]*"' | cut -d'"' -f2 | grep -vE '(Parent Directory|^\?)')

    # Loop through each link and download the content to a txt file
    for link in $links; do
        # Construct the full URL
        file_url="$full_url$link"

        # Download the file and save it as a txt file inside the appropriate directory
        curl -s -u "$username:$password" "$file_url" -o "${directory}/${link}.txt"

        echo "Downloaded $file_url to ${directory}/${link}.txt"
    done
}

# Process 'input' directory
download_from_directory "input"

# Process 'output' directory
download_from_directory "output"
