---
title: "XiaoYu OS"
date: 2024-01-19
draft: false
tags: ["xiaoyu-os"]
categories: ["os"]
---

{{< figure class="wide" src="./images/banner.webp" >}}

_XiaoYu OS_ is a brand new operating system built for the modern engineer's daily
workflow.
Every application runs in secure, isolated environement with minimal privileges,
requesting permissions only when needed. This also ensures a pristine system, even after
years of use, free from accumulated clutter or hidden processes.
XiaoYu OS empowers developers to directly maintain their applications, eliminating the
need for dedicated package maintainers.

## What makes _XiaoYu OS_ unique?

1. 严格的安全

除了 “系统初始化程序”、“图形 compositor” 以及 “消息总线” 等少数几个程序，其余的应用程序都运行于各自的容器（即：隔离的环境）当中。应用程序只有最小的权限，你可以运行任意应用程序而无需担心它会修改系统或者访问你的个人数据和文件。

2. 干净整洁

应用程序所产生的临时数据和文件均被限制在其所在的隔离环境中，当一个应用程序被删除时，不会留下任何垃圾在系统里。除此之外，应用程序甚至不需要安装，只需一个 URL 即可运行，运行完之后不留任何痕迹，实现“即用即弃”。

3. 高可用性

系统没有全局的动态共享库，每个应用程序自带其运行所需的共享库以及资源，因此即使系统进行了重大的更新或者修改，应用程序仍然能正常运行。

注：为减少冗余，那些非常通用的共享库被打包成一个叫做 “Core” 的组件，其组成以及共享库的版本是固定的，一个应用程序只能依赖一个指定版本的 “Core”。

4. 全新的 UI

5. 全新的交互方式

6. 兼容 Linux 应用

