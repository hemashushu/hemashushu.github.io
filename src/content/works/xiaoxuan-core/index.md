---
title: "XiaoXuan Core"
date: 2023-12-25
draft: false
tags: ["xiaoxuan-core", "xiaoxuan-lang"]
categories: ["xiaoxuan-core"]
---

{{< figure class="mid" src="./images/banner.webp" >}}

The _XiaoXuan Core Programming Language_ is used to build powerful user-space system programs with extremely fast startup speed and small footprint, it can directly call _syscall_ and interoperate with C shared libraries. Single-file, statically linked runtime make applications highly portable.

## Quick start

The following code demostrates how to call syscalls and external functions (from shared libraries). The code prints the current working directory.

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

> The _XiaoXuan Core_ standard library provides simpler ways to get the current working directory or print strings. The code below is written for demostration purposes only. Additionally, the following steps assume a Linux operation system. If you are using other platform or want to try a simpler "Hello, World!" program, please refer to the {{< null-link "XiaoXuan Code Documentation">}}.

## The XiaoXuan Core VM

{{< figure class="wide white" src="./images/vm-model.webp" caption="The XiaoXuan Core VM" >}}

_XiaoXuan Runtime_ is a self-contained, statically linked executable that combines a compiler and a virtual machine (VM) designed specifically for running system programs. It offers serveral key advantages:

- **Fast loading:** The structure of the application's image file and the instruction set architecture (ISA) are specially designed to eliminate the need for parsing and preprocessing by the VM. Instead, the file is simply mapped to memory and the bytecode can be executed directly.
- **Program security:** The _XiaoXuan Core VM_ uses indexes instead of pointers to locate functions, data, and local variables. The stack is also divided into three separate stack: frame information, local variables, and operands. This effectively prevents memory boundary and overflow issues, reducing program vulnerabilities.
- **Seamless interoperability with C/C++/Rust shared libraries:** The VM's memory model closely resembles that of the local native machine, allowing VM functions to directly call shared libraries built in C/C++/Rust. Additionally, VM functions can be also passed to shared libraries as callback functions (enabling shared libraries to call back into the VM). This feature allows _XiaoXuan Core_ to take full advantage of the rich ecosystem of existing shared libraries.
- **Data-race-free parallelism model:** The _XiaoXuan Core VM_ has no "global data", and threads are only allowed to communicate by passing copies of data through _channels_. This prevent data races and ensures thread safety.
- **Embeddable in Rust applications:** _XiaoXuan Core_ programs and the VM can be embedded as a library in Rust applications. Rust can then call VM functions just like regular functions (using a JIT generated "bridge function").

## Motivation

**Availability and portability**

Traditional system programs, as well as command-line utilities, can be difficult for ordinary users to set up and run if they are not maintained by a distribution and have not been updated for a while, this is because:

For applications built with compiled languages, may encounter excessive dependencies that require manual compilation during the build process, or compilation may fail due to changes in shared library version.

For applications built with script languages, may encounter version incompatibility issues, or may encounter dependency version conflict issues.

_XiaoXuan Core_ has learned from these lessons and is designed to ensure that once an application is created and can run, it will continue to run correctly even if it is not maintained and after a long period of time.

**Ease of development, maintaince, and high performance**

The _XiaoXuan Core_ language strikes a good balance between "ease of development" and "high performance". The _XiaoXuan Core_ language has the following features:

- Data-race-free concurrency model
- GC-free automatic memory management
- Discards difficult-to-master concepts such as pointers, ownership, borrow checking and lifetimes.

These features make it easy for developers to develop safe, stable and high-performance applications.

## How XiaoXuan Core solves verison compatibility issues?

_XiaoXiao Core_ applications can maintain correct operation even when the runtime environment changes (e.g., major version changes to the shared libraries in the system). This is achieved through the following two measures:

{{< figure class="wide white" src="./images/version-model.webp" caption="The XiaoXuan Core Applications Version Control" >}}

1. Runtime version specification

Each _XiaoXuan Core_ application is required to specify a runtime version number. For single-file applications, this is specified using the `config(runtime, "1.0")` statement. For multi-file applications, it is specified in the package descriptor file `package.anon`, for example:

```js
{
    name: "myapp"
    runtime: "1.1"
}
```

The _XiaoXuan Core Application Launcher_ (`ancl`) will start the corresponding runtime based on the version number specified by the application to compile or run.

2. Bundled shared modules and shared libraries

Each verson of the runtime comes with its own shared modules (e.g., `std` and `math`) and, most importantly, a set of dynamic shared libraries (e.g., `libc`, `libsqlite3`, `libz` etc.). This allows applications to not rely on the shared libraries of the OS.

Therefore, whether the _XiaoXuan Core_ runtime is updated or the system shared library versions change, the application can run in the same environment as it was developed in.

This feature improves application compatibility and stability, reduces dependency on the system environment, simplifies application deployment and maintenance.

## Get started

- {{< null-link "Get started with XiaoXuan Core in 5 minutes" >}}

## Manuals & Tutorials

<!-- book list start -->
{{< html >}} <ul class="card"> {{< /html >}}

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c1">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">M01 - The XiaoXuan Programming Language Reference</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Syntax, fundamental, and the standard library</div>
                <div class="date">2023-04-16</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Data types and Literals" >}}
- {{< null-link "Variables" >}}
- {{< null-link "Functions" >}}
- {{< null-link "Collection" >}}
- {{< null-link "Control Flow" >}}
- {{< null-link "Error Handling" >}}
- {{< null-link "Method, Generic and Interface" >}}
- {{< null-link "Pattern" >}}
- {{< null-link "Chain" >}}
- {{< null-link "Modules, Packages and Properties" >}}
- {{< null-link "Annotations and IoC" >}}
- {{< null-link "Macro" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c2">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">M02 - An introduction to the XiaoXuan Core Assembly</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">The syntax, structure, and the VM instructions</div>
                <div class="date">2023-09-10</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Literals" >}}
- {{< null-link "Module Nodes" >}}
- {{< null-link "Instructions" >}}
- {{< null-link "Control Flow" >}}
- {{< null-link "Function Call" >}}
- {{< null-link "System Call" >}}
- {{< null-link "Environment Call" >}}
- {{< null-link "Packages and Modules" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c3">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">M03 - An introduction to the XiaoXuan Core Intermediate Representation (IR)</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">The syntax, structure and modules</div>
                <div class="date">2023-10-12</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Data Types and Literals" >}}
- {{< null-link "Functions" >}}
- {{< null-link "Control Flow" >}}
- {{< null-link "Struct and Array" >}}
- {{< null-link "Packages and Modules" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c4">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S71 - Designing a Runtime Virtual Machine (VM) for Systems Programming</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">The memory, stack and the concurrency model of XiaoXuan Core VM</div>
                <div class="date">2023-06-13</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Data types and thoughts on floating-pointer numbers" >}}
- {{< null-link "The triadic stack" >}}
- {{< null-link "Using indexes instead of pointer" >}}
- {{< null-link "The instruction set" >}}
- {{< null-link "Using structured blocks instead of jumps for control flow" >}}
- {{< null-link "Tail call optimization" >}}
- {{< null-link "Environment calls" >}}
- {{< null-link "System calls" >}}
- {{< null-link "Bridge functions and external calls" >}}
- {{< null-link "A Data-race-free parallel Model" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c5">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S80 - Zero to OS: Building Your Own Usable Operating System, Volumn 1: The User Space</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Build the user-space part of an OS for RISC-V platform from scratch in XiaoXuan Core</div>
                <div class="date">2024-01-09</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Set up a RISC-V virtual machine using QEMU" >}}
- {{< null-link "Write a minimal `init` program" >}}
- {{< null-link "Write a minimal `shell` program" >}}
- {{< null-link "Fundamentals of file system and processes, implementing the `pwd` and `ls` commands" >}}
- {{< null-link "Implement the `mount` and `umount` commands" >}}
- {{< null-link "Principals of `redirect`, implementing the `echo` and `cat` commands" >}}
- {{< null-link "Principal of `pipe`, implementing the `tee` and `tr` commands" >}}
- {{< null-link "Session and process groups" >}}
- {{< null-link "The `root` privileges, users and groups, and the `setuid` bit" >}}
- {{< null-link "Add support for shell scripts" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c6">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S82 - Building a Docker-like Container Utility from Scratch using XiaoXuan Core</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Linux namespaces, capabilities, seccomp and virtual networking</div>
                <div class="date">2024-01-15</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "The principal of Linux container" >}}
- {{< null-link "Isolating the file system" >}}
- {{< null-link "Isolating the process space" >}}
- {{< null-link "Isolating the accounts" >}}
- {{< null-link "The virtual networking devices and route" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book list end -->
{{< html >}} </ul> {{< /html >}}

## Related documents

- {{< null-link "An introduction to the XiaoXuan Core application image file format" >}}
- {{< null-link "XiaoXuan Object Notation (ANON): a Human-readable object notation format" >}}
- {{< null-link "XiaoXuan Allocator: a low-latency, scalable memory allocator" >}}

## Related projects

The source code repositories of related projects:

- {{< null-link "XiaoXuan Core VM" >}}
- {{< null-link "XiaoXuan Core Assembly" >}}
- {{< null-link "XiaoXuan Core IR" >}}
- {{< null-link "XiaoXuan Core Compiler" >}}
- {{< null-link "XiaoXuan Core Runtime" >}}
- {{< null-link "XiaoXuan Core Launcher" >}}
- {{< null-link "XiaoXuan Core Standard Library" >}}
- {{< null-link "XiaoXuan Allocator" >}}
- {{< null-link "XiaoXuan Object Notation (ANON)" >}}