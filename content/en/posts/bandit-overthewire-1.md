---
title: 'OverTheWire Bandit 1'
date: 2025-01-30T19:23:27+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

After getting the password from Level 0, I connected to Level 1.

Here is the level goal by the way.

> The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game.

This one is pretty straightforward.

Once I logged in to the game server, my current working directory is at `~` or
in other word, the home directory.

I typed `ls` to list the current directory and there is a file named `readme`.

Using `cat`, I retrieved the password for Level 2.

And that's it. See you on the next one.

Stay safe.
