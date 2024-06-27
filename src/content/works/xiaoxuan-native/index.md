---
title: "XiaoXuan Native"
date: 2024-01-19
draft: false
tags: ["xiaoxuan-lang"]
categories: ["xiaoxuan-native"]
---

{{< figure class="mid" src="./images/banner.webp" >}}

_XiaoXuan Native_ is a memory-safe, general-purpose programming language inspired by Rust. It is designed to be simpler than Rust while it still provides automatic memory management without garbage collection, and avoids complex concepts such as ownership, borrow checking, and lifetimes. It aims to replace Rust in certain non-critical scenarios. It currently supports compiling to native code for architectures _x86-64_, _aarch64 (ARM64)_, _riscv64_ and _s390x (IBM Z)_, and will supports _loongarch64_ in the future.

> Currently, _XiaoXuan Native_ is written in Rust, but it will be self-hosted in the future 😄

## Features

TODO

## Comparison with Rust

_XiaoXuan Native_ and _Rust_ are both compiled, memory-safe, and GC-free general-purpose programming languages with similar user experiences, but they are very different internally:

**Memory mamangement implementation principles**

Rust's memory management uses a strict set of "rules" to constrain the writing of user code, including concepts such as ownership, borrow checking, and lifetimes, which are "hard" embedded in the Rust compiler. If the user code passes compilation, it can be roughly determined that the code is memory safe. However, because these rules are checked during compilation, it is possible to write syntactically correct Rust code that fails to compile.

_XiaoXuan Native_'s memory management implementation is much simpler, using "data immutability + reference counting" internally, which is reflected in the syntax. That is, as long as you write syntactically correct _XiaoXuan Native_ code, you can be sure that the code is memory safe even without compiling it.

Although _XiaoXuan Native_'s memory management method is slightly less performant than Rust's is some cases, it is more intuitive and simpler, and you can write memory-safe programs with performance comparable to Rust's without having to learn new concepts or constantly remember rules.

**Compiler implementation**

The syntax design of the _XiaoXuan Native_ is not only easy for humans to read and understand, but also makes the implementation of the language's lexer and parser very simple. And because there is no extra "rules" checking, the compiler is also very simple. In additional, _XiaoXuan Native_ has its own IR and code generator, and does not rely on any traditional compiler (such as GCC and LLVM) or library. These features make _XiaoXuan Native_ language easy to implement, and any engineer can understand the source code of the _XiaoXuan Native_ compiler, find bugs, and make improvements.

In contrast, the Rust compiler is not so easy to understand, and you need a lot of knowledge and experience to participate.

## Related projects

- {{< null-link "XiaoXuan Assembly LoongArch" >}} Assembler for LoongArch (la64).
- {{< null-link "XiaoXuan Assembly RISC-V" >}} Assembler for RISC-V (rv64gc).
- {{< null-link "XiaoXuan Assembly ARM" >}} Assembler for ARM (aarch64).
