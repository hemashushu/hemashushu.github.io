#!/bin/bash
riscv64-elf-as -o startup.o startup.S
riscv64-elf-gcc -I . -Wall -fPIC -c -g -o app.o app.c
riscv64-elf-gcc -I . -Wall -fPIC -c -g -o libprint.o libprint.c
riscv64-elf-as -o put_char.o put_char.S
riscv64-elf-ld -T app.ld -o app.out startup.o app.o libprint.o put_char.o

# riscv64-elf-gcc \
#     -I . \
#     -Wall \
#     -fPIC \
#     -g \
#     -Wl,-T,app.ld \
#     -nostdlib \
#     -o app.out \
#     startup.S app.c libprint.c put_char.S

qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel app.out

# riscv64-elf-objcopy -S -O binary app.out app.bin
# qemu-system-riscv64 -machine virt -nographic -bios none -device loader,file=app.bin,addr=0x80000000