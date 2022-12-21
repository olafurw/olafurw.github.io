---
layout: post
title: Blogvent 20 - What is the longest YouTube sponsored segment?
tags: [programming, rust, analysis, blogvent]
comments: false
---

This blog post is sponsored by...

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

This is a part of a short blog series, I have something planned for tomorrow as well.

## What?

I love data sets, and I saw one today.

There is a browser plugin called [SponsorBlock](https://en.wikipedia.org/wiki/SponsorBlock) that uses user submitted data to indicate where in the video is the sponsored segment and where is the normal video.

This is then indicated with a green line in the video play bar and you can configure the tool to automatically skip over the segment.

![sponsor1](/img/sponsor1.png "youtube video play bar with a small green line on it")

Users can create segments to send to the system, they can vote on already existing segments and submit a correction.

The great thing about this plugin is that the [database is open.](https://sb-archive.mchang.xyz/latest/) And because I love playing with datasets, I just had to try.

## What are we looking for

Since I saw this pretty late in the day I couldn't do much but I was able to answer one question.

> What video on YouTube has the longest sponsored segment?

The data is in a `csv` format and not that big (only about 4GB). So I used the rust csv library and wrote some code that would parse the data. 

Each line in the dataset is an entry someone has made, so there might be multiple entries per video, either because multiple people submitted a sponsor segment or because the video has many sponsored segments.

## The process

I'm only interested in long segments that have some number of votes and are marked as `sponsor` and `skip`. So first I check for those conditions and then early exit if they don't match.

```rust
let video_votes = record[3].parse::<i32>().unwrap();
if video_votes < 20 {
    continue;
}

let category = record[10].to_string();
let action = record[11].to_string();
if category != "sponsor" || action != "skip" {
    continue;
}
```

Then I check if the video is already in the hash map. If it exists and has a higher vote score than whatever entry I'm looking at, then I skip it as well.

```rust
let existing_video = videos.get(&video_id);
if let Some(existing) = existing_video {
    if video_votes < existing.votes {
        continue;
    }
}
```

Then I add that entry to the hash map with the video id and the difference between the start and end time. After this has been processed, I print it out to the screen and sort the results by highest sponsor segment time.

```rust
let videos = video_result.unwrap();
for video in &videos {
    println!(
        "{}, {}, {}", 
        video.1.sponsorDiff, video.1.votes, video.1.videoId
    );
}
```

`$ cargo run sponsorTimes.csv | sort -n`

```
1507, 25, Arx8bX4E_Cw
1524, 20, Ck_yuplT8O8
1581, 20, rMZYyG8qm-Y
1600, 23, 7Z610fSoifk
1630, 21, 8tCcRA2aogk
... etc
```

## The results

The top video is a Hungarian newspaper podcast, where the video is 1 hour and 7 minutes long and the sponsored segment is 32 minutes and 37 seconds.

I'm not going to link to the video mainly because from what I've googled it's an anti covid podcast (released in March 2020). Interestingly there doesn't seem to be any sponsored segments in the video though, they're just sitting around a table and talking (in both the sponsored and normal portions). Perhaps it's the community skipping over the bad parts? (it has 21 votes)

The next several results are funny though. Because they're all from the same YouTube channel (a channel I'm ok with linking to). [Critical Role.](https://www.youtube.com/@criticalrole) A dungeons & dragons role playing podcast.

The videos are about 3-4 hours in length and they're all from Campaign 2. The sponsored segments seem to be the intermission about halfway through the video. [Here's an example](https://youtu.be/8tCcRA2aogk?t=8010), sponsored segment starts at about 2 hours and 13 minutes and ends at 2 hours and 41 minutes.

The sponsored segments are about 24 to 27 minutes in length and include both ads and community submitted videos/images.

## More to come

I didn't have much time today but I want to play with this dataset more, so expect 1 or 2 more posts about it.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1605324220199620608) or [Mastodon](https://mastodon.social/@olafurw/109548280473037978)