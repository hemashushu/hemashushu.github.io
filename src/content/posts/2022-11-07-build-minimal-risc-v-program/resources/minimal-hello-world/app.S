.equ SYSCALL_WRITE, 64
.equ SYSCALL_EXIT, 93
.equ STDOUT_FD, 1

.section .text
.globl _start
_start:
    # ssize_t write(int fd, const void *buf, size_t count);
    addi a7, zero, SYSCALL_WRITE
    addi a0, zero, STDOUT_FD
    la a1, hello_world
    addi a2, zero, 14  # the length of "Hello, World!\n"
    ecall

    # void exit(int status)
    addi a7, zero, SYSCALL_EXIT
    addi a0, zero, 10
    ecall

.section .rodata
hello_world:
    .ascii "Hello, World!\n"
