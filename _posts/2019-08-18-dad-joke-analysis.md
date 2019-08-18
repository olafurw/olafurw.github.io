---
layout: post
title: Dad Joke Analysis
tags: [programming, analysis, python, jokes]
comments: false
---

What is the most common dad joke? What pun is the most worthy of posting?

Join me on this useless and odd journey!

## Why?

I really love dad jokes and similar puns.

I also love analysing big chunks of data.

...soooo let's go!

## Where's the data?

There is a subreddit called [/r/dadjokes](https://www.reddit.com/r/dadjokes/) that has been a bastion of bad jokes since 2011. Most of the jokes posted there have the initial bit of the joke in the title and then the punchline in the body (or selftext as reddit calls it).

![joke-1](/img/joke1.png)

Oof that's a groaner.

Then I had this idea.

Let's just download all of them. Easy right? Right.

## Again, where's the data?

There's a python library called [psaw](https://github.com/dmarx/psaw) which is a wrapper around the [pushshift.io](https://pushshift.io/) API's

With that library I could setup something like this.

```python
from psaw import PushshiftAPI
import datetime as dt
import time

api = PushshiftAPI()

# Start here and go backwards
start_epoch = int(dt.datetime(2019, 8, 18).timestamp())

for i in range(500):
    # Generator that will only give you 2000 at a time
    joke_list = api.search_submissions(before = start_epoch,
                                        subreddit = 'dadjokes',
                                        filter = ['id', 'title','selftext', 'score'],
                                        limit = 2000)

    for joke in joke_list:
        # Some posts don't have .selftext
        selftext = ""
        if hasattr(joke, "selftext"):
            selftext = joke.selftext.replace("\n", " ")

        # Dump that out to be piped into a file
        # ||| for quick simple parsing later
        print(joke.created_utc, "|||", joke.id, "|||", joke.score, "|||", joke.title, "|||", selftext)

        # next search to start where the last entry
        start_epoch = joke.created_utc
    
    # be nice to rate limits
    time.sleep(2)
```

I ran this, saw it was giving me sensible results, then I set it to fetch a million jokes and went to get dinner.

I arrived back to a script that had finished running.

How many jokes? - 157.266, all the way back to the first joke posted in 2011.

Awesome, that's a nice little data set!

## But first

Obviously the first thing I had to do was to run all the jokes through a markov chain generator. I used [markovify](https://github.com/jsvine/markovify) for this because it's the quickest way. I even used their "Basic Usage" example almost verbatim.

Ready to read some markov chain generated dad jokes? Most of them are bad. The ones I picked here were the ones that made sense and none of them have a punchline.

> Why washing machine instead of giving me cannons. Things didnt work out.

> Knock, Knock. Our local TV weatherman broke both her arms?

> What the difference between a piano, and an empty plate in the knees, and naturally, he was Finnish.

> Any guy who invented the knock knock joke, shouldve been a post earlier about the wheels.

> Did you hear about the hard-working mechanic who specializes in small groups

> Dad: Sure, wheres the punchline?

## Ok enough nonsense

Right. Here's my idea.

Most jokes have a similar structure. Setup and punchline.

Let's look at a common joke.

> How do you find Will Smith in the snow? You look for fresh prints!

So this joke starts with a common setup. "How do you..." and then the punchline is the last couple of words, here it's "fresh prints"

## Cleanup

We might get somewhere if we only look at the first three words of the joke. But first we need to cleanup the text.

I created a simple class to create some structure to the joke.

```python
class Joke:
    def __init__(self, aTimestamp, aId, aScore, aJoke):
        self.myTimestamp = aTimestamp
        self.myId = aId
        self.myScore = aScore
        self.myJoke = aJoke.strip()
```

And then I read in the `jokes.txt` file generated before to create an array of jokes.

```python
jokes = []

with open("jokes.txt") as myFile:
    for line in myFile:
        s = line.split(" ||| ")

        # a couple of jokes parsed badly, let's just ignore them
        if len(s) < 4:
            continue

        j = Joke(s[0], s[1], s[2], s[3] + " " + s[4])
        jokes.append(j)
```

You'll see here that I treat the setup and punchline as the same string, it's not a very reliable seperation to look at title and selftext, so I combine them.

To cleanup the text I use a few methods.

I tokenize the joke using `nltk.tokenize.word_tokenize`

```python
from nltk.tokenize import word_tokenize

words = word_tokenize(self.myJoke)
```

I use `string.punctuation` to translate any punctuation to an empty string.

```python
import string

punktTable = str.maketrans('', '', string.punctuation)
strippedWords = list(filter(None, [w.translate(punktTable) for w in words]))
```

And lastly I use `nltk.stem.snowball.SnowballStemmer` to stem each word. This helps immensly when you want to group together similar sentences.

```python
from nltk.stem.snowball import SnowballStemmer

stemmer = SnowballStemmer("english")

stemmedJoke = []
for word in strippedWords:
    stemmedJoke.append(stemmer.stem(word))
```

## Setup

When this is done, the first three items in the list `stemmedJoke` are the cleaned up first three words of the joke.

Let's join those words together, print them out and count the occurance of each triplet.

Here is the top 10.

```
   7898 what_do_you
   2632 what_did_the
   2629 did_you_hear
   2159 whi_did_the
   1667 how_do_you
    806 what_the_differ
    725 what_kind_of
    663 what_is_the
    561 did_you_know
    543 what_doe_a
```

So 7898 jokes start with "What do you...", followed pretty far behind with "What did the..." and "Did you hear..."

This is the stemmed version, which explains why one of them says "differ" and not "difference"

## Punchline

What if we do the exact same thing but for the last 3 words of the joke? Here is the top 20 most common with a version of the joke/jokes below each entry.

```
    172 sticki_a_stick
Whats brown and sticky? A stick.

    168 out_of_it
How do you make holy water? By boiling the hell out of it
I used to be a very small kid But i grew out of it

    150 in_his_field
Why did the scarecrow win an award? For being outstanding in his field

    142 grow_on_me
Ive gotten pretty attached to my beard. Its really starting to grow on me

    120 all_of_them
Hey dad, did you get a haircut? No son, they cut all of them
How many apples grow on a tree? all of them
How many dead people do you think are in the cemetary? Hopefully all of them

    115 medium_at_larg
What do you call a midget psychic on the run from the law? 
A small medium at large

    114 see_that_well
Why did the blind man fall down the well? He couldnt see that well

    113 get_in_there
Thats a nice cemetery, I hear people are dying to get in there

    106 have_2020_vision
I dont know where I see myself in a year. I dont have 20/20 vision

     94 waist_of_time
What do you call a belt made from a watch? A waist of time

     93 he_woke_up
Did you hear about the kidnapping at school? Its ok he woke up

     93 a_dad_joke
* This isn't a joke, it's mostly people ending the joke by saying
* something like "I made a dad joke"

     87 to_get_in
Thats a nice cemetery, I hear people are dying to get in
* Same as the one above, just skipping "there"

     85 trip_all_day
I bought some shoes from a drug dealer.. I dont really know 
what he laced them up with, but I was tripping all day

     85 do_he_laugh
I dont always tell dad jokes... ...but when I do, he laughs

     85 a_littl_lighter
Whats the difference between a hippo and a Zippo?
Ones heavy, ones a little lighter

     83 them_all_cut
Hey dad, did you get a haircut? No son, I got them all cut
* Same as above, but the ending is worded differently

     81 make_up_everyth
Never trust an atom. They make up everything

     76 a_chicken_sedan
Why does a chicken coup only have 2 doors? 
Because, if it had 4 doors it would be a chicken sedan

     74 food_no_atmospher
Have you heard about the restaurant on the moon? 
Great food, no atmosphere
```

## Copy paste

Some of the jokes are impressively copy pasted, to the letter.

Here's `"I dont always tell dad jokes... ...but when I do, he laughs"` but I'm only searching for `"he laughs"`

![joke-copy](/img/joke-copy.png)

Yeah, it has been posted before, sorry.

## Conclusion

I don't think there is one, this was mostly for me. If you want the data set, yell at me on twitter and we'll figure something out.

Later.