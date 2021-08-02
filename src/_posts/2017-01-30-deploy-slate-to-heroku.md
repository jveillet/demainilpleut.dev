---
excerpt_separator: <!--readmore-->
layout: post
title: 'Deploy Slate to Heroku'
published_at: 2017-01-30T18:10:00+00:00
categories: [code, ruby, middleman, heroku]
permalink: /:title/
author: jveillet
summary: 'Learn how to deploy the Slate documentation, and build the assets automatically on Heroku'
---

Documentaton is a big part of a project, more critical if you need to hand off the details of your API to multiple third parties that will interact with it.
Here you will lean how to deploy [Slate](https://github.com/lord/slate), the API documentation generator based on [Middleman](https://middlemanapp.com/),
on Heroku, and how to configure it to generate the static HTML files with each commit on a repository.

<!--readmore-->
## Table of Contents

- [Some context](#context)
- [Set up Slate locally](#install)
- [Building the documentation on Heroku](#building)
- [Serving files](#serving)
- [Customizing the Middleman build configuration](#customizing)

## Some context {#context}

One particular problem we were facing at work, was deploying documentation of our API on Heroku, without the need to host the generated files into our repository. This was
leading us to a lot of manipulations and possibly errors, particularly when we wanted someone outside the dev team to write the documentation. What we were trying to
achieve was to commit the markdown page and be done with it.

## Set up Slate locally {#install}

Slate is not a library, nor a Ruby gem, but a fully configured project to ease the redaction of APIs documentation. It take the form of a clonable Github repository.
You can modify the files to your needs in the `/docs` directory, like using your own logo, though it is already coming with a lovable UI theme. Create your
markdown files and they will be transformed into a single page HTML file.

```bash
$ git clone git@github.com:lord/slate.git
# Install middleman and all the dependencies
# /!\ You will probably need to install nodejs as well as it
# is required by one of the dependencies
$ bundle install
# Execute the middleman local server
$ bundle exec middleman
# OR
$ bundle exec middleman build --clean
# To only generate the files without lauching the server
```

The generated HTML files will be placed in a the `/docs` directory, based on what's int the `/sources` one.

## Building the documentation on Heroku {#building}

Middleman is a static site generator, so we want to be able to generate the files as we deploy, without to have to commit the entire result in our repository.
The only way for Heroku to generate the files on deploy, is to use the `assets:precompile` asset pipeline, via a
[Rake](https://github.com/ruby/rake) task. This was originally used for Rails app, but will come handy for our particular use.

Create a `Rakefile` at the root of the project and add it the following.

```ruby
require 'bundler/setup'

namespace :assets do
  task :precompile do
    # Build Slate/Middleman documentation
    sh 'bundle exec middleman build --clean'
  end
end
```

Now our documentation will be build every time the code is pushed on Heroku.

## Serving files {#serving}

We will be using a Rack app to serve the HTML files on the server, as it is a relatively painless to implement and configure. Rack must know which files
it should serve as static assets, so for that, we will need to create a `config.ru` file.

```ruby
use Rack::Static,
    :urls => ['/docs'],
    :root => 'docs',
    :index => 'index.html'

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('docs/index.html', File::RDONLY)
  ]
}
```

You can use the [Puma](https://puma.io/) web server to tied all of this together, it's a performant web server that plays nice whith Rack.
Add a `Procfile` to the project and insert the gem `gem 'puma'` in the Gemfile.

```ruby
web: bundle exec puma -p $PORT
```

## Customizing the Middleman build configuration {#customizing}

Middleman `source` and `build` directory can be customized to your needs, you will have to edit the configuration file `config.rb`.

**Changing the source files directory:**

```ruby
set :source, "#{File.dirname(__FILE__)}/my_source_dir"
```

**Changing the build directory:**

```ruby
set :build_dir, "#{File.dirname(__FILE__)}/my_build_dir"
```
