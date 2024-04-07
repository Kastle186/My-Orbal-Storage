#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char *get_filename_from_path(const char *);

int main(int argc, char **argv)
{
    const char *name = get_filename_from_path(*(argv+1));
    printf("App Name: %s\n", name);
    free(name);
    name = NULL;
    return 0;
}

const char *get_filename_from_path(const char *path)
{
    // First, we need to ignore the file extension. For practical purposes, we will
    // assume we will always get a valid path :)
    const char *ptr = (path + strlen(path) - 1);
    while (*ptr != '.') ptr--;

    // Get the size of the app name. We could just allocate a big chunk of memory
    // and skip this part, but let's add a little more spice and challenge to this
    // exercise :)
    size_t name_size = 0;
    while (*(--ptr) != '/') name_size++;

    // Copy the result to an array of its own that we can return from this function.
    char *result = calloc(name_size, sizeof(char));
    int i;

    for (i = 0; i < name_size; i++)
    {
        // We add a +1 here to "ptr" because it ended at the '/' in the previous
        // loop, and that's the directory separator, not part of the name.
        *(result + i) = *(ptr + i + 1);
    }
    return (const char *) result;
}
