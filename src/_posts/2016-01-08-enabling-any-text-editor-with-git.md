---
excerpt_separator: <!--readmore-->
layout: post
title: 'Enabling any text editor with git'
published_at: 2016-01-08T15:58:00+00:00
tags: [git, editor, commit]
category: blog
permalink: /:title/
author: jveillet
summary: 'How to enable any text editor to work with git commands'
---

I'm joining the party a little late, but I've started working with `git` and `GitHub`, both for this website, and coincidentally at work for my current project.This is a quick article about using your favorite editor to write your commit messages.

<!--readmore-->

## State of the art

If you happen to work with `git` (if not, you should download and it and play with it, it's marvelous), you probably need to enter a commit message at some point. When you first setup your environment, no default editor is configured (on OSX, if `git` is installed with XCode, it might use `vim` as the default editor).

Checking out what is configured, it is as easy as invoking this line in the Terminal:

```bash
$ git config core.editor
vim
```

Chances are, you will get an empty line as nothing is probably set.

## Change the editor

Let's say you want to use SublimeText 3. This software comes with a very handy multiplatform (Windows and OSX) CLI call `subl`, that you can invoke in the Terminal. To use it anywhere in your command line, you either have to put the path of the executable into the `PATH` variable of the Windows environment, or do a symlink on OSX (see Resources).

Open up a Terminal then type `subl`, you should see that it will open a new Sublime window. There is a bunch of optional parameters that you can pass to interact with Sublime, like `-n` for opening up a new window, or `-w` to wait for the files to be closed before returning.

To change the editor settings, use this command in the Terminal:

```bash
git config --global core.editor "subl -n -w"
```

Now every time the command `git commit` will be invoked, SublimeText will be the default editor for commit messages.

## Resources

- [SublimeText `Command Line Interface` documentation](https://www.sublimetext.com/docs/command_line.html).
- [Configure the PATH variable in Windows](https://www.computerhope.com/issues/ch000549.htm).
- [Configure a symlink in OSX](https://apple.stackexchange.com/questions/115646/how-can-i-create-a-symbolic-link-in-terminal?rq=1).
- [Associating text editors with git](https://help.github.com/articles/associating-text-editors-with-git/) - Github help page.
