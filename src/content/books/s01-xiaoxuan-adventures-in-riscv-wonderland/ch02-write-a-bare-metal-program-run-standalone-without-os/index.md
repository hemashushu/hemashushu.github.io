---
title: "S01C02 Write a Hello World program that can run standalone without an OS"
date: 2022-11-06
draft: false
# images: ["/posts/2022-11-06-s01c02-write-a-bare-metal-program-run-standalone-without-os/images/bare-metal.png"]
tags: ["riscv", "bare-metal"]
categories: ["craft-system", "S01"]
---

In [the previous chapter](../2022-11-05-s01c01-cross-compile-and-run-the-first-program) we wrote a "Hello, World!" program, then cross-compiled it with GCC and ran it successfully using the QEMU emulator. However, we also found that the program was several hundred KiB in size, so we can conclude that it must contain a lot of content that we didn't write. In addition, it relies on the operating system to run, which as you know, is itself a vary large program. In this chapter, we will write a "Hello, World!" program that runs on its own without an operating system and libraries (such a program called a _bare-metal program_), and then we will cross-compile it with GCC and try to run it with QEMU. Bare-metal programs give us an idea of how a complete program is made up, and also how it is executed when the machine is powered on.

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [1. What is a bare-metal program?](#1-what-is-a-bare-metal-program)
- [2. How to start a bare-metal program](#2-how-to-start-a-bare-metal-program)
- [3. Creating a bare-metal version of "Hello, World!"](#3-creating-a-bare-metal-version-of-hello-world)
  - [3.1 How to access the hardware directly?](#31-how-to-access-the-hardware-directly)
  - [3.2 Sending characters through the serial port](#32-sending-characters-through-the-serial-port)

<!-- /code_chunk_output -->

## 1. What is a bare-metal program?

A bare-metal program is a program that runs in a "non-OS" environment, which may sound amazing at first: "How can a program run in a machine without operating system? How do I type in the name of a program without a terminal?" But if you think about it, the operating system's bootloader e.g., [GRUB](https://www.gnu.org/software/grub/), and the operating system kernel, they all run without an exists operating system. So surely a program can run without an OS, it just might use some magic that we don't yet know about.

However, a bare-metal program doesn't have magic, in fact it's not much different from an ordinary program. The arithmetic operations, flow control, and the structure of the program, is the same as an ordinary program. The difference is that for some privileged operations or I/O operations on hardware devices, the program has to do it by itself and cannot ask the operating system for help. In addition, bare-metal programs are not started with a filename, because there is no file system in the environment. Bare-metal programs usually exist in binary form in ROM or in a fixed location on disk.

If you want a bare-metal application to play music and access the internet, you need to write your own application and hardware drivers for sound card and the network interface; if you want two applications to run at the same time, you need to write a process scheduler; if you want to save a file to the hard disk (or to an SSD), you need to write a filesystem module; and if you want to make the application run safety, you need to implement a virual memory manager. As you can see, the more features you need, the closer the bare-metal program is to an operating system, and in fact the operating system kernel is a typical bare-metal program.

Of course a bare-metal program can be extremely simple if you just want the machine to do something simple task, such as the "Hello, World!" program.

> In general, the CPU has two modes, The _Supervisor_ and the _User_ when executing instructions. The kernel runs in the supervisor mode and it can execute most of the instructions, as well as it can access any hardware resource. Applications running in the user mode and it can only execute a limited number of instructions, such as arithmetic operations, memory loads and stores. In other words, in the user mode, the application can not directly access to peripherals such as keyboards, mice, monitors and network interface. It seems the application in this mode is almost useless, so how is the rich function of the application implemented? The answer is that the CPU provides a _Trap_ instruction for the user mode, which corresponds to the operating system's _syscall_. The application sends requests to the operating system (kernel) through the _syscall_, and the operating system accesses the privileged modules and the hardware resources on behalf of the application. It is worth mentioning that _syscall_ is not the only way for user mode applications to communicate with the outside world. For example, the Linux kernel creates virtual filesystems such as `/dev`, `/sys`, etc., which can be read or written to by the user application to access the module or hardware. In addition, some hardware peripherals map their interfaces to a certain address in memory (called IOMMU), and the reading and writing of this memory data by the user application will be converted into access to the hardware.

Programs that run in the microcontroller (MCU) (these programs are often called _firmware_) are also bare-metal programs, because the MCU has too few resources to run an operating system.

> There is a type of program called _Real Time Operating System (RTOS)_, usually in the form of libraries, which is a completely different concept from the operating system we usually take about.

## 2. How to start a bare-metal program

After the machine is powered on or reset, the CPU will start executing its first instruction from a specified memory address, which usually stores a _loader_ or hardware initialization program (e.g. BIOS/UEFI programs, sometimes called _firmware_) fixed in the ROM chip. The loader then tries to load the system _boot loader_ from a specified location and jumps to the first instruction (a.k.a. _entry_), which in turn loads the _kernel_ and jumps to the entry point. The process of booting a machine is running serveral programs one by one.

{{< figure src="./images/linux-boot-process.webp" class="full white" caption="The Linux boot process on x86_64 platform" >}}

It is important to note that the boot process is not the same for all machines, some platforms may have only one or two steps, others may have more. But one thing is certain: the location (memory address) and the entry point of echo program is predefined. So the easiest way to get the machine to run our bare-metal program is to place the program in the location reserved for the _boot loader_ or the _kernel_, so that it can "pretend" to be them, and the machine will execute our program when it is powered on (perhaps after a number of steps).

We are going to implement a bare-metal version of the "Hello, World!" program, which will run in the _full system mode_ of the _QEMU RISC-V 64-bit Virt_ virtual machine.

## 3. Creating a bare-metal version of "Hello, World!"

Let's look at the source code of a traditional "Hello, World!" program:

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

The above program is very simple, with only one key statement: it outputs the "Hello, World!" string to the screen by calling the `printf` function. If you step through the debugger, or look at the source code for [libc](https://sourceware.org/git/?p=glibc.git), you'll see that the `printf` function (and the `puts` function as well) goes through a series of functions, ending with the `write` _syscall_. This indicates that the program requires an operating system to run properly, and therefor cannot be a bare-metal program.

If you want to implement a bare-metal version of the "Hello, World!" program, you will have to implement your own functions for outputting characters to the screen hardware.

### 3.1 How to access the hardware directly?

Thankfully, interacting with hardware is not too complicated. Computer hardware consists of digital circuits. From a programming point of view, there are many "little switches" in these circuits. Some of these switches are used to change the state of the circuit's components to perform specific functions, while others turn themselves on or off, like small light bulbs, to tell the state of the circuit.

These "switches" actually correspond to _registers_ in digital circuits, whose inputs or outputs are mapped to specified addresses in memory spece. So when we write a bit 0 or 1 to one of these memories, we can set the state of the corresponding register, and vice versa, by reading these memories, we can get the state of the corresponding register.

So interacting with the hardware is simplified to **writing or reading data to or from a specified address memory**

### 3.2 Sending characters through the serial port

The virtual machine _QEMU RISC-V 64-bit Virt_ contains a virtual hardware chip [NS16550](https://www.qemu.org/docs/master/system/riscv/virt.html) which implements the [UART communication protocol](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter), which is often known as serial comminication. When data is written to this hardware, it is transferred via an RS-232 interface (in modern computers, this has been replaced by the USB interface) and a cable to a device on the other end, which in the _QEMU RISC-V 64-bit Virt_ is the _virtual terminal_ program running the QEMU program.

By reading the [NS16550 datasheet](http://caro.su/msx/ocm_de1/16550.pdf), we can see that the chip has 13 registers, which are used to set the working conditions and to write or read communication data. Each register has a name according to its function. For example, the first register of NS16550 is `THR` (Transmitter Holding Register), which is used to hold the data to be sent. In addition, each register has its own data size, and in the NS16550, each register is exactly 8-bit. These registers are arranged together to form a data space. According to the datasheet, the NS16550's registers form a block of 8 bytes of data. This data will be mapped into memory, so this space will have an _address_, and the program can locate each register by using the address and offset.

> The reason why the register space of NS16550 is not `13 x 1 byte = 13 bytes` is bacause some of the registers share the same location, for example, the `RHR` and `THR` both have address 0.

The [QEMU RISC-V Virt source code](https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c) lists the memory-mapped addresses of peripherals:

```c
static const MemMapEntry virt_memmap[] = {
    ...
    [VIRT_MROM] =         {     0x1000,        0xf000 },
    [VIRT_UART0] =        { 0x10000000,         0x100 },
    [VIRT_FLASH] =        { 0x20000000,     0x4000000 },
    [VIRT_DRAM] =         { 0x80000000,           0x0 },
    ...
};
```

where UART stands for serial device. From the above list, we know that the memory address of the serial debice NS16550 of this VM is `0x10000000` (the starting address of a peripheral is generally referred to as the _base address_). According to the datasheet, the address of register `THR` should be `0x10000000 + 0 = 0x10000000`, the address of register `LSR` (Line Status Register) is `0x10000000 + 0x5 = 0x10000005` and so on.

To send a character through the serial port, simply write the ASCII value (an integer of type _uint8_) to the address `0x10000000` (i.e. the register `THR`), and the character will be redirected to the virtual terminal program where the QEMU program is running.

TODO::

{{< figure src="/images/subscribe-and-donate.en.png" class="mid" >}}