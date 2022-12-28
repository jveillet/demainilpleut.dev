---
excerpt_separator: <!--readmore-->
layout: post
title: 'Your first CLI tool with Rust'
published_at: 2019-03-22T18:00:00+00:00
tags: [rust, cli, command line, beginner]
category: blog
permalink: /:title/
author: jveillet
summary: 'Learn how to build your first CLI tool with Rust'
---

In the wonderful world of programming, you may have heard about this new shiny language called Rust. It is an open-source systems programming language that focuses on speed, memory safety, and parallelism. It allows you to do low-level programming à la C/C++.

You might have heard about it in the context of [Web Assembly](https://webassembly.org/). Rust is capable to compile WASM applications, you can find a wide variety of use cases on the [Web Assembly FAQ](https://webassembly.org/docs/use-cases/). It is also known as the basis of [servo](https://servo.org/), a high-performance browser engine, implemented in Firefox.

<!--readmore-->

It's a bit intimidating, but that's not what we will talk about here. Instead, we will go through on how we can build command line tools with it, and maybe have fun along the way.

## Why Rust?

Ok, let me set things straight. I could have done CLI tools with any other language or framework. I could have picked C, Go, Ruby, whatever. Hell, I could have used good old bash.

I wanted to learn something new in 2018, Rust picked my curiosity and I had a need for building simple small tools to automate some process at work and for personal projects.

## Installation

You can set up your workstation by using [Rustup](https://rustup.rs/), it is the main program that installs and configures all the Rust toolchain on your machine.

If you are on Linux or macOS, there is a single command line that will do this for you:

```bash
$ curl <https://sh.rustup.rs> -sSf | sh
[...]
```

If you are on Windows, it is very similar, but you need to download an `exe` on the [Rustup Website](https://rustup.rs/) and execute it.

My personal opinion here, if you are on Windows 10, I suggest you use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) instead. That's it for the installation,  we can go and create our first Rust application!

## Your first Rust app

What we will try to do here, is building a replica of the [cat](https://en.wikipedia.org/wiki/Cat_(Unix)) UNIX utility, or at least a very stripped down version of it, and we will call it `kt`. This application will accept a file path as input and display the content of the file in the terminal's standard output.

To create the basic skeleton of the application, we will use a tool called [Cargo](https://github.com/rust-lang/cargo/). It is the package manager of Rust, think of it as the NPM (for my Javascript friends) or the Bundler (for the Rubyists) of the Rust toolchain.

Open your terminal app, go to your favorite place to store source code, then type in the code below.

```bash
cargo init kt
```

This will create a directory called `kt` with the basis of the structure of our app.

If we `cd` into that directory, we will see a architecture and, bonus point, that the project has git initialized by default. Neat!

```bash
$ cd kt/
  |
  .git/
  |
  .gitignore
  |
  Cargo.toml
  |
  src/
```

The `Cargo.toml` file is the package file containing the information of our app as well as the dependencies. Once again, think of it as the `package.json` or `Gemfile` of your application.

The `src/` directory contains the source files of our application, we can see that there is a single `main.rs` file, and by inspecting it we see that it contains a single `main` function.

```rust
fn main() {
    println!("Hello, world!");
}
```

Try to build this project, it should be fast as there are no external dependencies.

```bash
$ cargo build
Compiling kt v0.1.0 (/Users/jeremie/Development/kitty)
Finished dev [unoptimized + debuginfo] target(s) in 2.82s
```

In development mode, you can execute a binary by invoking `cargo run` (`cargo run — my_arg` for passing command line arguments).

```bash
$ cargo run
Finished dev [unoptimized + debuginfo] target(s) in 0.07s
Running `target/debug/kt`
Hello, world!
```

Give yourself a pat in the back, you have created and run your first Rust application! 🎉

## Parsing our first command line argument

Like I said earlier in the article, we are trying to build a stripped-down version of `cat`. We aim to mimic `cat` and display the content of a file in the terminal output, by launching `kt myfile.txt`.

We could handle the parsing of arguments by ourselves, but luckily there is a Rust Crate that can ease this process for us, and it is called [Clap](https://github.com/clap-rs/clap).

This library is a fast command line argument parser, and it will allow us to manage them with little effort.

The first step to use this crate is opening the `Cargo.toml` file and explicitly add the dependency in it. If you never encountered a `.toml` file before, it looks a lot like an `.INI` file in the fabulous Windows world. It's a file format rather popular in the Rust world.

You will see in this file that there is already some information filled up for us, like the author, the version and so on. We will need to add our dependency under the `[dependencies]` key.

```toml
[dependencies]
clap = "~2.32"
```

After saving the file, we will need to build the project again in order to be able to use the library. Don't worry too much about `cargo` downloading much more than the `clap` crate, as it's caused by dependencies required by `clap`.

```bash
$ cargo build
 Updating crates.io index
  Downloaded clap v2.32.0
  Downloaded atty v0.2.11
  Downloaded bitflags v1.0.4
  Downloaded ansi_term v0.11.0
  Downloaded vec_map v0.8.1
  Downloaded textwrap v0.10.0
  Downloaded libc v0.2.48
  Downloaded unicode-width v0.1.5
  Downloaded strsim v0.7.0
   Compiling libc v0.2.48
   Compiling unicode-width v0.1.5
   Compiling strsim v0.7.0
   Compiling bitflags v1.0.4
   Compiling ansi_term v0.11.0
   Compiling vec_map v0.8.1
   Compiling textwrap v0.10.0
   Compiling atty v0.2.11
   Compiling clap v2.32.0
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished dev [unoptimized + debuginfo] target(s) in 33.92s
```

That's it for the configuration, we can get our hands dirty and finally do some code to read our first command line arguments.

Open the `main.rs` file. We will have to explicitly say that we want to use the Clap library.

```rust

extern crate clap;

use clap::{Arg, App};

fn main() {}
```

The extern crate keyword is for importing the library, you have to add this in the main file only, to have it enabled for any source file of the application. The `use` part indicates which module of `clap` you are going to use in this file.

A quick note about Rust modules:

> Rust has a module system that enables the reuse of code in an organized fashion. A module is a namespace which contains definitions of functions or types, and you can choose whether those definitions are visible outside their module (public) or not (private). — The Rust Documentation

Here we are saying that we want to use the `Arg` and the `App` module. We want to be able to have a `FILE` argument for our app, that will contain a file path. Clap can help up express that with a method chaining fashion that is very pleasant.

```rust
fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();
}
```

Compile and execute again, it should not give you much in the output, except a compilation warning on the variable `matches` (you can put a `_` in front of the variable, it will tell the compilator that this variable is optional (this will talk to Rubyists).

The magic happens if you pass the `-h` or `-V` arguments to the application, an help and a version command are automatically generated for free. I don't know what you think, but I found that 🔥🔥🔥.

```bash
$ cargo run -- -h
    Finished dev [unoptimized + debuginfo] target(s) in 0.03s
     Running `target/debug/kt -h`
kt 0.1.0
Jérémie Veillet. jeremie@example.com
A drop-in cat replacement written in Rust

 USAGE:
    kt [FILE]

 FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

 ARGS:
    <FILE>    File to print.

$ cargo run — -V
Finished dev [unoptimized + debuginfo] target(s) in 0.04s
Running target/debug/kt -V
kt 0.1.0
```

We can also try to launch the program without any arguments and see what happens.

```bash
$ cargo run --
Finished dev [unoptimized + debuginfo] target(s) in 0.03s
  Running `target/debug/kt`
```

Nothing. This is the default behavior that should occur every time you build a command line tool. I think that passing no arguments to the application should never trigger any action. There are times when this is not true, but for the vast majority, **you should never execute an action that your user  never intended to**.

Now that we have our argument in place, we can dig into how to *catch* this command line argument and display something in the standard output.

To implement this, we can use the `value_of` method of `clap`. Please refer to the [documentation](https://docs.rs/clap/2.32.0/clap/struct.ArgMatches.html#method.value_of) to know how this method behaves.

```rust
fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
      )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        println!("Value for file argument: {}", file);
    }
}
```

At this point, you can run the application and pass in a random string as an argument, it should display that random string in your console.

```bash
$ cargo run -- test.txt
Finished dev [unoptimized + debuginfo] target(s) in 0.02s
  Running `target/debug/kt test.txt`
Value for file argument: test.txt
```

Note that we actually make no verifications on the existence of that file for the moment. But what if we do?

There is a standard library that permits us to check if a file or directory exists, without the hassle. It's the `std::path` library. It has an `exists` method that can check the existence of the file for us.

Add the library with the `use` keyword as we've seen before, then drop in the code below. You see that we are using an `If-Else` condition to print some text in the output. The `println!` method is writing in the standard output `stdout`, whereas `eprintln!` in writing in the standard error output `stderr`.

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        println!("Value for file argument: {}", file);
        if Path::new(&file).exists() {
            println!("File exist!!");
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1); // Standard exit code for programs terminating with an error
        }
    }
}
```

We're almost there!! Now we need now to read the content of the file and display the result in `stdout`.

Once again, we will use a standard library to read from files called `File`. We will read the content of the file using the `open` method, then write it into a String object, which will be displayed in `stdout`.

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read};

fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();
    if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
           println!("File exist!!");
           let mut f = File::open(file).expect("[kt Error] File not found.");
           let mut data = String::new();
           f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
           println!("{}", data);
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

Build and run again this code. Congratulations! We now have a fully functioning tool! 🍾

```bash
$ cargo build
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished dev [unoptimized + debuginfo] target(s) in 0.70s
$ cargo run -- ./src/main.rs
    Finished dev [unoptimized + debuginfo] target(s) in 0.03s
     Running `target/debug/kt ./src/main.rs`
File exist!!
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read};

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            println!("File exist!!");
            let mut f = File::open(file).expect("[kt Error] File not found.");
            let mut data = String::new();
            f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
            println!("{}", data);
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

## Improving a little bit

Ok, our application is taking a parameter and displaying the result in `stdout`.

We can tweak a little bit the performance on the whole printing phase, by using `writeln!` instead of `println!`. This is well explained in the [Rust Output Tutorial](https://rust-lang-nursery.github.io/cli-wg/tutorial/output.html#a-note-on-printing-performance). While we are at it, we can clean a little bit code, remove unnecessary printing and fine-tune the possible error scenarios.

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read, Write};

fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            match File::open(file) {
                Ok(mut f) => {
                    let mut data = String::new();
                    f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
                    let stdout = std::io::stdout(); // get the global stdout entity
                    let mut handle = std::io::BufWriter::new(stdout); // optional: wrap that handle in a buffer
                    match writeln!(handle, "{}", data) {
                        Ok(_res) => {},
                        Err(err) => {
                            eprintln!("[kt Error] Unable to display the file contents. {:?}", err);
                            process::exit(1);
                        },
                    }
                }
                Err(err) => {
                    eprintln!("[kt Error] Unable to read the file. {:?}", err);
                    process::exit(1);
                },
            }
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

```bash
$ cargo run -- ./src/main.rs
  Finished dev [unoptimized + debuginfo] target(s) in 0.02s
    Running `target/debug/kt ./src/main.rs`
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read, Write};

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            match File::open(file) {
                Ok(mut f) => {
                    let mut data = String::new();
                    f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
                    let stdout = std::io::stdout(); // get the global stdout entity
                    let mut handle = std::io::BufWriter::new(stdout); // optional: wrap that handle in a buffer
                    match writeln!(handle, "{}", data) {
                        Ok(_res) => {},
                        Err(err) => {
                            eprintln!("[kt Error] Unable to display the file contents. {:?}", err);
                            process::exit(1);
                        },
                    }
                }
                Err(err) => {
                    eprintln!("[kt Error] Unable to read the file. {:?}", err);
                    process::exit(1);
                },
            }
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

Here we are! Our basic `cat` copy-cat 🤡, is finished with 45 lines of code or so, and it performs really well!

## Building a standalone application

What about building this application and installing it in our filesystem? cargo to the rescue!

`cargo build` is accepting a `—release` flag so that we can specify that we want the final version of our executable.

```bash
$ cargo build --release
   Compiling libc v0.2.48
   Compiling unicode-width v0.1.5
   Compiling ansi_term v0.11.0
   Compiling bitflags v1.0.4
   Compiling vec_map v0.8.1
   Compiling strsim v0.7.0
   Compiling textwrap v0.10.0
   Compiling atty v0.2.11
   Compiling clap v2.32.0
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished release [optimized] target(s) in 28.17s
```

The generated executable is located in a sub-directory: `./target/release/kt`.

Either you copy-paste this file somewhere in your `PATH`, or you use another cargo command to install it automatically. The application will be installed in the `~/.cargo/bin/` directory (make sure this directory is in your `PATH` in the `~/.bashrc` or `~/.zshrc`).

```bash
$ cargo install --path .
  Installing kt v0.1.0 (/home/jeremie/Development/kt)
    Finished release [optimized] target(s) in 0.03s
  Installing /home/jeremie/.cargo/bin/kt
```

Now we can invoke our application by calling it directly in the terminal with the command `kt`! \o/

```bash
$ kt -V
kt 0.1.0
```

## Wrapping up

We created a small command line tool with a few lines of Rust, which accepts a file path as an input, and displays the content of that file in `stdout`.

You can find all the sources for this article under the [GitHub repository](https://github.com/jveillet/kt-rs).

Your turn to improve the tool!

- You can add a command line argument to add the line numbers in the output (`-n` option).
- Display a chunk of a file, and then the rest after using the `ENTER` key on the keyboard.
- Open multiple files at once with a syntax like `kt myfile.txt myfile2.txt myfile3.txt`.

Don't hesitate to show me what you have built with it! 😎

_Special thanks to Anaïs for reviewing this post_ 👍

## Going further

- [cat](https://en.wikipedia.org/wiki/Cat_(Unix)): Wikipedia page of the cat utility.
- [kt-rs](https://github.com/jveillet/kt-rs): This article project.
- [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/).
- [Clap](https://github.com/clap-rs/clap): A full featured, fast Command Line Argument Parser for Rust.
- [Reqwest](https://github.com/seanmonstar/reqwest): An easy and powerful Rust HTTP Client.
- [Serde](https://github.com/serde-rs/serde): Serialization framework for Rust.
- [crates.io](https://crates.io/): The Rust community’s crate registry.
