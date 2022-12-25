---
layout: post
title: Blogvent 25 - Early Exit
tags: [programming, blogvent]
comments: false
---

We're leaving!

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Go Go!

Some of you thought that I would only go until the 24th, since that's the time advent ends, but no, I say here in the little blurb above and in the main blog post that I'm going all of december. So let's continue!

## The Great Pyramids

Have you ever seen code like this?

```cpp
#include <vector>

int calc(int value);

int do_work(const std::vector<int>& data)
{
    int result = 0;

    if (data.size() > 0)
    {
        for (const auto& value : data)
        {
            if (value > 0)
            {
                result = calc(value);
                if (result > 0)
                {
                    // ... etc
                }
            }
        }
    }

    return result;
}
```

I love code examples like this. I used to program this way, and I think this feels natural to someone relatively new to programming. Why? Because this is how you think before you're infected with "programmer brain".

"Ok we need to do work with the data vector, first we need some values in our data vector, so we need to check if the size is bigger than zero. Then we need to loop through every element in the data vector. Then for every single element we're only allowed to work with elements bigger than zero and then call the calculate function, if the results of the calculate function are not zero, we can ..."

## Positive thinking.

> What do I need to check before I can continue.

This kind of programming mentality is what I call "positive programming" and it gives you these great pyramid looking functions. The issue with positive programming is that when reading the function again later, you usually need to consider the entire function.

Let's take for example the condition "if the vector is empty". The highlighted areas of the function are the ones you need to think about, because they will be executed if the vector is empty.

![exit1](/img/exit1.png "same bit of code as above but the first and last line are highlighted pink")

Consider this small change to the function.

![exit2](/img/exit2.png "basically the same function but with an early exit at the top that returns 0, also an early continue in the loop")

Now when you encounter the function and you're only interested in the empty case you don't actually care then what the rest of the function does. You don't care how long it is, you don't care what kind of algorithm is being used, you don't need to read anything. You just spot the early exit and move on.

This is what I sometimes call a "bouncer". Like at a club. You're not allowed into the function unless you match these conditions.

Same thing applies in the opposite case. You now know that anything below that pink area is guaranteed to have a vector that contains data.

Creating these walls I feel really help with the mental load of reading code. You don't have to every time read the entire function or look at where conditions start and stop. You look for the bouncer and know that here is where the line is drawn.