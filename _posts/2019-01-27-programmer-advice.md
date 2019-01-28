---
layout: post
title: Advice to new Programmers
tags: [programming, learning]
comments: false
---

It's not every day where students new to programming get to ask 709 software developers for advice.

## Overview

There is a school here in Malmö, Sweden called [The Game Assembly](https://www.thegameassembly.com/). This school focuses on teaching students game production. Everything from programming to art and design. This is a three year program where the last year is spent at a games studio.

Since I work for a [games company](https://www.massive.se/), we get asked to hold lectures for the students. I've done this a few times over the years and feel very honored when I get the opportunity.

This year I got to speak to the first year students. The idea was to go over [the basics of object oriented programming](https://speakerdeck.com/olafurw/the-basics-of-object-oriented-programming) but I had another idea as well.

Why not reach out to Twitter and ask if they had any advice for some "impressionable youth" ?

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Hey, Programming Twitter!<br><br>I&#39;m going to be speaking to impressionable youth in a couple of days<br><br>They are in their early years of learning. In the 20ish age range.<br><br>What is your one solid advice? Language Agnostic.<br><br>RT&#39;s are loved<br><br>(I&#39;m gonna quote you in the slides so be nice :)</p>&mdash; Ólafur Waage (@olafurw) <a href="https://twitter.com/olafurw/status/1087438169585434624?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Getting well over 700 replies was not something I imagined would happen. Because I only had two days from the tweet until the talk, I was not able to summarize all of the wisdom. But I tried to find the most liked ones and replies from individuals that work in the gaming industry.

But there was just too much data to gloss over. I needed to analyze the replies.

## Getting the data

First I tried to just browse the timeline on Twitter and copy the text from there. But apparently when a thread reaches a certain size, Twitter limits how many tweets you can see. So from that data set I was only able to get 285 replies.

Next up was to use the Twitter Developer API, which is heavily throttled but allows for more granularity in searching.

Using Python and Tweepy and a 5 minute sleep between requests, I was able to fetch 763 tweets that were a direct reply to my request. This took **362 minutes**, or **6 hours**. It might have been ok to have a shorter sleep but I left it overnight, so it didn't matter much.

```python
for page in tweepy.Cursor(api.search, q="to:olafurw", since_id='1087438169585434624', tweet_mode='extended').pages():
  repliesFile = open("replies.txt", "a")
  
  for tweet in page:
    repliesFile.write(tweet.in_reply_to_status_id_str + "\n")
    repliesFile.write(tweet.user.screen_name + "\n")
    repliesFile.write(tweet.id_str + "\n")
    repliesFile.write(tweet.full_text.encode("utf-8") + "\n")
    
    repliesFile.write("\n--==--\n")
  
  repliesFile.flush()
  repliesFile.close()
  
  time.sleep(300)
```

## Basic Analysis

Analyzing a text corpus is an educational field on it's own and I don't have the knowledge or the time to go in depth. But I do want to highlight a few things that stood out.

### Programming is a human field

131 out of 763 tweets talk about other people. **17.1%**

They talk about humans, teams, peers, friends, colleagues.

Here are some examples: 

> [@tomjadams](https://twitter.com/tomjadams/status/1088336413827915776)  
> Software is a team sport    

> [@mrdowden](https://twitter.com/mrdowden/status/1087882550964641792)  
> The most important thing in life -- and something you always control -- is how you treat other people    

> [@originalJonLowe](https://twitter.com/originalJonLowe/status/1087594133357760513)  
> Be supportive and kind in your journey for knowledge  
> Build other developers up because at the end of the day, you're a part of a team  
> Be a team player over a "Rockstar" because knowledge is meant to be shared    

> [@ccmccomb](https://twitter.com/ccmccomb/status/1087845662937546756)  
> Never forget to find room for compassion in computation    

### Programming is about continuous learning

13 replies were literally "Never stop learning"

82 out of 763 tweets talked about learning or practice in some way. **10.7%**

Here are some examples:

> [@iam_js_](https://twitter.com/iam_js_/status/1088153200371355650)  
> There are no shortcuts, practice, practice and more practice    

> [@curtisko](https://twitter.com/curtisko/status/1087725805982093312)  
> You are responsible for continued learning and career progression    

> [@hedgeb](https://twitter.com/hedgeb/status/1087525264140234752)  
> Even if you are just one page ahead in the manual, you can mentor someone and help them along in their journey learning to code    

> [@howbazaar](https://twitter.com/howbazaar/status/1087773774374522881)  
> You are going to keep learning  
> You're not done  
> Being good takes practice  
> Read books, read blogs  
> Don't expect to be great in six months    

### Programming can be intimidating

Many replies reflected this well. There is a lot to learn and a lot you do not know. Looking at experts in the field can be daunting.

27 replies talked about mistakes or failing, 29 about fear, being afraid or scared.

> [@jitterted](https://twitter.com/jitterted/status/1087575050318835712)  
> Don't compare yourself to others, compare yourself to where *you* were in the past.    

> [@greberger](https://twitter.com/greberger/status/1087842355481325574)  
> Never be afraid to say that you don't know something  
> Don't be afraid to ask for help  
> We all suffer(ed) impostor syndrome    

> [@ben_deane](https://twitter.com/ben_deane/status/1087805790423904256)  
> We all make mistakes  
> Try to honestly accept responsibility for your mistakes without being ashamed, and don't put shame on others when they make mistakes    

> [@FiddlersCode](https://twitter.com/FiddlersCode/status/1087619274032721926)  
> Tech is ephemeral but relationships last  
> Get to know your colleagues and yourself emotionally  
> Have the courage to be vulnerable about your struggles  
> Ask for help even if you’re afraid of looking dumb    

### Programming is not just the latest tech

Yes the shiny new library/language/framework is cool. But as many replies showed, the fundamentals mattered much more.

34 replies talked directly about tech, algorithms and focusing on the bigger picture.

> [@bjorn_fahller](https://twitter.com/bjorn_fahller/status/1087439484709490689)  
> Languages and tools come and go.  
> Learn to see patterns that repeat, or rather rhyme, in different languages and libraries and even paradigms.  
> Learn the pros and cons of different techniques, so you can choose wisely for your specific problems.    

> [@aras_p](https://twitter.com/aras_p/status/1087443639750529025)  
> Find area of programming that interests you and do work there.  
> Small incremental tasks - "hey I made screen red! now I made a gradient!", "hey I made button on the page move!" etc.  
> Language, framework, library, "tech stack" does not matter (ignore everyone who say it does).    

> [@rickschott](https://twitter.com/rickschott/status/1087492136331812867)  
> The world needs problem solvers, not memorized algorithms    

### Programming can ask too much of you

Personal health was also a common discussion point. Sleep and eating right were top of the list regarding healthy behaviors.

33 replies talk about sleep, eating, personal health and working hours.

> [@sehurlburt](https://twitter.com/sehurlburt/status/1087448744113684481)  
> Get sleep, eat healthy, take care of your body— even if you feel fine  
> More hours working doesn’t mean better work, it doesn’t even mean more work gets done  
> You don’t have to have your career figured out  
> You don’t need to hit external life milestones to be just fine and happy    

> [@caffodian](https://twitter.com/caffodian/status/1087449579589591044)  
> Take care of yourself physically  
> Yea, actual programming skills are useful, but so is being able to use a mouse without hurting yourself, or being able to sit without back pain, looking at screens without giving yourself headaches, etc    

> [@ArvidGerstmann](https://twitter.com/ArvidGerstmann/status/1087462222551490560)  
> Don't overdo it. Enjoy your god damn life while you can. Signed, a 24 year old who feels like 44.    

> [@ma_lindstedt](https://twitter.com/ma_lindstedt/status/1087683256835809281)  
> Working 100 hour weeks does not mean you are dedicated  
> Take care of your body, speak with managers and be frank  
> Enjoy your spare time so you can deliver your best work every time  
> Hobbies + friends are not mutually exclusive with good work ethics    

### Programming, other interesting replies

The categories above were common themes, but there are some that don't fit into a generalized category but are worth mentioning.

30 replies mention testing

> [@brianokken](https://twitter.com/brianokken/status/1088177245431115776)  
> Learn to ask early these questions:  
> - How do I know it’s working?  
> - How do I automate that?  
> Learning to rely on automated tests ASAP will save them loads of time    

18 replies talk about some kind of version control

> [@UndefinedBehav](https://twitter.com/UndefinedBehav/status/1087441412747128832)  
> Use a version control system  
> I would have love it if someone would have told me before    

14 replies mention debugging

> [@AliBeeGfx](https://twitter.com/AliBeeGfx/status/1087826867363741696)  
> Coding is often like the opposite of the uncertainty principle  
> the only way to have any certainty something is *really* happening is to observe very closely via debugging!    

## Grateful

A thread like this comes once in a blue moon. That so many individuals took their time to reply is beyond comprehension. 

**Thank you to all who replied, re-tweeted and liked.**

I hope the thread inspired you and I hope this blog post helped as well.

> [@ericniebler](https://twitter.com/ericniebler/status/1087447876286869504)  
> Stay humble, stay curious.