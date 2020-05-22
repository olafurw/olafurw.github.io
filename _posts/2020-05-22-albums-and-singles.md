---
layout: post
title: Is the 3rd song most often an album single?
tags: [music, science, obsession]
comments: false
---

This was a curious pursuit of mine that has little scientific value and the answer is fairly predictable and boring.

For those who do not want to read the ramblings of an obsessive here is the answer.

**No, no it is not.** The most common song to be a single is the 1st song, the 2nd most common song to be a single is the 2nd song and, you guessed it, the 3rd most common song to be a single, is the 3rd song.

But if you are interested in data, music industry oddities and edge cases, then tread carefully ahead.

(Note that there might be a lot of links in the article, but the idea is that they're just extra material, you're supposed to be able to read this without clicking anything)

# Why?

Oh boy. So I've had this notion stuck in my head for the longest time. That whenever I saw an album being released, the 3rd song in that album was also a promotional single for the album.

I had created this fixation that there was some 300 iq play going on here from the music industry. That they had spent all their money on some elaborate research and found out that the 3rd song is the most effective placement on the track list, for.... reasons?

I'm not sure.

Then one day I thought. Hey, I can type on keyboards, surely there's a way to answer this.

Enter...

# MusicBrainz

[MusicBrainz](https://musicbrainz.org/) is an online music encyclopedia, think of it as Wikipedia but for music releases.

From their site:

> Like Wikipedia, MusicBrainz is maintained by a global community of users and we want everyone — including you — to participate and contribute.

Also similar to wikipedia, they have [database dumps](https://musicbrainz.org/doc/Developer_Resources) available (and more). So my naive thinking was.

1. Download Database
2. Get List of Albums
3. Get List of Singles
4. ???
5. Profit

Easy right?

Enter...

# The Music Industry

The music industry is a large and complex beast. So expecting that everything will be nice and uniform is not going to end well.

Let's start with a simple example.

In the year 2000 the alternative rock band Linkin Park released their first album [Hybrid Theory](https://en.wikipedia.org/wiki/Hybrid_Theory)

The album was released on October 24th 2000. According to wikipedia it has 12 songs and the singles are (in release order), "One Step Closer", "Crawling", "Papercut" and "In the End". Those songs are the 2nd, 5th, 1st and 8th songs on the album (respectively)

There are also 6 different "Bonus" or "Extra" releases of this album according to wikipedia. These releases all include the original 12 songs, plus extra material. These are, a "Japanese version", a "Special Edition", an "iTunes Store Deluxe Edition", a "Special Edition Bonus Disc", a "2013 Vinyl reissue" and a set of live songs.

Simple enough. All of the singles are on the actual main release and none of them are the 3rd song. The system would note that down and move onto whatever album was next.

## Terminology

I'm no music industry expert, but here are some terms that I use that might help you understand this article more.

- **Album** - A set of songs released by a band or an artist.
- **EP** - A smaller set of songs, think of it like a mini album
- **Single** - This is actually two things. 
- **Single (as a song)** - A single is a song on the album that is given an extra promotional boost, either before an album release to garner hype or after an album release to remind people to buy the album.
- **Single (as a release)** - A single is usually also made into a release of it's own. So even though "One Step Closer" is a single on the album "Hybrid Theory", there is also a release called ["One Step Closer"](https://en.wikipedia.org/wiki/One_Step_Closer_(Linkin_Park_song)) you could buy, which includes the song and the video for "One Step Closer" and 2 other songs.

# The Rabbit Hole

Database is downloaded and installed. Some [simple nodejs library](https://node-postgres.com/) to query postgres databases. Let's do this!

Or so I thought.

I won't go into all of the problems I had, most of them were me wildly underestimating the scope of this task, but let's talk about some of the more fun cases.

### What is an album?

An apple is not the same as an apple. Musicbrainz talks about a thing called a Release Group, which is as the name suggests, a grouping of releases. Like I talked about above, there wasn't technically one release of the album "Hybrid Theory" and [MusicBrainz agrees](https://musicbrainz.org/release-group/b5b4bb4b-8ba5-3acf-88cb-4cae2699d8da). 21 releases in 9 territories, from the year 2000 all the way to 2016, many of them having more than the original 12 songs.

So if I want to do a query that gives me the release I want, I need to disambiguate from all of these releases. When I say "Hybrid Theory", which one do I actually mean? The bonus track version with 15 songs released on October 24th 2000 or the Canadian CD release with 12 songs released on the same day? Or any of the other 19 releases.

The path I took is not a perfect one, but it seems to work pretty well. And I felt this method tried to keep the spirit of what we think of as "The Album"

For every release done by this artist within the release group in question, sort all of them by Year, Month and Day first, then to resolve many releases on the same day, we next sort by track count.

The reason for that is that there are albums out there that have a single attached to the album but that single was only released on some special edition of the album. An example of this is "Into the Groove" from Madonna's ["Like a Virgin"](https://musicbrainz.org/release-group/b69580b9-7050-3994-b544-4407a22c097a), this song is a single but was only on the Vinyl version of the album. So we pick the ones with the most songs.

We still might have clashes, but we resolve them by sorting by id. Just to be consistent for each request, so the release that was inserted first into the db is picked.

### What is an artist?

I didn't want to perform this search on every album in the database. The question I'm trying to answer is related to the behavior of the music industry, so I wanted to have a list of popular musical artists.

But that would require me to find each artist id in the database by name. To get that id from the name, I started with a simple string search. `name = 'Linkin Park';` and this served me well for a while. Until I got to Tom Jones and Nirvana.

To disambiguate bands with the same name as each other, was to sort the artist result by the date the band was founded.

This works for many bands, but it does not work for Tom Jones and Nirvana. There is a musical theatre lyricist from the US called Tom Jones and he started producing work in 1928, well before the other Tom Jones did.

For Nirvana this is also a problem, due to the London based pop rock band founded in 1967. This is an even bigger problem than Tom Jones, because they have released many albums and some singles.

I went back to the MusicBrainz website, because if you search for "Tom Jones" or "Nirvana", the correct one would be at the [top of the results.](https://musicbrainz.org/search?query=tom+jones&type=artist&method=indexed) How?

Apparently they implemented fulltext search ranking, based on how often the term you search for appears in a result set of band names and band aliases.

So I had to sit down and learn how text search works in Postgres. This is a pretty slow query, so what I did was, for every artist I was interested in, I would do the fulltext search and output the id found. This list of ids was then the main input used, not the names of the bands. So I only had to perform this expensive query once.

### Which artist?

Since this original idea came from me being curious about the music industry. I wanted to limit the scope to artists that are considered successful.

RIAA has a [table of all artists](https://www.riaa.com/gold-platinum/?advance_search=1&tab_active=awards_by_artist&format_option=singles&type_option=ST#search_section) they collect data on, you can then sort this table by how many millions of units of singles they have sold.

I used this table all the way down to 1 million units. This gave me 1427 artists. 

But since this is a table of single releases, some artists are in there more than once, due to them releasing a single with someone else. For example Drake is on the list twice. Once as "Drake" and once as "Future Feat. Drake", due to them releasing a single together.

So I removed all name duplicates, being careful to check that the thing I was removing was not classified as a band and had not released albums.

Then, since this is a table of only single releases, there are artists on this list that have released a single that sold more than 1 million units, but have never released an album. We are not interested in those, since then there would be no album to compare to. An example of this is the hip hop production of ["Epic Rap Battle of History"](https://musicbrainz.org/artist/322b62f3-ffbb-455d-af90-3f7c38baa01f), they have released many singles but never an album.

This gave me a list of 1110 artist ids. This would be the master list the data is based on.

### MusicBrainz isn't perfect.

Running through this list I found yet another problem.

The list from the RIAA is based on how many units of singles the artist had sold. So you would think that I would never get an artist result from MusicBrainz that would contain no singles.

But MusicBrainz is a database maintained by people. So there will both be mistakes and data that's just... missing.

(don't think of this as me bashing MusicBrainz, I think the entire project is amazing)

An example of this is the band [UB-40](https://musicbrainz.org/artist/7113aab7-628f-4050-ae49-dbecac110ca8). The English reggae and pop band, that had the hit single ["Red Red Wine"](https://musicbrainz.org/release/12b93b3b-6d12-4e7a-8bea-c3da7e02d760) in 1983 from the album ["Labour of Love"](https://musicbrainz.org/release/2251f967-3182-3bcb-9e4d-ee6518cdfe62).

MusicBrainz has the song release correctly marked as a single and it has the song as a track on the album release, but it doesn't connect those two together. MusicBrainz has a table of relationships, where a release group can be connected to another release group. This is how they connect the release of a single to the release of an album. For UB-40, this is just missing for all their singles, so in my data set, there are no singles to process.

Thankfully this isn't that common.

But there is a bigger issue...

### Which song is the single?

You might think. "Uh, what? How is this a problem?"

And initially I was right there with you. But hear me out.

An album for us is called a Release in MusicBrainz terms, a release is released on some kind of medium, this medium has a set of tracks. Those tracks are a recording of a song. Great. So now we have a recording of a song on an album.

The id of that recording on the album is not the same id for the same recording on the single release. 

Let's take Linkin Park and the song "One Step Closer" as an example. The id of the song on the album is ["c6111171-bb92-4401-9053-f165863547f2"](https://musicbrainz.org/recording/c6111171-bb92-4401-9053-f165863547f2) and the id of the song "One Step Closer" on the single is ["fe71abbe-0f3a-4896-bb12-bd667f66147b"](https://musicbrainz.org/recording/fe71abbe-0f3a-4896-bb12-bd667f66147b)

I thought I was screwed. Until I remebered that MusicBrainz has a singular entry for each song, which they call "Work" as in "The work of the artist". 

Score! I can just find the work id of all songs on the album and then the work id of the song on the single. They should match and then we can associate a single with a track on the album. Boom! Winning!

But no...

If you remember from before, a single is actually a release, and contains many songs, and those songs can actually be on the album, even though they technically aren't the single being promoted.

An example of this is Foo Fighters first self titled album. There is a song on the album called "Floaty" which isn't a single, but was being marked by my system as a single on the album for some reason. That reason is that the live version of the song Floaty was released alongside the [single release of "Big Me"](https://musicbrainz.org/release/cdeac7ab-a9c7-3ec8-a3d9-86681efc73be)

So there is no direct way for me to know which song on the tracklisting of the single is the actual single from the album, not with ids at least.

So I must resort to...

### Let's just string compare this shit

Oh no, are we really here? Yeah? Ok. Let's do this.

This actually saves us quite a few database queries, since I don't actually care about the tracks on the single release, just the name of the single. Get the name of the single, find that as a name of a song on the album. Boom, back to winning.

Funnily enough, this works WAY better than I expected. I was expecting a horror show of mismatched names and most singles not being found. Sure there are a bunch of edge cases, but overall, "string compare this shit" worked. Huh.

### Method to the madness

Let's get a little more technical.

For every track on the album, let's go through all of the singles associated and let's just do a straight compare. 

```let isSingle = track.name === single.name;```

This check works most of the time, but if it doesn't, we need to resort to some tricks.

First thing we do? We normalize the names of both the track and the single. We remove any áccént from any character. We lowercase the string and we remove anything that isn't a lowercase letter or 0 to 9. Examples of why we needed to be this aggressive is the song "I'll Stick Around" by Foo Fighters. One of the release was named `I'll Stick Around` and another `I’ll Stick Around`. Do you see it? Good.

Then we do a straight equality check. Are these normalized names exactly the same? They are? Good, we out.

They're not? Ok, time for some fun. 

Is the normalized song name shorter than 4 characters? Sorry, we don't care. There's such a high chance that you'll match as a substring in another song name that we can't take the risk. 

Example? Rihanna has an album called ["Loud"](https://musicbrainz.org/release/c43043ff-a16d-4c74-a7cb-a278bf4d4c5c) and that album has a few singles. Two of them are "What's My Name?", normalized as "whatsmyname" and "S&M" normalized as "sm", which is a substring of "whatsmyname".

Funnily enough, in this case, it would have been ok, since both of them are singles on the album, but there are cases where this is not ok.

We do all this juggling around to just feel a bit safer asking if the normalized track name is a substring of the single name. The reason for that is sometimes a single release is a double single, and then the name of the release is in a format similar to "Single A / Single B".

Example of this is the single release ["No Way Back/Cold Day in the Sun"](https://musicbrainz.org/release-group/d58dd640-6253-4413-816d-378dc0e70ee8) from the Foo Fighters. Which includes 2 songs, which are both singles and both on the album ["In Your Honor"](https://musicbrainz.org/release-group/304479f9-ea77-3299-8745-3985f05cfa13)

If the check still fails, then we bail out, not much more we can do to find the song on the album.

There are cases where even the coolest text search would not have worked:

- Madonna has a single release called ["SEX"](https://musicbrainz.org/release-group/73f21b44-19bf-434f-af99-a38956fd88c0), there are no songs with that name on her album "Erotica", but that single has a song called "Erotic", which is a slightly altered title of a song that is actually on her album.
- Rihanna has a single called ["Take a Bow"](https://musicbrainz.org/release-group/5bdaa74b-c83f-3e25-9a37-3ad28fad9bc2) which only appears on the "Reloaded" versions of her ["Good Girl Gone Bad"](https://musicbrainz.org/release-group/7e48f018-b774-32e6-a68b-b42db04535c0) album, which was released a year after the original version.
- And finally, The Rolling Stones have a single called ["Paint It Black"](https://musicbrainz.org/release-group/7b0b86e4-0104-3c2f-80c1-233ca36a6fc4) attached to the album ["Aftermath"](https://musicbrainz.org/release-group/26987c39-5914-483b-a897-d43ce6aad9b1) but this song never actually appears on any of the "Aftermath" versions released.

# I want results!

I ran the thing. I got the numbers. Wanna see?

![music-1](/img/music1.png)

Here we have how often we saw each song in each position, regardless of if it is a single or not. We can see here that most albums are at least 10 songs. We can also see, due to the very small difference between 1, 2 and 3, that there are albums out there that are just 1 or two songs, but still marked as albums. Interesting.

![music-2](/img/music2.png)

Here we see how often each position contained a single. A nice curve going straight down (except for spot 17, very odd, still a small sample set).

So our beloved 3rd song is not the scientific wonder I thought it was.

But what we do see is that the first 3 songs seperate from the pack by quite a margin, so singles are more common as one of the first 3 songs, not just the 3rd song. So there was some nugget of truth here.

# Now what?

You can [download the database yourself](https://musicbrainz.org/doc/Developer_Resources), it will be a little bit of work to setup, but it's not very scary. The code I used is on [github](https://github.com/olafurw/third-single-in-album), but please do remember, I only wrote it to answer this one question, it's written to do exactly that, so don't expect anything magically documented and unit tested. But if it can help you, then sweet!

If you made it this far, then I appreciate you. Lovelies like yourself are the reason I do this kind of nonsense. I hope to do more.

<3