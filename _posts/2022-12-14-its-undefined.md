---
layout: post
title: Blogvent 14 - It's undefined
tags: [programming, blogvent]
comments: false
---

Or is it null?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Specific behavior

C++ has this concept of [Undefined Behavior.](https://en.cppreference.com/w/cpp/language/ub) It's often touted as the wild west, the land of the unknown, here be dragons, we will uninstall your hard drive, etc, etc.

What it is in actuality isn't that strange. Undefined Behavior is when the standard doesn't specify what should happen in certain cases, so it's up to the compiler writers to do whatever they think is best, either logically or from a performance point of view.

## Other defines

Javascript has something called `undefined` as well. It's not even remotely related to C++'s undefined but it's fun to think about. JS programmers usually compare `undefined` with `null`.

So what's the difference?

## Javascript

Both signify the absence of value. "It's nothing", but I feel this is the key difference.

- `null` is intentional indication of no value
- `undefined` is indication of no value (intentional or not)

Usually, when you get a `null`, someone put that there. Someone returned `null` or assigned a `null` to a variable.

`undefined` can happen in more ways, either deliberate by assigning `undefined` to a variable or by not returning a value from a function and assigning that value to a variable.

```js
function f(){}

const value = f();
console.log(value); // undefined
```

Fun fact, `undefined` is actually a variable while `null` is a value.    
This means you can assign values to `undefined`

```js
() => {
  const undefined = null;
  console.log(undefined); // null
}();
```

But I don't recommend doing this... obviously.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1603122285954547713) or [Mastodon](https://mastodon.social/@olafurw/109513875436602167)