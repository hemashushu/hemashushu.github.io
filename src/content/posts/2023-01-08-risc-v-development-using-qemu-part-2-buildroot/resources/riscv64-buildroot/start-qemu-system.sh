#!/bin/bash
qemu-system-riscv64 \
    -M virt \
    -m 1G \
	-bios ./buildroot/output/images/fw_jump.elf \
	-kernel ./buildroot/output/images/Image \
	-append "rootwait root=/dev/vda ro" \
	-drive file=./buildroot/output/images/rootfs.ext2,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	-netdev user,id=net0,hostfwd=tcp::10022-:22 \
	-device virtio-net-device,netdev=net0 \
	-nographic
