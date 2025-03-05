---
title: 'OverTheWire Bandit 5'
date: 2025-02-05T18:42:50+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

This is level 4 -> level 5 of bandit wargame from overthewire.

Password stored in a file somewhere on the server. Here is the goal
level.

> The password for the next level is stored in the only human-readable 
> file in the **inhere** directory. Tip: if your terminal is messed up,
> try the “reset” command.

So logged in to the game server. Change directory to **inhere**.
You will find a lot of files with similar names that has increasing number
at the end of its name.

There are `-file00` to `-file09`.

It's not that many files and you can manually check the content
one by one. However, doing it programmatically is more fun, and practical.

Here is how to do it.

```bash
cat ./-file0{0..9}
```

Which will tell bash to `cat` file from `-file00` to `-file09`.

Read [this article](https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/) from cyberciti about bash for loop.

The only human-readable is the password for the next level.

I'll see you on the next one.

Stay safe.
