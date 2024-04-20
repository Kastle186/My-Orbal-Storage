#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define HASH_TABLE_CAPACITY 100

typedef struct kvp
{
    char *key;
    char *value;
} key_value_pair;

typedef struct ht
{
    key_value_pair **ht_items;
    size_t count;
} hash_table;

hash_table *create_ht_object(void);
bool try_insert(hash_table *ht, char *key, char *value);
bool try_get(hash_table *ht, char *key, char **output);

void print_keys(hash_table *ht);
void print_values(hash_table *ht);
void print_table(hash_table *ht);
void clear_table(hash_table *ht);
void delete_table(hash_table *ht);

int main(void)
{
    hash_table *h_table = create_ht_object();

    try_insert(h_table, (char *)"1", (char *)"One");
    try_insert(h_table, (char *)"2", (char *)"Two");
    try_insert(h_table, (char *)"3", (char *)"Three");
    try_insert(h_table, (char *)"4", (char *)"Four");
    try_insert(h_table, (char *)"5", (char *)"Five");

    print_table(h_table);

    char *result = NULL;

    putchar('\n');
    printf("Output Result Variable Currently Has '%s'.\n", result);

    if (try_get(h_table, (char *)"3", &result))
        printf("Output Result Variable Now Has '%s'.\n", result);
    else
        puts("Key wasn't found :(");
    putchar('\n');

    delete_table(h_table);
    puts("Finished!");
    return 0;
}

unsigned int hash_function(const char *key)
{
    int hash = 0;
    char *key_ptr = (char *) key;

    // We'll be using a very simple hashing algorithm for this exercise's purposes.
    // We'll add the values of each character in the key string, and then return
    // that total modulo the capacity of the hash table in HASH_TABLE_CAPACITY.

    while (*key_ptr != '\0')
    {
        hash += (int) *key_ptr;
        key_ptr++;
    }

    return hash % HASH_TABLE_CAPACITY;
}

hash_table *create_ht_object(void)
{
    hash_table *table = (hash_table *) malloc(sizeof(hash_table));

    table->ht_items = (key_value_pair **) calloc(HASH_TABLE_CAPACITY,
                                                 sizeof(key_value_pair *));
    table->count = 0;

    return table;
}

bool try_insert(hash_table *ht, char *key, char *value)
{
    if (ht->count >= HASH_TABLE_CAPACITY)
    {
        puts("Apologies, but the hash table is full, so the new element could"
            " not be added.");
        return false;
    }

    unsigned int index = hash_function(key);

    // Ideally, the hash value will point to an empty index in the table. If that's
    // not the case, then look onto the next one, until we find a vacant space.

    while (*((ht->ht_items) + index) != NULL)
    {
        key_value_pair *curr_item = *((ht->ht_items) + index);

        if (strcmp(curr_item->key, key) == 0)
        {
            puts("Apologies, but that key is already in the hash table.");
            return false;
        }

        // If we get to the end of the table, then continue at the beginning.
        // We might find a vacant space somewhere before where we started.

        index = (index + 1) % HASH_TABLE_CAPACITY;
    }

    key_value_pair *entry = (key_value_pair *) malloc(sizeof(key_value_pair));
    entry->key = key;
    entry->value = value;

    *((ht->ht_items) + index) = entry;
    ht->count++;
    return true;
}

bool try_get(hash_table *ht, char *key, char **output)
{
    if (ht->count <= 0)
    {
        puts("Apologies, but the hash table is currently empty.");
        return false;
    }

    unsigned int index = hash_function(key);
    unsigned int start = index;

    // Since our example hash table does not support individual item deletion,
    // we can guarantee that finding an empty space means the key we're looking
    // for is not there.

    while (*((ht->ht_items) + index) != NULL)
    {
        key_value_pair *curr_item = *((ht->ht_items) + index);

        if (strcmp(curr_item->key, key) == 0)
        {
            printf("DEBUG: output = %s\n", *output);
            *output = curr_item->value;
            printf("DEBUG: output = %s\n", *output);
            return true;
        }

        // If we get to the end of the table, then continue at the beginning.
        // We might find the key we're looking for somewhere before where we
        // started. However, if we get back to where we started, that means
        // we've looked through the entire table, and said key was nowhere
        // to be found.

        index = (index + 1) % HASH_TABLE_CAPACITY;
        if (index == start) break;
    }

    return false;
}

void print_keys(hash_table *ht)
{
    puts("HASH TABLE KEYS:");
    for (int i = 0; i < HASH_TABLE_CAPACITY; i++)
    {
        key_value_pair *item = *((ht->ht_items) + i);
        if (item == NULL) continue;
        printf("%s\n", item->key);
    }
}

void print_values(hash_table *ht)
{
    puts("HASH TABLE VALUES:");
    for (int i = 0; i < HASH_TABLE_CAPACITY; i++)
    {
        key_value_pair *item = *((ht->ht_items) + i);
        if (item == NULL) continue;
        printf("%s\n", item->value);
    }
}

void print_table(hash_table *ht)
{
    puts("HASH TABLE CONTENTS:");
    for (int i = 0; i < HASH_TABLE_CAPACITY; i++)
    {
        key_value_pair *item = *((ht->ht_items) + i);
        if (item == NULL) continue;
        printf("%s: %s\n", item->key, item->value);
    }
}

void clear_table(hash_table *ht)
{
    for (int i = 0; i < HASH_TABLE_CAPACITY; i++)
    {
        free(*((ht->ht_items) + i));
        *((ht->ht_items) + i) = NULL;
    }
}

void delete_table(hash_table *ht)
{
    for (int i = 0; i < HASH_TABLE_CAPACITY; i++)
    {
        free(*((ht->ht_items) + i));
    }

    free(ht->ht_items);
    free(ht);
    ht = NULL;
}
