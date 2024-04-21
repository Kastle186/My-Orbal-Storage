// Linked_List Header File

#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

#include <stdlib.h>
#include <string.h>

#define FIRST 0
#define LAST -1

#define NODE_STRUCT_TYPE(T) struct node_ ## T
#define LINKED_LIST_TYPE(T) struct linked_list_ ## T

#define NODE_STRUCT_TYPE_PTR(T) struct node_ ## T*
#define LINKED_LIST_TYPE_PTR(T) struct linked_list_ ## T*

#define DEF_NODE_T(T)                 \
    NODE_STRUCT_TYPE(T)               \
    {                                 \
        T data;                       \
        NODE_STRUCT_TYPE_PTR(T) next; \
    }

#define DEF_LINKED_LIST_T(T)          \
    LINKED_LIST_TYPE(T)               \
    {                                 \
        NODE_STRUCT_TYPE_PTR(T) head; \
        size_t size;                  \
        char *type;                   \
    }

#define MAKE_NODE_OBJ(TYPE, OBJ_NAME, DATA)                                  \
    NODE_STRUCT_TYPE_PTR(TYPE) OBJ_NAME =                                    \
        (NODE_STRUCT_TYPE_PTR(TYPE)) malloc(sizeof(NODE_STRUCT_TYPE(TYPE))); \
    OBJ_NAME->data = DATA;                                                   \
    OBJ_NAME->next = NULL

#define MAKE_LINKED_LIST_OBJ(TYPE, OBJ_NAME)                                 \
    LINKED_LIST_TYPE_PTR(TYPE) OBJ_NAME =                                    \
        (LINKED_LIST_TYPE_PTR(TYPE)) malloc(sizeof(LINKED_LIST_TYPE(TYPE))); \
    OBJ_NAME->size = 0;                                                      \
    OBJ_NAME->head = NULL;                                                   \
    OBJ_NAME->type = NULL;                                                   \
    MAKE_STRING(OBJ_NAME->type, #TYPE)

#define MAKE_STRING(VAR, STR)                         \
    VAR = (char *) calloc(strlen(STR), sizeof(char)); \
    strcpy(VAR, STR)

#define FREE_STRING(VAR) \
    free(VAR);           \
    VAR = NULL

#define UNWRAP_LIST_FROM_VOID_PTR(LIST, VAR_NAME) \
    LINKED_LIST_TYPE_PTR(LIST->type) VAR_NAME = (LINKED_LIST_TYPE_PTR(LIST->type)) LIST

#define UNWRAP_VAR_FROM_VOID_PTR(WRAPPED, TYPE, VAR_NAME) \
    TYPE *VAR_NAME = (TYPE *) WRAPPED

void append(void *list, void *data);
void prepend(void *list, void *data);
void insert(void *list, void *data, int position);
void traverse(void *list);
void cleanup(void *list);

#endif
