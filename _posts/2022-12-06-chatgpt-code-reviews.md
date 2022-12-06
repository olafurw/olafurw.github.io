---
layout: post
title: Blogvent 6 - ChatGPT Code Reviews
tags: [programming, learning, blogvent]
comments: false
---

The perfect pair programmer?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## AI What?

[ChatGPT from OpenAI](https://chat.openai.com/chat) is all the rage these days. A chat bot that is surprisingly good at holding a conversation with you. It will remember previous references, you can ask it to roleplay with you. I even got it to pretend to be King Harald from Norway.

![gpt1](/img/gpt1.png "conversation between me and the bot, where the bot pretends to be the king of norway that doesn't want to cut his hair")

## Then we went further

People started to give it code examples, someone even asked to to [pretend to be a virtual machine](https://www.engraved.blog/building-a-virtual-machine-inside/) and start pinging other websites. I thought, since it's acting like a human and you could give it code examples, then the perfect fit would be a programming partner.

So I started off easy, showing it an example of bubble sort in Rust and asking the bot what this is?

![gpt2](/img/gpt2.png "what does this function do, with a code example, the bot is telling me that this is bubble sort and then explains bubble sort")

Pretty good, I tried a few more examples with varying levels of success. The bot would usually just describe every line and not talk about the bigger picture.

Until I gave it a bit of code that was dividing by a result of some unknown function, then the bot said this.

![gpt3](/img/gpt3.png "bot saying: it's worth noting that this function doesn't include any error checking. Warning me of a division by zero error.")

Wait a minute, the bot can tell me if the bit of code I'm giving it has possible errors?

## Code Reviews

The bot can review my code? This definitely has some potential, but how good is it?

I gave it a bunch of different code examples to try out. Something simple or something that I knew had problems. Here is the bot on the 3rd point regarding a command line parser I had laying around in some Rust project.

![gpt41](/img/gpt41.png "command line parser in rust, reads allargs parse, opens a file and sends the contents to serde json.")

![gpt4](/img/gpt4.png "bot simplifying the code by removing the else condition if there is no config argument")

Is it better? I would say yes. The flow through the function is much simpler. 

Earlier in the answer it wanted to `io::Result<Args>` instead of `io::Result<&'static Args>`. It even started on point 4 but there is a limit of how much text it can display in one answer.

Let's do a bit of code I know has problems.

## Older C++

Almost 10 years ago I wrote a [very simple genetic algorithm implementation](https://github.com/olafurw/ML2048) of the game 2048. Looking at it now, it's not great but I like it since it shows me who I was as a programmer all those years ago.

So let's take a bit of code from that repo and give it to the AI. A bit of code that I know has problems, it even has a todo.

![gpt5](/img/gpt5.png "a pretty long function called one point crossover, that takes 2 vectors, splits them at a random point and creates two child vectors from a mix of the first two.")

There is plenty wrong here and it's not even fully finished, but the general idea is to take 2 vectors of "parents" and create 2 "children" from a random mix of the parent's actions.

Here it's a 1 point crossover so we split the parents in 1 location and swap them to make 2 children. These are then fed back into the population of possible moves in the game and then we try to figure out if those children are better at playing the game of 2048.

Without describing much more, this is what the AI gave me, and I want you to notice a few things here.

![gpt51](/img/gpt51.png "suggestions to improve your code, use deque instead of vector, use std::swap to swap the elements, use std::copy instead of the loop, use std::minmax instead of min and max separately.")

Ok, step 1, use `std::deque` instead of `std::vector`. So I tried that. I dusted off the project and built it, once with vector and once with deque and ran multiple performance tests and took the averages. With `std::deque` the average runtime using 10000 iterations was 4.72 seconds. With `std::vector` the average runtime was 4.43 seconds. Not huge but definitely a noticeable difference. Is there a benefit of using deque, yeah possibly, but vector still wins, as it often does.

Step 2, use `std::swap`. Well, in the example the bot gives me, there is no `std::swap`, so we'll call that an extra optimization. Maybe?

Step 3, use `std::copy`. Here is where I was really happy. The AI spotted that the two loops were in fact doing a mixed copy of elements from parent_a, parent_b into child_a, child_b. It turned the two loops into 4 copies (1 for each child/parent combo). There are some issues here since we are fetching parent min/max sizes in the lines above and then the bot fetches them again using `std::minmax`, not great but I applaud the effort.

And step 4 I agree with, this should use `std::minmax`

I tried running this, it compiles and runs, but as soon as I enable `-O3` or something similar it crashes. There's an issue with correctly giving each child vector the right size but I'm willing to overlook that issue for now.

## Summary

I haven't spent a lot of time with this but from what I'm seeing, there is potential here.

Now I don't think you can blindly copy these suggestions and I don't recommend you do. But having a bot like this as an extra rubber duck on your desk that you can have a chat with and get suggestions? Color me impressed.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1600233175531167745) or [Mastodon](https://mastodon.social/@olafurw/109468733358202936)