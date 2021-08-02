---
excerpt_separator: <!--readmore-->
layout: post
title: 'Introducing first draft of the Styleguide'
published_at: 2016-01-19T18:08:00+00:00
categories: [blog related, css]
permalink: /:title/
author: jveillet
---

A new section is up in the Menu: [The Styleduide]({{ 'styleguide' | absolute_url }})!

## A Styleguide to rule them all

When you work in a team, it's always great to have a common place to share the visual aspect and design of a project. The difficulty here is getting a common resource for all the visual elements of the website, and provide guidance on how to implement them, so that everything looks consistent on every page, without sacrificing people creativity. It should help implementing modularity, so that updating a component does not cause a shitstorm in your application.

<!--readmore-->

There is a lot of techniques and  methodologies this days to help you achieve that goal, to name a few [BEM](https://en.bem.info/), [ITCSS](https://www.youtube.com/watch?v=1OKZOV-iLj4&feature=youtu.be), [OOCSS](http://oocss.org/), [SMACSS](https://smacss.com/), you can also read the great Brad Frost's book about [Atomic Design](https://shop.bradfrost.com/), which was a great inspiration.

## How ?

Demain·il·pleut has been build around that philosophy. I designed everything in the browser, most of the CSS and HTML markup is done by hand. I didn't use tools, frameworks, or library (at the exception of jQuery and [PrismJS](https://prismjs.com/)) because I thought that for a small project like this one, they would get in the way.

Here is an overview of the approach I took:

- Every element on the page use CSS classes, using a BEM-like naming, I choose to name the components like `Component-Element--Modifier`.
- Very simple HTML markup.
- I use CSS Ids only for JS hooks.
- Only one CSS file of 14kb (10kb minified).
- For now, I use [Gulp](https://gulpjs.com/) to minify the CSS.
- Flexbox has a [browser compatibility of 95%](https://caniuse.com/#feat=flexbox) (as this time), that's great, so I had a little fun with it and used it to display the colors of the Styleguide.

## Feedback welcome

Designing for the web is cool, what is even cooler is doing it on the open, the code behind demain·il·pleut is already on [Github](https://github.com/jveillet/jk-demainilpleut), and sharing the Styleguide could help getting feedback. By publishing it, that's already a great experience.

## What's next ?

- Code snippets under each component.
- Table of contents.
- Code refactoring.
- Better layout.
- Getting rid of jQuery (in favor of Vanilla JS).
- Automate things.
