---
layout: post
title: Blogvent 12 - Tool recommendations
tags: [programming, blogvent]
comments: false
---

Two thumbs up for this one.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

I haven't done a tool recommendation before here so lets do one.

## Act

[Act](https://github.com/nektos/act) is a tool that allows you to run your GitHub Actions locally. It's very helpful not only as a testing tool but the main benefit I've seen from it is to speed up your iteration time.

My main problem with GitHub actions was that I was editing a `yml` file and then having to wait for some running to stop executing or fail and then try again. Tools that speed up your iteration loop are a godsend and `act` is definitely one of them.

It's not without flaws though. It sets up a docker image that is supposed to match what is running in actions but I've seen comments that it's not perfect. It does not support [Services on GitHub](https://github.com/nektos/act/issues/173) but it's being worked on. And if you rely on GitHub Actions to cache previously run output then you have to do something locally for that because that does not work with `act` out of the box.

But otherwise it's great, I'd recommend looking at it.