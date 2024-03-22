---
title: "Platform Support"
date: 2024-03-20
draft: false
tags: ["xiaoxuan-lang", "xiaoyu-os"]
categories: []
---

{{< figure class="mid" src="./images/banner.webp" >}}

_XiaoXuan Lang_ and _XiaoYu OS_ are newly designed software that have good support for various mainstream platforms. At the same time, because _XiaoXuan Lang_ has its own IR add assembly language and does not rely on traditional compilation tools and shared libraries, such as GCC and LLVM. it has faster support for newer platforms such as RISC-V and LoongArch.

The following are tables of the support status of _XiaoXuan Lang_, _XiaoYu OS_ and other software for various platforms.

## Programming Language

### Desktop and Server

**XiaoXuan Core (and XiaoXuan Managed)**

The runtime includes a compiler and a virtual machine. Applications are compiled into bytecode and then run in the virtual machine. Therefore, applications are almost unaffected by the host platform. The XiaoXuan Core runtime itself is developed in Rust, so it supports most platforms.

**XiaoXuan Native**

It is a compiled languaged. The compiler itself is developed in Rust, so it also supports most platforms. However, the compilation target (i.e., native binary code) is determined by the compiler's capabilities. Currently, XiaoXuan Native's compilation targets cover most platforms, but the code generator for LoongArch64 is still under development.

| Software               | x86_64 | aarch64 | riscv64 | s390x | loongarch64    |
|------------------------|:------:|:-------:|:-------:|:-----:|:--------------:|
| XiaoXuan Core          | ✓      | ✓       | ✓       | ✓     | ✓              |
| XiaoXuan Managed       | ✓      | ✓       | ✓       | ✓     | ✓              |
| XiaoXuan Native Host   | ✓      | ✓       | ✓       | ✓     | ✓              |
| XiaoXuan Native Target | ✓      | ✓       | ✓       | ✓     | In development |

### Browser

**XiaoXuan Script**

It consists of a compiler, a standard library, and a piece of JavaScript glue code. The compiler and standard library are distributed in WebAssembly binary format. Applications are compiled by the compiler to WebAssembly binary and then run by the browser. In summary, as long as the browser supports JavaScript and WebAssembly, XiaoXuan Script and applications can be run.

| Software        | Chrome | Firefox | Edge | Safari |
|-----------------|:------:|:-------:|:----:|:------:|
| XiaoXuan Script | ✓      | ✓       | ✓    | ✓      |

### Embed/IoT

**XiaoXuan Micro**

It includes a compiler and a virtual machine. Applications will be compiled into bytecode and merged with the virtual machine in the form of a payload. Then they will be burned into the MCU's Flash and run. Currently, the XiaoXuan Micro virtual machine supports ARM M series architechture, such as the common Cortex-M0/M0+/M1/M3/M4/M7/M23/M33 cores. It also supports the RISC-V 32 architecture.

| Software       | ARM Cortex-M | riscv32 |
|----------------|:------------:|:-------:|
| XiaoXuan Micro | ✓            | ✓       |

## Operating System

**XiaoYu OS**

_XiaoYu OS_ is based on the Linux kernel. Its userspace programs are mainly developed by XiaoXuan Core, XiaoXuan Native and Rust, so its platform support is limited by various software. However, for mainstream platforms, it can basically be well supported.

| Software  | x86_64 | aarch64 | riscv64 | s390x | loongarch64 |
|-----------|:------:|:-------:|:-------:|:-----:|:-----------:|
| XiaoYu OS | ✓      | ✓       | ✓       | ✓     | ✓           |

**XiaoYu Micro OS**

_XiaoYu Micro OS_ is a micro operating system that adds modules such as file system, hardware abstraction layer, and serial port communication on the basis of _XiaoXuan Micro_. Therefore, its platform support is the same as _XiaoXuan Micro_. Of course, you need to download the corresponding ported version for different chips (and boards). The specific chip list can be found in the project's documentation.

| Software        | ARM Cortex-M | riscv32 |
|-----------------|:------------:|:-------:|
| XiaoYu Micro OS | ✓            | ✓       |