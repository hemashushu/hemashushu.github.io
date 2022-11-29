#include "put_char.h"

void print_string(const char *str)
{
    while (*str != '\0')
    {
        put_char(*str);
        str++;
    }
}