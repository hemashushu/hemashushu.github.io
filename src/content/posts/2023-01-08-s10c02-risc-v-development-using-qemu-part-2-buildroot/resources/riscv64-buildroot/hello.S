    .text
    .global _start

_start:
    # calling convention
    # a0-a2                     - parameters to Linux function
    # a7                        - Linux function number

    # call `write(int fd, char* s, int len)`
    li      a0, 1               # file descriptor, 1 = stdout
    la      a1, s               # the address/pointer to `s` string
                                # `la a1, s` is equivalent to
                                # `lui a1, %hi(s)` and `addi a1, a1, %lo(s)`
    li      a2, 13              # the length of string `s`
    li      a7, 64              # the number of syscall `write`
    ecall

    # call `exit(int)`
    addi    a0, x0, 0           # return code must be from 0 to 255
    addi    a7, x0, 93          # the number of syscall `exit`
    ecall

    .section .rodata
s:
    .asciz  "Hello World!\n"