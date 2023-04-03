#include "put_char.h"

void print_string(const char *str)
{
    while (*str != '\0')
    {
        put_char(*str);
        str++;
    }
}

int strlen(const char *str)
{
    const char *char_ptr;
    for (char_ptr = str; *char_ptr != 0; ++char_ptr)
    {
        //
    }
    return (char_ptr - str);
}

void itoa(int num, char *buf, int buf_len)
{
    int idx = 0;
    for (; idx < buf_len; idx++)
    {
        int mod = num % 10;
        buf[idx] = mod + '0';

        num = num / 10;
        if (num == 0)
        {
            break;
        }
    }

    int count = buf_len;

    if (idx < buf_len - 1) {
        count = idx + 1;
        buf[count] = '\0';
    }

    // reverse
    for (int i = 0; i < count / 2; i++)
    {
        int j = count - i - 1;
        char t = buf[i];
        buf[i] = buf[j];
        buf[j] = t;
    }
}

void print_int(int i)
{
    char s[21];
    itoa(i, s, 21);
    print_string(s);
}
