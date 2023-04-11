---
title: "RISC-V Development using QEMU - Part 1 Build a minimal Linux System"
date: 2023-01-06
draft: false
# images: ["/posts/2023-01-06-risc-v-development-using-qemu-part-1-minimal-linux/images/banner.png"]
images: ["/images/banner.png"]
tags: ["risc-v", "qemu"]
categories: ["development"]
---

This series articles will guide you setting up a RISC-V development environment using QEMU. The series includes four parts:

[Part 1](../2023-01-06-risc-v-development-using-qemu-part-1-minimal-linux/). Building a minimal RISC-V Linux system with only Linux kernel and BusyBox, and runs on the QEMU emulator.

Part 2. Building a base RISC-V Linux system with the ability of doing RISC-V assembly development and debug using Buildroot.

Part 3. Setting up a complete Debian RISC-V Linux system in QEMU, and do C language development and debug with GCC toolchains.

Part 4. Remote debugging with the GDB, and setup remote text editing and debugging by VSCode.

- - -

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Why not use real RISC-V hardware?](#-why-not-use-real-risc-v-hardware)
- [Create the project folder](#-create-the-project-folder)
- [Create RISC-V Linux "Hello World!" program](#-create-risc-v-linux-hello-world-program)
- [Build the Linux system](#-build-the-linux-system)
  - [Compile Linux kernel](#-compile-linux-kernel)
  - [Compile BusyBox](#-compile-busybox)
- [Make the image file](#-make-the-image-file)
  - [Make the file system](#-make-the-file-system)
- [Boot the system](#-boot-the-system)
- [Run the "Hello World!" program](#-run-the-hello-world-program)
- [Conclusion](#-conclusion)

<!-- /code_chunk_output -->

## Why not use real RISC-V hardware?

The RISC-V ISA has become popular in recent years due to its ease of learning and implementation, and the RISC-V toolchains are now quite mature. However, high-performance, stable and affordable RISC-V chips are still missing as of 2023.

Moreover, writing and debugging programs in an emulator is far more convenient than on real hardware. This approach can save money, eliminate the need for connecting wires, and avoid the hassle of copying or synchronizing program files. You can perform all sorts of tasks on just one machine.

## Create the project folder

QEMU is a software that emulates all the hardware of a complete computer system, including the CPU, memory, storage drives and network interfaces. This emulation is commonly known as a "virtual computer" or "virtual machine".

The storage device is usually implemented using a file called "image file", which means that the hard disk drive you see within the virtual machine is actually an ordinary file located on the _host machine_ (the machine running QEMU). Operations such as partitioning, formatting, reading and writing to the hard disk drive within the virtual machine take place inside the image file.

The hardware configuation of the virtual machine, such as the type of CPU, number of cores, memory capacity etc. is specified through QEMU command line parameters. As a result, the command to start QEMU can be quite long. It's a good practice to create a directory for each virtual machine, which contains an image file and a Shell script to start QEMU.

To get started, create a directory in your home directory and name it something like "riscv64-minimal-linux", this is where you will store all the files created in this chapter.

```bash
$ mkdir ~/riscv64-minimal-linux
$ cd ~/riscv64-minimal-linux
```

> It is not possible to create a RISC-V virtual machine using virtualaztion software such as VirtualBox and VMWare. This is because these types of software are only capable of creating virtual machine with the same architecture CPU as the host machine. For example, on an *x86_64* system, you can only create an *x86_64* virtual machine. However, since the computing ability of virtual machines is provided by the physical CPU of the host machine, their performance is typically much higher than that of QEMU.

## Create RISC-V Linux "Hello World!" program

Out objective is to create a RISC-V Linux system. To validate that the target system is functional, the most straightforward approach is to write a RISC-V Linux "Hello World!" program and try to execute it on the target system.

To begin, create a `main.c` file in the `~/riscv64-minimal-linux` directory and input the following code:

```c
#include <stdio.h>

int main(void){
    printf("Hello World!\n");
    return 0;
}
```

Compile the code using RISC-V GCC:

```bash
$ riscv64-linux-gnu-gcc -g -Wall -static -o main.elf main.c
```

Note that you may need to install the RISC-V GCC toolchains if they are not already installed on your system. For example, on Archlinux, the required packages are:

- riscv64-linux-gnu-gcc
- riscv64-linux-gnu-binutils
- riscv64-linux-gnu-gdb

On Debian/Ubuntu, the packages are:

- gcc-riscv64-linux-gnu
- binutils-riscv64-linux-gnu
- gdb-multiarch

After compiling, we obtain the output file `main.elf`, however it is certain that the program will not run properly. The program's instructions are in RISC-V, while the CPU of our host machine is *x86_64* or _ARM_, which cannot understand the meaning of RISC-V instructions.

> The compilation parameter `-static` instructs the compiler to generate an executable program with static linking, it simplifies our example.

## Build the Linux system

Building a runnable Linux system is actually far easier than you may think. In fact it only requires two softwares: the Linux kernel and Busybox.

The Linux kernel is responsible for driving and initializing hardware componenets, as well as creating an environment for running applications. On the other hand, BusyBox privodes a user friendly interactive interface a.k.a the Shell.

### Compile Linux kernel

1. Download the [Linux kernel source code tarball](https://github.com/torvalds/linux/tags) to the project folder, it's not recommended that cloning the source code Git repository, as it is very large, takes a long time to download and requires a significant amount of storage space.

```bash
$ wget https://github.com/torvalds/linux/archive/refs/tags/v6.2.tar.gz
```

Once the tarball is downloaded, extract it to obtain a folder named `linux-6.2`

```bash
$ tar xf v6.2.tar.gz
```

2. Compiling with default configuration

```bash
$ cd linux-6.2
$ ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make defconfig
$ ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make -j $(nproc)
```

Take a break and step out for a cup of coffee. When you return, you should find a file named `arch/riscv/boot/Image`.

To examine this file, use the `file` command:

```bash
$ file arch/riscv/boot/Image
```

The output should indicate that file is a "PE32+ executable (EFI application)"

```text
./arch/riscv/boot/Image: PE32+ executable (EFI application) RISC-V 64-bit (stripped to external PDB), for MS Windows, 2 sections
```

### Compile BusyBox

Navigate back to the `~/riscv64-minimal-linux` folder, download the [BusyBox tarball](https://busybox.net/downloads/busybox-1.36.0.tar.bz2), extract the tarball and configure it using the default settings.

```bash
$ cd ..
$ wget https://busybox.net/downloads/busybox-1.36.0.tar.bz2
$ tar xf busybox-1.36.0.tar.bz2
$ cd busybox-1.36.0
$ CROSS_COMPILE=riscv64-linux-gnu- make defconfig
```

Before proceeding with the compilation process, enter the `menuconfig` and make a slight modification.


```bash
$ make menuconfig
```

Check the "Settings -> Build Options -> Build static binary (no shared libs)" option. Then select "Exit" and confirm "Yes" when prompted with "Do you wish to save your new configuration".

Once you have completed this step, you can begin the compilation process:


```bash
$ CROSS_COMPILE=riscv64-linux-gnu- make -j $(nproc)
```

We now have the output file `./busybox`, use the `file` command to check and confirm that it is a RISC-V executable file with static linking.

```bash
$ file busybox
```

The expected output should resemble something like:

```text
busybox: ELF 64-bit LSB executable, UCB RISC-V, RVC, double-float ABI, version 1 (SYSV), statically linked, BuildID[sha1]=04d2e9ad32458855c1861202cc4f7b53dea75374, for GNU/Linux 4.15.0, stripped
```

## Make the image file

Navigate back to the `~/riscv64-minimal-linux` folder, create a new folder named `output`. This folder will be used to store files that can be deleted during system rebuilds, such as the image file:

```bash
$ cd ..
$ mkdir build
$ cd build
```

Next, create an empty file `vda.img` with a capacity of 128MB and format it as `ext2`:

```bash
$ dd if=/dev/zero of=vda.img bs=1M count=128
$ mkfs.ext2 -F vda.img
```

### Make the file system

Since the image file currently only contains one partition, which is empty, we can access it by mounting it. Once mounted, create the common Linux file system folder structure.

```bash
$ mkdir mnt
$ sudo mount -o loop vda.img mnt
$ cd mnt
$ sudo mkdir -p bin etc dev lib proc sbin tmp usr usr/bin usr/lib usr/sbin opt
```

Next, copy the BusyBox program file into the `bin` folder and create essential symbolic links.

```bash
$ cd bin
$ sudo cp ../../../busybox-1.36.0/busybox .
$ sudo ln -s busybox sh
$ cd ../sbin
$ sudo ln -s ../bin/busybox init
```

Additionally, copy the "Hello World!" profile file into `opt` folder:

```bash
$ cd ../opt
$ sudo cp ../../../main.elf .
```

To ensure that the file system has been created correctly, use the `tree` command.

```bash
$ cd ..
$ sudo tree
```

The expected output should resemble the following:

```text
.
├── bin
│   ├── busybox
│   └── sh -> busybox
├── dev
├── etc
├── lib
├── lost+found
├── opt
│   └── main.elf
├── proc
├── sbin
│   └── init -> ../bin/busybox
├── tmp
└── usr
    ├── bin
    ├── lib
    └── sbin

14 directories, 4 files
```

Finally, exit the `mnt` folder and unmount the image file.

```bash
$ cd ..
$ sudo umount mnt
```

You now have an image file `vda.img` which contains a minimal bootable Linux file system.

## Boot the system

To begin, install QEMU, On Arch Linux, the packaged is called `qemu-system-riscv`, on Debian/Ubuntu it's simply called `qemu-system`. Once you've installed QEMU, navigate back to the `~/riscv64-minimal-linux` folder again and run the following command:

```bash
$ qemu-system-riscv64 \
     -machine virt \
     -m 1G \
     -kernel ./linux-6.2/arch/riscv/boot/Image \
     -append "root=/dev/vda rw console=ttyS0" \
     -drive file=build/vda.img,format=raw,id=hd0 \
     -device virtio-blk-device,drive=hd0 \
     -nographic
```

There are several parameters in this command, let's go through them line by line:

- `-machine virt` QEMU can emulate many different types of read hardware platforms. A machine is a combination of a specified processor and some peripherals. The `virt` machine is a specical one that doesn't correspond to any real hardware. It's an idealized processor for a specified architecture combined with some devices.
- `-m 1G`: This specifies the memory capacity.
- `-kernel ./linux-6.2/arch/riscv/boot/Image`: This specifies the kernel file. Just like a real machine, the QEMU boot process also contains several stages: "bios -> kernel -> initramfs -> userspace init". When you omit the `-bios` parameter, the default RISC-V QEMU BIOS firmware called ` OpenSBI` will be loaded automatically.
- `-append "root=/dev/vda rw console=ttyS0"`: This appends parameters to the kernel.
- `-drive file=build/vda.img,format=raw,id=hd0` and `-device virtio-blk-device,drive=hd0`: These specify the block device, which can be considered as the hard disk drive or SSD in real life.
- `-nographic`: This indicates that this machine has no graphic interface hardware (also called a graphic card), so all text messages generated by the software in this machine will be fed back to user through the _Serial port_. Of course, the _Serial port_ is also virtual, it redirects the text message to the Terminal running the QEMU program.

After executing the command, a lot of text will scroll up until an error message appears:

```text
can't run '/etc/init.d/rcS': No such file or directory

Please press Enter to activate this console.
```

This error message appears because the system isn't fully installed yet. Press the `Enter` key and then run the following commands to finish the installation:

```bash
# /bin/busybox --install -s
# mkdir /etc/init.d
# touch /etc/init.d/rcS
# echo "#!/bin/sh" >> /etc/init.d/rcS
# echo "/bin/mount -t proc proc /proc" >> /etc/init.d/rcS
# chmod +x /etc/init.d/rcS
```

Note that this step only needs to be done once. The Linux system is now ready, let's do some checking:

```bash
# uname -a
Linux (none) 6.2.0 #1 SMP Tue Jan 4 02:10:41 CST 2023 riscv64 GNU/Linux

# free -h
              total        used        free      shared  buff/cache   available
Mem:         970.5M       10.6M      957.1M           0        2.7M      952.6M

# mount -t proc proc /proc

# cat /proc/cpuinfo
processor       : 0
hart            : 0
isa             : rv64imafdch_sstc_zihintpause
mmu             : sv57
mvendorid       : 0x0
marchid         : 0x70200
mimpid          : 0x70200

# df -h
Filesystem                Size      Used Available Use% Mounted on
/dev/root               118.5M      2.3M    109.7M   2% /
devtmpfs                484.2M         0    484.2M   0% /dev
```

## Run the "Hello World!" program

Try running the "Hello World!" program we made:

```bash
/opt/main.elf
```

If there are no exceptions, a line of text that reads "Hello World!" will be displayed. This indicates that we've successfully created a minimal RISC-V Linux system. Finally, execute the `poweroff` command to turn off the virtual machine.

## Conclusion

In this part, we've created a minimal Linux system with a base shell, and it can properly run a static linking user program. However, you'll notice that this system lacks many tools that we use daily, such as `SSH`, `Vim` and `wget` etc. In the next part, we'll build a base Linux system with common tools and the capability of doing RISC-V assembly development and debugging.
