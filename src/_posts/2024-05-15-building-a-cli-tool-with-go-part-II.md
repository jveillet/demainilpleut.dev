---
layout: post
title: 'Building a CLI tool with Go part II'
published_at: 2024-05-15T12:00:00+00:00
tags: [golang, cli]
category: blog
permalink: /:title/
author: jveillet
summary: 'An evolution from the previous article about building a CLI with go for reading files in the terminal.'
---

In the [previous article]({% post_url 2024-01-17-building-a-cli-tool-with-go %}) we've seen how to build a minimal CLI program to read files in the terminal using golang.

Let's see if we are able to taking things up a notch. We wil update our code for a little performance bump, and had a feature to read many files.

## Previously

Last time we build a small program to read a file from disk and display the raw content in the terminal. While it's OK to dump all the file content into the memory, it can slow down or crash your system if your files are large.

## Reading files in chunks

One optimization we can do to improve the memory consumption, is reading files by chunks. We will only read limited "portions" of the file, one by one until we reach the end of the file.

Let's take our previous code and add that possibility.

```diff
// Our file can be anywhere
- content, err := os.ReadFile(filePath)
+ file, err := os.Open(filePath)

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

  os.Exit(1)
}

+ // Close the file when we are done
+ defer file.Close()
```

This is opening the file first, instead of reading straight into it. We leave the error check as is, and we close the file asynchronously.

If we want to read the file in chunks, we are able to leverage some nice functions from the standard `os.File` package. It means that we need to declare how much bytes we want to read for each chunk and make a buffer out of it.

```go
// Declare the chunk size
const chunkSize = 1024

// Create a buffer to read the file in chunks
buffer := make([]byte, chunkSize)
```

We need now to loop from the file by each chunk size and display the result as we go in the terminal.

```go
for {
  // Read from the file chunk into the buffer
  bytesRead, err := file.Read(buffer)

  if err != nil {
    if err != io.EOF {
      // In case of an error that is not the end of the file, we print an error message
      fmt.Println("Error while reading the file.")
    }
    // When we reach the end of the file, we break the loop and stop reading the file
    break
  }

  // Print the content of the buffer
  fmt.Println(string(buffer[:bytesRead]))
}
```

We could use other methods to achieve this, such as using the `bufio` package, but this is a good enough solution. It doesn't add too much complexity and it achieve the performances we are looking for.

## Reading many files

Our CLI program is able to read from one file at once. But if we want to have a clone of the `cat` command, one thing we can do for fun is trying to to read from many files.

First, let's refactor the command line arguments parsing to read many arguments.

```diff
- // Reads the first command-line argument
- filePath := flag.Arg(0)

+ // Read all the command-line arguments
+ files := flag.Args()
```

By doing this change, we also need to shift a little the "empty command line arguments" check.

```diff
- // Reads the first command-line argument
- filePath := flag.Arg(0)

// Display Usage if no file name is given
- if filePath == "" {
+ if len(files) == 0 {
  flag.Usage()
  os.Exit(1)
}
```

One step remaining, we need now to loop over the file names and still continue to read our files in chunks. Add a little `range` loop around the previous code, and that should do the trick.

```go
for _, filePath := range files {
  file, err := os.Open(filePath)
  (...)
}
```

## Bonus : Concatenate files

No programming involved to do that (almost). We can leverage the power of Unix piping to concatenate files.

Our program is able to read from files, and put the content in the Standard Output (`STDOUT`).

What we can do is using the `>` operator in the terminal to redirect this result into a new file.

```sh
go run main.go my_file1.txt my_file2.txt > my_file3.txt
```

If you open the `my_file3.txt`, you will see that it contains the content from the `my_file1.txt` and `my_file2.txt`.

I don't know, but I find this pretty neat.

## Wrapping up

In this article, we've seen how to improve a little bit our previous golang CLI app, to:

* Read many command line arguments.
* Load each files by chunk.
* Save some memory and improve performances 🚀️.

Complete source code of `main.go`:

```go
package main

import (
  "errors"
  "flag"
  "fmt"
  "io"
  "os"
)

func main() {
  // Nice help text in case of using the --help argument to the program
  flag.Usage = func() {
    fmt.Printf("Usage: ./go-cat [FILE]...\n")
    fmt.Printf("Concatenate FILE(s) to standard output.\n")
    fmt.Printf("FILE\t The name of the file.\n")
  }

  // Parse is the first thing to call so that the command-line arguments are parsed and available
  flag.Parse()

  // Read all the command-line arguments
  files := flag.Args()

  // Display Usage if no file name is given
  if len(files) == 0 {
    flag.Usage()
    os.Exit(1)
  }

  for _, filePath := range files {

    file, err := os.Open(filePath)

    if err != nil {
      if errors.Is(err, os.ErrNotExist) {
        fmt.Printf("The file %s does not exist.\n", filePath)
      } else if errors.Is(err, os.ErrPermission) {
        fmt.Println("You don't have the persmission to read this file.")
      } else {
        fmt.Println("Error while reading the file.")
        fmt.Println(err)
      }

      os.Exit(1)
    }

    // Close the file when we are done
    defer file.Close()

    // Declare the chunk size
    const chunkSize = 1024

    // Create a buffer to read the file in chunks
    buffer := make([]byte, chunkSize)

    for {
      // Read from the file chunk into the buffer
      bytesRead, err := file.Read(buffer)

      if err != nil {
        if err != io.EOF {
          // In case of an error that is not the end of the file, we print an error message
          fmt.Println("Error while reading the file.")
        }
        // When we reach the end of the file, we break the loop and stop reading the file
        break
      }

      // Print the content of the buffer
      fmt.Println(string(buffer[:bytesRead]))
    }
  }
}
```
