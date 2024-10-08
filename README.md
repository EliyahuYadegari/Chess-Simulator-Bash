# Chess Simulator Bash

This repository contains a set of Bash scripts designed to help you manage and analyze chess games stored in PGN (Portable Game Notation) files. Whether you have a large collection of chess games that need to be split into manageable pieces or you want to simulate and visualize individual games, these scripts provide a straightforward and efficient solution.

## Installation

1. Clone this repository to your local machine and enter to "Chess_Simulator_Bash" folder:

    ```bash
    cd Chess_Simulator_Bash
    ```

2. Make the scripts executable:

    ```bash
    chmod +x ./split_pgn.sh
    chmod +x ./chess_sim.sh
    ```

## Usage

### Part 1: Split PGN Files

1. Prepare your PGN file and place it in the project directory. For example, `capmemel24.pgn`.

2. Run the `split_pgn.sh` script to split the PGN file:

    ```bash
      ./split_pgn.sh {source_pgn_file} {destination_directory}
    ```

    - The first argument is the path to the input PGN file.
    - The second argument is the directory where the split PGN files will be saved.

3. The split PGN files will be saved in the specified directory.

### Part 2: Simulate Chess Games

1. Run the `chess_sim.sh` script to simulate a chess game from a split PGN file:

    ```bash
    ./chess_sim.sh splited_pgn/capmemel24_1.pgn
    ```

    - The argument is the path to the specific split PGN file you want to simulate.

## Features

- **Split PGN Files:** Automatically split large PGN files into smaller, more manageable files.
- **Simulate Chess Games:** Run simulations on individual PGN files to analyze and visualize games.
- **Command Line Interface:** Easy-to-use command line interface for executing the scripts.
- **Customizable:** Modify and extend the scripts to suit your specific needs.

