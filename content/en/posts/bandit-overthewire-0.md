---
title: 'OverTheWire Bandit 0'
date: 2025-01-29T17:29:28+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

I'm currently doing Bandit wargames in [overthewire](https://overthewire.org/) website,
while doing so I want to share my journey here.

First level, it's Level 0. The goal is to connect to the game server using
ssh. This one is pretty straightforward, the only obstacle here is knowing
how to use ssh.

Since I'm in a linux machine, I can easily read the manpage for `ssh` command.

The instruction for Level 0 is the following:

> The goal of this level is for you to log into the game using SSH. The host to which you need to connect is bandit.labs.overthewire.org, on port 2220. The username is bandit0 and the password is bandit0. Once logged in, go to the Level 1 page to find out how to beat Level 1.

I connect to the game server using the following command:

```bash
ssh bandit0@labs.overthewire.org -p 2220
```

They then ask for password. I typed in `bandit0` and connected to the game server successfully.

Level 0 finished. See you next time.

Stay safe.
