---
excerpt_separator: <!--readmore-->
layout: post
title: 'Dealing with the MongoDB error /data/db not found in OSX'
published_at: 2016-01-10T10:50:00+00:00
tags: [code, javascript, nosql]
category: blog
permalink: /:title/
author: jveillet
summary: 'How to fix MongoDB error /data/db not found'
---

## Disclaimer

if you landed somehow on this article, you have probably miss something in the install process of [MongoDB](https://docs.mongodb.org/manual/tutorial/install-mongodb-on-os-x/).

<!--readmore-->

## What the.. ?

When trying to launch mongodb in your Terminal, I guess you have met with this kind of error message:

```bash
$ mac:app jeremie$ mongod
2015-10-09T12:06:37.396+0200 I STORAGE [initandlisten] exception in initAndListen:
29 Data directory /data/db not found., terminating
```

The output is pretty clear, you do not have the `data` directory, and its `db` subdirectory created in your root folder, which are essential to run the mongodb instance.
So let's go ahead and fix that, and create that directory.

```bash
mkdir -p /data/db
```

If you try to launch the `mongod` command again after that, it will fail with something like the above:

```bash
$ mac:app jeremie$ mongod
2015-10-09T12:10:17.370+0200 I STORAGE [initandlisten] exception in initAndListen: 98 Unable to create/open lock file:
/data/db/mongod.lock errno:13 Permission denied Is a mongod instance already running?, terminating
```

The directory is created, but you do not have sufficient rights to interact with it.

## Do I have the permission, Sir?

Fixing this error can be done by using the two commands below:

```bash
sudo chmod 0755 /data/db
sudo chown $USER /data/db
```

What it means on the first line is the owner have read, write, and execute rights, and others have only read and execute rights.
The second line changes the ownership of the directory from its current owner to the logged in user.

Aaaaand, that's it! Next time you will fire the `mongod` command, you should see an output like this:

```bash
$ mac:~ jeremie$ mongod
[...]
2015-10-09T12:24:43.826+0200 I STORAGE [FileAllocator] creating directory /data/db/_tmp
2015-10-09T12:24:44.612+0200 I STORAGE [FileAllocator] done allocating datafile /data/db/local.0, size: 64MB, took 0.785 secs
2015-10-09T12:24:44.960+0200 I NETWORK [initandlisten] waiting for connections on port 27017
2015-10-09T12:26:50.108+0200 I NETWORK [initandlisten] connection accepted from 127.0.0.1:50278 #1 (1 connection now open)
```

## Wrapping up

Reading documentation is an essential part of being a software developer, it might not sound sexy, it's sometimes tedious, but it's an essential job to understand what you do and how things work.
