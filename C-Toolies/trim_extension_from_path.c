#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void trim_extension(char *);

int main(int argc, char *argv[])
{
    char *trimmed_path = argv[1];
    trim_extension(trimmed_path);
    printf("Path Without Extension: %s\n", trimmed_path);
    return 0;
}

void trim_extension(char *path)
{
    // First, we need to know where the extension begins. So, we look for the
    // first dot '.' starting from the end of the path string.
    char *ptr = path + strlen(path) - 1;
    while (*ptr != '.') ptr--;

    // Then, delete everything from the dot '.' onwards, and we're done :)
    *ptr = '\0';
}
