#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Algorithms to find the substring occurrences. To start with, we will only
// calculate the first occurrence of the pattern. Later on, we will expand
// to returning an array with the positions of all the pattern occurrences.

int naive_substring(const char *str, const char *pattern);
int knuth_morris_pratt_substring(const char *str, const char *pattern);

// Helper functions for the previous algorithms.

int *kmp_lps_table(const char *pattern);

int main(int argc, char **argv)
{
    return 0;
}

//***************************//
// Naive Substring Algorithm //
//***************************//

int naive_substring(const char *str, const char *pattern)
{
    return -1;
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
    int *lps = kmp_lps_table(pattern);
    int result = -1;

    // With indices!

    size_t str_len = strlen(str);
    size_t pat_len = strlen(pattern);

    // 'i' is gonna be the iterator of the text to look into.
    // 'j' is gonna be the iterator of the pattern to look for.

    for (int i = 0, j = 0; i < str_len; )
    {
        if ((j == 0) && (*(str+i) != *(pattern+j)))
        {
            i++;
            continue;
        }

        if (*(str+i) == *(str+j))
        {
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
            currlps_len = *(table + (currlps_len-1))
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
