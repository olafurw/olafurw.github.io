---
layout: post
title: Blogvent 10 - Self criticism
tags: [programming, learning, c++, blogvent]
comments: false
---

Be nice, and constructive.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Motivation

In [one of my recent posts](/2022-12-06-chatgpt-code-reviews/) I was playing with ChatGPT where I wanted to find old code of mine that wasn't great.

This got me thinking, is there more code in one of my old repositories I can look at with my current knowledge and give feedback to? I'm sure there is.

## Bejeweled

About 8 years ago I wrote a bot that plays Bejeweled, one of my favorite puzzle games. [It went well](https://www.youtube.com/watch?v=50n7qrRkAiQ), did it's job ok and then I moved on. Let's look at some of the code.

Here's a function that fetches the mouse position.

```cpp
void Window::get_mouse_position(const int x, const int y, int& outX, int& outY)
{
    RECT rect;
    GetWindowRect(m_window, &rect);

    POINT cursor;
    GetCursorPos(&cursor);

    outX = (rect.left + x) * static_cast<float>(65535.0f / GetSystemMetrics(SM_CXSCREEN));
    outY = (rect.top + y) * static_cast<float>(65535.0f / GetSystemMetrics(SM_CYSCREEN));
}
```

I have a few things to say here. The first two parts of calling `GetWindowRect` and `GetCursorPos` you can't do much with, maybe turn them into a function of their own but they're windows APIs and pretty simple so I'll leave them alone.

Next is the `const int x` and `const int y` arguments. I like the communication to the reader, those variables aren't supposed to change, that's the design, even though it doesn't mean much else (and it has no effect in the header file).

The `int& outX, int& outY` should be replaced with a return of a `std::pair` or even a `MousePosition` pod struct. The function doesn't even return anything, we have no idea if anything failed, if it can fail, a `std::optional<MousePosition>` or even `std::expected`.

Then the calculation that's happening, `65535.0f` is magic and should be named. What's actually going on in the function isn't very clear but it's converting from game coordinates to screen coordinates. This function is used to call `SendInput` later to perform the mouse movements.

## ML2048

I mention this project in one of the ChatGPT posts but here's a function I found that I think is funny.

```cpp
void grid::reset()
{
    for(int x = 0; x < grid_size; ++x)
    {
        for(int y = 0; y < grid_size; ++y)
        {
            m_grid[y][x] = 0;
        }
    }
}
```

What am I doing? Let's check what type `m_grid` is. 

```cpp
int m_grid[grid_size][grid_size];
```

Uhm ok, and what is the type of `grid_size`

```cpp
static const int grid_size = 4;
```

Yeah this is all over this project. I'm not sure why I did this, probably not thinking or not used to containers. Maybe this was a version of C++ where I couldn't do this but I'm not sure. I think it's inexperience, but the type should be replaced with `std::array` and the size should be `constexpr` and for the function itself, [that's easy.](https://godbolt.org/z/eqqG398Md)

```cpp
void grid::reset()
{
    m_grid = {};
}
```