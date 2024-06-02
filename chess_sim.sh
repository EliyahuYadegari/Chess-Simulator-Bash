#!/bin/bash

# Ensure Python3 and the python-chess package are installed
command -v python3 &>/dev/null || { echo "Python3 is required. Please install it."; exit 1; }
python3 -c 'import chess' &>/dev/null || { echo "python-chess package is required. Please install it."; exit 1; }

# Check if a PGN file is provided as an argument
[[ -z "$1" ]] && { echo "Usage: $0 <pgn_file>"; exit 1; }
pgn_file="$1"
[[ ! -f "$pgn_file" ]] && { echo "File does not exist: $pgn_file"; exit 1; }

# Extract metadata and moves from the PGN file
metadata=$(grep -E '^\[.*\]$' "$pgn_file")
pgn_moves=$(grep -v '^\[' "$pgn_file" | tr '\n' ' ' | sed 's/^ *//;s/ *$//')

# Convert PGN moves to UCI format using the Python script
uci_moves=($(python3 parse_moves.py "$pgn_moves"))
[[ ${#uci_moves[@]} -eq 0 ]] && { echo "No valid moves found in the PGN file."; exit 1; }

# Initial board state
initial_board=(
    "r n b q k b n r"
    "p p p p p p p p"
    ". . . . . . . ."
    ". . . . . . . ."
    ". . . . . . . ."
    ". . . . . . . ."
    "P P P P P P P P"
    "R N B Q K B N R"
)

# Function to convert file letter to index (a-h)
file_index() {
    case $1 in
        a) echo 0 ;;
        b) echo 1 ;;
        c) echo 2 ;;
        d) echo 3 ;;
        e) echo 4 ;;
        f) echo 5 ;;
        g) echo 6 ;;
        h) echo 7 ;;
    esac
}

# Function to update the board state based on a UCI move
update_board_state() {
    local move=$1
    local from_file=$(file_index ${move:0:1})
    local from_rank=$((8 - ${move:1:1}))
    local to_file=$(file_index ${move:2:1})
    local to_rank=$((8 - ${move:3:1}))
    local piece=${board_state[$from_rank]:$((from_file*2)):1}

    # Handle promotion
    if [[ ${#move} -gt 4 ]]; then
        local promotion_piece=${move:4:1}
        if [[ "$piece" == [P] ]]; then
            promotion_piece=${promotion_piece^^}  # Convert to uppercase if white pawn
        else
            promotion_piece=${promotion_piece,,}  # Convert to lowercase if black pawn
        fi
        board_state[$to_rank]="${board_state[$to_rank]:0:$((to_file*2))}${promotion_piece}${board_state[$to_rank]:$((to_file*2 + 1))}"
        board_state[$from_rank]="${board_state[$from_rank]:0:$((from_file*2))}.${board_state[$from_rank]:$((from_file*2 + 1))}"
        return
    fi

    # Update the source square
    board_state[$from_rank]="${board_state[$from_rank]:0:$((from_file*2))}.${board_state[$from_rank]:$((from_file*2 + 1))}"
    # Update the destination square
    board_state[$to_rank]="${board_state[$to_rank]:0:$((to_file*2))}${piece}${board_state[$to_rank]:$((to_file*2 + 1))}"
}

# Function to print the board
print_board() {
    echo "Move $1/${#uci_moves[@]}"
    echo "  a b c d e f g h"
    for ((i=0; i<8; i++)); do
        echo "$((8-i)) ${board_state[$i]} $((8-i))"
    done
    echo "  a b c d e f g h"
    echo -e "Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit: \c"
}

# Display metadata
echo "Metadata from PGN file:"
print_lines_starting_with_brackets() {
    local file="$1"
    if [ -f "$file" ]; then
        while IFS= read -r line; do
            if [[ "$line" == \[* ]]; then
                echo "$line"
            fi
        done < "$file"
    else
        echo "Error: File '$file' not found."
    fi
}

print_lines_starting_with_brackets "$pgn_file"
echo


# Initialize move index and board state
move_index=0
board_state=("${initial_board[@]}")

# Print the initial board
print_board $move_index
read -n 1 key



# Main loop to interactively navigate the chess game
while true; do
    echo
    case $key in
        d)
            if [ $move_index -lt ${#uci_moves[@]} ]; then
                move_index=$((move_index + 1))
                update_board_state ${uci_moves[$((move_index-1))]}
                print_board $move_index
            else
                echo "No more moves available."
            fi
            ;;
        a)
            if [ $move_index -gt 0 ]; then
                move_index=$((move_index - 1))
                board_state=("${initial_board[@]}")
                for ((i=0; i<move_index; i++)); do
                    update_board_state ${uci_moves[$i]}
                done
            else
                board_state=("${initial_board[@]}")
            fi
            print_board $move_index
            ;;
        w)
            move_index=0
            board_state=("${initial_board[@]}")
            print_board $move_index
            ;;
        s)
            move_index=${#uci_moves[@]}
            board_state=("${initial_board[@]}")
            for move in "${uci_moves[@]}"; do
                update_board_state $move
            done
            print_board $move_index
            ;;
        q)
            echo "Exiting."
            break
            ;;
        *)
            echo "Invalid key pressed: $key"
            ;;
    esac
    [[ $key != 'q' ]] && read -n 1 key
done
