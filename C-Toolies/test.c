#include <stdio.h>
#include <stdlib.h>

void char_ptr_test(void)
{
    char **test = (char **) calloc(3, sizeof(char *));

    for (int i = 0; i < 3; i++)
    {
        char *elem = *(test + i);
        if (elem == NULL)
            printf("Element #%d was NULL.\n", i+1);
        else if (*elem == '\0')
            printf("Element #%d was the null character terminator.\n", i+1);
        else
            printf("Element #%d was '%s'.\n", i+1, elem);
    }

    free(test);
    return ;
}

int main(int argc, char **argv)
{
    char_ptr_test();
    return 0;
}
