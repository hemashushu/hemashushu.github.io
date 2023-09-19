#!/bin/bash
riscv64-elf-gcc \
    -Wall \
    -Wl,-T,app.ld \
    -nostdlib \
    -o app.out \
    app.S

riscv64-elf-objcopy -S -O binary app.out app.bin

qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -device loader,file=app.bin,addr=0x80000000