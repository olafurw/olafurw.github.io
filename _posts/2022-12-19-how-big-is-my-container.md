---
layout: post
title: Blogvent 19 - How big is my container?
tags: [programming, c++, blogvent]
comments: false
---

Why ask? Just call .size()

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Data Size

In this blogpost, the size of `int` is 4 bytes. Seems reasonable, and on most systems this is a constant, but in the world of "it depends", we need to make stuff like that clear.

So if I have a `std::vector` of 4 `int` types, you would expect the size of the vector to be 4 elements that take up 16 bytes in total.

We can even confirm it with code snippets like this.

```cpp
#include <vector>
#include <iostream>

int main()
{
    std::cout << sizeof(int) << '\n'; // 4

    std::vector<int> data{ 1, 2, 3, 4 };
    std::cout << data.size() << '\n'; // 4

    return 0;
}
```

Great stuff, but how big is vector?

## Why does that matter?

So what is `std::vector` ? A classic implementation of a dynamic array would tell you:

> It's a pointer and a size

And in the world of programming, people like using precise language. So when they say pointer, they usually mean *'the size of a memory address on the machine it is being compiled on'*, but what does it mean when someone says 'size'.

## Again, I'm confused.

If you're new to this world of programming and would start by implementing a dynamic array like this, then you might have problems.

```cpp
template<typename T>
struct DynamicArray
{
    T* data;
    int size;

    // ... more stuff
}
```

(btw, there's also capacity, but for this discussion it doesn't matter much)

In that implementation, size is an `int`, which is a signed type, so it can be negative. What does it mean when your dynamic array has negative size? Ok let's fix it?

```cpp
template<typename T>
struct DynamicArray
{
    T* data;
    unsigned int size;

    // ... more stuff
}
```

You're still in trouble, technically... kinda. Because if you compile this on a 64 bit system, the size of your array can *only* hold 4.294.967.295 values. How awful... this isn't usable.

## Ok. How do I fix it?

Well, you can't change it to be a 64 bit value, because then you'll have the inverse issue on 32 bit systems. So what do you do?

This is where `std::size` comes in, and why C++ programmers often say that a vector has a pointer and a size. Here is a definition of `std::size`

> std::size_t can store the maximum size of a theoretically possible object of any type (including array).

How this is done depends on the implementation, but you can usually think of it as 32bit on 32 bit system and 64 on 64. Seems good.

But `std::size` is it's own type, so you might see errors or warnings when you do stuff like this.

```cpp
#include <vector>

int main()
{
    unsigned int cakes = 5;
    std::vector<int> bakery{ 1, 2, 3, 4 };

    unsigned int food = cakes + bakery.size();

    return food;
}
```

Here, a compiler with the `-Wconversion` flag will give you an error

```
<source>: In function 'int main()':
<source>:8:31: warning: conversion from 'std::vector<int>::size_type' 
{aka 'long unsigned int'} to 'unsigned int' may change value [-Wconversion]
    8 |     unsigned int food = cakes + bakery.size();
      |                         ~~~~~~^~~~~~~~~~~~~~~
```

So be careful when you're comparing apples to oranges. 

PS. I still recommend the `-Wconversion` flag, it will find all sorts of fun issues in your codebase.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1604925376492347397) or [Mastodon](https://mastodon.social/@olafurw/109542048831169443)