---
title: "XiaoXuan Managed"
date: 2024-01-19
draft: false
tags: ["xiaoxuan-lang"]
categories: ["xiaoxuan-managed"]
---

{{< figure class="mid" src="./images/banner.webp" >}}

_XiaoXuan Managed_ is used for building extremely secure, robust, truly portable and responsive programs, including desktop applications, cloud-native applications (such as microservices and serverless functions etc.), business systems, data science and A.I. programs and more. Each program runs in its own isolated environement, eliminating the need for containers. Applications do not need to be installed, they can be run with just a URL.

## Motivation

_XiaoXuan Managed_ applications run in an "isolated" environment, which brings a new way to run and publish applications:

**For users**

- You don't have to worry about the source of the application or whether it contains backdoors or malicious code. You can run it with confidence because _XiaoXuan Managed_ applications cannot harm your system or access your private data or files without your permission.

- You don't have to worry about the application not being able to run because the system is missing certain shared libraries, because _XiaoXuan Managed_ programs are truly portable. You don't need to install additional libraries for the system, or compile the program source code. As long as your system can run the _XiaoXuan Managed_ runtime, the application will definitely be able to run successfully.

- You can even run a new application without installing it first and use all its features.

**For developers**

- You don't have to open source your work or spend time building user trust. You can simply publish your application when it's ready.

- You don't need to submit your application to an "application store" or wait for lengthy review process.

- You don't have to pay a commission to an "application store".

- You can simply provide users with the application binary package, a URL, or even the address of a Github repository. With this information, users can run your applicaton.

- You can even release new versions of the application at any time, and users will be automatically notified of new versions.

_XiaoXuan Managed_ provides a new "user-application-developer" relationship. Users can simply focus on the features they need, and developer can simply focus on developing their software. There is no "application store" or "maintainer" between the two.

## Features

- **High Security**: _XiaoXuan Managed_ applications are strictly sandboxed and cannot access the user's system or data without permission.

- **True Portability**: Some programming languages allow user code to access native libraries, such as Java's JNI, Python's Binding, and Node.js's Addons. This causes the application to be bound to the system environment. For example, when the user's environment changes, it may take a lot of effort to make it work properly. _XiaoXuan Managed_, on the other hand, completely isolates user code from the system environment. As long as the user has obtained the XiaoXuan Manged application, it will be able to run successfully.

- **Self-contained application distribution channels**: _XiaoXuan Managed_ applications can be submitted to public free software repositories, or provided by the developer themselves with a publicly accessible internet address. _XiaoXuan Managed_ applications can be automatically updated to the latest version.

TODO