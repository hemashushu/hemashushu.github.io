---
title: "一文讲完 System ABI 和 syscall - 第 1 部 （2024 更新版）"
date: 2024-04-16T19:00:00+08:00
tags: ["abi", "syscall"]
categories: ["system"]
draft: false
---


## `syscall` 的原理

`syscall` 是应用程序 “调用” 操作系统提供的 “服务” 的一种方式。众所周知，一般 CPU 至少提供了两种运行模式：一种是给操作系统运行的内核模式，在这种模式下，几乎所有指令都可以执行，硬件资源也能直接访问；另一种是给应用程序运行的用户模式，在这种模式里，部分指令被屏蔽，而且无法直接访问硬件。

应用程序单凭自身的能力一般只能进行数值计算和内存读写等操作，显然这样的应用程序几乎是毫无用处的。因此一般 CPU 都提供了类似 `syscall` 的指令，当应用程序需要一些额外的功能时，就通过这个指令向操作系统（内核）发出委托，由内核执行具体的操作并将执行的结果返回给应用程序。

### 系统调用的过程

1. 应用程序先把功能的编号（即 `system call number`）以及必要的参数准备好（即按照约定写入到指定的寄存器），然后执行 `syscall` 指令。


2. 这时 CPU 会切换到内核模式，操作系统（内核）根据功能编号和参数执行相应的操作，把结果存放到约定的地方。然后执行 `sysret` 指令。

3. 这时 CPU 会再次切换回用户模式，继续执行应用程序的指令。

```text
以下是 syscall 和 sysret 指令的工作原理：

syscall 指令:

将系统调用号（rax 寄存器中的值）传递给内核。
将当前程序运行的下一条指令（即 sysenter_sysret 指令）的地址保存到 rsp 寄存器中。
将 MSR_LSTAR 寄存器中的值加载到 rip 寄存器中。
MSR_LSTAR 寄存器指向内核中负责处理系统调用的入口地址。
sysret 指令:

将 rsp 寄存器中的值恢复到 syscall 指令执行之前的值。
将 rip 寄存器中的值恢复到 syscall 指令执行之前的值。
使 CPU 从内核模式切换回用户模式。
```

### 返回值

当 `syscall` 完成时，它的返回值会储存在 `rax` 寄存器里。如果操作失败，那么这个值是一个负数（即  rax < 0）

## 关于 `errno`

### 标准库

在 C 标准库里，当某些函数调用了 syscall，标准库会把这个负数的值会被转译为一个正数（即 -rax）并储存在一个 “线程本地” 的符号 `errno` 里（可以在段 `.tbss` 找到这个符号），然后向函数调用者返回 `-1`。

这个符号的值可以通过 `libc` 提供的函数获取：
- `__errno_location` on linux (redox, fuchsia)
- `__error` on freebsd (ios, macos)

在 Rust 里可以通过函数 `std::io::Error::last_os_error().raw_os_error()` 获取。

在 C 里则有更简单的方法，只需引入 `<errno.h>` 然后读取外部变量 `errno` 即可。

> 注意，当你通过汇编直接调用 syscall，即绕过标准库调用 syscall，这种情况下标准库里的 `errno` 并不会更新，无论是读取外部变量 `errno` 还是 `std::io::Error::last_os_error()`，返回的都是旧的值。

{{< figure class="mid" src="/images/subscribe-and-donate.zh.png" >}}