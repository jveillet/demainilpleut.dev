---
layout: post
title: 'Adventures with static site generators'
published_at: 2022-12-30T16:00:00+00:00
tags: [ruby, javascript, static files]
category: blog
permalink: /:title/
author: jveillet
summary: 'My exploration of various static site generators and the frustrations involved.'
---

This website has gotten many shapes and forms, in both contents and design. I've started from a custom PHP CMS (good ol' PHP3 era), and went to the WordPress bandwagon, and then back to a custom hand made version.

When I went back to own my own code and content, I decided that having a CMS or blog engine wasn't worth the effort. I looked at static websites generators (SSG), and made the choice of using Jekyll. I was a lot into Ruby code at the time, and it seemed like the right tool for the job.

The promises were great: you spit some markdown text files, and your pages are build for you, no backend needed. One of the strongest argument of SSGs, is that it is very portable. Put your Markdown files on another static site generator, and voilà, your content is build in beautiful HTML pages.

One day, I decided that Jekyll wasn't doing it anymore for me. I needed more capabilities, more things integrated from the get go. I didn't want to use too much plugins. So my journey of changing tools started that way.

Oh boy did I had a bad time..

First things first, this article is not a full blown comparative between SSGs. it is not a critic either. These tools are Open Source, they are maintained (for free) by the community. This is one of the hardest but beautiful work ❤️.

My needs are quite simple, I have a small list of posts, some tags and categories. I want an organized archive page, and an author page. I also have custom CSS styles and a little bit of JavaScript but nothing spectacular.

I have tested a lot of of SSGs, Jekyll (Ruby), Zola (Rust), Cobalt (Rust), Hugo (Golang), Eleventy (Javascript), Bridgetown (Ruby, the engine of this very website). While this tools have many good advantages, they also come with some quirks.

## Portability

I said before that Markown posts are very portable, after all, it is text files with a special markup. As long has your engine knows how to compile Markown to HTML, you're good to go. I've come to realize that it is not true. Of all the SSGs available, you have to put in a header called the _Front Matter_. It is a small block of YAML containing metadata for your page, like a title, the author, the published date, tags, and so on. One of the frustrations I had with this, is that none of the SSGs uses the same properties. Some have `published_date`, other have `date`, and sometimes the date format isn't even the same. Worse, some properties are engine specific.

Don't let me start with internal linking. If you want to link between posts, or with other static pages, barely none handle it the same way. In theory, if the engine uses a common templating engine (like liquid), you can. Again it depends on what is the library used for this particular templating engine, the version, etc..

With all that, it is impossible to just migrate your markdown files **without** rewriting a part of it. So thumbs down for portability.

## Templating engines

Most of SSGs works with one or more templating engine (Liquid, Nunjuks, Mustache, Handlebars, HAML, Pug, etc..). I mean, choice is good, right?

Yes, choice is good, until it's not. If I want to switch SSG, I don't want to deal with rewriting my layout and components so it fits your tool. I already spend a lot of time doing that already. I know, I know, it's not necessary the fault of SSGs, and more a library problem, but as a user, it gives me headaches.

## Assets

At some point, we all need to bundle JavaScript and CSS files. Some projects uses Webpack, other ESBuild, or a home made bundler, or nothing at all. It's more a "me" problem, but I don't want to spend time playing with bundlers, nor I want to install a handfull of dependencies to compile and minify CSS/JS files. Luckily, most of SSGs comes with sane defaults, so it is a matter of putting your files in the right folder.

Frustration 101: Most of SSGs uses SASS, some plain CSS, and if you want to change that, you're force to dig in, install dependencies, and write custom code.

## Filters, tags and categories

Like I said, I have simple needs. I do need some filters, and custom collections from time to time. But even with that, if you go out a little outside what the documentations specifies, you have no choice but writing custom code, and you are on your own. Don't get me wrong, I don't want to throw rocks at SSGs for that. It's both a blessing and a curse of the technologies and programming language the engine is base on. It's a matter of choosing the language you are the most at ease with, and a tradeoff you have to accept.

## Breaking changes

Oh you're in a lot of troubles.

Aren't we all already with all the other tools we are using daily?

I strongly recommend that you be careful with API changes with the engine you choose. I know it's applicable generally
when using a third party library or framework, but even if you are aware of that, you will be caught off guard.

I know I should have known better, but I decided to use an engine that was pre version 1. I couldn't update my website for months, because if I did, I would have to make changes in my custom code to make it work.

## Dependencies

This rings with the Breaking changes part.

One thing that is really annoying, is to deal with dependencies. And it's even more true when we talk about JavaScript
dependencies (sorry JS fans). Like I said, I don't have much time, and I certainly have no time to loose on updating libraries, which happens.. a lot. You are always one click away for fucking up your site, because, well, we decided to change the API, deal with it 🙄️.

## Performances

Nothing special to say here. Unless you're a prolific writer that have more than 10.000 posts to generate, or a performance obsessed person. You will barely notice the difference of build times between SSGs. Of all the engines I tested, it went fast _enough_.

## Conclusion

**Q: If you are not satisfied with SSGs, why not build your own tool or use something else ?**

A: I thought a lot about it. I mean, I want to publish posts, plain and simple, I don't want to deal with maintaining
software, I have been already doing that for a living for 15 years, that's enough for me. I long for a tool that could go on for years without me touching it, and that is practical to use. For now, the cost ratio of building my own tool versus using an existing one isn't worth it. I prefer to spend the free time I have doing other things, even if I have to do maintenance work. But if it's scratching your own itch, do build your thing, it's an incredible learning experience.

**Q: So, it's not clear, what SSG do you recommend ?**

A: I don't recommend a particular one. All I wanted to highlight in this post was the tradeoff and quirks you can find in using a SSG, like I did. I am not a fan boy that will try to evangelize you to use this or that, I would recommend to choose one that uses a technology your at ease with. Or go nuts and learn a tool that is outside your comfort zone, your choice.
