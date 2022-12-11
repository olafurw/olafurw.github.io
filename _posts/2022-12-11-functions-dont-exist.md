---
layout: post
title: Blogvent 11 - Functions don't exist
tags: [programming, learning, c++, blogvent]
comments: false
---

Um, actually, they do!

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## What?

I've been in an odd mood recently, so with moods like that come odd thoughts.

Of course functions are a thing, even if we only think of them conceptually. Sure within a language they are a concrete thing, they have a boundary, they most likely have input and output. There is no denying that.

When going into the assembly level, functions don't exist as much, not as clearly as they do in higher level languages. They exist by convention. You need to behave in a certain way and then the idea of a function exists.

This feels off.

## Good behavior

Why do I have to behave in a certain way for something that is very much concrete to exist? Is it to fall in line with others around me? What if I don't want to fall in line.

But this is just a function you're talking about. You're putting arguments on the stack, setting up the stack frame and off you go, there isn't much else.

Return values? They need to be given to a certain register. Again by convention. But what if I just write my return value somewhere.

## That's just a global

Sure, but I'm talking about convention. But I could write a system where, by convention, each function has dedicated space in memory where it would write it's return value. And no I'm not talking about a pointer to the heap, I'm saying for function F, the return value is always at address N.

## Why?

No reason. It's just what's been going through my head today.