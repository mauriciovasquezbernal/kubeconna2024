#include <stdio.h>
#include <stdlib.h>

int main() {
    // Attempt to open a file that doesn't exist, without checking for errors
    FILE *file = fopen("nonexistent_file.txt", "r"); // ignoring the error

    // Try to read from the file without checking if 'file' is NULL
    char buffer[100];
    fread(buffer, sizeof(char), 100, file); // This will crash if 'file' is NULL

    printf("File read successfully: %s\n", buffer);

    // Close the file if it was actually opened (won't reach here if 'file' is NULL)
    fclose(file);

    return 0;
}
