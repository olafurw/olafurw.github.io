---
layout: post
title: Blogvent 23 - Low friction matters
tags: [programming, blogvent]
comments: false
---

What's in your way?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Time

> I didn't have time to write you a short letter, so I wrote you a long one. - Mark Twain.

The longer I've been a programmer, the more I'm convinced that one of the most important aspects of programming is time.

Sure time in execution matters, you don't want things to take forever, but development time as well. And there is one aspect of development time that I've really come to dislike when it's done badly.

Iteration time.

## Iteration

And iteration can mean multiple things, but the definition of what I'm thinking about looks something like this.

> How long does it take from the time you've stopped typing until you see your change?

I've asked people a question like this in the past and it's a fascinating thing, because depending on your industry there can be a factor of 10 difference, and then if you ask if they think they're fast, they'll usually say yes.

I've worked in the web world where when you hit `ctrl+s` and the other screen flashes because it just updated the website you're working on. And I've also worked in the gaming industry where changing a certain application meant that you had to wait for an hour for a build to actually try it out.

Then I heard a story that the daily build of Windows takes more than a day. Fun stuff.

## But...

So those were examples of full iteration, from a change to the actual end product that could be sent to live users. Usually the day to day iteration time is much faster. Even on that gaming project the normal iteration time was in minutes. But that's still slow in my eyes.

To change a function and have to wait 3-5 minutes until you realize that you forgot this one small change and have to wait another 3-5 minutes. The web person would get this feedback immediately and have saved 10 minutes right away. That's a nice coffee break and some lightsaber fights.

## Build systems

It always comes back to build systems right? Oh poor C++, who did this to you.

A few days ago I did the YouTube sponsored content database parsing in Rust, and I was so relived that I didn't have to think about libraries or dependencies. I just added the thing into the `.toml` file and ran `cargo build`.

C++ has been improving with things like Conan and vcpkg, but those are still points of friction. They aren't naturally embedded with the language itself.

I actually wouldn't be mad if installing `clang` would also install `conan` or if setting up your Visual Studio environment would also install `vcpkg` (or the other way around, both systems support most operating systems and compilers).

It's just this idea of starting a quick C++ project, it still gives me a feeling of dread. This "oh no, then I need to setup CMake and vcpkg and and and..."

I just don't want this friction to exist.