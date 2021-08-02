---
excerpt_separator: <!--readmore-->
layout: post
title: 'WordPress development environment with Docker Part I: installing Docker'
published_at: 2016-03-30T16:44:00+00:00
categories: [code, wordpress]
permalink: /:title/
author: jveillet
---

Welcome to this (soon to be) series about WordPress development environment using [Docker](https://www.docker.com/). We will cover the basis of how to set up Docker, how to configure it to run a WordPress instance in a container, and how to add our theme, modify it, and see instantly the result.
Part I is aimed at people who heard about Docker and containers, but never got deeper. If you already know what is it
all about, and have a functioning environment, skip directly to [Part II]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-ii-using-docker-compose-to-install-wordpress %}).

<!--readmore-->

## Table of Contents

- [Prerequisites](#prerequisites)
- [Introduction](#intro)
- [Create a docker machine](#create)
- [Connect to the Docker Machine](#connect)
- [Start and stop machines](#start_stop)
- [Getting the Host IP address](#ip)
- [Wrapping up](#conclusion)

## Prerequisites {#prerequisites}

Install Docker Toolbox (Windows or Mac, VirtualBox is included).
A Terminal (No worries on OSX or Linux, if you're on Windows, try [Cygwin](https://www.cygwin.com/), or an equivalent like [Babun](https://babun.github.io/)).

## Introduction {#intro}

> “Docker allows you to package an application with all of its dependencies into a standardized unit for software development.
Docker containers wrap up a piece of software in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. This guarantees that it will always run the same, regardless of the environment it is running in.” — [Docker documentation](https://docs.docker.com).

There are three key components of Docker:

- The docker program.
- Docker subcommands (run, compose, etc..).
- Docker images, that will run in containers.

> “A container is a stripped-to-basics version of a Linux operating system. An image is software you load into a container. When you ran the command, the Engine software:
checked to see if you had the hello-world software image
downloaded the image from the Docker Hub (more about the hub later)
loaded the image into the container and “ran” it
” — [Docker documentation](https://docs.docker.com).

Imagine you want to run a MySQL server, you then have to ask Docker to run MySQL.

```bash
$ docker run mysql
[...]
```

But, how is it going to know how to launch MySQL, you might say? Well, Docker has an "image hub", a repository with a lot of already configured images ready for you to use. So if the image doesn't exist on your system, it will "pull" it from the repository and install it before anything else. Of course you can build your own images, and even pushed them on the Docker repository, but it's a another story, for a different time.

Once again, I encourage you to read through the [Docker Website](https://www.docker.com/), there are good tutorials and example.

## Create a docker machine (first install only) {#create}

If this is your first install of Docker, and the first time ever you are using it, you have to create a Docker Machine, which means creating a VirtualBox image using the docker toolbox.

Fire up a terminal, because nearly everything will be done in the command line. To know if machines already exists you can invoke the docker-machine program.

```bash
$ docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM   DOCKER   ERRORS
```

If you have that kind of result, that means there is no created machines yet (otherwise skip to the next part). Now, to create a machine, we will reuse the docker-machine command, with additional parameters (docker-machine - - help to know all about the parameters).

```bash
$ docker-machine create --driver virtualbox default
Running pre-create checks...
Creating machine...
(staging) Copying /Users/ripley/.docker/machine/cache/boot2docker.iso to /Users/ripley/.docker/machine/machines/default/boot2docker.iso...
(staging) Creating VirtualBox VM...
(staging) Creating SSH key...
(staging) Starting the VM...
(staging) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Machine is running, waiting for SSH to be available...
Detecting operating system of created instance...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect Docker to this machine, run: docker-machine env default
```

List again the machines to see your newly created machine.

```bash
$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER   ERRORS
default   *        virtualbox   Running   tcp://192.168.99.100:2376
```

The Docker machine is now created, but we need to be able to talk to it, like the last line of the output says, we need to use the env parameter to connect to this machine.

## Connect to the Docker Machine {#connect}

```bash
$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.169.10.199:2376"
export DOCKER_CERT_PATH="/Users//.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval "$(docker-machine env default)"
```

Again, the terminal prompt is saying what we must do in order to connect to the machine, run the command above:

```bash
eval "$(docker-machine env default)"
```

That's it, your terminal session is now connected with the Docker machine. In order to know that everything runs smoothly, and see if there are containers running into the machine, you can do a `ps` command with the docker program (like you can do when you want to know what program is running on Linux or OSX).

```bash
$ docker ps
CONTAINER ID    IMAGE    COMMAND    CREATED    STATUS    PORTS    NAMES
```

The problem is, if you don't want to repeat this steps every time you start the Docker Machine, you can add the `eval "$(docker-machine env default)"` command into your `.bashrc` or your `.zshrc`, so that it will be launched every time you open a terminal window. Otherwise you are left with putting this command in your terminal before doing anything else with Docker, so go for the lazy way and put it in your bash profile file.

<div class="alert alert--info">
  <strong>Where is .bashrc, or .zshrc?</strong> Those files are located in your home folder, so if you <code>cd ~/</code> in your terminal, you should find them. If they do not exist, do a <code>touch ~/.bashrc</code> or <code>touch ~/.zshrc</code> before editing them.
</div>

## Start and stop machines {#start_stop}

When you're done with whatever you were doing with your Docker environment, there is a command that permits to stop the machine (like shutting down your computer), and,
the opposite, a command to start the machine again.

```bash
docker-machine stop default
docker-machine start default
```

## Getting the Host IP address {#ip}

We will eventually need to *connect* to WordPress later, so knowing the IP address of the virtual machine can be handy, because no more connecting to localhost or 127.0.0.1 like with a LAMP/WAMP set up.

```bash
$ docker-machine ip default
192.168.99.100
```

## Wrapping up {#conclusion}

In this tutorial, you've learn a little about Docker, how to install it and configure your Terminal to use it. Now everything is set up for the next level:
[Using Docker Compose to run WordPress]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-ii-using-docker-compose-to-install-wordpress %}).
