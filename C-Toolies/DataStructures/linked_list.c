#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define FIRST 0
#define LAST -1

typedef struct node node_t;

struct node
{
    char *data;
    node_t *next;
};

typedef struct linked_list
{
    node_t *head;
    size_t size;
} linked_list_t;

linked_list_t *create_list_object();
void cleanup(linked_list_t *list);
void traverse(linked_list_t *list);

void append(linked_list_t *list, char *data);
void prepend(linked_list_t *list, char *data);
void insert(linked_list_t *list, char *data, int position);

bool delete(linked_list_t *list, char *data);
bool search(linked_list_t *list, char *data, char *result);
void reverse(linked_list_t *list);

void just_remembering_c_struct_initialization_with_pointers()
{
    linked_list_t *list = create_list_object();

    printf("List size: %zu\n", list->size);
    if (list->head == NULL)
    {
        puts("The list head was null.");
    }
    else
    {
        puts("The list head was not null.");
        if (list->head->data == NULL)
            puts("The list head data was null.");
        else
            puts("The list head data was not null.");
    }

    free(list);
    list = NULL;
}

int main(void)
{
    linked_list_t *list1 = create_list_object();
    linked_list_t *list2 = create_list_object();

    append(list1, (char *)"one");
    append(list1, (char *)"two");
    append(list1, (char *)"three");
    append(list1, (char *)"four");
    append(list1, (char *)"five");
    append(list1, (char *)"six");

    append(list2,  (char *)"22");
    prepend(list2, (char *)"12");
    append(list2,  (char *)"50");
    insert(list2,  (char *)"44", 2);
    insert(list2,  (char *)"30", 2);

    puts("List 1:");
    traverse(list1);

    puts("List 2:");
    traverse(list2);

    delete(list1, "one");
    delete(list1, "four");
    delete(list1, "six");
    puts("List 1:");
    traverse(list1);

    cleanup(list1);
    cleanup(list2);
    return 0;
}

linked_list_t *create_list_object()
{
    linked_list_t *result = (linked_list_t *) malloc(sizeof(linked_list_t));
    result->size = 0;
    result->head = NULL;
    return result;
}

void cleanup(linked_list_t *list)
{
    if (list->size > 0)
    {
        node_t *curr = list->head;
        node_t *after = NULL;

        while (curr != NULL)
        {
            after = curr->next;
            free(curr);
            curr = after;
        }
    }

    free(list);
    list = NULL;
}

void traverse(linked_list_t *list)
{
    if (list->size == 0)
    {
        puts("The list is currently empty.");
        return ;
    }

    printf("List Size: %zu\n", list->size);
    node_t *current = list->head;
    int curr_node = 1;

    while (current != NULL)
    {
        printf("Node %d: %s\n", curr_node, current->data);
        curr_node++;
        current = current->next;
    }

    putchar('\n');
}

void append(linked_list_t *list, char *data)
{
    insert(list, data, LAST);
}

void prepend(linked_list_t *list, char *data)
{
    insert(list, data, FIRST);
}

void insert(linked_list_t *list, char *data, int position)
{
    if (list->size == 0)
        position = FIRST;

    if (position == FIRST)
    {
        node_t *new_head_node = (node_t *) malloc(sizeof(node_t));
        new_head_node->data = data;
        new_head_node->next = list->head;
        list->head = new_head_node;
    }
    else if (position == LAST)
    {
        node_t *current = list->head;

        while (current->next != NULL)
            current = current->next;

        node_t *new_node = (node_t *) malloc(sizeof(node_t));
        new_node->data = data;
        new_node->next = NULL;

        current->next = new_node;
    }
    else
    {
        int curr_index = 1;
        node_t *curr = list->head->next;
        node_t *prev = list->head;

        while (curr_index < position && curr->next != NULL)
        {
            prev = curr;
            curr = curr->next;
            curr_index++;
        }

        node_t *new_node = (node_t *) malloc(sizeof(node_t));
        new_node->data = data;

        prev->next = new_node;
        new_node->next = curr;
    }

    list->size++;
}

bool delete(linked_list_t *list, char *data)
{
    if (list->size == 0)
        return false;

    if (strcmp(list->head->data, data) == 0)
    {
        node_t *old_head = list->head;
        list->head = list->head->next;
        list->size--;

        free(old_head);
        old_head = NULL;
        return true;
    }

    node_t *curr = list->head;

    while (curr->next != NULL)
    {
        if (strcmp(curr->next->data, data) == 0)
        {
            node_t *found = curr->next;
            curr->next = curr->next->next;
            list->size--;

            free(found);
            found = NULL;
            return true;
        }
        curr = curr->next;
    }

    return false;
}

bool search(linked_list_t *list, char *data, char *result)
{
    if (list->size == 0)
        return false;

    node_t *curr = list->head;
    while (curr != NULL)
    {
        if (strcmp(curr->data, data))
        {
            if (result != NULL) result = curr->data;
            return true;
        }
        curr = curr->next;
    }

    return false;
}

void reverse(linked_list_t *list)
{
    return ;
}
