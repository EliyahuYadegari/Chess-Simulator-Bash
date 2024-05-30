#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <source_pgn_file> <destination_directory>"
    exit 1
}

# Function to check if a file exists
file_exists() {
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' does not exist."
        exit 1
    fi
}

# Function to create a unique directory if it doesn't exist
create_unique_directory() {
    local base_dir="$1"
    local dest_dir="$base_dir"
    local count=1

    while [ -d "$dest_dir" ]; do
        dest_dir="${base_dir}_${count}"
        count=$((count + 1))
    done

    mkdir -p "$dest_dir"
    echo "Created directory '$dest_dir'."
    echo "$dest_dir"
}

# Function to check the validity of the PGN file
check_pgn_validity() {
    local input_file="$1"
    if ! grep -q '\[Event' "$input_file"; then
        echo "Error: The file '$input_file' does not contain valid PGN data (missing [Event] tag)."
        exit 1
    fi
}

# Function to split the PGN file into individual games
split_pgn_file() {
    local input_file="$1"
    local dest_dir="$2"
    local game_count=0
    local game_content=""
    local game_started=false

    while IFS= read -r line; do
        # Detect the start of a new game by looking for [Event] tag
        if [[ $line == \[Event* ]]; then
            if [ "$game_started" = true ]; then
                game_count=$((game_count + 1))
                echo -e "$game_content" > "$dest_dir/$(basename "$input_file" .pgn)_$game_count.pgn"
                echo "Saved game to $dest_dir/$(basename "$input_file" .pgn)_$game_count.pgn"
            fi
            game_content="$line\n"
            game_started=true
        else
            game_content+="$line\n"
        fi
    done < "$input_file"

    # Save the last game
    if [ "$game_started" = true ]; then
        game_count=$((game_count + 1))
        echo -e "$game_content" > "$dest_dir/$(basename "$input_file" .pgn)_$game_count.pgn"
        echo "Saved game to $dest_dir/$(basename "$input_file" .pgn)_$game_count.pgn"
    fi

    echo "All games have been split and saved to '$dest_dir'."
}

# Main script execution

# Check the number of arguments
if [ "$#" -ne 2 ]; then
    usage
fi

input_file="$1"
dest_dir="$2"

# Check if the source file exists
file_exists "$input_file"

# Check the validity of the PGN file
check_pgn_validity "$input_file"

# Ensure the destination directory is unique and create it
dest_dir=$(create_unique_directory "$dest_dir")

# Split the PGN file into individual game files
split_pgn_file "$input_file" "$dest_dir"
