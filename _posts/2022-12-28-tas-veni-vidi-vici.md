---
layout: post
title: Blogvent 28 - TAS Veni Vidi Vici
tags: [programming, games, rust, blogvent]
comments: false
---

I came, I saw, I cheated.

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## On the last episode...

[Yesterday](/2022-12-27-tas-speedrun-exploits/) I was trying to run an already existing speedrun by reading the Tool Assisted Speedrun file from libTAS, with varying and mostly lacking results.

I saw that in the description of the speedrun that the framerate was `58.8235294117647`, what an awfully complicated number, so I decided to try and to get the delay between frames you calculate `1 / 58.8235294117647` which was ... `0.017`. How suspicious. So instead of waiting `16.666` ms per frame I would wait `17` ms per frame.

Although this sounded like the solution to my problems, it was not. I tried for a few hours without any luck. So I decided to tackle another problem.

I think the actual correct solution to this is to run the game process yourself and hook into the render function and perform the frame perfect actions ... frame perfectly. But I don't think that I can do something like that in 1 day. Maybe later.

## Veni Vidi Vici

There's an optional part of VVVVVV called Veni Vidi Vici, where you have to travel through a spike maze while flying upside down, land perfectly on 1 platform at the top and reverse your movement and go back through the maze down, only to land on the other side of a wall to collect a prize.

Here's the author of the game doing this part on an iPad.

<iframe src="https://www.youtube.com/embed/jzP5QfxPEcw" frameborder="0" allowfullscreen style="position: relative; top: 0; left: 0; width: 720px; height: 476px"></iframe>

Then what I wanted to do is to program the little bot to do this section (oh and gatekeepers don't worry, I've done this section normally multiple times).

So it was just a matter of doing one of the movements (or many of them), record it and count the frames in the video. Then make the bot wait that amount of time before pressing the next key.

What I found out is that even though you have the perfect timing, it still won't always work, which is (I think) the original problem with the libTAS input. There's always a slight delay or small hickup in your system that causes a 10 frame input to actually take 20 frames.

The conclusion there is that writing a TAS bot using `sleep()` functions just doesn't actually work in real world cases. But I got it to work eventually and here is the result.

<iframe src="https://www.youtube.com/embed/7dxOwhyXN4U" frameborder="0" allowfullscreen style="position: relative; top: 0; left: 0; width: 720px; height: 476px"></iframe>