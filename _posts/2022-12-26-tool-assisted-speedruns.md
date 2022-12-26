---
layout: post
title: Blogvent 26 - Tool Assisted Speedruns
tags: [programming, games, rust, blogvent]
comments: false
---

Look ma, no hands!

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

## Speedrunning?

Normally when people speedrun games, they practice a lot, and I mean a lot. For example, the Ninja Gaiden game for the NES can be beaten in [11 minutes 34 seconds and 184 milliseconds](https://www.speedrun.com/ngnes/run/zq7ejl1m). Yes for those who aren't familiar with speedruns, people count individual video frames.

One of the best Ninja Gaiden speedrunner has has a counter to show you how often he has tried to beat the world record. In one of his latest videos the counter is at 66.362 runs. Of course he doesn't take the full 11 minutes for each attempt but lets say that on average each attempt is 3 minutes, that's still ~3318 hours of trying to beat one game.

## Tool Assisted?

I love playing video games, but sometimes it's just to tedious. You have to get better at the game, you have to spend time solving the problems. This is all way too hard for me. But since I know programming, I can just let the computer do the work for me! Right?

That's one way to speedrun games. Note down when to press the buttons and get the computer to do it for you at the perfect time. There's even a [famous bot](https://en.wikipedia.org/wiki/TASBot) that does this for NES games on actual NES hardware.

So how does this work?

## VVVVVV

I wanted to try this on a game that I love called VVVVVV. The intro sequence is relatively short but requires you to press a few buttons before you gain control of the character. You could spam the `v` button but I wanted to press the right buttons at the exact right time.

I found a Rust library called [InputBot](https://github.com/obv-mikhail/InputBot) that seemed perfect for this task.

First thing I did was to record the intro sequence at 60 frames a second and then open it in a video editing tool and note down at what frames I could press the buttons.

Each frame is 16.666... milliseconds at 60 frames per second so I had this little helper function to make the program sleep for N amount of frames.

```rust
fn sleep_frames(frames: u64) {
    sleep(Duration::from_millis((frames as f64 * 16.667).round() as u64));
}
```

Then it was just a matter of making the program sleep, pressing a button, sleep again, press, etc. The sequence seems to be 294 frames, 2, 2, 72, 553, 5, 189 and then 138 frames. After that you have control of the character. The code is very simplistic but it looks something like this.

```rust
// once we press the 1 key, it starts
Numrow1Key.bind(|| {
    println!("starting");
    Numrow1Key.unbind();

    // I print out what is happening as well
    println!("start press");
    VKey.press(); // press the button
    sleep_frames(2); // sleep to let the game detect the input
    VKey.release(); // release

    // here we wait 294 frames or about 5 seconds.
    sleep_frames(294);
    println!("uh oh...");
    VKey.press();
    sleep_frames(2);
    VKey.release();
    
    // next button we can press basically instantly
    sleep_frames(2);
    println!("Is everything ok?");
    VKey.press();
    sleep_frames(2);
    VKey.release();
    
    // etc...
});
```

Next step is to turn it into a loop and read the delays from a file but here I wanted to have each action visible while I was playing with the numbers.

Here's a little video of the tool in action. Note: some flashing images in the video.

<iframe src="https://www.youtube.com/embed/rY7vT7OnEC4" frameborder="0" allowfullscreen style="position: relative; top: 0; left: 0; width: 720px; height: 476px"></iframe>

It's very quick and pretty simple but it was pretty fun to work on and I can imagine how difficult this would be to create a sequence that beats the entire game.

I know that for older games on emulators people use freeze frames and are able to rewind the game so that helps a lot with the creation of these sequences.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1607356010053632000) or [Mastodon](https://mastodon.social/@olafurw/109580027319943029)