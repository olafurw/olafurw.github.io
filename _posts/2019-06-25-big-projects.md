---
layout: post
title: How do you make big projects?
tags: [programming, learning]
comments: false
---

Let's create a hypothetical.

You've learned quite a bit about programming now. You've mastered your functions, your variables, your conditionals.

Then a questions sits right in front of you.

Now what?

I've had my DM open on Twitter for a while now. My focus is to help people new to programming, but I do get people asking for general advice. Advice regarding careers, what languages to learn and the big one, the one I seem to get the most often...

"I've been studying programming for a few years and I've done a lot of small projects. But now I feel like I can take on a big project. How do you make big projects?"

## Big projects

At first I didn't understand this question. I almost wanted to give them project ideas and ask them "What are you interested in making?" but I stopped myself pretty quickly.

"Why would you want to make big projects?" I would ask. "It's much more fun to make small projects." In my opinion at least.

Why did I keep getting this question, or questions similar to it? So I asked and the general answer is that they feel like something is missing in their education. That nobody told them how to make big projects. Like someone forgot.

And I told them. "Big projects are small projects that someone kept working on for years and years." Which apparently was an eye opener.

I don't believe any reasonable developer sits down and thinks "I'm going to make a big project". They sit down and think "I want to solve this problem". The project is going to grow almost by itself. It's your job to guide the growth in a manageable direction.

There isn't always a clear distinction here. Sure new projects might inherit a large codebase from another project or they might be started with another project as a reference/guide. That other project might be benefiting from yet another project or it might have started as a small project itself.

But in many cases big projects are just that, small projects to solve a specific problem but grow over time.

## Program a lot at once

Another thought new programmers have is that they feel like they need to program a lot at once. That they have to be able to dish out this massive amount of code in one sitting without fault.

This is also false.

Experienced programmers are faster, sure. But there is no magic here to make big projects.

Not only are big projects small projects that grow. Many big projects start of with baby steps. Focus on a small part that needs to be solved, and when that is solved, look ahead at the next obstacle and solve that.

## Examples

As a way to show this in a more tangible way. Here are a couple of examples of big open source projects that started small and grew large over time.

I do recommend looking at your favorite big project but do note that the entire history of the project might not exist online so it can give the illusion that someone sat down and wrote thousands of lines of code in one fell swoop.

### systemd

Here is a description from wikipedia.

> "The systemd software suite provides fundamental building blocks for a Linux operating system. It includes the systemd "System and Service Manager", an init system used to bootstrap user space and manage user processes."

I like that word Fundamental. It currently has over 40.000 commits to [github](https://github.com/systemd/systemd). It has over 5000 stars. I would say that systemd is not a small project in any way.

Let's look at the [first commit to systemd](https://github.com/systemd/systemd/commit/f0083e3d4eb49e11fd7e37532dc64a6e6f5d4039) made in Apr 27, 2005.

First file is a makefile, and for a new programmer it might look quite intimidating. But if you read the first line, it's actually copied from another project called "diethotplug". I also want to focus on code so let's ignore Makefiles for now.

Next is a file called logging.c

Title of the file is "Simple logging functions that can be compiled away into nothing."

It's 2 functions. One called "init_logging" which calls openlog and then "log_message" which basically just calls vsyslog to log any message the system wants.

Next file is udev.c which is 3 functions.

"get_action" which fetches an environment variable called ACTION. "get_device" which fetches an environment variable called "DEVPATH" and the main function, which calls those two functions and exits the program if those two functions don't return a value.

That is it.

They started with absolute baby steps, fetch a couple of environment variables and check if they exist.

The next couple of commits follow the same path, [create a couple of small simple functions](https://github.com/systemd/systemd/commit/85511f02466297b7dca07c3fe5491230f3f06d14), use them and see what the results are.

### Swift

> "Swift is a general-purpose, multi-paradigm, compiled programming language developed by Apple Inc"

An entire programming language. That is not a small project.

I love Swift's [first commit to github](https://github.com/apple/swift/commit/afc81c1855bf711315b8e5de02db138d3d487eeb). So much so that here's is a picture of the entire commit. (Minus some makefiles).

![big-swift](/img/big-swift.png)

Every programming language needs a lexer and a parser. So here they are. Empty for now.

The [second commit](https://github.com/apple/swift/commit/5e88a2175579b0b2ed3c4a15fe8c2382601ac321) is wonderful as well.

We have Lexer.h where the developer is creating a class called Lexer with a function called Lex. Neither of which are implemented in this commit, the developer just wants to create the interface.

Then we have Token.h where a few keywords for the language are defined, like "int" and "var" and then some functions to get and set those values.

Is making an entire programming language easy? Nope, not at all. But does it all appear at once as a big project? Or are there some "magic big project" things done? Nope. It starts off just like any other small project.

## Conclusion

Please don't be intimidated by big projects and please don't think that you have to aspire to make big projects. Developers focus on solving problems and when writing code that should be our main objective.

Make no mistake though, big projects are difficult to make and the ever growing complexity takes a lot of skill and experience to manage, but I want to leave you with just a simple message.

Develop projects that solve problems and make them well, don't think about how much code they are.