---
title: "XiaoXuan Script"
date: 2024-01-19
draft: false
tags: ["xiaoxuan-script", "xiaoxuan-lang"]
categories: ["xiaoxuan-script"]
---

{{< figure class="wide" src="./images/banner.png" >}}

The _XiaoXuan Script Programming Language_ is suitable for building high-performance, solid web applications. It can be compiled to WebAssembly on-the-fly without the need for any build tools. It is intended to be the next preferred programming language for web development.

## How does it work?

Only 3 files are needed to give browsers the ability to develop web applications using a new language (the XiaoXuan Script):

- `ans_compiler.wasm`, the compiler for XiaoXuan Script.
- `ans_loader.js`, the loader for the compiler, which also serves as the web application manager, as well as the bridge between the WebAssembly and the Web API.
- `ans_std.ans`, the source code of the XiaoXuan Script standard library.

{{< figure src="./images/compilation.png" class="mid white" caption="The Compilation Process" >}}

When a user accesses your web application (web page), the _compiler_ will compile all the source code (including the user code, standard library, and all dependencies) on-the-fly into a WebAssembly file, which is then cached in the user's browser to speed up the next load. The web page and WebAssembly will then interoperate via the _bridge_.

## Quick start

Let's create a minimal "Hello World!" XiaoXuan Script application.

First create a folder named "hello-ans" in your home directory (or any directory), then download the XiaoXuan Script distribution package {{< null-link "xiaoxuan_script_dist_1.0.1.tar.gz">}}, which is a compressed file containing `ans_compiler.wasm`, `ans_loader.js`, `ans_std.ans`, and some README etc. files, and then extract it to this folder.

Then create files _main.ans_ and _ans_package.json_ in this folder.

The file _main.ans_ is the main module of our web application, which should contain the `main` function. The file content is as follows:

```js
function main() {
    let title = document.querySelector("#title")
    set(title.textContent, "Hello World!")

    let btn = document.querySelector("#like")
    btn.addEventListener("click", like)
}

function like() {
    let count = document.querySelector("#count")
    let number:int = get(count.textContent).parse().unwrap()

    set(count.textContent, (number+1).to_string())
}

```

You may have noticed that the above code looks similar to the JavaScript, this is the design of XiaoXuan Script, where the names of objects and functions are kept as close as possible to JavaScript, the similarity to an existing language reduces the difficulty of learning a new language.

The file _ans_package.json_ is the package description file, which contains information about the package name, version, compiler version, list of source files, and dependencies. _ans_package.json_ has the following contents:

```json
{
    "name": "hello_ans",
    "version": "1.0",
    "compiler": "1.0",
    "modules": {
        "main": "./main.ans"
    }
}
```

Next, create the web page file _index.html_, the content is as follows:

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Hello, XiaoXuan Script</title>
    <script type="module" src="./ans_loader.js"></script>
</head>

<body>
    <h1 id="title">title</h1>
    <input type="button" id="like" value="+1">
    <span id="count">0</span>
</body>
</html>

```

The content of _index.html_ is quite simple, the key line is: `<script type="module" src="./ans_loader.js"></script>`, it loads the _XiaoXuan Script Loader_ and the loader does all the rest.

The structure of the folder "hello-ans" should look like this:

```text
hello_ans
├── ans_compiler.wasm
├── ans_loader.js
├── ans_module.json
├── ans_std.ans
├── index.html
└── main.ans
```

Finally, let's create a local HTTP server, which can be done by running the command `python -m http.server`.

Now open any browser and visit `http://localhost:8000/`. You should see the text "Hello World!" and the number will increase when you click on the "Like" button.

## Q & A

### What are the differences between _JavaScript_ and _XiaoXuan Script_?

_JavaScript_ is the default programming language supported by browsers. It is easy to learn and use, and its syntax is flexible. Compared to _JavaScript_, _XiaoXuan Script_ has the following advantages:

- It has a stricter syntax and is a statically, strongly typed compiled programming language, it is more suitable for developing large-scale applications. It can significantly reduce coordination costs between team members in team development, and is also easier to maintain the application source code.

- It is compiled to WebAssembly before running, and WebAssembly is widely considered to have higher performance than _JavaScript_. Therefore, _XiaoXuan Script_ has better performance in computationally intensive scenarios (such as data processing, audio or image processing).

### What are the differences between _TypeScript_ and _XiaoXuan Script_?

_XiaoXuan Script_ has some syntactic similarities to TypeScript. If you are familiar with TypeScript, it means that you can easily learn _XiaoXuan Script_. The difference is that _TypeScript_ is compiled to _JavaScript_, while _XiaoXuan Script_ is compiled to WebAssembly, which means that _XiaoXuan Script_ will have better performance.

### Rust/C/C++ can also be compiled to WebAssembly, so what are the differences between _XiaoXuan Script_ and them?

Rust/C/C++ are mainly used to build parts of a web application, such as data processing libraries, rather than building the entire web application. On the other hand, _XiaoXuan Script_ is used to build the entire application. Using _XiaoXuan Script_ means that you only need to learn one language to  develop a variety of applications, which reduces the learning burden on developers.

### Why on-the-fly compilation?

_XiaoXuan Script_ actually supports pre-compilation mode, which is recommended for large-scale web applications that have a large amount of source code and dependencies.

However, for most web applications, the code may not so large, and on-the-fly compilation mode is more convenient. It can simplify the developer's workflow, you can write, debug and run your code like you do with _JavaScript_, without the need for any build tools. In addition, XiaoXuan Script has a very fast compilation speed, and users can hardly notice the compilation process when they access your web application.

## Get started

- {{< null-link "XiaoXuan Script Playground" >}}
- {{< null-link "Get started with XiaoXuan Script in 5 minutes" >}}

## Manuals & Tutorials

- {{< null-link "Build a local TODO web application using XiaoXuan Script" >}}
