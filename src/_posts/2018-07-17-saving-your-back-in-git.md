---
excerpt_separator: <!--readmore-->
layout: post
title: 'Saving your back in git'
published_at: 2018-07-17T18:00:00+00:00
categories: [git, commands]
permalink: /:title/
author: jveillet
summary: 'Common situations with Git and how to resolve them'
---

Here is a usefull collection of git commands that I keep coming back to, it saved me countless times when I was in tricky situations.
I have finally decided to compile them here, I hope it can help you too!

<!--readmore-->

## Table of Contents

- [Rename a local branch](#rename-branch)
- [Delete a remote tag](#delete-tag)
- [Check out a remote branch](#checkout-remote-branch)
- [List all the files in a commit](#list-files-commit)
- [Remove files from a commit](#remove-files-commit)
- [Undo a git commit --amend](#undo-commit)
- [Ignore files already commited](#ignore-files)
- [Exclude a file from a diff](#exclude-file-diff)
- [Usefull resources](#usefull-resources)

## Rename a local branch {#rename-branch}

Rename a branch while pointed to any branch:

```bash
git branch -m oldname newname
```

Rename the current branch:

```bash
git branch -m newname
```

## Delete a remote tag {#delete-tag}

Remove a tag on the origin:

```bash
git push -d origin tagname
```

Remove a tag locally:

```bash
git tag -d tagname
```

## Check out a remote branch {#checkout-remote-branch}

You can be in a situation when you need to check out a remote branch locally. This branch has been pushed to
the remote repository, by someone else or you.

```bash
git pull --all
Fetching origin
remote: Counting objects: 1, done.
remote: Total 1 (delta 0), reused 0 (delta 0), pack-reused 1
Unpacking objects: 100% (1/1), done.
From github.com:github-user/my-repo
XXXXf37..XXXXb28  my-branch     -> origin/my-branch
...
```

You can then checkout out this branch:

```bash
git co my-branch
```

## List all the files in a commit {#list-files-commit}

```bash
git diff-tree --no-commit-id --name-only -r my_commit_id
test.txt
src/lib.rb
```

Information about the arguments:

+ The `--name-only` show only names of changed files.
+ The `--no-commit-id` removes the commit ID output.
+ The `-r` argument is to recurse into sub-trees.

For listing files from the parent commit, use a `-m` argument:

```bash
git diff-tree --no-commit-id --name-only -m -r my_parent_commit_id
```

## Remove files from a commit {#remove-files-commit}

You have mistakely commited files locally, and you want this files to be back in the staging area without undoing the work that has been done on them.

```bash
git reset --soft HEAD~1

git reset HEAD path/to/file_to_remove

git commit -c ORIG_HEAD
```

Alternatively, you can define this with a git alias:

```bash
git config --global alias.undo 'reset --soft HEAD~1'
```

## Undo a git commit --amend {#undo-commit}

```bash
# Move the current head so that it's pointing at the old commit
# Leave the index intact for redoing the commit.
# HEAD@{1} gives you "the commit that HEAD pointed at before
# it was moved to where it currently points at". Note that this is
# different from HEAD~1, which gives you "the commit that is the
# parent node of the commit that HEAD is currently pointing to."
git reset --soft HEAD@{1}
```

```bash
# commit the current tree using the commit details of the previous
# HEAD commit. (Note that HEAD@{1} is pointing somewhere different from the
# previous command. It's now pointing at the erroneously amended commit.)
git commit -C HEAD@{1}
```

Thanks to this [Stackoverflow](https://stackoverflow.com/questions/1459150/how-to-undo-git-commit-amend-done-instead-of-git-commit#1459264) question.

## Ignore files already commited {#ignore-files}

Create a new branch to apply the effective removal of files.

```bash
git checkout -b new-branch
```

Apply the removal of the file, without removing the local copy.

```bash
git rm --cached my-file
```

It's now safe to commit the file and push it to the remote.

```bash
git add . && git commit my-file
```

## Exclude a file from a diff {#exclude-file-diff}

```bash
git diff -- . ":(exclude)path/to/file-to-exclude.rb"
```

Exclude files from the diff based on the extension:

```bash
git diff -- . ":(exclude)*.min.js" ":(exclude)*.min.css"
```

## Usefull resources {#usefull-resources}

- [Oh, shit, git](http://ohshitgit.com/)
