---
title: "在面包板上制作开发板和调试器（1）—— 开始"
date: 2022-12-05
draft: true
images: ["/posts/2022-12-05-diy-devel-board-and-debugger-on-breadboard-01-start/images/dev-boards.png"]
tags: ["arm", "mcu"]
categories: ["make", "dev-board"]
---

看到精美的开发板（指微控制器/MCU 芯片厂商生产的评估板/开发板）是不是很想买回来动手玩一下？可是开发板并不便宜，如果要买几块或者更多，再加上调试器，则是一笔不小的开支。

幸运的是我们可以自己动手制作开发板和调试器！令人出乎意料的是，开发板制作方法非常简单，你不需要多少电子专业的知识，也不需要专门的工具，更加不需要掌握诸如 PCB 设计等专业软件。唯一要添加的工具是一支普通电烙铁，然后买一些随处可见的、非常便宜的零件，在家里就能制作。自己制作开发板有许多优点：

- 省钱：你只需花费零售开发板的 1/5 到 1/10 的价钱就可以拥有相近功能的开发板和调试器。
- 简洁：零售的开发板一般会预先连接了一些芯片的引脚，或者预先集成一些额外的模块，在开发应用程序之前你需要先了解开发板的电路原理图以及说明文档，通常这会让人一头雾水；而且在调试固件的过程中一旦遇到错误，你还得反复地查看和核对电路原理图（最常见的问题是：开发板的引脚印刷的名称跟芯片的引脚名称不一致）。而自己制作的开发板是最简化的，仅在有需要时才连接额外的模块，所以在自己制作的开发板上开发和调试固件时，你不会受到无关电路的干扰；
- 学习：自己制作开发板是从零开始的，所以开发板制作完成之后，你会更完整地了解芯片的功能、特性和使用方法，为以后自己设计硬件电路、PCB 以及开发诸如基于 Cortex-A 的设备打下基础；
- 自由：零售开发板没有涵盖所有芯片的型号，而自己制作开发板则不受限制，你能用上最新的芯片，或者任意型号的芯片。

> 想象一下你的桌子上摆满了自己制作的开发板和调试器，全部通上电之后几十个指示灯一闪一闪的，那是一副多么美丽的画面啊 😄

<!-- ## 前提条件

本系列教程假设你并没有多少电子专业知识，也没有专业的工具（比如热风枪、加热台、示波器等），不会使用 ，预算也很有限（每块开发板限制在十到二十来块钱）。

你所需要的有：普通电烙铁，焊锡线，助焊剂（不能使用松香），几块面包板，面包板用的连接导线（直径 0.6mm 左右的单芯铜线）和杜邦线，电阻器和电容器等基本电子元件（你可以买一个元件包，里面有常用的各种型号的电子元件），当然还有几块微控制器芯片，这系列教程所使用的芯片非常便宜（一块芯片从五元到十五元不等），而且非常常见，也就是说你很容易就能买到； -->

## 目标

NUCLEO-F042K6   32
NUCLEO-F031K6   32
NUCLEO-G070RB

NUCLEO-G431KB   32

NUCLEO-L432KC   32 /    NUCLEO-F401RE
NUCLEO-F411RE


型号/Model      核心/Core   频率/Freq    Flash    SRAM    USB     封装    引脚间距


CH32V203F8P6    -           144MHz      64K     20K     H/D     TSSOP20 0.65mm  https://www.wch.cn/products/CH32V203.html
CH32V203C8T6    RISC-V      144MHz      64K     20K     D+H/D   LQFP48  0.5mm   https://www.wch.cn/products/CH32V203.html
CH32V305FBP6    RISC-V      144MHz      128K    32K     H/D     TSSOP20 0.65mm  https://www.wch.cn/products/CH32V307.html


## software

软件上没有专用的 IDE 或者开发工具，对芯片厂商提供的 SDK 或者封装好的库也不了解；
软件方面只需基本的文本编辑器和编译器（这系列里我会使用 Rust 语言），不需任何 IDE 或者厂商提供的软件，不需任何 SDK 或者第三方库，也不需了解汇编语言。

## index

- STM32F042, connect power and USB
- blink, program the flash by USB DFU
- STM32F031, connect power and UART
- blink, program the flash by UART DFU
- SysTick and Clock (External Oscillator)
- timer ?
- convert STM32F042 into DAP-Link, program the target (STM32F031) by OpenOCD and DAP-Link
- debug the STM32F031 by DAP-Link, GDB and `SVD tools`
- UART to USB
- try VSCode
- try STM32CubeIDE

- STM32G070 and blink
- IRQ (button GPIO) + UART
- PWM LED
- RTC (and internal EEPROM)

- STM32G431 and blink
- Bootloader and target APP through STM32G431
- CRC and DMA
- task scheduler
- CoreMark

- QFN 1, STM32L431 and blink
- SPI Flash, QSPI
- Temp sensor
- Arduino (for emu Nucleo L432KC)
  https://github.com/stm32duino/Arduino_Core_STM32
- USB keyboard emulator

- QFN 2, STM32F411 and blink
- MicroPython through STM32F411

- ATSAMD21 and blink
- UF2 bootloader and target APP through ATSAMD21
- MS Make Code
- Arduino Nano IoT through ATSAMD21

- LPC824 and blink
- LPC11U68 and blink

- CY8C4 and blink
- XMC1100 and blink
- XMC1100 and Arduino IDE

- RA2E1 and blink
- RA4M2 and blink

- nRF52810 and blink
- ESP32C3 and blink

- CH32V305 and blink
- CH32V205 and blink
- Convert CH32V305 into WCH-Link
