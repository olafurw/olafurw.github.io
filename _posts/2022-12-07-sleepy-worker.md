---
layout: post
title: Blogvent 7 - Sleepy worker
tags: [programming, learning, c++, blogvent]
comments: false
---

What's a nap between friends?

[What is Blogvent?](/2022-11-27-blogvent-calendar/) (**tl;dr** I am going to write one post a day for all of December as a way to practice writing.)

I had this silly idea today. What if you had a `Worker` class in C++ where you would interact with them like this.

```cpp
int main()
{
    Worker worker;

    // some time passes

    worker.give_work({ 1,2,3,4,5 });

    // some time passes

    worker.give_work({ 1,2,3,4,5 });

    // some time passes
    // we are now ready for the worker to work

    worker.wake_up();

    // we wait until worker is sleeping again
    // because if the worker is sleeping, the work is done.
    while(!worker.is_asleep())
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    const int results{ worker.get_results() };

    // some time passes, we use result
    // we are done, let's destruct

    return 0;
}
```

So a worker that has it's own thread(s) and it's collecting data given by someone else but it's technically asleep. Then you wake up the worker, and after it's been woken up it performs the work. We then check if the worker is back to being asleep because then the work is done.

It's the real world equivalent of putting a bunch of boxes in front of a sleeping worker, then yelling "Naptime's over!" and then waiting for them to finish working.

## Why?

- Are there any use cases for this? ¯\\_(ツ)\_/¯
- Doesn't this already exist? Oh probably, and most likely much better done and tested.
- Why did you write this? As with many things, I get a silly idea and I do the exercise. Useful or not for someone else is a secondary objective, it's always useful for me to practice programming.

## Implementation

Here's a quick implementation I did just before writing this blog post. Assume it has errors and threading problems (at least tsan and ubsan didn't complain).

The comments are mostly for people reading this blog post, not as normal code comments.

The header is pretty straight forward and I liked this idea of a bed. The data doesn't matter much, it's a representation of something we do.

```c++
struct Worker
{
private:
    // the thread we will be working on
    std::jthread thread;

    // Our "bed"
    // we will use this to indicate if we're awake
    // and can be used to wake us up.
    std::condition_variable cv;
    mutable std::mutex mtx;
    bool sleeping{ false };

    // the data we're working on, just something.
    std::vector<int> data;
    int results{ 0 };

    // where the thread will run
    // and the function to perform the work
    void operator()(std::stop_token token);
    void perform_work();

public:
    Worker();
    ~Worker();

    // sleeping related functions
    bool is_asleep() const;
    void wake_up();

    // work related functions
    void give_work(const std::vector<int>& incoming_data);
    int get_results() const;
};
```

Here we have the constructor and some of the utility member functions. They're a relatively basic use of [condition_variable](https://en.cppreference.com/w/cpp/thread/condition_variable) and [locks](https://en.cppreference.com/w/cpp/thread/unique_lock) but can be illustrative for people who haven't used them much.

```cpp
// Here we're using the new std::bind_front to start the thread
// using the call operator and this instance.
// I never like the feeling of using this in a constructor but 
// in this case it's ... ok.
Worker::Worker()
{
    thread = std::jthread(std::bind_front(&Worker::operator(), this));
}

// We need to wake up the worker to tell them that
// the workday is over, seems logical :D
Worker::~Worker()
{
    thread.request_stop();
    wake_up();
}

// This one we use to check the status of the worker
// Where the idea is always sleeping = previous work done
bool Worker::is_asleep() const
{
    std::unique_lock lck{ mtx };
    return sleeping;
}

// Grab a brush and put a little make-up
// We're no longer sleeping and we notify the cv to continue.
void Worker::wake_up()
{
    std::unique_lock lck{ mtx };
    sleeping = false;
    cv.notify_one();
}
```

Then we have the work related functions. Data in/Data out. Here 'work' is us adding all of the numbers in the vector and then clearing the it.

```cpp
// Some method to give the worker data
void Worker::give_work(const std::vector<int>& incoming_data)
{
    std::unique_lock lck{ mtx };
    data.insert(std::end(data), std::begin(incoming_data), std::end(incoming_data));
}

// Some method to get results from the worker
int Worker::get_results() const
{
    std::unique_lock lck{ mtx };
    return results;
}

// Some work the worker has to perform.
void Worker::perform_work()
{
    results = std::accumulate(data.cbegin(), data.cend(), 0);
    data.clear();
}
```

Then we have the actual thread loop.

```cpp
void Worker::operator()(std::stop_token token)
{
    // we start by being asleep
    // we're such a good worker, right?
    {
        std::unique_lock lck{ mtx };
        sleeping = true;
    }

    while (true)
    {
        // we enter the loop, fetch the mutex and wait
        // on the condition variable to trigger
        // here we want it to trigger on someone waking us up
        std::unique_lock lck{ mtx };
        cv.wait(lck, [&]{ return sleeping == false; });

        // if someone asked for us to stop working
        // while we were asleep, then we quit the loop
        if (token.stop_requested())
        {
            break;
        }

        // otherwise we're here because someone woke us up
        // how rude, ok, but let's perform that work.
        perform_work();

        // ok work done, let's go back to sleep.
        sleeping = true;
    }
}
```

Most of it ended up being vanilla uses for mutexes and condition variables but a good exercise anyway. Here is an example output where I added some print statements for each of the steps (x is main thread, o is worker thread).

![worker](/img/worker.png "x: starting
o: starting
o: sleeping
o: got work
o: got work
o: wake_up
o: is_asleep
o: was woken up
o: performing work
o: back to sleep
o: sleeping
o: is_asleep
x: results 30
x: sleep done bye
o: wake_up
o: stop requested, stopping")

## Summary

So that's it?

Well here's the point I wanted to make. I had this idea today. "What if there was a `std::nap` for thread workers?" then that turned into "How would an interface towards such a worker look like?" and "Can I make the interface look like someone waking up a sleeping worker?"

Having an idea, thinking about it's execution, trying to come up with a solution. This is a very fundamental part of practicing to become a better programmer.

Practice something today.