#include <stdio.h>
#include <string.h>

#define DICT_CAPACITY 100

typedef struct key_value_pair
{
    char *key;
    char *value;
} key_value_pair;

typedef struct dictionary
{
    key_value_pair *items;
    int count;
    int capacity;
} dictionary;

unsigned int compute_hash(char *str_to_be_key);
bool add_dict_entry(dictionary *dict, char *key, char *value);

// **********************
//  Code Implementation!
// **********************

int main(int argc, char **argv)
{
    dictionary dict;
    return 0;
}

// compute_hash(char *)
// This is one of the main components of the dictionary. This function calculates
// a hash code to be the storing index in the underlying array of the dictionary.
// For simplicity's purposes, we'll be writing a very simple function that adds
// up all the key's characters ASCII codes, and returns that modulo the capacity
// of our dictionary's underlying array engine.

unsigned int compute_hash(char *str_to_be_key)
{
    unsigned int hash = 0;
    size_t key_length = strlen(str_to_be_key);

    for (size_t i = 0; i < key_length; i++)
    {
        hash += (unsigned int) *(str_to_be_key + i);
    }

    return hash % DICT_CAPACITY;
}

bool add_dict_entry(dictionary *dict, char *key, char *value)
{
    // If the dictionary has a capacity of '0', then that means it has not been
    // initialized, so allocate the array that will serve as the hashing table
    // for it here.
    if (dict->capacity == 0)
    {
        dict->items = calloc(DICT_CAPACITY, sizeof(key_value_pair));
        dict->capacity = DICT_CAPACITY;
    }

    unsigned int index = compute_hash(key);

    // Find the next available slot closest to the ideal index, and add it there.

    return true;
}
