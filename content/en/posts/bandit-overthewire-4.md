---
title: 'OverTheWire Bandit 4'
date: 2025-02-05T18:33:27+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

Continuing with level 3 -> level 4. The password is
stored in a file, somewhere on the server.

Here is the level goal.

> The password for the next level is stored in a hidden file in the **inhere** directory.

Hidden file is a file named beginning with dot. It won't be displayed using
`ls` command. You need to add `-a` flag to display hidden file. Naming directory
beginning with dot will also makes it hidden.

After logged in to the game server, change directory to **inhere** and then do `ls -a`.
There will be a hidden file containing password for the next level.

```bash
cd inhere
ls -a
```

Level done. I'll see you on the next one.

Stay safe.
