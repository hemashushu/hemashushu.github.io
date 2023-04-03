.equ VIRT_UART0, 0x10000000
.globl _start

.section .text
_start:
    la      sp, stack_top
    call    bare_main

_loop:
    nop
    j       _loop

bare_main:
    la      t0, hello_world     # load hello world string address into t0
    li      t4, VIRT_UART0      # load UART0 address (a immediate number) into t4

    mv      t1, x0              # let t1 = 0 (t1 will be the loop index)
1:
    add     t2, t1, t0          # let t2 = t1 + t0
    lb      t3, 0(t2)           # let t3 = hello_world[t2] (lb = load byte)

    beqz    t3, 2f              # if a0 == 0 then goto `2f`
    sb      t3, 0(t4)           # t4[0] = t3 (sb = store byte)

    addi    t1, t1, 1           # t1 = t1 + 1
    j       1b                  # goto `1b`
2:
    ret

.section .rodata
hello_world:
#   .ascii "Hello, World!\n\0"  # no automatic trailing zero
    .asciz "Hello, World!\n"    # automatic trailing zero, as well as `.string`
