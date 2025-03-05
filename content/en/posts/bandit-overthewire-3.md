---
title: 'OverTheWire Bandit 3'
date: 2025-02-04T19:04:51+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

This is level 2 -> level 3 in the bandit wargame from [overthewire.org](https://overthewire.org).

Not so much different from the [previous level](./bandit-overthewire-2.md), the
password for the next level is stored inside a file.

Let's see the level goal:

> The password for the next level is stored in a file called **spaces in this filename** located in the home directory

You notice that the filename contains space, so to view the content of
the file we need to surround it with double quote or single quote, or we
can escape the space character using backslash.

So there are three ways to do this.

Using double quotes.

```bash
cat "spaces in this filename"
```

Using single quotes.

```bash
cat 'spaces in this filename'
```

Escaping space characters.

```bash
cat spaces\ in\ this\ filename
```

I prefer using the double quotes by the way since it look nicer and easier to read.

Level completed.

See you on the next one.

Stay safe.
