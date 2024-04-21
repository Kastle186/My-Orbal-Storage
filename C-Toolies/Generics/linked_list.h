// Linked_List Header File

#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

#include <stdlib.h>
#include <string.h>

#define node_struct_type(T) struct node_ ## T
#define linked_list_type(T) struct linked_list_ ## T

#define node_struct_type_ptr(T) struct node_ ## T*
#define linked_list_type_ptr(T) struct linked_list_ ## T*

#define node(T)                       \
    node_struct_type(T)               \
    {                                 \
        T data;                       \
        node_struct_type_ptr(T) next; \
    }

#define linked_list(T)                \
    linked_list_type(T)               \
    {                                 \
        node_struct_type_ptr(T) head; \
        size_t size;                  \
        const char *type;             \
    }

#define make_node_obj(OBJ_NAME, TYPE, DATA)                                  \
    node_struct_type_ptr(TYPE) OBJ_NAME =                                    \
        (node_struct_type_ptr(TYPE)) malloc(sizeof(node_struct_type(TYPE))); \
    OBJ_NAME->data = DATA;                                                   \
    OBJ_NAME->next = NULL;

#define make_linked_list_obj(OBJ_NAME, TYPE)                                 \
    linked_list_type_ptr(TYPE) OBJ_NAME =                                    \
        (linked_list_type_ptr(TYPE)) malloc(sizeof(linked_list_type(TYPE))); \
    OBJ_NAME->size = 0;                                                      \
    OBJ_NAME->head = NULL;                                                   \
    OBJ_NAME->type = NULL;                                                   \
    make_string(OBJ_NAME->type, #TYPE)

#define make_string(VAR, STR)                \
    VAR = calloc(strlen(STR), sizeof(char)); \
    strcpy(VAR, STR);

#define free_string(VAR) \
    free(VAR);           \
    VAR = NULL;

void append(void *list, void *data);
void prepend(void *list, void *data);
void insert(void *list, void *data, int position);
void traverse(void *list);
void cleanup(void *list);

#endif
