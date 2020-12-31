---
layout: post
title: Everything is a rotate
tags: [programming, c++, learning]
comments: false
---

And I can "totally" prove it in this very serious blog post about algorithms.

# What?

"That's a rotate" has been a meme in the C++ community for a few years now. It originated from [Sean Parent](https://twitter.com/seanparent) in his 2013 GoingNative talk ["C++ Seasoning"](https://www.youtube.com/watch?v=W2tWOdzgXHA). The talk is excellent and I highly recommend watching the whole thing.

The meme comes from the initial surprise that a relatively complex bit of code could be reduced to a few standard algorithm function calls, especially std::rotate. It also helps that Sean and others repeated the quote [a few times](https://www.youtube.com/watch?v=UZmeDQL4LaE).

So the meme then turned into ["Some bit of code? That's a rotate"](https://youtu.be/HlzYbjjtMBI?t=203)

# Algorithms

But Sean's talk is highlighting an important point. There is a great benefit in knowing what STL algorithms are out there and when they can be applied to the problem you are trying to solve. There have even been several talks at C++ conferences that are reinforcing this idea. **Know your toolset.**

- ["Better Algorithm Intuition"](https://www.youtube.com/watch?v=TSZzvo4htTQ) by [Conor Hoekstra](https://twitter.com/code_report)
- ["105 STL Algorithms in Less Than an Hour"](https://www.youtube.com/watch?v=2olsGf6JIkU) by [Jonathan Boccara](https://twitter.com/joboccara)

Just to name a few.

# Rotate

Why this fascination with std::rotate? Even when researching this blog post, I saw multiple YouTube and Reddit comments talking about not understanding what rotate does (and some stating that sarcastically).

So what does std::rotate do? Someone that is not experienced in C++ might equate rotate with flip or reverse. You're taking a collection of elements and "rotating" them? Right?

I can answer that with another C++ meme. **It depends.**

Cppreference describes [std::rotate](https://en.cppreference.com/w/cpp/algorithm/rotate) as "Performs a left rotation on a range of elements.", which helps a bit. But I always like looking at examples.

```cpp
#include <vector>
#include <algorithm>
#include <iostream>

int main()
{
    std::vector<int> items{ 4, 5, 1, 2, 3 };
    std::rotate(
        items.begin(), // start
        items.begin() + 2, // end
        items.end() // where to place start
    );

    // 1 2 3 4 5
    for (const auto i : items)
    {
        std::cout << i << ' ';
    }
}
```

[Compiler Explorer](https://godbolt.org/z/dP86TT)

Here we have the values 4 and 5 at the start and we "rotate" them to the end of the vector. "But wait" you might ask, "That didn't rotate the values to the left like the cppreference quote said". And I would agree with you. Which is why the second description of the algorithm is better, but a bit "math-y"

> template< class ForwardIt >    
> void rotate( ForwardIt first, ForwardIt n_first, ForwardIt last );
> 
> std::rotate swaps the elements in the range [first, last) in such a way that the element n_first becomes the first element of the new range and n_first - 1 becomes the last element.

My mental picture of rotate is **rotate takes a range within a container and puts it somewhere else**. It's a move, relocate, transfer or even shift if that helps.

# Let us obsess

There's a sentence in the std::rotate cppreference page that I like.

> std::rotate is a common building block in many algorithms.

Ok, let's have fun here. What can we implement using std::rotate?

## swap

Here we can take 2 values and swap them with each other using rotate. You can see that I'm not being serious, but when thinking about rotate you start to think about the edge cases. What is a rotate with 1 element? What is a rotate with 2 elements? When you place the range between the two elements, it's an overengineered swap.

```cpp
template<class T>
void swap(T& a, T& b)
{
    std::array<T, 2> items{a, b};
    std::rotate(
        items.begin(), 
        items.begin() + 1, 
        items.end()
    );

    a = items[0];
    b = items[1];
}
```

[Compiler Explorer](https://godbolt.org/z/rfa64r)

## for_each

The mighty for_each, see how easily std::rotate tackles this fundamental problem. Again, a silly example but there is a common behavior here. Performing some work on the first element, and then moving it to the back. Silly in a vector where you can just address each item with an index but in other data structures this is the norm.

```cpp
template<class InputIt, class UnaryFunction>
constexpr UnaryFunction for_each(InputIt first, InputIt last, UnaryFunction f)
{
    std::vector<typename InputIt::value_type> items(first, last);
    std::size_t counter = 0;

    do
    {
        f(*items.begin());

        std::rotate(
            items.begin(),
            items.begin() + 1,
            items.end()
        );

        counter++;
    }
    while(counter < items.size());
    
    return f;
}
```

## Playing with your tools

**Law of the instrument** states *"I suppose it is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail."*

While true, I feel this mainly applies when you have only one tool. What I'm trying to focus on here is that you need to explore your tools, treat them like a hammer for a few moments. Make **everything** a nail. But **only** do so to learn more about the tools that are available.

Make mistakes. Write silly code. Laugh at that silly code and grow as a developer.

## Joining the fun

While I was writing out this blog post [I tweeted](https://twitter.com/olafurw/status/1343640006863237121) about std::rotate and Mariia Kornieva mentioned that Conor Hoekstra had talked about std::rotate in his podcast ["ADSP: The Podcast"](https://twitter.com/adspthepodcast) (check it out, it's very nerdy and very fun)

> As mentioned in the latest episode of the @adspthepodcast by @code_report std::rotate is implementable with three std::reverse. Can we conclude that everything is a std::reverse? - [Mariia Kornieva](https://twitter.com/mariia_kornieva/status/1343659760189644802)

I love this. So of course the next question is. *"Can std::reverse be implemented with something else?"*

So Conor joined in on the fun.

> std::reverse is just a std::tranform with reverse iterators and the identity function https://godbolt.org/z/P1xTGv - [Conor Hoekstra](https://twitter.com/code_report/status/1343666691235065859)

What a wonderfully simple solution, I would have never thought about using std::transform with the identity function. But here comes the cherry on top.

It doesn't work.

Conor replied a few hours later.

> Sad news (and I thought this was the case but failed to verify) ... old code was broken and this doesn't actually work https://godbolt.org/z/n7TexY - [Conor Hoekstra](https://twitter.com/code_report/status/1343750196409344000)

This made me so happy to see. Why? **It checks all the boxes I mention above.**

Playing with your tools. Writing silly code and then growing as a developer. (Not sure if he laughed at the mistake, but in my imagination he did)

It might not be much, but it's this kind of attitude that matters. There's a lot of perfectionism that gets associated with programming. Especially when you get to a certain skill level. And don't get me wrong when you are doing work, something that you put in front of users, then yes that matters.

But practice is very important. It's how you grow. So create an environment where you can make mistakes. Create an environment that forces you to think differently.

You'll never know what it might teach you.