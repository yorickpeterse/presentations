# Rubinius And The Eternal Yak - FOSDEM 2015

A talk I gave at FOSDEM 2015 about the maintenance process of Rubinius, the
problems one will encounter when working on a Ruby implementation and more.

FOSDEM page: <https://fosdem.org/2015/schedule/event/rubinius_and_the_yak/>

## Summary

What exactly does it take to maintain a Ruby implementation? What is the process
of porting over features? Why can this often take a considerable amount of time?
This talk aims to dive into these topics in general but also how it affects
Rubinius.

This talk will focus on what it takes to maintain a Ruby implementation and the
process behind it. While there will be a strong focus on how Rubinius handles
this, most of the topics also apply to other implementations such as JRuby and
Opal. We'll also look into writing tests for Ruby, how this has been handled
historically and why it's so important to have good tests.

One of the examples I'll be showcasing is how `String#scrub`, a new method in
Ruby 2, was implemented in co-operation with Charles Nutter from JRuby and why
this took quite a large amount of time (nearly a month). Another example will be
`Kernel#caller_locations`, a method recently added to Rubinius which highlighted
a potential bug in the implementation of MRI itself.
