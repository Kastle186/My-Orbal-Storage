#include <stdio.h>
#include "linked_list.h"

DEF_NODE_T(int);
DEF_NODE_T(char);
DEF_LINKED_LIST_T(int);
DEF_LINKED_LIST_T(char);

int main(void)
{
    MAKE_LINKED_LIST_OBJ(int, mylist);
    PREPEND_TO_LIST(mylist, 5, int);
    printf("%d\n", new_node->data);
    free(mylist);
    return 0;
}

void append(void *list, void *data)
{
    return ;
}

void prepend(void *list, void *data)
{
    return ;
}

void insert(void *list, void *data, int position)
{
    return ;
}

void traverse(void *list)
{
    return ;
}

void cleanup(void *list)
{
    return ;
}
