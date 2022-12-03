---
layout: post
title: Blogvent 3 - std::string_view and std::map
tags: [jokes, blogvent]
comments: false
---

A view of a map (or a view in a map?)

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

A thing you might have been told is that don't use `std::string_view` with associative containers. But why?

The short answer revolves around lifetimes. A view doesn't own the content it is viewing and containers are all about owning their stuff. So putting a `std::string_view` in a `std::vector` for example, the vector will technically own the view but whatever the view is... viewing might be gone.

It's pointers with extra steps.

## Map View

Let's take a look at this code example.

![map1](/img/map1.png "creating a map of string views and ints, storing two integers and then fetching them and adding them together")

[(CE link)](https://godbolt.org/z/o1T73xj97)

This might look like a straightforward example but there is a lot happening here.

We are creating two strings, but we are storing a view to them as the keys to the map and then when fetching them we are using `const char*` strings.

If we drag this example to C++ Insights, you'll see the absolute mayhem of conversions that is going on. Excuse the formatting of the image, I've tried my best to make it look presentable.

![map2](/img/map2.png "a very expanded construction of the code from above, a lot of explicit use of types, very long and pretty unreadable.")

[(Insights link)](https://cppinsights.io/s/e48dce92)

The use of the code above works, and will give you the correct result of 17 but it has problems. (a few problems but we might get into that later)

Here the issue lies with lifetimes. The lifetime of the string, the views and the map are the same, they're all in the same function. But what happens when we do this?

![map3](/img/map3.png "same code as the first one but now it's been refactored into a function and then the map is returned")

[(CE link)](https://godbolt.org/z/9qxT9dWhM)

The only thing I did was to move the creation of the map into a function and then return the function. Something that an automated refactoring tool might do. And now this doesn't work. Because the view is referencing a string that does not exist anymore. The version in Compiler Explorer will give you a result, but it's the wrong result.

("fun" fact, using [-O3 in GCC](https://godbolt.org/z/hqW85nvbG) will actually give you the right results, but it's most likely due to how simple the example is)

## Static View

So we can never use `std::string_view` in a map? The classic answer to that is "It depends." I would personally avoid it and not accept it in a code review but there is a version that works, but it has a rule you must follow at all times.

![map4](/img/map4.png "same code as the second one but now we use const char* strings instead of std::string")

[(CE link)](https://godbolt.org/z/eaT1ebe66)

Now those strings are stored in the binary and have the same lifetime as the application itself. Again, this will give you a correct results but I'd still personally avoid using string_views in map. One mistake of using the wrong string type and things will break.