---
layout: post
title: strftime and fixed size buffers
tags: [c++, time, rant]
comments: false
---

Implementing Last-Modified to all HTTP 200 responses.

Was not happy with how I had to setup a fixed size buffer to give to std::strftime, in this case I was able to set all values to their fixed size counterpart.

The string looks like "Last-Modified: Fri, 16 Nov 2018 12:34:56 GMT" which is "%a, %d %b %Y %H:%M:%S %Z"

If I set %Z to be 3 characters for GMT (longest one is 5, for example CHADT for Chatham Islands) the total max length the string can be is 29. I set it to 32 because it's just so close and a much nicer number, also I can create some excuses like "But what about \0 or longer %Z zone names"

```cpp
const auto now = std::time(nullptr);

char buf[32];
std::strftime(
    buf, 
    sizeof(buf), 
    "%a, %d %b %Y %H:%M:%S %Z",
    std::gmtime(&now)
);
```

But why isn't there a nice C++11/14/17 thing where I can give it the format and get a string back?

```cpp
const auto formatted = std::time_to_string(
    now, 
    "%a, %d %b %Y %H:%M:%S %Z"
);
```

If I want the control I can fall back to but in 99% of the cases I just want the formatted text of the time_t I'm giving it.