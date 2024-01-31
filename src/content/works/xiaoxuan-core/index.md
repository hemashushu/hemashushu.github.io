---
title: "XiaoXuan Core"
date: 2023-12-25
draft: false
tags: ["xiaoxuan-core", "xiaoxuan-lang"]
categories: ["xiaoxuan-core"]
---

{{< figure class="wide" src="./images/banner.png" >}}

The _XiaoXuan Core Programming Language_ is used to build powerful user-space system programs with extremely fast startup speed and small footprint, it can directly call _syscall_ and interoperate with C shared libraries. Single-file, statically linked runtime make applications highly portable.

## Motivation

### Availability and portability

Traditional system programs, as well as command-line utilities, can be difficult for ordinary users to set up and run if they are not maintained by a distribution and have not been updated for a while, this is because:

- For applications built with compiled languages:
  - May encounter excessive dependencies that require manual compilation during the build process.
  - Compilation may fail due to changes in shared library version.

- For applications built with script languages:
  - May encounter version incompatibility issues
  - May encounter dependency version conflict issues

_XiaoXuan Core_ has learned from these lessons and is designed to ensure that once an application is created and can run, it will continue to run correctly even if it is not maintained and after a long period of time.

### Ease of development, maintaince, and high performance

The _XiaoXuan Core_ language strikes a good balance between "ease of development" and "high performance". The _XiaoXuan Core_ language has the following features:

- Data-race-free concurrency model
- GC-free automatic memory management
- Discards difficult-to-master concepts such as pointers, ownership, borrow checking and lifetimes.

These features make it easy for developers to develop safe, stable and high-performance applications.

## Quick start

The following code demostrates how to call syscalls and external functions (from shared libraries). The code prints the current working directory.

> The _XiaoXuan Core_ standard library provides simpler ways to get the current working directory or print strings. The code below is written for demostration purposes only. Additionally, the following steps assume a Linux operation system. If you are using other platform or want to try a simpler "Hello, World!" program, please refer to the {{< null-link "XiaoXuan Code Documentation">}}.

1. Create a file named `pwd.anc` in any directory with the following content:

```js
config(runtime, "1.0")

external shared "libc.so.6" {
    function puts(addr:long)
}

function main() {
    const buf_length = 1024
    let buf = std::Array::<byte>::fill(0, buf_length)

    // invoke syscall
    syscall(
        syscall::number::getcwd,
        buf.raw_addr,
        buf.length)

    // call external function
    puts(buf.raw_addr)
}
```

2. Download the _XiaoXuan Core_ launcher {{< null-link "ancl-1.0.1.x86_64-linux-gnu.tar.gz" >}} from the offical website and extract it to the `~/.local/bin` or `/usr/bin` directory.

3. Run the following command:

`$ ancl pwd.anc`

The launcher will first check the version of the runtime required by the application and then start the corresponding runtime to execute it.

Since this is the first time we are running an _XiaoXuan Core_ application, the launcher will download the runtime from the internet. Then the runtime will compile and cache the application on-the-fly. Finally, you should see the application output a line of text, which is the current working directory.

## The XiaoXuan Core VM

ANC 运行时是一个单一的静态链接的可执行文件，其由编译器和虚拟机（VM）两部分组成。其中的VM是为运行系统程序而专门设计的，它有如下特点：

-