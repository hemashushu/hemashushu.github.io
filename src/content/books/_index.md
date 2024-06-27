---
title: "Books"
menus: "main"
weight: 30
meta: "false"
type: "custom"
---

Many of the books and articles below only have titles and no content yet, this is because:

1. I wrote them earlier, and most of the tools I used have been significantly updated. Much of the original content is no longer applicable, and I need time to update it.

2. Some of the articles use generic software, such as the GCC compiler and C/Python/JavaScript/Rust languages. Now that I have my own language and compiler, I plan to replace all the tools in these articles with my own, therefore, it will take some time.

> I will publish the following articles gradually, you can add my website to your bookmarks to check back for updates.

## Tutorials

- {{< null-link "S01 - XiaoXuan's Adventures in RISC-V Wonderland" >}} Walkthrough the RISC-V platform with XiaoXuan Native: compilation, assembly, instructions, processes and memory

- {{< null-link "S20 - Building a Task List Organizer Web Application with XiaoXuan Script" >}} Build a local web application with IndexedDB, Web Storage API, and XiaoXuan Script

- {{< null-link "S30 - Mastering MCU Hardware Programming with XiaoXuan Micro" >}} A step-by-step guide to writing programs (firmware) for ARM Cortex-M chips

- {{< null-link "S40 - Zero to AI: Building a Deep Learning Framework from Scratch with XiaoXuan Lang, Volumn 1" >}} Hands-on deep learning theory and practice, without any third-party libraries

- {{< null-link "S70 - Building Your Own Usable Programming Language: A Step-by-Step Guide" >}} Implement a programming language using XiaoXuan Lang: the lexer, parser, and interpreter

- {{< null-link "S71 - Designing a Runtime Virtual Machine (VM) for Systems Programming" >}} The memory, stack and the concurrency model of XiaoXuan Core VM

- {{< null-link "S80 - Zero to OS: Building Your Own Usable Operating System, Volumn 1: The User Space" >}} Build the user-space part of an OS for RISC-V platform from scratch in XiaoXuan Core

- {{< null-link "S81 - Zero to OS: Building Your Own Usable Operating System, Volumn 2: The Kernel" >}} Write a simple kernel in XiaoXuan Native for RISC-V platform

- {{< null-link "S82 - Building a Docker-like Container Utility from Scratch using XiaoXuan Core" >}} Linux namespaces, capabilities, seccomp and virtual networking

- {{< null-link "S83 - Building a KVM-based Virtual Machine Tool Using XiaoXuan Native" >}} Linux KVM, kernel, and virtual device I/O

- {{< null-link "S90 - Building Your Own Linux-Capable CPU: A Step-by-Step Guide" >}} Design a RISC-V CPU core using XiaoXuan Logic

- {{< null-link "S10 - Mastering Cross-Platform Development with QEMU" >}} Set up linux system and development environment in QEMU

## Manuals

- {{< null-link "M01 - The XiaoXuan Programming Language Reference" >}} Syntax, fundamental, and the standard library

- {{< null-link "M02 - An introduction to the XiaoXuan Core Assembly" >}} The syntax, structure, and the VM instructions

- {{< null-link "M03 - An introduction to the XiaoXuan Core Intermediate Representation (IR)" >}} The syntax, structure and modules

## Articles

- {{< null-link "XiaoXuan Script Object Notation (ASON): a new easy-to-read and write data representation format" >}}
- {{< null-link "XiaoXuan Allocator: an efficient memory allocator for automatic memory management programming language" >}}
- {{< null-link "XiaoYu SPI Flash FileSystem: a fail-safe filesystem designed for SPI flash chip" >}}

## Table of content

<!-- book list start -->
{{< html >}} <ul class="card"> {{< /html >}}

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c3">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S01 - XiaoXuan's Adventures in RISC-V Wonderland</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Walkthrough the RISC-V platform with XiaoXuan Native: compilation, assembly, instructions, processes and memory</div>
                <div class="date">2024-02-17</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Let's cross-compile the first program and run it" >}}
- {{< null-link "Write a \"Hello World\" program that can run standalone without an OS" >}}
- {{< null-link "Get to know XiaoXuan Assembly Language, and build \"Hello World\" program using it" >}}
- {{< null-link "Uncovering the ELF executable file, slim down the \"Hello World\" program to just 70 bytes" >}}
- {{< null-link "Setting up a Linux system and RISC-V development environment in QEMU" >}}
- {{< null-link "The memory layout of process, and the calling conventions" >}}
- {{< null-link "Static libraries, dynamic libraries, and dynamic linking" >}}
- {{< null-link "Design an assembly language with a target architecture of RISC-V" >}}
- {{< null-link "Implement the assembler and linker" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c1">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S20 - Building a Task List Organizer Web Application with XiaoXuan Script</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">
                Build a local web application with IndexedDB, Web Storage API, and XiaoXuan Script
                </div>
                <div class="date">2024-02-21</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Setting up the XiaoXuan Script development environment" >}}
- {{< null-link "Analyzing and designing the application's workflow" >}}
- {{< null-link "Writing basic pages" >}}
- {{< null-link "Introduction to the Web IndexedDB API" >}}
- {{< null-link "Writing basic XiaoXuan Script code for CRUD functionality" >}}
- {{< null-link "Introduction to the Web Storage API and adding attachment functionality" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c7">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S30 - Mastering MCU Hardware Programming with XiaoXuan Micro</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">
                A step-by-step guide to writing programs (firmware) for ARM Cortex-M chips
                </div>
                <div class="date">2024-02-22</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Introduction to STM32 MCU chips" >}}
- {{< null-link "Write your first firmware: Blinky" >}}
- {{< null-link "Respond to button presses with GPIOs" >}}
- {{< null-link "Master interrupts for efficient programming" >}}
- {{< null-link "Communicate with UART: sending and receiving data" >}}
- {{< null-link "Boost performance with Direct Memory Access (DMA)" >}}
- {{< null-link "Fine-tune your system with the clock tree" >}}
- {{< null-link "Schedule tasks with Timers" >}}
- {{< null-link "Convert analog signals: reading temperature with ADC" >}}
- {{< null-link "Control RGB LEDs with digital-to-analog converters (DACs)" >}}
- {{< null-link "Access the RTC module with the I2C protocol" >}}
- {{< null-link "Connect external Flash memory chips with the SPI protocol" >}}
- {{< null-link "Drive servos for precise motion control" >}}
- {{< null-link "Display graphics on OLED display module" >}}

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
                    <h3><span class="null-link">S40 - Zero to AI: Building a Deep Learning Framework
                    from Scratch with XiaoXuan Lang, Volumn 1</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Hands-on deep learning theory and practice, without any
                    third-party libraries</div>
                <div class="date">2024-02-17</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "The myth and truth of AI, and some foundations you need to know" >}}
- {{< null-link "Implementing neural network layers: weights and biases" >}}
- {{< null-link "Building a handwritten number recognition program: training and testing" >}}
- {{< null-link "Implementing backpropagation" >}}
- {{< null-link "Improving learning efficiency: parameter update methods and parameter initialization" >}}
- {{< null-link "Improving recognition accuracy with convolution neural networks (CNNs): implementing convolutional and pooling layers" >}}
- {{< null-link "Adding network layers, towards deep learning" >}}

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
                    <h3><span class="null-link">S70 - Building Your Own Usable Programming Language: A Step-by-Step Guide</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Implement a programming language using XiaoXuan Lang: the lexer, parser, and interpreter</div>
                <div class="date">2024-02-17</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Programming language fundamentals: interpreters, VM, compilers, AOT and JIT" >}}
- {{< null-link "S-Expressions: designing a simple syntax" >}}
- {{< null-link "Implementing lexer: converting characters to language elements \"tokens\"" >}}
- {{< null-link "Implementing parser: converting tokens to structured \"statements\"" >}}
- {{< null-link "Evaluating expressions: understanding the \"intent\" of statements" >}}
- {{< null-link "Variables and context: enabling multiple statements to express complex \"intents\"" >}}
- {{< null-link "Statement blocks and variable scopes: organizing sentences to express more complex intents" >}}
- {{< null-link "Implementing control flow: conditional branches and loops, completing a \"basic language\"" >}}
- {{< null-link "Implementing functions: code structuring and reusability" >}}
- {{< null-link "Adding native functions: turn our language from \"toy\" to \"tool\"" >}}
- {{< null-link "Implementing anonymous functions (closures): enhancing language expressiveness" >}}
- {{< null-link "Adding syntax sugar: making our language more modern" >}}
- {{< null-link "Implementing \"objects\": handling complex data types" >}}
- {{< null-link "Implementing a minimal standard library: Lists, Maps, Sets, and file I/O" >}}

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
        <div class="card-book c3">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S81 - Zero to OS: Building Your Own Usable Operating System, Volumn 2: The Kernel</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Write a simple kernel in XiaoXuan Native for RISC-V platform</div>
                <div class="date">2024-02-06</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "RISC-V QEMU boot process and basic input/ouput" >}}
- {{< null-link "Creating a bare-metal \"Hello, World\" program" >}}
- {{< null-link "CPU interrupts and task switching" >}}
- {{< null-link "Multi-level page tables" >}}
- {{< null-link "Creating a simple file system" >}}
- {{< null-link "Pipes: Inter-process communication" >}}
- {{< null-link "Creating a simple shell" >}}

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

<!-- book item start -->
{{< html >}}
    <li>
        <div class="card-book c2">
            <div class="frame">
                <div class="name">
                    <h3><span class="null-link">S83 - Building a KVM-based Virtual Machine Tool Using XiaoXuan
                                                Native</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Linux KVM, kernel, and virtual device I/O</div>
                <div class="date">2024-02-01</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Comparison of CPU virtualization, simulators, and containers." >}}
- {{< null-link "Creating a minimal virtual machine using the KVM API" >}}
- {{< null-link "Creating a virtual serial port device" >}}
- {{< null-link "Creating a virtual block device" >}}
- {{< null-link "Building a minimal kernel and a simple userspace program" >}}
- {{< null-link "Guide to booting a Linux kernel" >}}

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
                    <h3><span class="null-link">S90 - Building Your Own Linux-Capable CPU: A Step-by-Step Guide</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Design a RISC-V CPU core using XiaoXuan Logic</div>
                <div class="date">2024-01-15</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Digital circuit fundamentals: combinational and sequential circuits" >}}
- {{< null-link "Building a Blinky circuit, and interacting with the visual simulator" >}}
- {{< null-link "Synthesizing and downloading to FPGA hardware (Optional)" >}}
- {{< null-link "Introduction to RISC-V Instruction Architecture" >}}
- {{< null-link "Instruction decoder" >}}
- {{< null-link "Register File and Arithmetic Logic Unit (ALU) " >}}
- {{< null-link "Jump and branch instructions" >}}
- {{< null-link "Memory and load/store instructions" >}}
- {{< null-link "RISC-V calling convention ABI and implementing the functon calling" >}}
- {{< null-link "Memory mapping and implementing the UART peripheral" >}}
- {{< null-link "ROM and Building a simple program (firmware)" >}}
- {{< null-link ""Running" the CPU with XiaoXuan Logic visual simulator" >}}
- {{< null-link "Synthesizing and downloading to FPGA hardware (Optional)" >}}
- {{< null-link "Interacting via USB-UART and terminal on computer" >}}

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
                    <h3><span class="null-link">S10 - Mastering Cross-Platform Development with QEMU</span></h3>
                </div>
                <div class="separator"></div>
                <div class="subheading">Set up linux system and development environment in QEMU</div>
                <div class="date">2024-02-17</div>
            </div>
        </div>
        <div class="card-content">
{{< /html >}}

- {{< null-link "Build a minimal Linux system" >}}
- {{< null-link "Build a base Linux system using Buildroot" >}}
- {{< null-link "Setting up a complete RISC-V Linux system, and developing with XiaoXuan Lang" >}}
- {{< null-link "Setting up remote editing and debugging by VSCode" >}}

{{< html >}}
        </div>
    </li>
{{< /html >}}
<!-- book item end -->

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

<!-- book list end -->
{{< html >}} </ul> {{< /html >}}
