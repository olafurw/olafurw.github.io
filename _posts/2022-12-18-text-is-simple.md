---
layout: post
title: Blogvent 18 - Text is simple!
tags: [programming, blogvent]
comments: false
---

It's just an array of numbers, right?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Text is text

I remember when I first learned how basic text is implemented in computers. I thought it was an ugly hack.

> It's an array of numbers from 0 to 127

I love good jokes, this is one of them really good jokes right? But apparently no.

Text should be so much more complex, even just looking at Europe, text needs to contain so many different characters.

## Extended extensions

I still remember by heart the code Iceland uses for their character encoding. ISO-8859-1. We need our `ÁÉÝÚÍÓ` but you can't also forget the classic `ÞÆÐÖ`, here is where the extended ascii comes along, using the rest of the `unsigned char` space to it's full 255 size.

Fun fact, if you see a lowercase `ÿ` somewhere, you can almost use it as a signifier that something has gone wrong. Because it has the ascii value of `255` and it's from French and so uncommon that even wikipedia calls it "the very rare ÿ".

## Strings

Then with languages like C and C++, these bits of text are stored as strings, usually with a `\0` at the end to signify the end. In both languages you can write them as `"hello world"` and they will most likely be stored in the `.text` section of your binary.

But if you need your bits of text to be more dynamic, you could store them on the heap.

## Mutable?

I also remember when I learned this for the first time.

> When you modify a string, you generally don't change it but make a brand new one and throw away the old.

This feels so wasteful, but here we are.

You want your bit of text to take only the space it needs, and if you are modifying text, you are most likely either expanding or shrinking it, so you sacrifice some CPU cycles for this hopefully one time transaction.

## Unicode

Then we need to transition to a more civilized age. These ISO extensions aren't going to work in the long run, not even slightly. So we need to support Unicode, and the can of worms this opens is incredible.

I'm not nearly smart enough to describe this so I will point you to a very smart person and recommend [this talk](https://www.youtube.com/watch?v=BdUipluIf1E) by JeanHeyd Meneide, I also recommend [their blog](https://thephd.dev/), go read.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1604521780764344321) or [Mastodon](https://mastodon.social/@olafurw/109535742806834126)