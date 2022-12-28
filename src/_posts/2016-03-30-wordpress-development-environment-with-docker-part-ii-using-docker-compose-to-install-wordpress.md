---
excerpt_separator: <!--readmore-->
layout: post
title: 'Wordpress development environment with Docker Part II: Using Docker Compose to install WordPress'
published_at: 2016-03-30T17:12:00+00:00
tags: [code, wordpress]
category: blog
permalink: /:title/
author: jveillet
image:
  - src: wp_docker_capture_1.png
    alt: 'WordPress install page'
  - src: wp_docker_capture_3.png
    alt: 'WordPress admin interface'
  - src: wp_docker_capture_4.png
    alt: 'PHPMyAdmin interface'

---

This is part II of an ongoing series about WordPress development with Docker. Part I was about installing Docker and preparing the environment. Our goal this time, is installing WordPress in a container, a database, and play a little bit with it.

<!--readmore-->

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory structure](#structure)
- [Using docker-compose](#compose)
- [Setting up WordPress](#wordpress)
- [Setting up a database](#database)
- [Bonus part](#bonus)
- [Wrapping up](#conclusion)

## Prerequisites {#prerequisites}

A fonctionning installation of Docker (see [Part I]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-i-installing-docker %}).
A command line / Terminal.
A web browser of your choosing.

## Directory structure {#structure}

We will use a simple directory structure, create a folder on your OS, then create an empty `docker-compose.yml` in it.

```bash
mkdir wp-docker
cd wp-docker/
touch docker-compose.yml
```

## Using docker-compose {#compose}

> Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application’s services. Then, using a single command, you create and start all the services from your configuration — [Docker Compose documentation](https://docs.docker.com/compose/overview/).

You can also launch containers one by one by doing a docker run + parameters, but it is not really friendly (yes, this is highly subjective), and very verbose as you have to type a list of parameters the size of the Mississippi. Compose is a tool made to combine the launch of multiple containers ( = multiple run commands), with the help of a YML file. This file can take a lot of parameters, we will focus on the key ones we will need in order to accomplish a WordPress installation. As always check the [Docker documentation](https://docs.docker.com/compose/compose-file/) to know more.

For illustration purpose, we will use the syntax version 1 of the Compose file.

## Setting up WordPress {#wordpress}

What we want for starter is to be able to launch WordPress on an Apache server and a database. We have to define two containers, and what image it should use when we will invoke the Compose program. Note that we can name or containers however we want, as it is just a label that will help ourselves to link the containers between them and see what is going on in the CLI.

Fire up your favorite text editor, and insert the following text. Save it into the docker-compose.yml as it is the default name that Docker will invoke.
You can name it with another name, but you will have to tell the program explicitely (see [Bonus section](#bonus)).

```bash
wordpress:
  image: wordpress
  ports:
    - 8080:80
```

You see that the text is indented, it is crucial to keep the text as is, as it is the norm for YML files. First line with "worpdress:" is the name of the container. Second line is the name of the image you will use (remember [Part I]({{site.url}}{% link _posts/2016-01-21-how-to-clean-up-local-git-branches-matching-a-name.md %}), Docker has a directory of pre-build images with a lot of softwares ready to be used). We will use the official (and latest version) WordPress image. Next parameter is the ports. In order to connect to the website, we need to tell Docker to map the port that is running on the Docker Machine, to a local port on our computer.

We can see what's going on if we try to launch Docker Compose with what we have in the Compose file.

```bash
$ docker-compose up
[...]
```

It will pull the WordPress image from the repository, with PHP and an Apache server as dependencies, install and configure everything with default values (it may take a little time, depending on your internet connection). but if you try to connect to the WordPress instance (http://192.168.99.100:8080), chances is that you might get an error due to a lack of database.

## Setting up a database {#database}

In order to use the website, we need to install a database as well, something like MySQL. I choosed [MariaDB](https://mariadb.org) image from the Docker Repository, as it is an open source fork of MySQL, and it is nicely offered to us. You are probably asking yourself how we are going to access this database instance? Docker provide us with a "environment" section where we can put the variables we need to override the default configuration (Refer to the [Environment section](https://docs.docker.com/compose/compose-file/#environment) on the Docker documentation, and [Environment Variables section](https://hub.docker.com/_/mariadb/) on the Docker Hub page of MariaDB in order to know what can be tweaked).

The final step is to link the WordPress container with this database container: this is a one liner. under a new "links" section, add the following code to your Compose file.

```bash
wordpress:
  image: wordpress
  links:
    - wordpress_db:mysql
  ports:
    - 8080:80
wordpress_db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: examplepass
```

<div class="alert alert--danger">Please try not to use this password and use one of your own, even if you are using this on your local machine.</div>

Run an "up" command and see what is going on.

```bash
$ docker-compose up
[...]
```

As you can see in the screenshot, launching the browser with the url of the website, we are now greeted with the WordPress install step.

{% assign image =  page.image[0] %}
{% render "srcset" image: image, site: site %}

Configure the parameters that are asked, then login to the WordPress admin interface. And voila!

{% assign image =  page.image[1] %}
{% render "srcset" image: image, site: site %}

You can now configure everything like a regular WP installation, install themes, plugins, etc..

## Bonus part {#bonus}

### phpMyAdmin {#phpmyadmin}

Being a command line ninja is pretty cool, but sometimes, one like to have an interface to navigate through the MySQL databases. Like for MySQL,
we need to add a container in the Compose file and link it to the database instance.

```bash
wordpress:
  image: wordpress
  links:
    - wordpress_db:mysql
  ports:
    - 8080:80
wordpress_db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: examplepass
phpmyadmin:
  image: corbinu/docker-phpmyadmin
  links:
    - wordpress_db:mysql
  ports:
    - 8181:80
  environment:
    MYSQL_USERNAME: root
    MYSQL_ROOT_PASSWORD: examplepass
```

As you can see, we use the 8181 port to access the admin page of phpMyAdmin, and we add environment variables to configure an account with a login and password. Launch the browser with the new url.

BOOOOM!!!

{% assign image =  page.image[2] %}
{% render "srcset" image: image, site: site %}

### Renaming the Docker Compose file {#renaming}

I get it, `docker-compose.yml` is a lame name, there are situations when you want to be able to launch different configurations. Let's create a different file, called "dev", with the content of the docker-compose.yml file.

```bash
cp docker-compose.yml dev.yml
```

Launching this configuration will not be more difficult that previously, we add to tell the program to use a different path to compose. Use the `-f` flag with the new Compose file name.

```bash
$ docker-compose -f dev.yml up
[...]
```

## Wrapping up {#conclusion}

In this article, we learned how to use the Docker Compose program, and create a simple `docker-compose.yml` file to install and launch a WordPress website with a MySQL instance.
What comes next? how are we using this to integrate plugins or themes
development and get down to business ? [Read part III: integrating a development theme]({% post_url 2016-04-20-wordpress-development-environment-with-docker-part-iii-using-your-own-wordpress-theme %}).
