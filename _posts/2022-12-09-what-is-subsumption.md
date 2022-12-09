---
layout: post
title: Blogvent 9 - What is Subsumption?
tags: [programming, learning, c++, blogvent]
comments: false
---

It should be simple, right?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

This word was tossed around a lot recently in the C++ world and there are a lot of really nice technical explanations out there but I am a bear of very little brain, so this is how I've been thinking about it.

## Concepts

Subsumption is an idea used with C++ concepts to handle a certain scenario. What if you have multiple functions, all with the same name, all using different concepts and you could technically use any of them.

**Which one do you pick?**

You can kind of think of it as function overload resolution, but with concepts.

## Example

So the classic example is to use integers, so let's do that. There is a bit of overlap with these concepts that I'm using but they are more illustrative.

```cpp
#include <type_traits>

// For any kind of numeric value
// this will match integers, floats, enums, pointers, etc
template<typename T>
concept Number = std::is_scalar<T>::value;

// Here we say an integer is a number AND an integer
// We technically only need std::is_integral but it's fine
// as a mental model that I'll go into below.
template<typename T>
concept Integer = Number<T> && std::is_integral<T>::value;

// Here an unsigned integer is an Integer and unsigned.
// Good so far.
template<typename T>
concept UnsignedInteger = Integer<T> && std::is_unsigned<T>::value;
```

Think of 3 concepts as overlapping circles. The set of numbers is bigger than the set of integers which is bigger than the set of unsigned integers.

Then we use those concepts in three functions.

```cpp
int do_work(Number auto value) { return 2; }
int do_work(Integer auto value) { return 5; }
int do_work(UnsignedInteger auto value) { return 7; }
```

So based on what we give the function, we will return a different prime number.

Then we use it like this.

```cpp
int main()
{
    int result = 0;
    result += do_work(&result); // Number
    result += do_work(0); // Integer
    result += do_work(0U); // UnsignedInteger

    return result;
}
```

And we get the result of 14, as expected.

But here's where Subsumption comes in. Technically `0U` is an integer, and it's also a number. Why wasn't that picked? How do we resolve this?

## The mental model

Think back to the circles. When picking a function, out of all the ones that technically work, pick the "smallest" one. **The one that narrows the universe of posibilities the most.** For `0U` the smallest set of possible inputs is `UnsignedInteger` so that one is picked.

Of course there might be "it depends" and other caveats to this, this is C++ after all. But I've found that this kind of mental model matches most of the functionality.

This also applies to when the concepts are being joined together using `||`, because using `or` expands the universe of posibilities. So you can think of it as the inverse, pick the one the one that has the "fewest" `||`.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1601223127736160258) or [Mastodon](https://mastodon.social/@olafurw/109484200906506328)
