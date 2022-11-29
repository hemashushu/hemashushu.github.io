#define VIRT_UART0 0x10000000

volatile char *const VIRT_UART0_PTR = (char *)VIRT_UART0;

void put_char(char c)
{
    *VIRT_UART0_PTR = c;
}