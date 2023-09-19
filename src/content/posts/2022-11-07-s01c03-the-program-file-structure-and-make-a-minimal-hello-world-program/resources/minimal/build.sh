#!/bin/bash
riscv64-elf-as -g -o app.o app.S
riscv64-elf-ld -T app.ld -nostdlib -o app.out app.o

qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel app.out