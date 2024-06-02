#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

#define MAX_COMMANDS 100
#define MAX_COMMAND_LENGTH 100
#define MAX_PATHS 10
#define MAX_PATH_LENGTH 100

char commands[MAX_COMMANDS][MAX_COMMAND_LENGTH];
char paths[MAX_PATHS][MAX_PATH_LENGTH];
int num_commands = 0;
int num_paths = 0;

void read_commands(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        strcpy(paths[num_paths], argv[i]);
        num_paths++;
    }
}

void read_input() {
    printf("$ ");
    fflush(stdout);

    if (fgets(commands[num_commands], MAX_COMMAND_LENGTH, stdin) != NULL) {
        strtok(commands[num_commands], "\n");  // Remove trailing newline
        num_commands++;
    } else {
        printf("\n");
        exit(EXIT_SUCCESS);  // Exit on EOF (Ctrl+D)
    }
}

void execute_command(char *command, char *args[]) {
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) {
        execvp(command, args);
        perror("exec failed");
        exit(EXIT_FAILURE);
    } else {
        wait(NULL);
    }
}

void execute_custom_command(char *command) {
    if (strcmp(command, "history") == 0) {
        for (int i = 0; i < num_commands; i++) {
            printf("%s\n", commands[i]);
        }
    } else if (strcmp(command, "pwd") == 0) {
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("%s\n", cwd);
        } else {
            perror("getcwd failed");
        }
    } else if (strcmp(command, "exit") == 0) {
        exit(EXIT_SUCCESS);
    }
}

void handle_cd(char *directory) {
    if (directory != NULL) {
        if (chdir(directory) != 0) {
            perror("cd failed");
        }
    } else {
        printf("Usage: cd <directory>\n");
    }
}

int main(int argc, char *argv[]) {
    read_commands(argc, argv);

    while (1) {
        read_input();
        char *input = commands[num_commands - 1];
        char *command = strtok(input, " ");
        char *args[MAX_COMMAND_LENGTH];
        int i = 0;

        while (command != NULL && i < MAX_COMMAND_LENGTH - 1) {
            args[i++] = command;
            command = strtok(NULL, " ");
        }
        args[i] = NULL;

        if (args[0] == NULL) {
            continue;
        }

        if (strcmp(args[0], "cd") == 0) {
            handle_cd(args[1]);
        } else if (strcmp(args[0], "history") == 0 || strcmp(args[0], "pwd") == 0 || strcmp(args[0], "exit") == 0) {
            execute_custom_command(args[0]);
        } else {
            int found = 0;
            for (int j = 0; j < num_paths; j++) {
                char full_path[MAX_PATH_LENGTH + MAX_COMMAND_LENGTH];
                snprintf(full_path, sizeof(full_path), "%s/%s", paths[j], args[0]);
                if (access(full_path, X_OK) == 0) {
                    execute_command(full_path, args);
                    found = 1;
                    break;
                }
            }
            if (!found) {
                execute_command(args[0], args);
            }
        }
    }

    return 0;
}
