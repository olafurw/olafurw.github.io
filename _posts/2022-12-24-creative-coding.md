---
layout: post
title: Blogvent 24 - Creative Coding
tags: [programming, blogvent]
comments: false
---

Limitless.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Creative Coding

Art and programming mix very well. Some say too well (for bad or good). Using programming to create works of art has been a thing we have done ever since we were able to visualize software output.

Here's John Whitney setting up a film camera to capture an animation frame during his art residency at IBM in the 60s.

![art1](/img/art1.png "person sitting in front of a computer screen with circular spiral art on the screen and big camera equipment on the left")

## Tools

There are so many tools out there that can help you in creating your next art project. The one that I've been playing with recently is called [Nannou](https://github.com/nannou-org/nannou), which is a Rust library that focuses on being a Creative Coding framework. It can act as a simple canvas for your sketches or allow you to create full applications with a variety of interactions.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Inspired by magnetic fields, but quickly diverged into it&#39;s own form. <a href="https://twitter.com/hashtag/nannou?src=hash&amp;ref_src=twsrc%5Etfw">#nannou</a> <a href="https://twitter.com/hashtag/generative?src=hash&amp;ref_src=twsrc%5Etfw">#generative</a> <a href="https://twitter.com/hashtag/generativeart?src=hash&amp;ref_src=twsrc%5Etfw">#generativeart</a> <a href="https://t.co/fMubhO2jaF">pic.twitter.com/fMubhO2jaF</a></p>&mdash; Eric Dauenhauer (@ericydauenhauer) <a href="https://twitter.com/ericydauenhauer/status/1243420670937010182?ref_src=twsrc%5Etfw">March 27, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

I used Nannou myself recently when I wanted to learn more about Rust and resurrect an older project of mine.

## Pokémon

![art2](/img/art2.gif "person sitting in front of a computer screen with circular spiral art on the screen and big camera equipment on the left")

Each pixel in that animation is a "Pokémon" and it looks to it's neighbouring pixels and tries to find the weakest one, then it attacks and if that Pokémon dies, it becomes the same type as the attacker.

Which means you'll get these waves or cells of colors that engulph an area only to be overtaken by another wave of Pokémon.

My favorite memory of creating this was when I tweeted about it and someone replied that it reminded them of Neutron Clustering and linked to a [paper they wrote in statistical mechanics.](https://arxiv.org/abs/2203.00540)

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">The dynamics of this system is similar to the models of neutron clustering with mass conservation that we studied in <a href="https://t.co/TgSla6TOH7">https://t.co/TgSla6TOH7</a>! Can we say anything about the fixation time in this context? <a href="https://t.co/EMMiDYq2a6">https://t.co/EMMiDYq2a6</a></p>&mdash; Davide Mancusi (@arek_fu) <a href="https://twitter.com/arek_fu/status/1522502883417145345?ref_src=twsrc%5Etfw">May 6, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1606600600522833923) or [Mastodon](https://mastodon.social/@olafurw/109568223782973816)