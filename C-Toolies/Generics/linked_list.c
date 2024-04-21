#include <stdio.h>
#include "linked_list.h"

DEF_NODE_T(int);
DEF_NODE_T(char);
DEF_LINKED_LIST_T(int);
DEF_LINKED_LIST_T(char);

int main(void)
{
    MAKE_LINKED_LIST_OBJ(int, mylist);
    int value = 5;
    insert(mylist, &value, 0);
    free(mylist);
    return 0;
}

void append(void *list, void *data)
{
    insert(list, data, LAST);
}

void prepend(void *list, void *data)
{
    insert(list, data, FIRST);
}

void insert(void *list, void *data, int position)
{
    /* UNWRAP_LIST_FROM_VOID_PTR(list, listptr); */
    /* UNWRAP_VAR_FROM_VOID_PTR(data, int, value); */

    /* printf("Data: %d\n", *value); */
    /* printf("Size: %zu\n", listptr->size); */
    /* printf("Type: %s\n", listptr->type); */

    /* LINKED_LIST_TYPE_PTR(list->type) list_ptr = (LINKED_LIST_TYPE_PTR(list->type)) list; */

    /* if (list_ptr->size == 0) */
    /*     position = FIRST; */

    /* if (position == FIRST) */
    /* { */
    /*     MAKE_NODE_OBJ(list_ptr->type, new_head_node, /\* cast data *\/); */
    /*     new_head_node->next = list_ptr->head; */
    /*     list_ptr->head = new_head_node; */
    /* } */
    /* else if (position == LAST) */
    /* { */
    /* } */
    /* else */
    /* { */
    /* } */

    /* list_ptr->size++; */
}

void traverse(void *list)
{
    return ;
}

void cleanup(void *list)
{
    return ;
}
