---
title: "S01C01 What is cross-compilation? Let's cross-compile and run the first program"
date: 2022-11-05
draft: false
images: ["/posts/2022-11-05-s01c01-cross-compile-and-run-the-first-program/images/hello-world.png"]
tags: ["riscv", "gcc", "qemu"]
categories: ["craft-system", "S01"]
---

This is the first chapter of series _Dive into RISC-V system, step by step_. In this series, we will learn the basic principles of programs, including how they are constructed, the structure of program files, how programs run, how software and hardware communicate, and how assembly language is converted into instructions. In the latter part of this series, we will implement a RISC-V assembler and linker, as well as a custom RISC-V assembly language and linker script language. With the assembler and linker, we will have the ability to generate programs (binary executable files), making it possible for us to create our own tools from scratch.

> In the first chapter of _Linkers & Loaders_ by John R. Levine, it is mentioned that "all the linker writers in the world could probably fir in on root". Perphaps after we finish this series, we may aslo be able to squeeze into this room 😁.

I will be using [Rust](https://www.rust-lang.org/) to write the assembler and script parser for this series. While many articles, tutorials and projects related to compiler and system programming often use C as the programming language. Rust provides a better option in this era. Using Rust is not just to keep up with the trend, but also to avoid low-level errors and reduce frustration in the learning and development process, which is especially important for beginners in system programming. Additionally, Rust has a convenient toolchain, like many modern languages, which allows us to focus on development and reduce some repetitive work. However, in the chapters that discuss basic principles, I will still use C language since it is very straightforward and can correspond well with low-level technology.

You may be wondering, "Why don't we jump right in and start by writing a language, an operation system, or a CPU?" While I understand the eagerness to dive into these ambitious projects. it's not a feasible approach. These projects have a high starting point. If you attempt to learn or practice directly from them, you will encounter many new concepts, which will lead to even more new concepts. Eventually, you may become overwhelmed by too many incomprehensible things. Of course, there are many paths to exploration and learning, but after stumbling around for a while, you will likely return to this starting point, which is like a beginner's village in system programming. To avoid unnecessary detours, it's best to begin your exploration journey here.

> Many beginners often ask questions like "How does the CPU work?" or "How to write an operating system?" Unfortunately, these questions are too "huge" to receive satisfactory answers. Such questions are akin to asking "Why can a battery light up a bulb?" or "Why does a magnet attract iron?" Initially, these questions may seem simple, but as you go deeper, new questions keep arising, leading to knowledge gaps that are difficult to fill.

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [1. Preface](#1-preface)
- [2. What is cross-compilation?](#2-what-is-cross-compilation)
- [3. GCC compiler](#3-gcc-compiler)
- [4. Cross-compiling your first program](#4-cross-compiling-your-first-program)
  - [4.1 Creating the "Hello, World!" program](#41-creating-the-hello-world-program)
  - [4.2 Cross-compiling](#42-cross-compiling)
  - [4.3 The ELF format](#43-the-elf-format)
- [5. Executing](#5-executing)
  - [5.1 Installing QEMU](#51-installing-qemu)
  - [5.2 Trying to run the program](#52-trying-to-run-the-program)
  - [5.3 Specify the dynamic linker path](#53-specify-the-dynamic-linker-path)
  - [5.4 Compiling program as statically linked type](#54-compiling-program-as-statically-linked-type)
  - [5.5 Modify the interpreter of program](#55-modify-the-interpreter-of-program)
- [6. Phased compilation](#6-phased-compilation)
  - [6.1 Preprocessing](#61-preprocessing)
  - [6.2 Compilation](#62-compilation)
  - [6.3 Assembly](#63-assembly)
  - [6.4 Linking](#64-linking)
- [7. General compilation parameters](#7-general-compilation-parameters)
- [8. Conclusion](#8-conclusion)

<!-- /code_chunk_output -->

## 1. Preface

To understand how programs are constructed, we can use some existing and widely used tools, such as compilers and debuggers. At the same time, to implement a relatively complete compiler within one person's capabilities, this series will focus on the relatively simple and low-threshold RISC-V architecture as the research and practice object. Of course, most of the computers we use today are based on the *x86_64* or _ARM_ architecture. Therefore, to build RISC-V programs, we need to start with _cross-compilation_.

## 2. What is cross-compilation?

_Cross-compilation_ is the process of compiling an application on one computer to run on another computer with a different architecture or operating system. For example, compiling an application on a computer to run on a mobile phone, compiling a Windows application on a Linux system, compiling a Linux application for the _RISC-V_ architecture on an *x86_64* architecture machine.

In other word, cross-compilation occurs when "the environment in which the compiler runs" is different from "the environment in which the generated program runs". The target environment includes two main elements: the _target architecture_ and the _target platform_.

- The _target architecture_ refers to the CPU instruction set architecture (ISA), such as the x86_64 instruction set of Intel and AMD CPUs, and the A64 instruction set used by popular mobile phones.

- The _target platform_ refers to the type of operating system, such as Linux, Windows, and Darwin/macOS.

The working principles and processes of both _native compilation_ (ordinary compilation) and _cross-compilation_ are exactly the same. Both aim to translate high-level languages into machine instructions (assembly code) for the target environment. So the term _cross-compilation_ does not refer to a specific function, but is just used to describe a situation where the compilation environment is different from the runtime environment.

{{< figure src="./images/compilation-comparasion.png" class="mid" caption="Compilation Comparation" >}}

Of course, when developing programs, in addition to considering the target architecture and target platform, more detailed information may need to be considered. For example, when developing Linux applications, subtle differences between different distributions need to be considered. However, for the compiler, it only cares about the target archiecture and target platform.

It's worth nothing that there are programs that do not require an operating system and can run independently, called _freestanding_ or _bare-metal_ programs, such as firmwares running on the microcontrollers (MCUs) and the kernel. When compiling such programs, only the _target architecture_ needs to be specified, and the _target platform_ does not need to be specified.

Cross-compilation serves two main purposes:

- First, it facilitates the generation of program files (binary executable files) for different target envvironments. If an application needs to be released on multiple platforms, cross-compilation can be used to generate the required program files with just a few steps for each update. Without cross-compilation, the source code would need to be copied to each target enviroment and then compiled, which would be tedious and time-consuming.

- Second, and most importantly, some target environments cannot run a compiler at all. For example, microcontrollers typically have limited resources, there is usually only tens of KiB of RAM and a few hundred KiB of flash, and cannot run a full set of compiler tools. You would not expect your smart oven or toilet to run compiler. In this case, cross-compilation can be used to generate programs.

The target instruction set of the compiler to be implemented in this series is _riscv64gc_, which is also a cross-compiler.

## 3. GCC compiler

The mainstream compilers currently in use are GCC and LLVM, both of which are open source and free. However, GCC is more commonly used in the field of microcontrollers, which will be used in the later chapters discussing the principles of software and hardware communication. Therefore, for simplicity, only GCC will be discussed below.

In addition to the compiler, the binary tool Binutils, debugging tool GDB, standard libraries, and kernel headers are often used when developing programs, collectively known as the GNU Toolchain. The GNU Toolchain can be easily installed through package managers in most Linux distributions. Depending on the compilation target, the names of the packages in the toolchain will also be different. For example, in Arch Linux, the [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) package names name:

- riscv64-linux-gnu-binutils
- riscv64-linux-gnu-gcc
- riscv64-linux-gnu-gdb
- riscv64-linux-gnu-glibc
- riscv64-linux-gnu-linux-api-headers

In addition, there are packages for compiling RISC-V bare-metal programs:

- riscv64-elf-binutils
- riscv64-elf-gcc
- riscv64-elf-gdb
- riscv64-elf-newlib

Package names may vary in different Linux distributions. For example, in _Debian_/_Ubuntu_, the package names are:

- binutils-riscv64-linux-gnu
- gcc-riscv64-linux-gnu
- binutils-riscv64-unknown-elf
- gcc-riscv64-unknown-elf
- gdb-multiarch

If the RISC-V GNU Toolchain is not available in your system's package repository, you can [download the source code](https://github.com/riscv-collab/riscv-gnu-toolchain) and install it from the source code.

> Unless otherwise specified, all operations in this series of articlles are completed in the Linux environment. While it is possible to operate on other systems, it is recommended to use Linux if one is determined to learn system programming in depth. In addition to being more convenient, the Linux system is like an open library full of treasures, and it would be a shame not to take advantage of the treasures at your fingertips.

## 4. Cross-compiling your first program

The "Hello, World!" program is a staple of the programming world, and it is a natural first step for learning cross-compilation.

### 4.1 Creating the "Hello, World!" program

Create a file named `app.c` anywhere with the following contents:

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

The program is very simple: print the text "Hello, World!" to the screen then exit the program with a return value of 0.

> After program exits, it returns an integer to the caller, which is called the _exit code_, It is a `uint32` number. It should be noted that in the Linux environment, only the least significant 8 bits of the number are valid. Therefore, the valid range of exit code is from 0 to 255. If a negative number is returned, it will be returned in [Two's complement](https://en.wikipedia.org/wiki/Two%27s_complement) form. For example, `-10` is represented in binary as `0000,1010` and in Two's complement as `1111,0101 + 1 = 1111,0110`, which corresponds to decimal `246`.

In the Linux environment, it is a convention to return 0 when the program exits successfully and a non-zero value when it fails. It's worth nothing that this is exactly the opposite of the _Boolean_ value convention in most programming languages, Therefore, when writing shell scripts, one should be careful that the `true` value in shell script is 0. In the shell, you can check the exit code of the previous program with the command `echo $?`. For example, running the command `true; echo $?` will display the number 0.

> I will create a folder called `resources` in the directory of each article. This folder will contain all the source code for the examples in that article. You can download them from [my blog's Github repository](https://github.com/hemashushu/hemashushu.github.io/tree/main/src/content/posts) if you need it.

### 4.2 Cross-compiling

The programs for compiling, assembling, and linking in the GNU Toolchain are `gcc`, `as` and `ld`. If you are processing a native compile, simply enter the program names. When cross-compiling, you need to add a prefix to the program name. For example, the prefix is `riscv64-linux-gnu-` when the target envirtonment is RISC-V and Linux.

To cross-compile the "Hello, World!" program, run the following command:

```bash
$ riscv64-linux-gnu-gcc -g -Wall -o app.elf app.c
```

The meanings of each parameters are:

- `-g`: Used to generate debugging information for use by GDB. The debugging information includes variable names, the location (line number) of instructions in the source code, etc. The debugging information is kept in the output file. Although we don't need debugging information in this example, it is good practice to include the `-g` parameter when compiling code in general.

- `-Wall`: Reports all warning messages generated during the compilation process, such as "declaring a local variable without using it", or "assigning a value to a variable without ever reading it". These warning messages are helpful in writing good code. Another similar parameter is `-Wextra`, which reports extra warning messages other than `-Wall`, such as "comparing `int` type and `unsigned int` type variables. For a detailed list, see [GCC 3.8 Options to Request or Suppress Warnings](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html)

> Sometimes, when compiling old source code, errors may be reported and the compilation process may be terminated. However, an old version of GCC can successfully complete the compilation. This is because the new version of GCC introduces new error checking rules, or some rules that only warned in the old version but are now treated as errors. If you cannot modify the source code, you can temporarily disable the rules by adding `-Wno-error=...` parameter to the GCC command. For example, `-Wno-error=int-conversion` allows pointer types to be assigned to integer variables or passed to integer parameters. Conversely, you can specify the `-Werror=...` parameter to promote some rules from the warning level to the error level. This can help catch potential issues early in the development process and prevent them from causing problems later on.

- `-o app.elf`: Specifies the name of the output file. If this parameter is omitted, the default output file name is `a.out`. Note that `-o app.elf` is a complete parameter, and the `app.c` that follows it is not part of this parameter.

> In the Linux system, the file extension of an executable file can be anything, unlike in the Windows system where the file extension of an executable file must be `exe`. This means that the output file can have any file extension or no extension at all, as long as it is marked as executable using the `chmod` command or other means.

- `app.c`: The name of the source code file.

The `app.elf` file is generated when compiling complete.

### 4.3 The ELF format

The ELF (_Executable and Linkable Format_) format is one of the formats for binary executable files, and `app.elf` generated in the previous step is a file in ELF format. To check the format information of the output file, you can use the following command:

`$ file app.elf`

The output result is roughly as follows:

```text
app.elf: ELF 64-bit LSB pie executable, UCB RISC-V, RVC, double-float ABI, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-riscv64-lp64d.so.1, BuildID[sha1]=afe0994d7df77dc817058ae17e814d8f0a4163ed, for GNU/Linux 4.15.0, with debug_info, not stripped
```

Here are the meanings of some of the content in the above text:

- `ELF` and `execuable`: Indicates that the current file is an _executable file_ in the _ELF file format_. There are three types of ELF format:

   1. `executable`: Which is the most common type. Note that in Linux systems, some executable files are not in ELF format, they are just script files with executable permissions, and their contents are text rather than binary.

   2. `shared object`: Which is shared library used for dynamic linking during runtime. The bunch of "*.so" files in the directories `/lib` and `/usr/lib` are this type.

   3. `relocatable`: Which is a file generated during the compilation process. The GCC compilation command in the previous step roughly did two things behind the scenes: the first is converting the C source code into a series of machine instructions and saved them in a relocatable file, which is called _compiling_; The second is linking one or more relocatable files into an executable file or shared library, which is called _linking_.

- `dynamically linked`, `interpreter`: Indicates that the current executable file is the _dynamically linked_ type, which means that it needs the help of other shared libraries to complete its work during runtime. The loading and initialization tasks of these libraries are completed by a program called _interpreter_, which is also called the _runtime dynamic linker_. This program is usually `/usr/bin/id.so` (although the extension is `so`, which looks like a shared library, it it actually an executable file. The reason why `so` suffix is added is probably to distinguish it from the statically linked program `ld`). The executable file can also be the _statically linked_ type, which does not need the help of other shared libraries during runtime and can complete all work by itself.

- `pie`: Indicates that the current executable file is a _position independent executables_, which will be explained in detail later.

- `64-bit, RISC-V, double-float ABI, GNU/Linux 4.15.0`: These pieces of information indicate the target architecture, target platform, and some detailed information of the target environment.

- `LSB`: Indicates that the data in the current file is _least significant byte_ first, which is commonly known as _little-endian_. The opposite of LSB is MSB, which is _most significant byte_ first, commonly known as _bit-endian_. Byte order determines how an integer (such as `int32` and `int64`, which must be composed of multiple bytes) is stored in memory or on disk. For example, if the number `0x11223344` is stored in memory using LSB, the order of each byte is "(start) 44 33 22 11", and if it is stored using MSB, the order is "(start) 11 22 33 44". When viewing the contents of an executable file with a hexadecimal viewer that uses LSB byte order, the order of each byte of an integer number needs to be reversed to get its true value, while text content can be read directly.

- `with debug_info, not stripped`: Indicates that the current executable file contains debug information.

The `file` command can only roughly view the format and basic information of a file. If you want to view the detailed contents of an executable file, you need a set of tools in the GNU Toolchain called [GNU Binutils](https://www.gnu.org/software/binutils/), which will be explained in detail in later sections.

## 5. Executing

If you try to run the `app.elf` compiled above directly, you will find that it cannot run property. This is because the target architecture of the executable file is RISC-V (assuming that your current machine is not RISC-V architecture). To run the program, a convenient method is to use an emulator software to simulate a RISC-V machine.

The generally well-known _virtualization software_, such as VirtualBox and VMWare, can only virtualize a machine with the same architecture as the host machine. This is because the virtual processor provided by these software is actually provided by the CPU hareware of the host. If you need to virtualize a machine with a different architecture, you need to use an emulator software, such as [QEMU](https://www.qemu.org/). The emulator uses software to simulate the target CPU, and then simulates some peripherals such as network interfaces, graphics interfaces, and solid-state storage drivers to ultimately create a virtual machine.

> Note that the term "Virtual Machine (VM)" is also often used in the runtime of programming languages, which is a concept closer to the emulator. A VM simulates an idealized processor (which is unrelated to the host processor) during runtime, and allows the processor to execute bytecode compiled from specific programming languages. Unlike an emulator, the VM only simulates the processor, and all the system calls and the hardware access are redirected to the host, so the VM is not a complete machine.

### 5.1 Installing QEMU

QEMU is an open-source and free software that is included in most Linux distribution's package repositories. So you can install QEMU using your system's package manager. In _Arch Linux_, the packages are:

- `qemu-system-riscv`
- `qemu-user`
- `qemu-user-static`

In _Debian_/_Ubuntu_, the packages are:

- qemu-system
- qemu-user
- qemu-user-static

For distributions that do not have QEMU in their package repositories, you can download the QEMU source code and compile and install it according to [this guide](https://wiki.qemu.org/Documentation/Platforms/RISCV).

QEMU can simmulate a complete set of hardware, including CPU, memory, hard disk driver, network interfaces and other components. All CPU instructions can be executed, and bare-metal programs can be run in this mode, this mode is called _full system mode_. In addition, QEMU can also simulate an independent Linux system. Linux applications compiled for different architecture can be run directly in this mode, this mode is called _user mode_. In this mode, QEMU dynamically translates the instructions in the application into the instructions of the host architecture, as well as redirect the system calls.

To start the _full system mode_, use the program `qemu-system-riscv64` and specify the machine type, the number of CPU cores, the amount of memory, and the virtual disk configuration through command parameters. To start the _user mode_, use the program `qemu-riscv64` and pass the file path of the application (executable file) as a parameter.

> QEMU is created by a legendary programmer [Fabrice Bellard](https://bellard.org/), who also wrote [FFmpeg](http://ffmpeg.org/). FFmpeg exists on almost every computer and mobile phone (although many people may not know it), since most media player software and video editing software rely on it. He also wrote TCC, QuickJS and other notable programs.

### 5.2 Trying to run the program

If you want to run the above "Hello, World!" program in QEMU full system mode, you need to configure a RISC-V system with bootloader, a virtual disk and install a Linux system, and copy the program into the virtual machine. for simplicity, we will run the program in the user mode:

`$ qemu-riscv64 app.elf`

The result of the command is:

```text
qemu-riscv64: Could not open '/lib/ld-linux-riscv64-lp64d.so.1': No such file or directory
```

Obviously, the program did not run correctly. By default, GCC produces dynamically linked programs, which require a _runtime dynamic linker_ to load the shared libraries required by the program. The runtime dynamic linker is the program `ld.so`, which is the `/lib/ld-linux-riscv64-lp64d.so.1` shown in the error message in this example.

The program produced by GCC is assumed to run in a "normal Linux system", while we are currently in a special environment called QEMU user mode. From the perspective of the "Hello, World!" program, it does not know that it is running in a specical environment and assumes that it is running in a Linux system based on the RISC-V architecture. Therefore, it searches for the dynamic linker `/lib/ld-linux-riscv64-lp64d.so.1` as usual. In reality, the current environment (the author's machine) is running the *x86_64* version of Linux, and the dynamic linker is `/lib/ld-linux-x86-64.so.2`. QEMU user mode only translates CPU instructions and does not convert other data such as file paths, so the program fails to run.

> You may have noticed that `./app.elf` can be executed directly, and the error message produced are the same. This is because the Linux kernel supports programs which require interpreters through the [MISC binary](https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html) feature. Check the file `/proc/sys/fs/binfmt_misc/qemu-riscv64`, it shows when you run `./app.elf` from the command line, the actually command `/usr/bin/qemu-riscv64-static ./app.elf` is executed. `qemu-riscv64-static` is the same as `qemu-riscv64` above, except that it is itself statically linked.

### 5.3 Specify the dynamic linker path

You will find that the file `ld-linux-riscv64-lp64d.so.1` does exist if your system is _Arch Linux_ and the package `riscv64-linux-gnu-glibc` is installed, but the path is `/usr/riscv64-linux-gnu/lib/ld-linux-riscv64-lp64d.so.1` instead of `/lib/ld-linux-riscv64-lp64d.so.1`. According to the manual of `qemu-riscv64`, you can pass a path as a parameter using the `-L` options or setting the `QEMU_LD_PREFIX` environment variable, then QEMU will add this path as a prefix to the ELF's `interpreter` path.

Therefore, you can run the `app.elf` program as follows:

- `$ qemu-riscv64 -L /usr/riscv64-linux-gnu/ app.elf`
- `$ QEMU_LD_PREFIX=/usr/riscv64-linux-gnu/ qemu-riscv64 app.elf`

Both commands can run correctly, and you should see the "Hello, World!" text output by the program.

{{< figure src="./images/qemu-user.png" class="wide" caption="QEMU User Mode" >}}

> On Linux, you can use the `locate` command to quickly find the location of files. For example, the command `$ locate lp64d.so.1` will show you the path to the dynamic linker.

### 5.4 Compiling program as statically linked type

In addition to running programs by specifying the path of dynamic linker in QEMU user mode, there is another method: generating statically linked executable files using GCC.

A statically linked program copies the binary code of external functions into the target executable file during compilation. In this way, the program does not need any shared libraries at runtime, and it does not need the dynamic linker `ld.so` either. The GCC compiler generates a statically linked program by adding the `-static` option. The modified compile command is as follows:

`$ riscv64-linux-gnu-gcc -static -o app-static.elf app.c`

Next, check the file format using the `file` command:

`$ file app-static.elf`

Part of the output is as follows:

```text
app-static.elf: ... statically linked ...
```

It shows that the original "dynamically linked" program has become "statically linked".

Then run this program with `qemu-riscv64`:

`$ qemu-riscv64 app-static.elf`

The program can run correctly without needing the `-L` option or setting the `QEMU_LD_PREFIX` environment variable. Actually the statically linked programs completely ignore the file system unless they need to read or write files.

Since statically linked programs are so portable and convenient to use, why not compile all programs as statically linked? Let's compare the file sizes of the same "Hello, World!" program in dynamically linked and statically linked types:

```text
$ ls -lh
total 668K
-rw-r--r-- 1 yang yang   78 Nov 26 04:00 app.c
-rwxr-xr-x 1 yang yang 9.8K Nov 27 13:38 app.elf
-rwxr-xr-x 1 yang yang 645K Nov 27 21:40 app-static.elf
```

The result shows that the size of the dynamically linked program is `9.8K`, while the size of the statically linked program is `645K`, which is much larger than the former.  This is because the compiler copies all the binary code of the functions requried by the `printf` function directly or indirectly into the target executable file. Statically linked programs not only have a larger file size, but also take longer to load and occupy more memory at runtime. On the other hand, the shared libraries are only loaded once and shared with all applications using memory mapping. So the dynamically linked programs load faster and occupy less memory. When a program depends on more libraries, the difference between these two types will be more significant.

> _Dynamically linking_ is a good idea for systems, However it also brings some headaches. In daily use experience with Linux, few programs that can be downloaded and run directly. In most cases, errors such as missing or mismatched shared libraries will occur. If you want to install a program that does not exist in the package repository, you can only install it by compiling the source code. This is too difficult for non-professional users. The author believes that this problem is caused by an excessive use of shared libraries. Many small and non-essential libraries should not be global shared libraries.

> The operating system that is being implemented will completely prohibit users from adding global shared libraries to the system. Global shared libraries are limited to very general and essential libraries, and they should be maintained by the kernel maintainers. Applications should also be isolated from each other, the shared libraries provided by a program can only be used by the program itself and its child programs. This mechanism fundamentally solves the portability problem caused by global share libraries, reduces the troubles of application deployment, and make application updates more effective and timely, eliminating the need for third-party maintainers.

### 5.5 Modify the interpreter of program

To make the "Hello, World!" program run correctly, you can also modify the dynamic linker of a program by passing the `--dynamic-linker` option to the GCC compiler, and the value of `interpreter` of the program will be updated. For example:

```bash
$ riscv64-linux-gnu-gcc -g -Wall -Wl,--dynamic-linker,/usr/riscv64-linux-gnu/lib/ld-linux-riscv64-lp64d.so.1 -o app-inter.elf app.c -L /usr/riscv64-linux-gnu/lib -lc
```

The `-Wl,--dynamic-linker,...` option in the command is used to pass parameters to the linker; the `-L` option is used to specify the path for the linker to search for shared libraries; the `-lc` option is used to specify the `libc.so` shared library to link. These options will be explained in detail in later sections.

When compilation is completed, check the program using the `file` command:

`$ file app-inter.elf`

Part of the output is:

```text
app-inter.elf: ... interpreter /usr/riscv64-linux-gnu/lib/ld-linux-riscv64-lp64d.so.1 ...
```

It shows that the `interpreter` of the program has been changed to the specified path. However, when running this program, a new error message appears:

```text
$ qemu-riscv64 app-inter.elf
app-inter.elf: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory
```

It seems that the RISC-V version of `ld.so` works, but the dynamic linker cannot find the RISC-V version of the shared library `libc.so.6`. This problem is easy to solve, just specify the path of the shared library that the program depends on through the `LD_LIBRARY_PATH` environment variable, for example:

`$ LD_LIBRARY_PATH=/usr/riscv64-linux-gnu/lib qemu-riscv64 app-inter.elf`

{{< figure src="./images/interpreter-path.png" class="wide" caption="Interpreter Path" >}}

The program can also run correctly. However this method is not very useful because it is much more complicated than the first two methods, and the generated program is only suitable for running in the QEMU user mode, and cannot run in a standard RISC-V Linux system. The main purpose of this example is to demonstrate how to modify the `interpreter` of a program. For more information about dynamic linkers, you can use the command `$ man ld.so` to view the documentation.

## 6. Phased compilation

When the command `riscv64-linux-gnu-gcc` compiles a C source code into an executable file, GCC actually completes the process in four stages.

{{< figure src="./images/gcc-compile-stage.png" class="wide" caption="GCC compile stages" >}}

### 6.1 Preprocessing

The files specified by `#include ...` in the source code are copied, and the conditional compilation instructions (`#ifdef`) are parsed and the macros are expanded. This is equivalent to the command:

`$ riscv64-linux-gnu-cpp app.c > app.i`

or

`$ riscv64-linux-gnu-gcc -E app.c > app.i`

The source code file that has been preprocessed has the extension `*.i`.

Note that the "cpp" in the name of program `riscv64-linux-gnu-cpp` stands for "C Preprocessor", not "C++".

> The `-D` parameter of the GCC compiler command is used to pass values to the C source code to control the conditional compilation instructions. For example, `-D DEBUG` (equivalent to `-D DEBUG=1`) can make the condition value of `#ifdef DEBUG ...` to true. For details, please refer to [GCC Preprocessor](https://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html)

### 6.2 Compilation

The C source code is compiled into assembly code, which is equivalent to the command:

`$ riscv64-linux-gnu-gcc -S app.i`

The generated assembly code file has the extension name `*.s`.

Note that when we write assembly code by hand, the file extension is generally `*.S` (capital S). `*.S` files will be preprocessed (such as processing `.include` instructions) during assembly, while the `*.s` (lowercase s) files will not be preprocessed. The specific extensions and GCC parameters can be found in [GCC Options Controlling the Kind of Output](https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html).

> Steps 1 and 2 can also be combined into one command: `$ riscv64-linux-gnu-gcc -S app.c`.

### 6.3 Assembly

The assembly code is converted into a sequence of machine instructions, generating a _relocatable file_, which is equivalent to the command:

`$ riscv64-linux-gnu-as -o app.o app.s`

> Steps 1 to 3 can also be combined into one command: `$ riscv64-linux-gnu-gcc -c -o app.o app.c`. The `-c` parameter means compile only but not link.

### 6.4 Linking

One or more _relocatable files_ are linked together, and the address of global variables, static variables, and functions are relocated. Finally, an ELF format executable file is generated, which is equivalent to the command:

`$ riscv64-linux-gnu-ld -o app.elf startup.o app.o`

The above commands links the two files `startup.o` and `app.o` to generate the executable file `app.elf`.

> `startup.o` provides the entry procedure `_start` and performs some initialization and cleanup work. It will be implemented in the next chapter.

These four steps represent a series of operations that occur when executing the command `$ riscv64-linux-gnu-gcc -o app.elf app.c`. If you wish to understand each step and detail of GCC during the compilation process, you can add the `-v` parameter to the command, like `$ riscv64-linux-gnu-gcc -v -o app.elf app.c`. This will prompt the GCC to display each operation as it occurs.

> In most cases, we do not need to divide the compilation process into four steps. Instead, we typically separate it into two steps: steps 1 to 3 referred to as _compilation_, and step 4 known as _linking_. Fenerally, building tools such as `make` are utilized to complete these tasks. Nevertheless, it is still crucial to comprehend the stages involved in the compilation process, and this can aid in resolving various issues encountered during the compilation.

## 7. General compilation parameters

GCC has some other commonly used parameters:

**`-I` is used to specify the path of header files during compilation**

Sometimes header files (`*.h`) are distributed in multiple directories. In this case, the `-I` parameter can be used to include the additional header file paths. For example, if the current path is `/home/yang/hello-world/app.c`, and there are additional header files located in `/home/yang/hello-world/include`, the command can be:

`$ riscv64-linux-gnu-gcc -I /home/yang/hello-world/include app.c`

**`-L` and `-l` are used to specify the path and name of additional libraries during linking**

For example, if a program depends on the shared library `/usr/lib/hello-world/libmymath.so`, the command can be:

`$ riscv64-linux-gnu-gcc app.c -L /usr/lib/hello-world/ -lmymath`

The parameter `-lmymath` indicates that the linking process will use the shared library `libmymath.so`. Note that the value of the `-l` parameter is not the file name of the library, but the _soname_ of the library. For example, the real name of shared library file in the above example is `libmymath.so`, and the soname is obtained by removing the prefix `lib` and the suffix `.so`. Similarly, `-lm` represents the shared library `libm.so`, and `-lpthread` represents the shared library `libpthread.so`.

> Generally, the parameters `-L ...` and `-l ...` are placed at the end of command, following the order of "dependent come last".

> If the compilation process is separated into two stages of _compilation_ and _linking_, then the `-I` parameter only needs to be specified during the compilation stage. This is because header files are only used for preprocessing and are not required during linking. Similarly, the `-L` and `-l` parameters only need to be specified during the linking stage. This is because library files are only used during the linking process and are not required during compilatin.

> You may have noticed that the syntax of GCC parameters is different from that regular programs. For example, the parameter `-lmymath` is actually a shorthand for `-l mymath`. The parameter `-static` which should be written as `--static` according to the standard syntax. GCC has a historical legacy.

## 8. Conclusion

In this chapter, we learned about cross-compilation and how to cross-compile a "Hello, World! program. We also used QEMU to simulate a Linux environment of a different architecture to run the cross-compile executable file. Through this process, we found that cross-compilation is not significantly different from regular compilation, but it produces an executable file that cannot be run directly on the current machine.

> This chapter is the first in a series of articles, and some parts may be difficult to understand. However, as we progress through the series, the content will become clearer. Learning C language in the Linux environment is crucial, and taking breaks between reading chapters to allow the brain to digest the information is recommended.

In the next chapter, we will build a simple program that can run independently without an operation system. If you feel confident in your understanding of the concepts covered in this chapter, feel free to proceed to the next chapter.

{{< figure src="/images/subscribe-and-donate.en.png" class="mid" >}}
