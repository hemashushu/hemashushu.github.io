---
title: "The XiaoXuan Programming Language"
date: 2023-12-01
draft: false
tags: ["xiaoxuan-lang"]
categories: ["development"]
---

{{< figure class="wide" src="./images/banner_v2.png" >}}

_The XiaoXuan Programming Language_ is an elegant, full-stack programming language. It consists of several variants and can be used to develop a variety applications, including digital circuits and chips, microcontroller programs, GPU shaders, system programs, local native programs, cloud native programs, web applications and more. All variants use the same syntax and design philosophy, allowing you to learn one language for all sorts of development.

The implemented variants:

- {{< null-link "XiaoXuan Script" >}}
  Build high-performance, solid web applications. It can be compiled to WebAssembly on-the-fly without the need for any build tools. It aims to be the preferred programming language for web development.

- [XiaoXuan Core](/works/xiaoxuan-core)
  Build powerful user-space system programs that have extremely fast startup speed and small memory footprint, it can directly call _syscall_ and interoperate with C shared libraries.

- {{< null-link "XiaoXuan Managed" >}}
  Build secure, robust, low-latency and responsive cloud-native applications (such as microservices and serverless functions etc.), business systems, data science programs, A.I. programs and more. Each program runs in its own isolated environement, eliminating the need for containers. Applications do not need to be installed, they can be run with just a URL.

- {{< null-link "XiaoXuan Native" >}}
  A general-purpose programming language inspired by Rust but much simpler. It provides automatic memory management without garbage collection, and avoids complex concepts such as ownership, borrow checking, and lifetimes. It supports compiling to native code for architectures such as _x86-64_, _aarch64_ and _riscv64_.

- {{< null-link "XiaoXuan Micro" >}}
  Build high-performance firmware for microcontroller easily, the built-in micro VM makes it possible to "write once, run anywhere".

- {{< null-link "XiaoXuan Logic" >}}
  A brand new and modern hardware description language (HDL) that lets you design hardware and chips in the same ease and collaboration as open-source software. Its built-in GPU-accelerated simulator dramatically enhances test efficiency, saving you valuable time and resources.

{{< figure class="wide" src="./images/variants.png" caption="The XiaoXuan Programming Language Family" >}}

_The XiaoXuan programming language_ supports writing code in local languages, such as Chinese, Japanese and French. In addition to keywords, the standard library and related documentation are also translated into local languages. Using local language programming is beneficial for children, beginners and non-computer majors who are not native English speakers.

The implemented local language variants are as follows:

- {{< null-link "XiaoXuan Core Hans" >}} - The Chinese edition (中文版)

## Which one should I choose?

There are three variants designed for specialized application development:

- XiaoXuan Script: for building web applications.
- XiaoXuan Micro: for building microcontroller firmware.
- XiaoXuan Logic: for developing hardware such as digital circuits and chips.

The other three variants are general-purpose programming languages. However, the assets they generate run differently, so they have different focuses:

- XiaoXuan Core: for building command-line tools, system programs.
- XiaoXuan Managed: for building server-side service programs, business systems, data processing programs, and desktop applicatons.
- XiaoXuan Native: for building performance-critical native applications.

## Where to get started

If you are a beginner in XiaoXuan Programming Language, it is recommended to start with XiaoXuan Script. Because it doesn't require you to download or install any programs, there is an online testing page on the project's web site where you can write and run XiaoXuan Script programs to learn about the syntax and main features.

If you perfer to write programs that run locally, it is recommended to start with XiaoXuao Core, which makes it very easy to write utilities. Once you are familiar with XiaoXuan Core, it will be easier to move on to XiaoXuan Managed and XiaoXuan Native.

## Recommended tutorials

- {{< null-link "Get started with XiaoXuan Script in 5 minutes." >}}
- {{< null-link "Get started with XiaoXuan Core in 5 minutes." >}}

## Related documents

{{< html >}}
<ul class="card wide">
    <li>
        <div class="card-title">
            <h3><span class="null-link">The XiaoXuan Language Reference</span></h3>
        </div>
        <div class="card-content">
            <ol>
                <li><span class="null-link">Data types</span></li>
                <li><span class="null-link">Variables</span></li>
                <li><span class="null-link">Functions</span></li>
                <li><span class="null-link">Collection</span></li>
                <li><span class="null-link">Control flow</span></li>
                <li><span class="null-link">Method, generic and trait</span></li>
                <li><span class="null-link">Pattern</span></li>
                <li><span class="null-link">Chain</span></li>
                <li><span class="null-link">Error handling</span></li>
                <li><span class="null-link">Modules</span></li>
            </ol>
        </div>
    </li>

    <li>
        <div class="card-title">
            <h3><span class="null-link">Build a simple OS (Linux kernel based) from scratch using XiaoXuan Core</span></h3>
        </div>
        <div class="card-content">
            <ol>
                <li><span class="null-link">Set up a RISC-V virtual machine using QEMU.</span></li>
                <li><span class="null-link">Write a minimal 'init' program.</span></li>
                <li><span class="null-link">Write a basic 'shell' program.</span></li>
                <li><span class="null-link">Fundamentals of file system and processes,  implementing the `pwd` and `ls` commands.</span></li>
                <li><span class="null-link">Implement the `mount` and `umount` commands.</span></li>
                <li><span class="null-link">Principals of `redirect`, implementing the `echo` and `cat` commands.</span></li>
                <li><span class="null-link">Principal of `pipe`, implementing the `tee` and `tr` commands.</span></li>
                <li><span class="null-link">Session and process groups.</span></li>
                <li><span class="null-link">The `root` privileges, users and groups, and the `setuid` bit.</span></li>
                <li><span class="null-link">Add support for shell scripts.</span></li>
            </ol>
        </div>
    </li>

    <li>
        <div class="card-title">
            <h3><span class="null-link">Building a Docker-like container manager from scratch using XiaoXuan Core</span></h3>
        </div>
        <div class="card-content">
            <ol>
                <li><span class="null-link">The principal of Linux container</span></li>
                <li><span class="null-link">Isolating the file system</span></li>
                <li><span class="null-link">Isolating the process space</span></li>
                <li><span class="null-link">Isolating the accounts</span></li>
                <li><span class="null-link">The virtual networking devices and routeb  b 56rtn j </span></li>
            </ol>
        </div>
    </li>
</ul>
{{< /html >}}
