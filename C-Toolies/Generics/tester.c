#include <stdio.h>
#include "linked_list.h"

linked_list(int);
linked_list(char);

int main(void)
{
    make_linked_list_obj(int, my_int_list);
    printf("List Size: %zu\n", my_int_list->size);
    printf("List Type: %s\n",  my_int_list->type);

    make_linked_list_obj(char, my_char_list);
    printf("List Size: %zu\n", my_char_list->size);
    printf("List Type: %s\n",  my_char_list->type);

    free_string(my_int_list->type);
    free_string(my_char_list->type);

    free(my_int_list);
    free(my_char_list);
    return 0;
}
