---
layout: post
title: Blogvent 15 - Javascript Destructors
tags: [programming, javascript, blogvent]
comments: false
---

By convention.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Destructor

Originally, this was a very C++ topic. Lifetime management in C++ is done by a feature called `RAII` (I call it Ray), it's actual meaning doesn't matter since it's very bad and in my opinion harmful to new programmers.

The best example of `RAII` is what I call a noisy class. A class that prints out to the console every time it enters any function. Here's an example.

```cpp
#include <iostream>

struct Noisy
{
    // Constructor, called when we create the class
    Noisy()
    {
        std::cout << "Noisy()\n";
    }

    // Destructor, called when we're no longer using the class
    ~Noisy()
    {
        std::cout << "~Noisy()\n";
    }
};

int main()
{
    std::cout << "main() starts\n";

    Noisy n;

    std::cout << "main() is ending\n";
}
```

And this prints out the following

```
main() starts
Noisy()
main() is ending
~Noisy()
```

The thing that might trip up new programmers is that the `~Noisy()` destructor call happens *after* the main function has ended. This is used to release any kind of resource, close files, free memory, etc. Or as is often taught in modern C++ classes, the destructor does nothing because all of the members are standard types that have destructors already defined for you [(rule of zero)](https://en.cppreference.com/w/cpp/language/rule_of_three).

If you wanna practice this kind of stuff, I recommend the [Object Lifetime Puzzler](https://leanpub.com/objectlifetimepuzzlers_book1) books by [Jason Turner.](https://twitter.com/lefticus)

## Javascript?

So Javascript the language does not have destructors, you have to release your resources yourselves. But this can be problematic when forgotten.

What is important is that it's hard to forget to do it, that the definition of the destruction is happening at an important part, hopefully near the construction.

This is what many modern web libraries are doing. You create custom components. Small isolated bits of your site that can then be reused. Anything from a button to complicated user profile (which is then made out of smaller components).

Those libraries realized long time ago that performing some actions at the start is important (construction) and then you might need to release those resources afterwards (destruction).

In Javascript land they usually call this "a lifecycle". Many libraries have this but here's an example in [Svelte.](https://svelte.dev/)

```javascript
import { onMount } from 'svelte';

onMount(() => {
    // any code here is executed at the start
    console.log('constructor');

    // then at the end, this function is executed
    return () => {
        console.log('destructor');
    }
});
```

Here we have a function from `Svelte` called `onMount`. This function is given another function to execute. When the component has been drawn for the first time this function is called. Notice that the return value of this function is another function (how functional). This function is called when the component is removed, usually by browsing away or when the component is replaced with something else.

This is the same behavior, but not through the language, but by convention. And it's right next to the construction part of the code, which means that the chance of forgetting to release your resource is reduced.