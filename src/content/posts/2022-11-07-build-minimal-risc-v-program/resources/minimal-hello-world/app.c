#include <stdlib.h>
#include <unistd.h>

int main(){
    char *buf = "Hello, World!\n";
    write(1, buf, 13);
    exit(10);
}