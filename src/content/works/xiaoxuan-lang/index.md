---
title: "XiaoXuan Programming Language"
date: 2023-12-01
draft: false
tags: ["xiaoxuan-lang"]
categories: ["xiaoxuan-lang"]
---

{{< figure class="wide" src="./images/banner.webp" >}}

_XiaoXuan Language_ is a full-stack programming language that allows you to learn one language to develop all kinds of programs.

Currently, it can be used to develop a variety applications, including digital circuits and chips, microcontroller programs, GPU shaders, system programs, local native programs, cloud native programs, web applications and more.

_XiaoXuan Language_ achieves this by providing multiple backends and variants, all of which follow the same syntax and design philosophy. This frees developers from the burden of learning multiple programming languages and tools.

{{< figure class="mid" src="./images/title.png" >}}

_XiaoXuan Language_ consists of the following variants:

- [XiaoXuan Core](/works/xiaoxuan-core)
  Build powerful user-space system programs that have extremely fast startup speed and small memory footprint, it can directly call _syscall_ and interoperate with C shared libraries. Single-file, statically linked runtime make applications highly portable.

- [XiaoXuan Script](/works/xiaoxuan-script)
  Build high-performance, solid web applications. It can be compiled to WebAssembly on-the-fly without the need for any build tools. It aims to be the next programming language for web development.

- [XiaoXuan Managed](/works/xiaoxuan-managed)
  Build secure, robust, low-latency and responsive cloud-native applications (such as microservices and serverless functions etc.), business systems, data science programs, A.I. programs and more. Each program runs in its own isolated environement, eliminating the need for containers. Applications do not need to be installed, they can be run with just a URL.

- [XiaoXuan Native](/works/xiaoxuan-native)
  A memory-safe, general-purpose programming language inspired by Rust. It is designed to be simpler than Rust while it still provides automatic memory management without garbage collection, and avoids complex concepts such as ownership, borrow checking, and lifetimes. It aims to replace Rust in certain non-critical scenarios. It currently supports compiling to native code for architectures such as _x86-64_, _aarch64_ and _riscv64_.

- [XiaoXuan GPU](/works/xiaoxuan-gpu)
  A modern shading language designed to facilitate the rapid development of high-performance programs such as game engines, AR, AI engines, data analysis, biocomputing, scientific computing, and more. It features the same elegant syntax and design philosophy as the _XiaoXuan Lang_, allowing you to develop in new domains without learning a new language.

- [XiaoXuan Micro](/works/xiaoxuan-micro)
  Build high-performance firmware for microcontroller (MCU) easily, the built-in micro VM makes it possible to "write once, run anywhere", build IoT applications in a more modern way.

- [XiaoXuan Logic](/works/xiaoxuan-logic)
  A brand new and modern hardware description language (HDL) that lets you design hardware and chips in the same ease and collaboration as open-source software. Its built-in GPU-accelerated simulator dramatically enhances test efficiency, saving you valuable time and resources.

{{< figure class="wide white" src="./images/variants.webp" caption="The XiaoXuan Programming Language Family" >}}

## Localization

_The XiaoXuan Language_ supports writing code in local languages, such as Chinese, Japanese and French. In addition to keywords, the standard library and related documentation are also translated into local languages. Using local language programming is beneficial for children, beginners and non-computer majors who are not native English speakers.

The local language variants are as follows:

- [XiaoXuan Core Hans](/works/xiaoxuan-core-hans) - The simplified Chinese edition (简体中文版) of XiaoXuan Core.

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

- {{< null-link "Get started with XiaoXuan Script in 5 minutes" >}}
- {{< null-link "Get started with XiaoXuan Core in 5 minutes" >}}

## Language features

TODO

## Example program

TODO

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
