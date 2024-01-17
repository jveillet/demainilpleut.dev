---
layout: post
title: 'Building a CLI tool with Go'
published_at: 2024-01-17T18:00:00+00:00
tags: [golang, cli]
category: blog
permalink: /:title/
author: jveillet
summary: 'An introduction to building a CLI program using golang.'
---

I started digging through the Golang programming language in 2023 and I really liked it.  In fact, it's really powerful and composable and modular, and in a sense more accessible than other low-level languages like Rust. We are far from the developer happiness that a programming language like Ruby is providing, yet I find it very pleasant to work with. There is a wide variety of packages and frameworks that make it a great candidate to build any kind of software with. Therefore, I want to take the opportunity of this new year to write an introduction to the Go programming language, by building a replica of the [cat](https://en.wikipedia.org/wiki/Cat_(Unix)) UNIX utility, a standard tool available on Linux/Unix based OSes.

This is a recycled version of an old article I wrote where I did basically the same thing with Rust (it's outdated now, don't bother). However, this time I will use Go and show you how easy and fun it is to create a CLI tool with it.

## What we will build

Step by step, we will build a small CLI app that we can use in a terminal. This program will take an argument that will represent the file name to read, and will display the content of this file in the terminal output. The goal is not to make a full featured, bullet proof application, but rather to discover the language in an interactive way.

To do so, we will need:

* The Go runtime.
* A code editor.
* A terminal.

## Setting up the project

I will not cover how to install the Go runtime, There is good documentation on the language website, choose the platform you want to use and
follow the instructions from there: [go.dev](https://go.dev/doc/install).

When the runtime is installed, create a directory to hold our project, let's call it `go-cat`.

```sh
mkdir go-cat
cd go-cat
```

We need to initialize a new Go project. For this, we can use the `go mod init` command via the terminal. It accepts an optional module name argument. You can leave it blank or use the one below. This command creates a `go.mod` file that will hold a reference to the packages we will use.

```sh
go mod init golang-tutorial/go-cat
```

> "The go mod init command creates a go.mod file to track your code's dependencies. So far, the file includes only the name of your module and the Go version your code supports. But as you add dependencies, the go.mod file will list the versions your code depends on. This keeps builds reproducible and gives you direct control over which module versions to use." — The Go Documentation

All right, we need to create a file that will host our source code. To do this, create a `main.go` file via the terminal or with your code editor of choice.

```sh
touch main.go
```

Open this file, and inside add the `main` function. If you ever programmed with another low-level language (C/C++/rust), it will look familiar.

```go
// This declares the package name of the file
package main

// This is the function that will automatically be called when you run the program
func main() {

}
```

Great, but our program isn't doing anything special right now. Let's add a printing function so that we can test if our program is launching correctly.

```go
// This declares the package name of the file
package main

// This is the function that will automatically be called when you run the program
func main() {
  // This prints a message in the terminal
  println("hello from go-cat!")
}
```

In development mode, you can execute a binary by invoking `go run` (`go run myfile.go` with the file we want to execute).

```sh
$ go run main.go
hello from go-cat!
```

Neat! we have our first Go program.

## Parsing a command-line argument

We want to be able to invoke our program with at least one command-line argument like: `./go-cat myfile`. How can we read a command-line argument within our program?

We can leverage the standard `os` package, which contains the `Args` array, that will hold all the command-line arguments passed. Here is an updated version of our previous example:

```go
// This declares the package name of the file
package main

// This imports the packages we need
// It should be auto added by the go runtime
import (
  "fmt"
  "os"
)

// This is the function that will automatically be called when you run the program
func main() {
  // This assigns the first argument to a variable
  filePath := os.Args[1]
  // This prints a message in the terminal with the argument
  fmt.Println("hello from go-cat! I am using the argument:", filePath)
}
```

If you run again `main.go`, with an additionnal argument, you will see it display in the terminal result.

```sh
$ go run main.go myfile
hello from go-cat! I am using the argument: myfile
```

## Reading from a file

We can now read a command-line argument with our program. Next, we want to be able to read a file from our program.

For this example, we will need a text file, let's create one, name it `lorem.txt` and store it in the same directory as our project. Open this file and put random text in it, you can use the online tool [lipsum.com](https://com.lipsum.com/) to generate a couple of paragraphs and copy/paste it in this file.

Let's try to read from it inside our program. For this example purpose, we will put aside for now the command-line arguments.

I want to be fancy here, and add a little error check if the file doesn't exist.

```go
// This declares the package name of the file
package main

// This imports the packages we need
// It should be auto added by the go runtime
import (
  "fmt"
  "os"
)

// This is the function that will automatically be called when you run the program
func main() {
  // Reads the file inside the current directory
  content, err := os.ReadFile("lorem.txt")

  // Error handling in case the file cannot be read
  if err != nil {
    fmt.Println("Error while reading the file")
  }

  // This prints the file content in the terminal output
  fmt.Println(string(content))
}
```

Run the program again, ommiting the command-line argument we defined before.

```sh
$ go run main.go
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vehicula odio id pretium dignissim. (...truncated)
```

Nice! We can see that the content of our file displays in the terminal (I truncated the output for readability here).

We can integrate with the command-ligne argument we defined before, and swap the static file name that we put inside our code with it.

It goes with someting like this:

```go
// This declares the package name of the file
package main

// This imports the packages we need
// It should be auto added by the go runtime
import (
  "fmt"
  "os"
)

// This is the function that will automatically be called when you run the program
func main() {
  // This assigns the first argument to a variable
  filePath := os.Args[1]

  // This prints a message in the terminal with the argument
  fmt.Println("hello from go-cat! I am using the argument:", filePath)

  // Read the content of the file passed by argument
  content, err := os.ReadFile(filePath)

  // Error handling in case the file cannot be read
  if err != nil {
    fmt.Println("Error while reading the file")
  }

  // This prints the file content in the terminal output
  fmt.Println(string(content))
}
```

```sh
$ go run main.go lorem.txt
hello from go-cat! I am using the argument: lorem.txt
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vehicula odio id pretium dignissim.(...truncated)
```

OK, it works like before. But what happens if we put random text, or a wrong file path as a command-line argument?

```sh
$ go run main.go another_file.txt
hello from go-cat! I am using the argument: another_file.txt
Error while reading the file
```

Not the best error hint, but it does the job for now.

## Going further with the `flag` package

The command line arguments via the `os` package is very low-level. If we want to evolve the code a little bit,
and add a more elegant parsing of command-line arguments, there is a standard package named `flag` that will help us do that.

This package implements command-line flag parsing and can do verification on the command-line arguments we pass, as well as
displaying a "usage" help text when the program is run without any arguments.

You can find the documentation of this package on the pkg.go website: [pkg.go.dev/flag](https://pkg.go.dev/flag).

Let's rewrite our previous example so that it uses the `flag` package.

Notice that we need to display a "Usage" help text in case there is no command-line arguments.
And we can also display this "Usage" text when using the `--help` command-line argument, which is a standard way of displaying
a help message from terminal based programs.

```go
// This declares the package name of the file
package main

// This imports the packages we need
// It should be auto added by the go runtime
import (
  "flag"
  "fmt"
  "os"
)

// This is the function that will automatically be called when you run the program
func main() {
  // Nice help text in case of using the progam without arguments
  // Or when passing the --help argument to the program
  flag.Usage = func() {
    fmt.Printf("Usage: \n")
    fmt.Printf("./go-cat [FILE]>\n")
    fmt.Printf("FILE\t The name of the file.\n")
  }

  // Parse is the first thing to call so that the command-line arguments are parsed and available
  flag.Parse()

  // This assigns the first argument to a variable
  filePath := flag.Arg(0)

  // No argument have been passed, or the argument is empty
  // Display the Usage text and exit
  if filePath == "" {
    flag.Usage()
    os.Exit(0)
  }

  // This prints a message in the terminal with the argument
  fmt.Println("hello from go-cat! I am using the argument:", filePath)

  // Read the content of the file passed by argument
  content, err := os.ReadFile(filePath)

  // Error handling in case the file cannot be read
  if err != nil {
    fmt.Println("Error while reading the file")
  }

  // This prints the file content in the terminal output
  fmt.Println(string(content))
}
```

Little bit better, but let's see if we can spice it up.

## One more thing, displaying better errors

To conclude this walkthrough, we can rewrite the error message so that we clearly communicate with more user friendly messages.

Golang has a standard package called `errors`, that implements functions to manipulate errors that will help us. Particularly, there is a `Is` function that matches an error with a predefined list of standard errors.

Let's replace the code that handle errors with this one:

```go
  // Handle errors with more user friendly messages
  if err != nil {
    if errors.Is(err, os.ErrNotExist) {
      fmt.Printf("The file %s does not exist.\n", filePath)
    } else if errors.Is(err, os.ErrPermission) {
      fmt.Println("You don't have the persmission to read this file.")
    } else {
      fmt.Println("Error while reading the file.")
      fmt.Println(err)
    }

    // Exit(1) tells the OS that the program did not executed correctly
    // While Exit(0) indicates success
    os.Exit(1)
  }
}
```

This will display a nice custom message if the file does not exist, or if we don't have the permissions to read that file (in case we try to read
a system file for example). All the unhandled errors will fallback into the last `else` statement.

Run again `main.go` with a non existent file path, we can see our custom error message!

```sh
$ go run main.go non-existant-file.txt
The file non-existant-file.txt does not exist.
exit status 1
```

And that's it for today!

## Wrapping up

We learned to build a small CLI program that mimic one functionnality of the `cat` utility. It takes the file name (complete path) of
the file as a command-line argument, and diplays the content of the file in the terminale ouput, or an error message.

Complete source code of `main.go`:

```go
// This declares the package name of the file
package main

// This imports the packages we need
// It should be auto added by the go runtime
import (
  "errors"
  "flag"
  "fmt"
  "os"
)

// This is the function that will automatically be called when you run the program
func main() {
  // Nice help text in case of using the --help argument to the program
  flag.Usage = func() {
    fmt.Printf("Usage: \n")
    fmt.Printf("./go-cat [FILE]\n")
    fmt.Printf("FILE\t The name of the file.\n")
  }

  // Parse is the first thing to call so that the command-line arguments are parsed and available
  flag.Parse()

  // This assigns the first argument to a variable
  filePath := flag.Arg(0)

  // Display Usage if no file name is given
  if filePath == "" {
    flag.Usage()
    os.Exit(0)
  }

  // Read the content of the file passed by argument
  content, err := os.ReadFile(filePath)

  // Handle errors with more user friendly messages
  if err != nil {
    if errors.Is(err, os.ErrNotExist) {
      fmt.Printf("The file %s does not exist.\n", filePath)
    } else if errors.Is(err, os.ErrPermission) {
      fmt.Println("You don't have the persmission to read this file.")
    } else {
      fmt.Println("Error while reading the file.")
      fmt.Println(err)
    }

    // Exit(1) tells the OS that the program did not executed correctly
    // While Exit(0) indicates success
    os.Exit(1)
  }

  // This prints the file content in the terminal output
  fmt.Println(string(content))
}
```
