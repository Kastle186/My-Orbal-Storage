#include <stdio.h>

#define TO_UPPER_ASCII(c) (c - ('a'-'A'))

int main(int argc, char **argv)
{
    printf("%d\n", TO_UPPER_ASCII(97));
    return 0;
}
