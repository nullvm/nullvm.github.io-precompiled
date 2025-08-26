---
title: 'Access Import Anywhere in Python'
date: 2025-08-19T16:50:14+07:00
draft: false
description: ''
tags: ['python']
---


## That One Silly Python Feature Hackers Love (and Devs Hate) 🐍💻

Python is an amazing language. It’s clean, elegant, and super beginner-friendly.

…until you stumble across one of its cursed features and realize **“oh no, this is how hackers get RCE.”**

Today’s silly Python feature:
👉 You can **import literally anything, from anywhere.**



## Wait… I Can Do *That?*

Normally in Python, you import modules at the top like a responsible developer:

```python
import os
os.system("ls")
```

But what if I told you… you can just conjure up imports on the fly, without ever writing `import` at the top?

Yep. Python lets you do this:

```python
os = __import__("os")
os.system("echo hello, world")
```

Boom. No `import os` in sight, but suddenly you’ve got `os` and all its goodies.

This is silly and fun… until you realize it’s also nightmare fuel if your server is evaluating untrusted input.



## Enter the MRO Black Magic 🧙‍♂️

Python has something called the **Method Resolution Order (MRO)**.
It’s basically the order Python looks through classes to find methods/attributes.

Hackers realized: “Wait… if everything in Python is an object… and objects know their classes… and classes know their base classes… can’t we… uh… walk through this graph until we find `__subclasses__` and then pull imports out of thin air?”

Yes. Yes, you can.

Something like this (simplified for the memes):

```python
().__class__.__base__.__subclasses__()
```

That one-liner is like the Konami code for Python internals. From there, attackers can dig up file handles, `os`, `sys`, `subprocess`… whatever they need.



## Why Hackers Love This

If you’ve ever played with:

* **SSTI (Server-Side Template Injection)** in Flask/Jinja2
* **RCE (Remote Code Execution)** on a misconfigured Python service

…then you’ve probably seen this trick in action.

You think you’ve locked down Python?
Nah. Some hacker just did `().__class__.__base__.__subclasses__()[1337]` and spawned a shell on your server.



## But Why Is This a Problem?

Because developers sometimes write *innocent-looking* server code like this:

```python
@app.route("/calc")
def calc():
    return str(eval(request.args.get("expr")))
```

And then wonder why their logs suddenly say:

```
$ curl "http://example.com/calc?expr=__import__('os').system('rm -rf /')"
```

😬



## The Actual Pro Tip

If you’re building anything in Python that runs on the internet:

* 🚫 Never `eval()` user input. Ever.
* 🚫 Never trust template engines to “sanitize for you.”
* ✅ Sanitize, whitelist, and validate everything.
* ✅ Assume hackers *will* try `__import__()` from inside your app.



## Final Thoughts

Python is wonderful… but also cursed.
The fact that you can import modules *without importing them* is equal parts genius and dangerous.

So next time you’re writing a Flask app and think: *“It’s just a tiny eval, what’s the worst that could happen?”* — remember: somewhere out there, a hacker is already typing:

```
__import__('os').system('cat /etc/passwd')
```

…and you just turned your server into their personal playground. 🎢



👉 TL;DR: Python imports are silly, MRO is hacker magic, and you should sanitize your server code before someone “imports chaos.”

