---
layout: post
title: Blogvent 16 - Cache locality - What is that?
tags: [programming, blogvent]
comments: false
---

It's right there!

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

Computers are fast. Like really fast. Like they go zoom zoom... or something. But if computers are so fast, then why do we care about caches and all that stuff?

## Are computers really fast?

Well, like with everything, it depends. We usually say that a computer is fast when processing the information it has, but what if it doesn't have the information? What if there is no relevant data in the registers?

It all has to come from somewhere.

So let's just fetch it from memory, right? Again I don't see the problem.

## Is memory fast?

Generally? Yes, memory is very fast.

Relative to a CPU's processing needs? Memory is actually pretty slow.

And that's the core of the problem. Reading a big block of data from RAM is pretty fast, but we usually process a few bytes at a time.

If you were to implement a very basic computer from scratch, you'd have some sort of adding mechanism, some sort of storage for those two numbers you want to add together and a mechanism to fetch data.

If you are testing the system in a vacuum, it works fine, you fetch the data, add the numbers and you're done. But it's when you start to use it over and over again with actual input when you start seeing the issue.

You'll see that the bottleneck is not the adding, it's the constant fetching of the data.

## Latency

There's an [excellent post](http://norvig.com/21-days.html#answers) by Peter Norvig from 2001 where he gives approximate timings for various computer operations. These are in nanoseconds but a ["humanized" version](https://gist.github.com/hellerbarde/2843375) was posted on github some time ago that compares these actions.

If fetching the data from the L1 cache would take 0.5 seconds (0.5 nanoseconds in actuality) then referencing to a value from the main memory would take 100 seconds.

## So what do we do?

For experienced programmers this is a pretty simple answer but if you're new to the field, this might sound weird.

We assume.

If we are reading data from some specific point in memory, we assume that the next thing you are going to read is somewhere nearby. This is **cache locality**. We'll fetch the value and cache the stuff around it.

This means that working with contiguous memory is very fast and if we aren't, then we would have fetched some extra bytes unnecessarily, but that's ok... kinda.

tl;dr `std::vector` good `std::list` bad.