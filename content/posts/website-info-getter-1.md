---
title: 'WebInfo GET - log 1'
date: 2026-06-24T23:05:59+07:00
draft: false
description: ''
tags: ['python', 'http']
---

It's been a while since I do programming, I lost motivation and
goal this past few months, I don't know what I want to do with
programming.

Well, here I am, starting out new project. I won't say anything
much about this project or what this goal is. What's important
is that I want to use this project to satisfy my programming
curiosity and made softwares that I actually use. Hope anyone
reading this find it helpful.

### checkpoint

here is the full code, currently tidying up my github repositories
and starting new.

```python
import httpx

r = httpx.get("https://news.ycombinator.com/")

with open("output/ycom1.html", "w") as fp:
    fp.write(r.text)

for i in range(2, 11):
    r = httpx.get(f"https://news.ycombinator.com/?p={i}")
    with open(f"output/ycom{i}.html", "w") as fp:
        fp.write(r.text)
```

what i want to build here is basically a python script that will
scrape certain information from some websites and put it in a file.

i still haven't parse or reformat the output, i want to force myself
to report anything about my project so that it will also force me
to keep checking and updating it.

i'm planning on doing 2 requests per day on fixed list of websites. it
would be more or less websites about programming, gacha games and anime.