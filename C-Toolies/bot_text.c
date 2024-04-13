#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define UPPER(c) (c - (('a' - 'A') * (c / 'a')))

char *generate_bot_text(const char *human_text);

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("You need to pass the text to be converted in human form.\n");
        return -1;
    }

    const char *human_text = *(argv+1);
    char *bot_text = generate_bot_text(human_text);

    printf("Human Text: %s\n", human_text);
    printf("Bot Text: %s\n", bot_text);

    free(bot_text);
    bot_text = NULL;
    return 0;
}

// char *generate_bot_text(const char *)
//
// This method generates the bot-like version of the given human text. The result
// is that same text but with only capital letters, and a space between each letter.

char *generate_bot_text(const char *human_text)
{
    // The bot string will have one less than double the original string's number
    // of characters because the last one is not followed by a space, but is rather
    // the end of the string.@

    size_t original_len = strlen(human_text);
    size_t generated_len = (original_len * 2) - 1;
    char *result = calloc(generated_len, sizeof(char));

    char *orig_ptr = (char *) human_text;
    char *res_ptr = result;
    bool next_space = false;

    // This might sound counterintuitive but has an explanation. Calloc() initializes
    // the char type to the null terminator '\0'. So, while we still find that in the
    // result's allocated memory, we can be virtually sure that we're still within
    // its boundaries. Contrary to the original string, whenever we find its null
    // terminator, then that means we're done processing it and should exit this loop.

    for (; *orig_ptr != '\0' && *res_ptr == '\0'; res_ptr++)
    {
        if (next_space)
        {
            *res_ptr = ' ';
        }
        else
        {
            *res_ptr = UPPER(*orig_ptr);
            orig_ptr++;
        }

        // We need to keep track of alternating the letters with spaces as we fill
        // the resulting string :)
        next_space = !next_space;
    }

    return result;
}
