---
excerpt_separator: <!--readmore-->
layout: post
title: 'Building a basic HTTP server with plain old Ruby & Rack'
published_at: 2020-10-13T12:00:00+00:00
categories: [ruby, server, static files]
permalink: /:title/
author: jveillet
summary: 'Build a basic HTTP server with Ruby to serve static files.'
image:
  - src: building-a-basic-http-server-with-plain-old-ruby-and-rack.png
    alt: 'Image showing the ruby server index file'
---

Occasionally, I find myself in need for a basic HTTP server that will render some static content (HTML, CSS, images,..), no complex installation, only build and launch. As I am a huge Ruby fan, I was wondering how can I achieve this in the simplest way possible with plain Ruby.

## What we will build

A basic HTTP server, serving a static HTML file. The Install process should be as small as possible, and launching the server should be fast and with a single command.

<!--readmore-->

## What we need

- Ruby 2.6

## Enter rack

According to the `rack` documentation:

> Rack provides a minimal, modular, and adaptable interface for developing web applications in Ruby. By wrapping HTTP requests and responses in the simplest way possible, it unifies and distills the API for web servers, web frameworks, and software in between (the so-called middleware) into a single method call.

Rack is used by most of the Ruby web servers you can find (puma, Sinatra, Webrick,..), it has an excellent support, a lot of plugins, and is very modular. Think of it has a framework to build Web servers on top of it.

In the next section, we will use Webrick to build the server, I chose this because it is built-in Ruby, the performances are OK, and it doesn't need a lot of configuration.

## Create the project

We will need to first create a home for our project, that will contain our application logic, I called it `static-rb`, you can call it whatever you want.

Inside that project, to create our Ruby server, we will need to create three files:

- A `Gemfile` (contains the dependencies we will need).
- A `config.ru` file (the web server logic).
- An `index.html` file inside a `public/` folder.

Create those three files with you favorite tool (explorer, VS Code, vim, terminal, ...), the folder tree should look like this:

```bash
static-rb/
 |
 config.ru
 |
 Gemfile
 public/
  |
  index.html
```

## The Gemfile

As the goal is to have a small footprint, we will keep the dependencies short with only one of them, you guessed it, `rack`!

```bash
# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.6'

# Rack provides a minimal, modular and adaptable interface for developing web applications in Ruby
gem 'rack', '~> 2.2', '>= 2.2.3'
```

As I said before, no need to install Webrick as it comes built-in with Ruby.

Next, let's install that dependency using `bundler` (the Ruby package manager).

```bash
bundle install
```

## The config.ru

This file will hold all the logic behind our web server, and it will fit in ≤ 40 lines of code.

We need the server to listen on a specific port, and respond with our HTML file when we will request the document root `/`.

To achieve this, we will have to use the `rack` [Builder method](https://www.rubydoc.info/github/rack/rack/master/Rack/Builder):

```ruby
# frozen_string_literal: true

require 'webrick'

# Listen on '/' and display the index.html
app = Rack::Builder.new do
  map '/' do
    use Rack::Static, urls: ['/'], root: 'public', index: 'index.html'
    run lambda { |_env|
      [
        200,
        {
          'Content-Type': 'text/html',
          'Cache-Control': 'no-cache'
        },
        File.open('public/index.html', File::RDONLY)
      ]
    }
  end
end
```

It does not grow more complex than this. It is almost finished, we need to plug it to Webrick and roll with it.

```ruby
# frozen_string_literal: true

require 'webrick'

# Listen on '/' and display the index.html
app = Rack::Builder.new do
  map '/' do
    use Rack::Static, urls: ['/'], root: 'public', index: 'index.html'
    run lambda { |_env|
      [
        200,
        {
          'Content-Type': 'text/html',
          'Cache-Control': 'no-cache'
        },
        File.open('public/index.html', File::RDONLY)
      ]
    }
  end
end

# Options, like port, logs, SSL config, etc..
webrick_options = {
  Port: 3000,
  Logger: WEBrick::Log.new($stdout, WEBrick::Log::DEBUG),
  DocumentRoot: './'
}

# Launch Webrick server
Rack::Handler::WEBrick.run app, webrick_options

# Shutdown the server with CTRL + C
Signal.trap 'INT' do
  Rack::Handler::WEBrick.shutdown
end
```

We are now ready to use our web server. What's really cool is that `rack` comes up with a useful command line tool that use our config and launch the server with a single command:

```bash
rackup # OR bundle exec rackup
```

Type this in your terminal, and you should see that the server is ready and listening on the port 3000.

```bash
[2020-10-08 12:23:30] INFO  WEBrick 1.4.2
[2020-10-08 12:23:30] INFO  ruby 2.6.6 (2020-03-31) [x86_64-linux]
[2020-10-08 12:23:30] DEBUG WEBrick::HTTPServlet::FileHandler is mounted on /.
[2020-10-08 12:23:30] DEBUG Rack::Handler::WEBrick is mounted on /.
[2020-10-08 12:23:30] INFO  WEBrick::HTTPServer#start: pid=182768 port=3000
```

Open your web browser of choice and enter the URL [localhost:3000](http://localhost:3000).

{% assign image =  page.image[0] %}
{% render "srcset" image: image, site: site %}

Yeah 🔥 !!!

## Wrapping up

We learned to create a small footprint web server, that can host static files, like a documentation, and that you can launch with the help of two small commands: `bundle install && rackup`.

**Can it be more simple?**

Probably yes, but I think it's simple *enough*.

**Can I use this to host my next big ass web project ?**

I would advise you not to 😉.

**Can I have SSL support?**

Definitely yes, you can see one example on the [repository jveillet/static-rb](https://github.com/jveillet/static-rb).

**Is this useful?**

I don't know, you decide 🙂.

## Resources

- [rack](https://github.com/rack/rack): A modular Ruby web server interface.
- [webrick](https://github.com/ruby/webrick): HTTP server toolkit.
- [jveillet/static-rb](https://github.com/jveillet/static-rb): A very stripped-down HTTP server built with Ruby and Rack.
