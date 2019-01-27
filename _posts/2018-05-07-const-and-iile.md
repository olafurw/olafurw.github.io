---
layout: post
title: const and ILLE
tags: [c++, const, lambdas]
comments: false
---

I've been playing a bit more with IILE's lately. (Immediately Invoked Lambda Expression)

Especially regarding initializing a variable you have that has to be initialized using an interface you perhaps don't control.

So the interface might look something like this.

```cpp
bool
SomeApi::GetSomething(
    const int    aIndex,
    int&         aOutValue)
{
    if(myMap.count(aIndex) == 0)
    {
        aOutValue = 0;
        return false;
    }

    aOutValue = myMap[aIndex];
    return true;
}
```

So if you really want the aOutValue to be const where it's used, you usually had to create a function that you then const'ed the return value.

But with IILE you can wrap that function's logic in a lambda and call it immediately

```cpp
const int value = [&myApi]()
{
    int apiValue = 0;
    myApi.GetSomething(10, apiValue);
    return apiValue;
}();
```

It's still the same idea, wrap it in a function and use it, but if it's only used in one location, it feels a bit nicer.