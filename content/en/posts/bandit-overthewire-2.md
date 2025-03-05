---
title: OverTheWire Bandit 2
date: 2025-01-31T18:03:42+07:00
draft: false
description: ''
tags: ['programming', 'cybersecurity']
---

Continue to Level 2. Here is the level goal:

> The password for the next level is stored in a file called - located in the home directory

I connected to the game server using the password from the previous level.
The file needed to get the password for the next level is located at the
home directory, so I just typed in:

```bash
cat ./-
```

And the content get printed.

If I typed `cat -` the content inside `-` file won't be printed since typing
`cat -` means the `cat` command will read from **standard input**.

Another way of reading dashed filename is by typing

```bash
cat < -
```

Which means the `cat` command will take input from `-` file.

For more information, search for "dashed filename" in Google or read [this discussion.](https://stackoverflow.com/questions/42187323/how-to-open-a-dashed-filename-using-terminal)

That's it for Level 2.

See you on the next one.

Stay safe.
