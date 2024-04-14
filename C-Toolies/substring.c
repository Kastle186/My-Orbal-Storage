#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NO_SUBSTR_FOUND -1

// Algorithms to find the substring occurrences. To start with, we will only
// calculate the first occurrence of the pattern. Later on, we will expand
// to returning an array with the positions of all the pattern occurrences.

int naive_substring(const char *str, const char *pattern);
int knuth_morris_pratt_substring(const char *str, const char *pattern);

// Helper functions for the previous algorithms.

int *kmp_lps_table(const char *pattern);
void print_result(int res, const char *str, const char *pat, const char *algorithm);

int main(int argc, char **argv)
{
    if (argc < 3)
    {
        puts("\nApologies, but you need to pass the string to look into, and the"
             " pattern to search in the command-line arguments.");
        return 1;
    }

    const char *str = (const char *) *(argv+1);
    const char *pat = (const char *) *(argv+2);

    putchar('\n');
    // int substr_n = naive_substring(str, pat);
    int substr_kmp = knuth_morris_pratt_substring(str, pat);

    // print_result(substr_n, str, pat, (const char *)"naive");
    print_result(substr_kmp, str, pat, (const char *)"knuth_morris_pratt");

    return 0;
}

void print_result(int res, const char *str, const char *pat, const char *algorithm)
{
    if (res == NO_SUBSTR_FOUND)
    {
        printf("'%s' was not found in '%s' with %s algorithm :(\n",
               pat, str, algorithm);
    }
    else
    {
        printf("'%s' is a substring of '%s' at index %d with %s algorithm.\n",
               pat, str, res, algorithm);
    }
}

//***************************//
// Naive Substring Algorithm //
//***************************//

int naive_substring(const char *str, const char *pattern)
{
    // If either the string to search or the pattern are null or empty, there
    // cannot be a potential substring match, so we return the -1 since here.

    if (str == NULL || pattern == NULL || strlen(str) == 0 || strlen(pattern) == 0)
        return NO_SUBSTR_FOUND;

    int result = NO_SUBSTR_FOUND;
    return result;
}

//******************************//
// Knuth-Morris-Pratt Algorithm //
//******************************//

// Algorithm Overview:
// Start matching the characters in the string with the pattern.
//
// - If the characters are equal, then move on to the next one on both sides,
//   the text and the pattern.
//
// - If we reach the end of the pattern with no mismatches, then we've found the
//   answer we've been looking for.
//
// - When the characters differ, we take a look at our lps table. At the
//   item lps[pat_failed_index-1], it tells us what index we start again in the
//   pattern. If it's 0, then we start at the beginning of the pattern.
//
// - If we're at the first pattern character, and it differs from the current
//   text character, then we just move on to the next text character.

int knuth_morris_pratt_substring(const char *str, const char *pattern)
{
    // If either the string to search or the pattern are null or empty, there
    // cannot be a potential substring match, so we return the -1 since here.

    if (str == NULL || pattern == NULL || strlen(str) == 0 || strlen(pattern) == 0)
        return NO_SUBSTR_FOUND;

    int *lps = kmp_lps_table(pattern);
    int result = NO_SUBSTR_FOUND;

    // With indices!

    size_t str_len = strlen(str);
    size_t pat_len = strlen(pattern);

    // 'i' is gonna be the iterator of the text to look into.
    // 'j' is gonna be the iterator of the pattern to look for.

    for (int i = 0, j = 0; i < str_len; )
    {
        if (*(str+i) != *(pattern+j))
        {
            if (j == 0)
            {
                i++;
                continue;
            }

            // The potential candidate failed to be, so we're back to square one
            // looking for the next one opportunity.
            result = NO_SUBSTR_FOUND;
            j = *(lps + (j-1));
        }
        else
        {
            // If we're starting a potential substring result, then store its
            // index in the result variable, to have it ready in case the
            // candidate succeeds.
            if (result == NO_SUBSTR_FOUND) result = i;

            if (i == str_len-1 && j < pat_len-1)
            {
                // If we're still in a potential candidate but the original string
                // is over, then it ended up not being a full substring, and therefore
                // we failed the mission.
                result = NO_SUBSTR_FOUND;
                break;
            }
            else if (j == pat_len-1)
            {
                break;
            }
            else
            {
                i++;
                j++;
            }
        }
    }

    // With pointers!

    /* char *str_ptr = str; */
    /* char *pat_ptr = pattern; */
    /* int *lps_ptr = lps; */

    /* while (*str_ptr != '\0') */
    /* { */
    /* } */

    free(lps);
    lps = NULL;
    return result;
}

// LPS: Longest Prefix Suffix
// What does this mean? It indicates the longest proper prefix of the pattern,
// that also happens to be a proper suffix for it. For example:
//
// Let's use the string "A B C" here.
// Its proper prefixes would be "A" and "AB", and its proper suffixes would be
// "C" and "BC".
//
// Now, the LPS table contains on each 'index' the length of the longest prefix/suffix
// found within that range. For example:
//
// Let the pattern be "A B C D A B E A B F"
// Let's see a few indexes now:
// lps[5] -> This contains the string "ABCDAB"
// The lps is 2 because this string both, starts and ends, with "AB". All other
// proper prefixes and proper suffixes do not match.
//
// Why does this work?
// While looking for a substring, whenever a potential match ends up not being one,
// there might be some commonalities with the next potential match. If a certain
// amount of characters is an lps, then we can skip checking those in the next
// iteration because we already know they would match. Hence, we avoid doing
// duplicate checking work.

int *kmp_lps_table(const char *pattern)
{
    size_t pat_length = strlen(pattern);
    int *table = calloc(pat_length, sizeof(int));
    *table = 0;

    for (int currlps_len = 0, pat_i = 1; pat_i < pat_length; )
    {
        if (*(pattern + currlps_len) == *(pattern + pat_i))
        {
            // If we're finding an lps, keep moving forward for as long as we can.
            *(table + pat_i) = ++currlps_len;
            pat_i++;
        }
        else if (currlps_len > 0)
        {
            // If the current lps was broken, then retrocede one space in the hopes
            // of finding a shorter lps next.
            currlps_len = *(table + (currlps_len-1));
        }
        else
        {
            // If we're here, then that means there is no lps, or the last one we
            // found has been broken entirely. So, we set it to zero and continue.
            *(table + pat_i) = 0;
            pat_i++;
        }
    }

    return table;
}
