---
title: "S01C02 编写一个无需操作系统，可独自运行的 Hello World 程序"
date: 2022-11-06
draft: false
images: ["/posts/2022-11-06-s01c02-write-a-program-run-alone-without-os/images/bare-metal.png"]
tags: ["riscv", "bare-metal"]
categories: ["craft-system", "dive-into-riscv"]
---

[上一章](../2022-11-05-s01c01-cross-compile-and-run-the-first-program) 我们写了一个 "Hello World!" 程序，然后用 GCC 交叉编译并使用 QEMU 模拟器成功运行。这一章将会编写一个无需操作系统即可独自运行的 "Hello World!" 程序，然后同样会使用 GCC 交叉编译并尝试使用 QEMU 运行。以此了解一个计算机在通电之后是怎样开始运行程序的，以及了解一个裸机程序应该怎样编写。

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [什么是裸机程序？](#什么是裸机程序)
- [如何启动裸机程序](#如何启动裸机程序)
- [裸机版的 "Hello World!" 程序](#裸机版的-hello-world-程序)
  - [如何直接访问硬件？](#如何直接访问硬件)
  - [通过串口发送字符](#通过串口发送字符)
  - [实现 print_string 函数](#实现-print_string-函数)
  - [主程序](#主程序)
  - [程序启动器](#程序启动器)
- [编译](#编译)
- [链接](#链接)
- [运行](#运行)
- [打包静态库](#打包静态库)
- [总结](#总结)

<!-- /code_chunk_output -->

## 什么是裸机程序？

_裸机程序_ 是指在 "无操作系统" 的环境中运行的程序，初一听起来可能会觉得很神奇：一个机器不用安装操作系统也能运行程序？没有操作系统我怎样输入程序的名称，怎样启动程序？但仔细想想，操作系统本身，还有系统引导器（比如 GRUB），它们都是在没有操作系统的情况下运行的。

其实裸机程序跟普通应用程序并没有太大的区别，其中的数值计算、流程控制、程序的结构等跟普通应用程序是一摸一样的，只是在进行一些特权或者 I/O 操作时，无法让操作系统代劳（因为运行环境中根本没有操作系统）。一般的程序进行 I/O 操作时，是通过调用标准库，标准库再向操作系统发起 _系统调用_ 等一系列过程实现的。而裸机程序需要自己直接跟硬件打交道。

如果你想在裸机程序里让机器播放音乐或者访问互联网，则还得自己写声卡和网卡的硬件驱动，当然如果这些外设有开源的驱动的话就不必自己写。如果你还想让机器能够一边播放音乐一边上网，那么还得自己写进程管理程序。如果想让程序运行起来安全可靠一些，可能还得自己写虚拟内存管理程序。可见当你要求裸机程序的功能越多，它就越接近一个操作系统，操作系统内核就是一个典型的裸机程序。

## 如何启动裸机程序

机器通电之后 CPU 会从某个固定的内存地址开始执行第一条指令，这个内存地址一般对应着一段固定在 ROM 芯片里的加载程序（loader）或硬件初始化程序（比如 BIOS），然后加载程序会尝试从约定的几个地方加载引导程序（boot loader）并跳转到该引导程序的第一条指令，引导程序再加载内核并跳转内核的入口。

需要注意的是并不是每一个机器通电后的过程都一样的，有些硬件平台可能只有其中的一个或两个步骤，有些则可能会有更多的步骤。但有一点是确定的：每个环节的程序的第一条被执行的指令的位置都是上一个环节固定的，所以要让机器运行我们写的裸机程序，只需把这个程序放置在预留给引导程序或者内核的位置，这样就可以 "冒充" 为引导程序或者内核而被机器运行。

## 裸机版的 "Hello World!" 程序

下面要实现是一个 "裸机" 版的 "Hello World!" 程序，该程序将会在 _QEMU 全系统模式_ 的 _RISC-V 64_ 机器（也就是程序 `qemu-system-riscv64`）里运行。

<!--
实现 3 个功能：

1. 向串口控制台打印一行 "Hello world!" 文本；
2. 计算两个整数的和并显示其结果；
3. 计算一个整数加上 10 之后的值，并显示其结果。

该程序的源文件数量比较多，涉及的新鲜概念也比较多，在这篇文章里暂时不会作细致的分析，如果对其中的细节或者原理有疑惑，可以暂时忽略。后续的文章会有详细的讲解，你可以在阅读完后续的文章之后再回来看该程序的内容。

这个章节仅为了简单介绍用 GCC 编译裸机程序的过程。

### 程序的组成

程序由下列几个部分组成：

- 基础库 `put_char.S` 和 `libprint.c`
- 计算库 `liba.c` 和 `libb.c`
- 主程序 `app.c`
- 启动器 `app_startup.S`

#### 基础库
-->

### 如何直接访问硬件？

"Hello World!" 的程序很简单，主要就是调用 `printf` 函数向屏幕输出 "Hello World!" 字符串。可问题是在裸机环境里没有标准库，所以无法直接调用 `printf` 函数，而更严重的问题是，因为没有操作系统的支持，所以连底层的 `write` 系统调用（syscall）都无法使用。为了向屏幕输出文字信息，只能直接跟硬件打交道了。

幸好跟硬件打交道不算太复杂，数字电路可以粗略地看作由一系列 "小开关" 构成。其中有些开关供外部设置，有些开关用于向外部反映状态。这些开关实际上对应着数字电路中的 _寄存器_ 元件（注意这里的寄存器不是指处理器里面那组寄存器，而是一般的寄存器），这些寄存器的输入端或者输出端会通过复用器映射到内存空间的某个地址。于是当我们向这些内存地址写入比特 0 或者 1 时，就可以设置相应寄存器的状态（即低电平和高电平，分别用 0 和 1 表示），反之，读取这些内存地址，就能获得相应寄存器的状态。于是跟硬件打交道就简化为 **向指定内存地址写入或者读取数字**。

### 通过串口发送字符

虚拟机 _QEMU RISC-V 64 Virt_ 里有一个虚拟的硬件 [NS16550](https://www.qemu.org/docs/master/system/riscv/virt.html)，它是一个实现了 [UART 通信协议](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter) 的芯片，也就是我们常说的串口。当向这个芯片读入数据时，数据会通过 RS-232 电缆传送到另一端的设备，在 _QEMU RISC-V 64 Virt_ 里，这个 _另一端的设备_ 就是运行 QEMU 程序的虚拟终端。

通过阅读 [NS16550 的数据手册（data sheet）](http://caro.su/msx/ocm_de1/16550.pdf) 可知芯片一共有 13 个 8 bit 的寄存器，这些寄存器用于通信状态和数据的设置和读取。其中偏移地址为 0 的名称为 `THR`（Transmitter Holding
Register）的寄存器用于存放待发送的数据（一个 uint8 类型的整数）。

然后再通过 [QEMU RISC-V virt 的源代码](https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c) 所显示的硬件外设（peripherals）的内存映射地址列表，得知 UART 被映射到内存 `0x10000000` 位置。

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

也就是说，NS16550 芯片的寄存器组的在内存中的基址为 `0x10000000`，那么寄存器 `THR` 的实际地址就是 `0x10000000` + `0`，寄存器 `LSR`（Line Status Register）的实际地址为 `0x10000000` + `0x5`：

<!--
https://github.com/michaeljclark/riscv-probe/blob/master/libfemto/drivers/ns16550a.c
-->

综合以上信息，如果要向串口发送一个字符，只需向地址 `0x1000_0000` 写入字符对应的 ASCII 数值，然后这个字符就会被重定向到运行 QEMU 程序的虚拟终端。

所以要实现打印单个字符的函数是很简单的，源代码文件是 `put_char.S`, 内容如下：

```S
.equ VIRT_UART0, 0x10000000

.section .text.put_char

.globl put_char

put_char:
    li s1, VIRT_UART0
    mv s2, a0
    sb s2, 0(s1)
    ret
```

上面汇编源代码定义了一个名为 `put_char` 的函数，其中的代码的大致作用是：

1. `li s1, VIRT_UART0` 将常量 `VIRT_UART0` 的值加载进寄存器 `s1`；
2. `mv s2, a0` 将寄存器 `a0` 的值，也就是函数的第一个参数的值，复制到寄存器 `s2`；
3. 将 `s2` 的值写到内存地址 `s1 + 0`。

> 有关 RISC-V 汇编的内容会在后面的章节详细讲解，在这里列出是为了大家对它有个大概的印象。
>
> 如果之前了解过汇编，会发现 RISC-V 的 [汇编源代码的语法](https://en.wikipedia.org/wiki/X86_assembly_language#Syntax) 是 Intel 风格，而不是 GNU 默认采用的 AT&T 风格，包括后面将会接触的 ARM thumb 汇编，也是 Intel 风格，很有意思。

`put_char` 函数也可以用 C 语言实现，两个版本随意选一个即可，源代码文件是 `put_char.c`，其内容如下：

```c
#define VIRT_UART0 0x10000000

volatile char *const VIRT_UART0_PTR = (char *)VIRT_UART0;

void put_char(char c)
{
    *VIRT_UART0_PTR = c;
}
```

> 为了简单起见，所以这里忽略了 UART 发送所需的延迟。如果是在真实硬件上编写发送字符的程序，应该检查 UART TX FIFO 的值，仅当上一个字符发送完毕之后（即 TX 空闲之后）再发送下一个字符。

### 实现 print_string 函数

在此函数 `put_char` 基础之上，可以用 C 语言实现 `print_string` 函数，以方便后续的调用。源代码文件为 `libprint.c`，其内容如下：

```c
#include "put_char.h"

void print_string(const char *str)
{
    while (*str != '\0')
    {
        put_char(*str);
        str++;
    }
}
```

<!--
至此，应用程序已经有打印字符、字符串和数字的能力了。

#### 计算库

接下来实现整数相加等数学函数，源代码文件分别为 `liba.c` 和 `libb.c`，其内容如下：

```c
// liba.c
int add(int a, int b)
{
    return a + b;
}

// libb.c
#include "liba.h"

int add10(int i)
{
    return add(i, 10);
}
```

> 之所以把函数划分到两个文件，是因为接下来的章节会讲述 _打包目标文件_ 的功能，即把 `liba.o` 和 `libb.o` 打包为 `libmath.a`
-->

### 主程序

主程序很简单，源代码文件为 `app.c`，其内容如下：

```c
#include "libprint.h"

void bare_main()
{
    print_string("Hello World!\n");
}
```

因为这个是裸机程序，为了跟标准程序区分，这里把平常的主函数 `main` 命名为 `bare_main`（随意的一个名称都可以）。

### 程序启动器

学习过 C 语言编程的大概都知道程序最先被执行的是 `main` 函数，可实际上程序的入口（即最先被开始执行的指令）是由编译器自动生成的 `_start` 过程，该过程会做一些初始化工作，比如设置栈顶地址等，然后才跳转到函数 `main`。

但仅在编译和链接为标准 Linux 程序时才会自动生成 `_start` 过程，现在我们写的是裸机程序，所以需要自己手写类似的入口过程。源代码文件为 `startup.S`，其内容如下：

```S
.section .text.entry
.globl _start

_start:
    la sp, stack_top
    call bare_main

_loop:
    nop
    j _loop
```

其中的代码的大致作用是：

1. `la sp, stack_top` 因为程序有嵌套的函数调用，所以需要用到 _栈_。通过向 `sp`（stack pointer）寄存器写入一个地址即可设置栈顶地址，这样一句话就把 _栈_ 搭建好了。（注意代码中的 `stack_top` 来自下面的链接脚本 `app.lds` 导出的符号）
2. `call bare_main` 调用主程序的主函数 `bare_main`，当 `bare_main` 函数执行完毕返回后，就执行由 `_loop ... j _loop` 组成的死循环。之所以需要这样的一个死循环，是因为物理机器里可没有类似 "结束程序" 的指令，为了防止从函数 `bare_main` 返回之后往下执行内存中乱七八糟的数据，所以设置这样的一个让 CPU 原地打转的指令，虽然不优雅却管用。注意，当 QEMU 执行到这里时，你的电脑风扇也会飞快地旋转起来，不过不用担心，只需结束 QEMU 程序就解决了。

## 编译

编译各个源文件，但暂时不需要链接：

```bash
$ riscv64-elf-as -o startup.o startup.S
$ riscv64-elf-gcc -I . -Wall -fPIC -c -o app.o app.c
$ riscv64-elf-gcc -I . -Wall -fPIC -c -o libprint.o libprint.c
$ riscv64-elf-as -o put_char.o put_char.S
```

在编译 `app.c` 时你可能会感到疑惑，在 `app.c` 里调用了函数 `print_string`，但这个函数却在后面才编译，那么为什么 `app.c` 在 "引用了一个尚未编译的函数" 的情况下也能成功编译呢？

这正是 GCC 编译的工作原理，在编译一个源文件时，如果代码里有调用外部函数，编译器实际上不管这个外部函数是否存在（是否已经编译），也不管它在哪里，你只需提供这个函数的签名即可（函数签名位于诸如 `libprint.h` 等头文件里），这也是为什么各个源文件可以各自单独编译，甚至多个源文件可以并行编译的原因。

> 平时编译软件可能会经常输入的类似 `$ make -j $(nproc)` 或者直接 `$ make -j` 这样的命令，它可以让编译速度提高几倍，现在应该知道它的原理正是使用多条进程同时并行编译。

## 链接

在上面的 [如何直接访问硬件？](#如何直接访问硬件) 一节里提到，需要把裸机程序放置在某个指定的位置，机器才能正确找到并执行我们的程序，在 QEMU 里这个位置就是内存位置 `0x80000000`。

怎样才能让 QEMU 把程序加载到指定的位置呢？`qemu-system-riscv64` 程序支持加载 ELF 格式的程序和纯二进制数据：

- 当加载的是 ELF 格式文件时，它会按照 ELF 的结构信息加载到指定的位置；
- 当加载的是纯二进制数据是，可以通过参数 `-device loader,file=FILENAME,addr=0x80000000` 指定加载地址。

下面采用的是第一种方法，只需在链接时指定一个链接脚本，就可以让链接器按照脚本的描述来组织和生成程序的各段。下面是链接脚本 `app.ld` 的部分内容：

```text
BASE_ADDRESS = 0x80000000;

SECTIONS
{
  . = BASE_ADDRESS;
  ...
}
```

其中 `. = BASE_ADDRESS` 语句用于指定程序的第一个段的加载地址，相当于指定了程序的加载位置。

> 有关 _程序段_ 以及链接脚本的详细内容，会在下一章讲解。

然后使用 `ld` 命令把 `startup.o`，`app.o`，`libprint.o` 和 `put_char.o` 链接起来，并根据链接脚本 `app.ld` 生成可执行文件：

`$ riscv64-elf-ld -T app.ld -o app.out startup.o app.o libprint.o put_char.o`

命令中个参数的作用：

- `-T app.ld` 表示使用指定的链接脚本 `app.ld`。
- `-o app.out` 指定输出的文件名。
- `startup.o app.o libprint.o put_char.o` 表示待链接的文件列表（注意，文件列表和共享库列表一样，尽量按照 "被依赖的项排在后面" 这样的顺序排列。顺序错误的话可能会导致链接失败）。

<!--
链接命令中的参数 `libmath.a` 是静态库文件，可见其实静态库文件可以简化链接命令（假设静态库是由非常多的目标文件组成的话）。
-->

命令运行之后得到 ELF 格式的可执行文件 `app.out`。

当然编译和链接也是可以只用一个命令来完成：

```bash
riscv64-elf-gcc \
    -I . \
    -Wall \
    -fPIC \
    -g \
    -Wl,-T,app.ld \
    -nostdlib \
    -o app.out \
    startup.S app.c libprint.c put_char.S
```

上面命令有两个新的参数：

- `-Wl,-T,app.ld` 这个是用于传递给链接器 `ld` 的参数，相当于 `$ ld ... -T app.ld ...`。当需要把参数从 GCC 传递给链接器时，可以构造这种以逗号分隔的字符串。
- `-nostdlib` 表示不需要自动往目标程序添加 `_start` 启动过程以及链接标准库，上一章我们知道 GCC 会自动往目标程序添加很多内容，而参数 `-nostdlib` 告诉它整个程序的内容都由我们自己的代码提供，这是构建裸机程序必须的。

## 运行

下面使用 QEMU 的 _全系统模式_ 程序 `qemu-system-riscv64` 运行该文件：

```bash
$ qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel app.out
```

如无意外，应该能看到正确的输出结果 "Hello World!"：

![qemu system](images/qemu-system.png)

这时你的主机（通常称为 _host_）可能会有一个核心（core）的负载率高达 100%，这是因为 "Hello World!" 程序从 _bare_main_ 函数返回之后，来到了一个死循环（即 `startup.S` 的 `_loop`），你需要结束 QEMU 程序才能让 CPU 平静下来。

请注意需要按 `Ctrl+a` 然后再按 `x` 来结束 QEMU 程序，而不是平常的 `Ctrl+c`，这个奇怪的组合键可能跟 VIM 的退出方法一样让你手忙脚乱一阵子。

> QEMU 不使用 `Ctrl+c` 退出自身程序是有原因的，因为在 QEMU 里运行的是一个系统（比如一个完整的 Linux 系统，或者一个 Linux 桌面），这个系统（通常称为 _guest_）里面的程序需要 `Ctrl+x` 来退出，所以虚拟机本身当然不能用 `Ctrl+c` 来退出了。有些串口通信程序也是使用这样 "奇怪" 的组合键来结束程序本身，比如 [picocom](https://github.com/npat-efault/picocom) 和 [minicom](https://salsa.debian.org/minicom-team/minicom) 也是使用 `Ctrl+a, x`，也是基于同样的原因。

## 打包静态库

写一段时间裸机程序后可能会发现诸如 `startup.S`、`libprint.c` 和 `put_char.S` 等基础功能会经常被不同的程序所引用，我们可以把这些基础功能的代码编译并打包为一个库，就像 C 标准库 `libc` 一样，可以方便地为以后写的程序所使用。

在 Linux 系统里，_库_ 分有 _静态库_ 和 _动态库_ 两种，扩展名分别为 `*.a` 和 `*.so`。静态库的代码会在编译的过程直接复制到输出文件（即可执行文件），而动态库则需要操作系统的支持，在程序运行时动态地链接上。当前程序是裸机程序，所以只能使用静态库了。使用工具 `ar` 可以将 _可重定位文件_ 打包成静态库，例如：

`$ riscv64-elf-ar rs libbaremetal.a startup.o libprint.o put_char.o`

`ar` 命令后面跟着 _一个操作码_ 以及 _零或多个修饰符_：

- 操作码 `r` 表示插入新的文件，或者替换静态库中已存在的文件，通常用于新建静态库；
- 修饰符 `s` 表示为静态库创建索引，相当于创建完静态库之后执行了一次 `$ riscv64-elf-ranlib libbaremetal.a` 命令；
- `libbaremetal.a` 是输出的文件名；
- `startup.o libprint.o ...` 是输入的文件列表。

运行之后将得到静态库文件 `libbaremetal.a`。

工具 `ar` 除了可以创建静态库，还可以用于查看或者修改，使用不同的操作码就能实现不同的功能。比如下面的命令可以查看静态库文件里含有哪些文件：

`$ riscv64-elf-ar t libbaremetal.a`

输出的结果如下：

```text
startup.o
libprint.o
put_char.o
```

由此可以确定已经正确打包所需的文件了。然后编译时就再也不需要 `startup.S`、`libprint.c` 和 `put_char.S`（当然头文件 `libprint.h` 仍需要），使用一个 `libbaremetal.a` 代替它们三个即可，编译命令也得到了简化：

```bash
riscv64-elf-gcc \
    -I . \
    -Wall \
    -fPIC \
    -g \
    -Wl,-T,app.ld \
    -nostdlib \
    -o app-one.out \
    app.c libbaremetal.a
```

运行之后将得到可执行文件 `app-one.out`，这个文件跟 `app.out` 是一模一样的。（可以使用命令 `$ diff app-one.out app.out` 验证）

> 工具 [ar](https://en.wikipedia.org/wiki/Ar_(Unix)) 实际上是一个通用的打包程序，只是后来被 `tar` 替换了，目前 `ar` 主要用于创建静态库，另外 _Debian_ 的包文件 `*.deb` 也是 ar 格式。

## 总结

这章我们创建了一种无需操作系统就可以独自运行的程序，并了解了机器通电后是如何一步步地加载并运行我们的程序，同时也知道操作系统的内核其实也是一个 "大号" 的裸机程序，而上面写的裸机程序实际上就是一个功能弱到爆的 _系统内核_。希望通过这章能够破除内核的神秘感，同时能解开诸如 “机器通电后到图形桌面出现究竟经历了什么过程？” 这些长期在我们心中的困惑。

下一章将会深入剖析 _可执行文件_ 的组成和结构，然后构建一个最简化的，只有 150 左右字节不需要任何库的 "Hello World!" 程序。

{{< rawhtml >}}
<div>
    <img src="/images/subscribe-and-donate.zh.png" class="block-image image-480px"/>
</div>
{{< /rawhtml >}}