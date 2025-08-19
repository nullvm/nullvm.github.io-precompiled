---
title: 'Understanding Python’s Method Resolution Order (MRO) Without Losing Your Sanity'
date: 2025-08-19T16:30:43+07:00
draft: false
description: ''
tags: ['python']
---

Python loves inheritance. You can make classes inherit from other classes, those classes inherit from others, and suddenly you’ve got a full-blown family tree that looks like someone spilled spaghetti on your UML diagram. And then you run into the question: *when I call a method, which ancestor actually answers the call?*

That’s where **MRO (Method Resolution Order)** comes in. Think of it like `ls` for Python’s class hierarchy—it shows you the exact path Python will take when looking for a method. No more guessing which `def speak()` gets invoked when you’ve got five grandparents fighting for attention.



## The Basics

Python is object-oriented, meaning you can create classes, inherit from them, and override their behavior. But when you’ve got multiple inheritance (aka the diamond problem’s evil cousin), things get spicy.

When you call a method, Python doesn’t just randomly pick one like a dodgy RNG—it follows the **C3 linearization algorithm**. That’s a fancy name for “a set of rules that decide which class is checked first, second, third, and so on.”



## Accessing MRO

You can inspect the Method Resolution Order in two ways:

* `__mro__` attribute (tuple of classes)
* `mro()` method (returns a list)

They both spill the same beans; one’s just slightly more Pythonic to read.



## Example Time

```python
class A:
    def speak(self):
        return "A"
    
class B(A):
    pass

class C(A):
    def speak(self): 
        return "C"
    
class D(B, C):
    pass

if __name__ == "__main__":
    print(D.__mro__)
```

Running this gives:

```bash
(
    <class '__main__.D'>,
    <class '__main__.B'>,
    <class '__main__.C'>,
    <class '__main__.A'>,
    <class 'object'>
)
```



## What Just Happened?

Notice something weird?
Class **C** *does* have its own `speak()` method, but Python checks **B** before **C**, because when defining `class D(B, C)`, we listed `B` first. So Python politely knocks on `B`’s door before asking `C`. Since `B` doesn’t override `speak()`, it continues down the chain and finds `C`.

The rule of thumb: **the order in your inheritance list matters**. If you inherit from `B, C`, then Python tries `B` first, then `C`. If you flip them to `C, B`, the story changes.



## Why Should You Care?

If you’re just subclassing one class, MRO is basically a non-issue. But once you’ve got multiple inheritance, especially those diamond-shaped hierarchies, debugging without understanding MRO is like trying to resolve merge conflicts while half-asleep.

Knowing MRO saves you from late-night “why the hell is it calling *that* method” moments.

Pro tip: If you’re ever lost, just `print(SomeClass.mro())` and you’ll see the exact search path. Treat it like `traceroute` for methods.



## Afterword

Think of MRO like your package manager:

* `apt` (Python) has strict rules to decide dependencies.
* You don’t always agree with them.
* But if you fight it, your whole system breaks.

So… just trust the algorithm. It’s smarter than you, me, and probably most of Stack Overflow combined.
