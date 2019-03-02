# The Goal

This repo is a set of examples to show the use of the different types of *Test Doubles*:

- dummy
- spy
- mock
- stub
- fake

# Why?
It is difficult to find good examples of Test Doubles in *Plain Ruby*. Instead it is quite easy to find them in *Java*, for instance.   

In Ruby, often you'll find examples that make use of Rspec DSL (Domain Specific Language).

Rspec, and other Test frameworks, are powerful and useful tools, but they blur the type of doubles that we are actually using.
For example, the Rspec keyword *double* can be used to create either a dummy, a stub or a spy.

A good way to clarify which Double to use in which occasion is to write one by one the various examples.

# Where should I start?
The examples here aim to test the control algorithm for launching a missile using all possible type of Doubles.

These are based on the blog post *The Test Double Rule of Thumb*, so you should start to read it: 
[The Test Double Rule of Thumb](http://engineering.pivotal.io/post/the-test-double-rule-of-thumb/).

I suggest you to proceed this way:

- Read the first block of the post, until the first test
- Rewrite the test in Ruby, and run it
- Your test is Red, of course! Make it pass using the suggested Test double (for the first test is a Dummy)
- Go on reading the next requirement and the write the next test ...

Code and have fun :)

---

This was created during a [Mob programming](https://www.google.com/search?q=mob+programming) session at [MadeTech](https://learn.madetech.com/)
