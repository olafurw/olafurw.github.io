---
layout: post
title: Blogvent 21 - What YouTube video has the most sponsored segments?
tags: [programming, rust, analysis, blogvent]
comments: false
---

Brought to you by...

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

This is part 2 of [yesterday's post](/2022-12-20-what-is-the-longest-ad/) where I ask what is the longest sponsored segment on YouTube. Check it out to see more detail on this database I'm using.

## What are we doing?

With the SponsorBlock database, I wanted to see if I could answer a couple of more questions. So I had some more fun with it today and was able to answer to two more questions.

> Where in the video are the sponsored segments most often?

and

> What video has the most sponsored segments?

## Where are they?

The [database](https://sb-archive.mchang.xyz/latest/) contains when the sponsored segments starts and ends for all videos but there is one problem. It doesn't always contain the video length. Only about 4% of videos in the data set also tell you how long the video is, and we need that data to figure out where the sponsored segments are.

Thankfully it still is a lot of videos (around half a million) but we still need to trim that down because we're only interested in segments that the community has voted on and segments that are marked as sponsored and you should skip. So in the end I was able to find 29.605 videos that fit that criteria.

- 11.7% of videos have the sponsored segment at the end.
- 15.4% of videos have them in the middle.
- And 72.9% of videos have them at the start.

Makes sense because that's where most of the viewers are since videos have a natural drop-off over time.

![sponsorb2](/img/sponsorb2.png "graph showing an example of video viewing retention, line graph slowly dropping over time.")

[Here's the code](https://gist.github.com/olafurw/b3cc195855038550eb0783729dafd798) that calculates the average and [here is the code](https://gist.github.com/olafurw/c278bda47f46e74e212688f301626cc4) that parses that result.

## What is the most sponsored video?

There is one detail that I can't extract from the data alone, and that is what the sponsor actually is. So counting the number of sponsored segments is just going to count the segments within the video. They could all be for the same product or brand.

So that is what I did, but there is one snag. As I mentioned in yesterday's post, there could be multiple submissions for the same segment, just slightly different in time. So I use the code from the question above to find out where in the video that segment is and not count duplicate entries.

To do this I create a string that concatenates the video id + the number 0-100 of where in the video the segment is. For example `pb29jzOCONY` is a Try Guys video about making a pizza, there is a sponsored segment at around 40 seconds into the video, which is 1% into the video, so that sponsored segment would get the unique key of `pb29jzOCONY1`

Then it's just a matter of creating a `HashMap` of the video id and count how many unique segments there are.

Here I'm going through all the records, filtering out the segments that don't have enough votes and aren't sponsored segments, checking for the `sponsor_key` and otherwise incrementing the count.

```rust
for result in rdr.records() {
    let record = result?;

    let video_votes = record[3].parse::<i32>().unwrap();
    if video_votes < 5 {
        continue;
    }

    let category = record[10].to_string();
    let action = record[11].to_string();
    if category != "sponsor" || action != "skip" {
        continue;
    }

    let video_id = record[0].to_string();
    let sponsor_average = get_sponsor_average(&record);
    let sponsor_key = format!("{}{}", video_id, sponsor_average);
    if duplicate_check.contains(&sponsor_key) {
        continue;
    }

    *sponsor_count.entry(video_id).or_insert(0) += 1;
    duplicate_check.insert(sponsor_key);
}
```

From this I can see that most videos have only 1 or 2 sponsored segments, as expected. But there are only 2 outliers.

A [video by Linus Tech Tips](https://www.youtube.com/watch?v=zk97ywS-fGc) that is a studio tour that is sponsored by some speakers and a webcam and they show how they use those products in a few places around the studio, so each one of those segments are marked as sponsored. So that video has 4 sponsored segments.

![sponsorb1](/img/sponsorb1.png "video of linus tech tips with the play bar visible and 4 green segments, showing the sponsored sections.")

Then we have the other outlier. That one has 5 sponsored segments, but they're all the same segment. It's [MrBeast's Squid Game video.](https://www.youtube.com/watch?v=0e3GPea1Tyg)

There's only one sponsored segment, but what he does is he mixes the sponsored message in with the action of the video, so the users of the SponsorBlock addon have found the precise moments when MrBeast talks about the sponsor and when he stops talking for a bit and chats with the contestants.

So as you can see here, on the play bar that the sponsored part is localized in one area but it's broken into multiple segments.

![sponsorb3](/img/sponsorb3.png "video of mrbeast's squid game video with the play bar visible and 5 green segments, but they're all around the same area.")

[Here's the code](https://gist.github.com/olafurw/1e76bbe98bb8ef306c3f1e12c2aba156) that I used to find what video has the most segments, you run this against the dataset and sort the results `cargo run sponsorTimes.csv | sort -n`

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1605661683476750353) or [Mastodon](https://mastodon.social/@olafurw/109553553417430881)