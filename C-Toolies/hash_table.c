#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

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

    // A linked list would help wonders here. Will leave using mine as an exercise
    // for later :)
    const char **keys;
    const char **values;
} hash_table;

hash_table *create_ht_object(void);
bool try_insert(hash_table *ht, char *key, char *value);
bool try_get(hash_table *ht, char *key, char *output);
bool contains_key(hash_table *ht, char *key);
void print_table(hash_table *ht);
void clear_table(hash_table *ht);

int main(void)
{
    hash_table *h_table = create_ht_object();
    clear_table(h_table);
    free(h_table);
    return 0;
}

hash_table *create_ht_object(void)
{
    hash_table *table = (hash_table *) malloc(sizeof(hash_table));

    table->ht_items = (key_value_pair **) calloc(HASH_TABLE_CAPACITY,
                                                 sizeof(key_value_pair *));

    table->size = 0;

    table->keys = (const char **) calloc(HASH_TABLE_CAPACITY,
                                         sizeof(const char *));

    table->values = (const char **) calloc(HASH_TABLE_CAPACITY,
                                           sizeof(const char *));

    return table;
}

bool try_insert(hash_table *ht, char *key, char *value)
{
    return true;
}

bool try_get(hash_table *ht, char *key, char *output)
{
    return true;
}

bool contains_key(hash_table *ht, char *key)
{
    return false;
}

void print_table(hash_table *ht)
{
    return ;
}

void clear_table(hash_table *ht)
{
    return ;
}
