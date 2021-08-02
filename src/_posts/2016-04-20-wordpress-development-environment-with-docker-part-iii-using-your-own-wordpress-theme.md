---
excerpt_separator: <!--readmore-->
layout: post
title: 'Wordpress Development Environment With Docker Part III Using Your Own Wordpress Theme'
published_at: 2016-04-20T16:56:36+00:00
categories: [code, wordpress]
permalink: /:title/
author: jveillet
---

Welcome to the last part of the WordPress development environment with
Docker. We will see how to use your own theme in the previous Docker container we created in [Part II]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-ii-using-docker-compose-to-install-wordpress %}).

<!--readmore-->

## Table of Contents

- [Accessing the container](#container)
- [Sharing data](#mount)
- [Adding your own theme](#theme)
- [Side note on volumes](#side)
- [Wrapping up](#conclusion)

## Accessing the container {#container}

Our WordPress instance is installed and running in a container, we have to ask ourselves how to access to this container to be able to read and write in the directory where the files are contained. Docker has mounted WordPress in `/var/www/html`, so in order to access this directory, we must tell the Compose tool, how to share a directory from the host and the container.

<div class="alert alert--warning">Something tricky about sharing data with Docker, on OSX and Windows, sharing directories is restricted. Your project must be located at least in the root of C:\Users (Windows) and /Users (OSX), otherwise it won't work.</div>

## Sharing data {#mount}

To share data, it's a matter of adding the `volume` line in the Compose file and tell it which directory on the host we map with the container.
For this example, we want to mount the directory in a _wordpress_ folder.

The syntax start with the host directory path, separated with a colon `:`, and then the path in the container.

```yaml
[...]
  volumes:
    - /my/awesome/path:/var/www/html
[...]
```

Let's add this in our Compose file:

```yaml
wordpress:
  image: wordpress
  links:
    - wordpress_db:mysql
  ports:
    - 8080:80
  volumes:
    - /c/Users/jeremie.veillet/.dev/wp-docker/wordpress:/var/www/html
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

Before launching this, we will have to stop the container if it is running. Then, we need to remove the container, unless mounting the data will not work.

```bash
$ docker-compose stop
[...]
$ docker-compose rm wordpress
[...]
```

Start the WordPress container again:

```bash
$ docker-compose up
[...]
```

Alright, now we should find the WordPress files in our "wordpress" folder. Check in a Terminal or open a file browser window.

```bash
$ cd wordpress
$ ls -la
total 167
drwxr-xr-x 1 jeremie.veillet Domain Users     0 Apr 20 12:43 .
drwxr-xr-x 1 jeremie.veillet Domain Users     0 Mar 22 10:01 ..
-rw-r--r-- 1 jeremie.veillet Domain Users   234 Mar 18 12:28 .htaccess
-rw-r--r-- 1 jeremie.veillet Domain Users   418 Mar 18 12:28 index.php
-rw-r--r-- 1 jeremie.veillet Domain Users 19935 Apr 15 13:51 license.txt
-rw-r--r-- 1 jeremie.veillet Domain Users  7358 Apr 15 13:51 readme.html
-rw-r--r-- 1 jeremie.veillet Domain Users  5032 Apr 15 13:51 wp-activate.php
drwxr-xr-x 1 jeremie.veillet Domain Users     0 Apr 15 13:51 wp-admin
-rw-r--r-- 1 jeremie.veillet Domain Users   364 Apr 15 13:51 wp-blog-header.php
-rw-r--r-- 1 jeremie.veillet Domain Users  1476 Apr 15 13:51 wp-comments-post.php
-rw-r--r-- 1 jeremie.veillet Domain Users  3238 Apr 20 12:43 wp-config.php
-rw-r--r-- 1 jeremie.veillet Domain Users  2853 Apr 20 12:43 wp-config-sample.php
drwxr-xr-x 1 jeremie.veillet Domain Users     0 Apr 19 17:25 wp-content
-rw-r--r-- 1 jeremie.veillet Domain Users  3286 Mar 18 12:28 wp-cron.php
drwxr-xr-x 1 jeremie.veillet Domain Users     0 Apr 15 13:51 wp-includes
-rw-r--r-- 1 jeremie.veillet Domain Users  2380 Mar 18 12:28 wp-links-opml.php
-rw-r--r-- 1 jeremie.veillet Domain Users  3316 Mar 18 12:28 wp-load.php
-rw-r--r-- 1 jeremie.veillet Domain Users 33837 Apr 15 13:51 wp-login.php
-rw-r--r-- 1 jeremie.veillet Domain Users  7887 Mar 18 12:28 wp-mail.php
-rw-r--r-- 1 jeremie.veillet Domain Users 13106 Apr 15 13:51 wp-settings.php
-rw-r--r-- 1 jeremie.veillet Domain Users 28624 Apr 15 13:51 wp-signup.php
-rw-r--r-- 1 jeremie.veillet Domain Users  4035 Mar 18 12:28 wp-trackback.php
-rw-r--r-- 1 jeremie.veillet Domain Users  3061 Mar 18 12:28 xmlrpc.php
```

## Adding your own theme {#theme}

Now that we have full access to the WordPress installation, we can copy and paste our own theme into wp-content/theme, as usual. For the sake of the demonstration, I will use [demain·il·pleut's](https://github.com/jveillet/wp-demainilpleut) theme, but you can use whatever theme you like, even modify the ones provided by WordPress (e.g: Twenty Something).

```bash
$ cd wordpress/wp-content/themes
$ git clone https://github.com/jveillet/wp-demainilpleut.git
[...]
$ cd wp-demainilpleut
```

If you go the WordPress administration tool, and go to Appearance -> Themes, you should see the theme we have cloned/copied. You can now select it as the default theme. Now, you can start to change the files of the theme and reload the website in your browser to see the changes, no need to restart the container.

Congrats, you are ready to develop in WordPress with Docker!

## Side note on volumes {#side}

When defining the "volumes" section, putting the full path of your project can be error prone, but fortunately, we can use some environment
variables in the Compose file to construct the path. As we do in a Terminal, we can use the `$PWD` variable to use the host current folder path.

```yaml
[...]
  volumes:
    - $PWD:/var/www/html
[...]
```

## Wrapping up {#conclusion}

We have learned how to install and configure Docker, and use WordPress and MySQL + phpMyAdmin in containers, and run everything with Docker Compose.
In this chapter, we covered how to mount the WordPress installation from the container into a folder in the host machine, put a theme in it, as to modify it and see the results.

**Other Parts in this series:**

- [WordPress development environment with Docker Part I: installing Docker]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-i-installing-docker %})
- [Wordpress development environment with Docker Part II: Using Docker Compose to install WordPress]({% post_url 2016-03-30-wordpress-development-environment-with-docker-part-ii-using-docker-compose-to-install-wordpress %})
