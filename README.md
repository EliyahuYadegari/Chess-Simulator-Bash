# Chess Simulator Bash

This repository contains a set of Bash scripts designed to help you manage and analyze chess games stored in PGN (Portable Game Notation) files. Whether you have a large collection of chess games that need to be split into manageable pieces or you want to simulate and visualize individual games, these scripts provide a straightforward and efficient solution.

## Installation

1. Clone this repository to your local machine:

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

### Part 3: Custom Shell Implementation in C

In this part, I developed a simple command-line interpreter, named myshell.c. This custom shell handle basic Linux commands like ls, cat, and sleep. The shell is implemented in C using fork() and exec().
#### Running the Custom Shell

1. **Compile the `myshell.c` Program:**

   Before running the custom shell, you'll need to compile the `myshell.c` file using `gcc`:

   ```bash
   gcc myshell.c -o myshell
   ```

   This command will create an executable file named `myshell`.

2. **Run the Custom Shell:**

   To run the shell, use the following command:

   ```bash
   ./myshell /path/to/directory1 /path/to/directory2
   ```

   - Replace `/path/to/directory1` and `/path/to/directory2` with actual paths that contain executable files. You can include multiple directories as arguments, separated by spaces.

   Example:

   ```bash
   ./myshell /usr/bin /home/user/custom_commands
   ```

   This will start the shell and allow you to execute commands from the specified directories or from directories included in your system's `$PATH` variable.

3. **Using the Shell:**

   Once the shell is running, you'll see a prompt like this:

   ```bash
   $ 
   ```

   - You can now enter any basic Linux command (e.g., `ls`, `cat`, `sleep`) or use the custom commands (`history`, `cd`, `pwd`, `exit`) that you've implemented.
   - After entering a command, press `Enter` to execute it.

4. **Exit the Shell:**

   To exit the shell, simply type:

   ```bash
   exit
   ```

   The shell will terminate, and you'll return to the standard command line.

---


## Features

- **Split PGN Files:** Automatically split large PGN files into smaller, more manageable files.
- **Simulate Chess Games:** Run simulations on individual PGN files to analyze and visualize games.
- **Command Line Interface:** Easy-to-use command line interface for executing the scripts.
- **Customizable:** Modify and extend the scripts to suit your specific needs.
- **Custom Shell:** Implement a custom shell in C that can handle basic commands and custom commands like history, cd, pwd, and exit.

