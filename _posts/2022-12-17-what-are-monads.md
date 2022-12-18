---
layout: post
title: Blogvent 17 - What are monads?
tags: [programming, blogvent]
comments: false
---

Explain like I'm 5.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Very funny

*Monad is a monoid in the category of endofunctors*

Explaining monads has turned into this cultural joke within the circle of programmers. Most likely originating from [this post](http://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html) by James Iry which is poking fun at descriptions like this one from [Categories for the Working Mathematician](https://en.wikipedia.org/wiki/Categories_for_the_Working_Mathematician) by Saunders Mac Lane.

![monad1](/img/monad1.png "formally the definition of a monad is lik that of a monoid M in sets, as described in the introduction. The set M of elements of the monoid is replaced by the endofunctor, etc, etc")

This is probably a wonderful description for mathematicians or others that have brains that work well in this area, but the joke is still great.

## So what are monads?

Technically all of those books and descriptions are right, those are monoids, they are in the endofunctor category. But this isn't helping. As I mentioned in the [Subsumption post](/2022-12-09-what-is-subsumption/). I am a bear of very little brain, and I need this explained to me in nice and simple way.

## A foot in the door

One way of starting to grasp a concept is to look at the problem it solves. Why would I bring this tool with me?

Let's imagine that you need to do some work and this is the function you have. This is not any language, just some pseudocode.

```
Result DoSomeWork(/* some input data */)
{
    if (/* some error check */)
    {
        return;
    }

    Result res = /* some work */
    return res;
}
```

There is actually a problem with this style of programming. What do you return when you have the error? You could embed the error state in the `Result` type, you could use in/out variables and return `bool`...

...or you could wrap the `Result` type in something that can signal to the outside world what happened. Do we have a result or not?

So types like `std::optional`, `std::expected` in C++ can be thought of as "Monadic" but it's usually followed by saying that types like that should have a "Monadic interface", so what is that?

## Interface

If you would have this wrapper type (like `std::optional`), the most important part is that it behaves in a specific way and has certain functionality. Most importantly when being used as an argument into a function.

Because if you only had `std::optional` as a wrapper for your value, you'd be filling your codebase with conditional checks to see if you actually have a value or not. So in this [excellent proposal by Sy Brand](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p0798r6.html) which was accepted for C++23, this kind of interface was added to `std::optional`.

So if I use their motivating example, you go from:

```cpp
std::optional<image> get_cute_cat (const image& img) {
    auto cropped = crop_to_cat(img);
    if (!cropped) {
      return std::nullopt;
    }

    auto with_tie = add_bow_tie(*cropped);
    if (!with_tie) {
      return std::nullopt;
    }

    auto with_sparkles = make_eyes_sparkle(*with_tie);
    if (!with_sparkles) {
      return std::nullopt;
    }

    return add_rainbow(make_smaller(*with_sparkles));
}
```

to something like

```cpp
std::optional<image> get_cute_cat (const image& img) {
    return crop_to_cat(img)
           .and_then(add_bow_tie)
           .and_then(make_eyes_sparkle)
           .map(make_smaller)
           .map(add_rainbow);
}
```

Because the `crop_to_cat` function returns a `std::optional` which has a function called `and_then` that does the checks for you, etc, etc.

So to get your foot in the door with the idea of monads:

> A wrapper type that helps you call multiple functions one after another without the boilerplate of error checking.

Is there more too it? Sure, but this is fine for now.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1604188327707656193) or [Mastodon](https://mastodon.social/@olafurw/109530532279045545)