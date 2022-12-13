---
layout: post
title: Blogvent 13 - What is a road?
tags: [programming, data, blogvent]
comments: false
---

It's just a line on a map right?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

I often get obsessed with weird questions, most of them nobody has answered. I've covered a couple of those here, like [What is the most commonly told dad joke](/2019-08-18-dad-joke-analysis/) and [Is the 3rd song most often an album single?](/2020-05-22-albums-and-singles/)

I have a new one I'm working on that is way tricker to answer than the other ones. Especially since I had to download the entire earth in OpenStreetMap.

## What is a road?

To answer my original question (which I'll go into later), another question had to be answered. What is a road, really?

Now I'm no expert on OpenStreetMap but I started with (what I thought) was a tiny town somewhere in California called Colusa, mainly because the file was about 2mb in size.

As soon as I opened the file in some OpenStreetMap tool I notice that I was in trouble.

![osm1](/img/osm1.png "street map of colusa, it's very big and a lot of landmarks")

It's fine it's fine. Let's just zoom in and look for a street, click it and see what tags it has, it must be tagged as a street right?

## Wrong

Here we have Vann Street in Colusa. Seems like a lovely little street, it even has little side streets, great. What are the tags? Oh sweet, there's something called `tiger:name_type` and it has the value `St`, we're in business.

![osm2](/img/osm2.png "overhead view of a map with a street highlighted and metadata on the side")

Now we just click on the street below and confirm that our suspicion is correct...

![osm3](/img/osm3.png "similar image to the one above, another street but there is no tag")

Ahh so it's the `highway` tag, right? That must be the one. Please tell me that's the one... yes. It seems to be the one, there are multiple tags for different types of roads but fine, we can use that.

So for the question I need the points that designate the road because I need to create a line/vector out of the road.

## Where we're going...

It seem that the library I'm using is able to give me the points but the results seem weird. Let's try to extract one of the cases and see what's going on.

Oh no...

The street I find is King Street in Arbuckle, just north of Sacramento. Just look at this.

![osm4](/img/osm4.png "street view similar to the ones above but there are three line segments highlighted")

Why are there 3 lines highlighted you might ask? Because those three lines are all King Street. It starts there on the left, then it joins an intersection with another road, you then go south a bit and there King Street starts again. But then it continues on nicely and then stops again.

You might think "Oh that's just an underpass or some sort of intersection". No, no it's not. The street stops, there's a wall and then the street continues on the other side.

![osm5](/img/osm5.png "google streetview of this intersection, in front of you is just a wall")

...fine, we can deal with this also. We'll just reconstruct the road from the points, join them all together to make one connected "street"

## No point

We'll just take the nodes, sort them by id and there we go.

Wait, you cant? Because the node ids can be updated after the road is made...

![osm6](/img/osm6.png "a list of ids, they all look around the same but then there are a couple of outliers")

Fine, I'll take each node, get the geographic point, find out what point is closest and...

![osm7](/img/osm7.png "road from before but highlighting that the end of one of the roads is further in than the start of the other")

I give up. I'll just treat them as 3 separate roads for now.