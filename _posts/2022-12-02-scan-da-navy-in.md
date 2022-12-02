---
layout: post
title: Blogvent 2 - Scan da navy in
tags: [jokes, blogvent]
comments: false
---

Are they putting barcodes on ships?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

There's a well known Dad joke that goes something like this: The Norwegian Navy has started to put barcodes on their ships. So they can scan da navy in.

Excellent joke. But what if it was real?

## Barcodes

![barcode](/img/barcodes.png "image of a standard barcode with some numbers below it")

Patented in the 1950s and used to identify railroad cars in the late 50s, barcodes have all sorts of identification uses and although they were used to identify trains they generally aren't used to identify ships.

But what would it take, what would a barcode like that look like? There are a lot of ships out there.

## Does this exist?

Maybe the first question we should ask is "Does a system like this exist?", and yes, yes it does. There is a system called a "Unique Vessel Identifier" or (UVI) which is an identifier given to a ship for the rest of it's life. Even if it changes owners or name.

It's a 7 digit number (with 1 check digit) with the letters IMO (International Maritime Organization) in the front. This number needs to be clearly visible somewhere on the hull of the ship. So this can then account for 1 million vessels.

## Wait, how many ships?

1 million? How many ships are out there?

According to [Statista](https://www.statista.com/statistics/264024/number-of-merchant-ships-worldwide-by-type/) there are 58.228 ships in the world classified as "merchant ships". So even if we double the number to 100.000, we're not even close to exhausting the IMO numbers.

But wait, I said that the number is given to the ship for the rest of it's life. So this also needs to account for all ships that have ever existed?

## A boat is not the same as a ship

That kind of question isn't easy to answer, but... while researching this, I found that the official classification of these vessels is not the same. Because even if there are these 60.000 ships, the number of fishing vessels and recreational boats is WAY higher. [About 34 million.](https://www.scmo.net/logistics-facts) So this IMO system definitely doesn't work for them.

## Then what?

The average lifespan of a boat in freshwater is 20 years and 10 years in salt water. Let's assume that every 15 years there is a whole new set of boats out there and we've been using this system since the IMO system started, that would be ~3 sets of 15 years.

If we then use the 34 million number for each of those sets, we'll have 102 million boats. A nice cool round 100 million. I can get down with that.

Then lets increase the number to give it some room to grow for the next few decades and let's say the system has to handle 500 million boats.

So what kind of barcode can handle 500 million numbers?

## All of them (almost)

Barcodes are designed to encode a lot of data, more than some think. Most barcodes can handle this without breaking a sweat, though there are a couple that are too small (like EAN-8).

But what about the classic barcode we all know and love? The good ol' [EAN-13.](https://en.wikipedia.org/wiki/International_Article_Number)

![ean13](/img/ean13.png "the barcode you'll find in most grocery stores")

It (unsurprisingly) has 13 digits, 1 for checksum and 1 for country code. So we have 11 left, and we only need 9.

So let's extend it to use 3 digits in total for checksum (since scanning a boat from a distance might be tricky) and there we go.

# Results

What barcode would you use to Scan Da ~~Navy~~ Boat In? The normal grocery store EAN-13 barcode with 2 extra checksum digits.

PS. If you like Dad Jokes, you might like [this older post I made](/2019-08-18-dad-joke-analysis/) where I downloaded all of reddit... kinda.

## Comments

If you want to chat about this, [Twitter](https://twitter.com/olafurw/status/1598772621276893184) or [Mastodon](https://mastodon.social/@olafurw/109445912286861056)