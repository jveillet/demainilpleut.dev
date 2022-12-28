---
excerpt_separator: <!--readmore-->
layout: post
title: 'How to clean up local git branches matching a name'
published_at: 2016-01-21T18:00:00+00:00
tags: [git]
category: blog
permalink: /:title/
author: jveillet
summary: 'How to clean your local Git branches'
---

## Introduction

If you are like me, and you are in an project using `git`, you probably create or use a LOT of branches. There can be times when it's hard to keep track of all of them and they pile up in your project's folder until you see 100 of them.

<!--readmore-->

## Listing branches and deleting them

<div class="alert alert--danger">
  <strong>A word of caution:</strong> Deleting branches is a definitive act, you cannot go back, especially if the branches hadn't been pushed to some kind of remote repository (e.g Github, BitBucket, etc..).
</div>

Navigate through your project and list the branches, you probably already know that `*` represent your current default branch:

```bash
$ cd myProject
$ git branch
  Another_thing_to_do_aside
  Fix_another_fix
  Fix_some_kind_of_task
  Fix_urgent_task_to_change
  JIRA-10_End_task_yes_the_real
  JIRA-1_One_task
  JIRA-2_Another_task
  JIRA-3_Task_3
  JIRA-4_TEST_task
  JIRA-5_Great_Task
  JIRA-6_No_task
  JIRA-7_Foo_task
  JIRA-8_Bar_Task
  JIRA-9_Bazz_task
* master
```

As you can see, you could have a whole bunch of branches of every name. Now, git gives you the possibility of listing the branches that has been already merged.

```bash
git branch --merged
```

You can reverse the logic and do the exact opposite and list the not merged ones.

```bash
git branch --no-merged
```

Now you can go and use the results of these commands and add it to the delete method.

```bash
git branch -d `git branch --merged`
```

But what if you want to delete branches based on their name or a part of their name ?

## Grep to the rescue

<div class="alert alert--info">
  <strong>If you're on Windows</strong>: I suggest you at least use Git bash, or some kind of Cygwin equivalent, because we are about to use Linux/Unix commands.
  <br/>
  <strong>Update:</strong> You can also use WSL (Windows Subsystem for Linux) on Windows 10 now.
</div>

So, how to retrieve branches of a certain name ? Well, after searching, I didn't find this kind of filter in git. But, with every Unix/Linux environment, you have the possibility to search/filter in an Terminal output with a simple command called `grep`. With this utility, you can filter based on a Pattern, it can be a simple String or even better, a Regular Expression. I will not cover the Regex part because I'm terrible at it, I'll stick with the simple String filtering.

As you have seen in my project, I tried to name my branches in harmony with JIRA's, tying the name to the User Story is convenient for me as I can rapidly scan and find any particular topic I worked on.

Let's say I want to see only the ones containing `JIRA` in their name, the first thing is to list the branches, then apply a filter on top of it:

```bash
$ git branch | grep "JIRA"
 JIRA-10_End_task_yes_the_real
 JIRA-1_One_task
 JIRA-2_Another_task
 JIRA-3_Task_3
 JIRA-4_TEST_task
 JIRA-5_Great_Task
 JIRA-6_No_task
 JIRA-7_Foo_task
 JIRA-8_Bar_Task
 JIRA-9_Bazz_task
```

Isn't that nice? Imagine you want the opposite, those that don't have `JIRA` in their name:

```bash
$ git branch | grep -v "JIRA-"
  Another_thing_to_do_aside
  Fix_another_fix
  Fix_some_kind_of_task
  Fix_urgent_task_to_change
* master
```

Pretty neat, yes? The `-v` stands for "select non-matching lines", not to be confused with `-V` which will output the version of grep.

## Combine the options

How can we use this results to delete the matching branches? We have the possibility to chain the commands to the `git branch -d` and apply the filter to it. One nice thing about this command, is that you can pass in a list of branches you want to delete.

```bash
git branch -d `git branch | grep "JIRA"`
```

This will use the result of the grep command, and pass the list to the `git branch -d`. Unfortunately, it will only delete the merged branches of this list. If you want to delete any branch no matter what, you have to use the `-D` flag instead.

```bash
git branch -D `git branch | grep "JIRA"`
```

Happy cleaning 😊
