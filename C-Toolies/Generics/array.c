#include <stdio.h>
#include <stdlib.h>

#define array_t(T) T*
#define array_new(T, len) calloc(len, sizeof(T))

int main(int argc, char **argv)
{
    array_t(int) my_int_list = array_new(int, 5);
    array_t(char) my_char_list = array_new(char, 5);

    for (int i = 0; i < 5; i++)
    {
        *(my_int_list+i) = i + 1;
    }

    for (int j = 0; j < 5; j++)
    {
        *(my_char_list+j) = (char) ('a' + j);
    }

    printf("\nMy Int List:");
    for (int i = 0; i < 5; i++)
    {
        printf(" %d", *(my_int_list+i));
    }

    printf("\nMy Char List:");
    for (int j = 0; j < 5; j++)
    {
        printf(" %c", *(my_char_list+j));
    }

    printf("\n");

    free(my_int_list);
    free(my_char_list);
    return 0;
}
