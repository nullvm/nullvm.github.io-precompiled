---
title: 'PicoCTF Writeup #505'
date: 2025-08-19T11:27:28+07:00
draft: false
description: ''
tags: ['ctf', 'forensics']
---

## PicoCTF Writeup – Forensics Disk Image

Challenge: [Disk, disk, sleuth!](https://play.picoctf.org/practice/challenge/505)

> **Description:**
> Can you find the flag in this disk image?
> Download the disk image [here](https://artifacts.picoctf.net/c/536/disko-1.dd.gz).


## First Thoughts

This challenge was tagged **forensics**, which usually means poking around filesystems, memory dumps, or raw disk images. The goal is to extract hidden information — in this case, the flag.

I grabbed the disk image (`disko-1.dd`) and started experimenting.


## Initial Attempts

My first instinct was to take a look at the raw hex using `xxd`:

```bash
xxd disko-1.dd | less
```

I did see some readable text, like:

```
This is not a bootable disk. Please insert a bootable floppy
and .. press any key to try to gain...
```

But nothing that looked like a flag. At this point, I also tried mounting the image as a loop device, but it didn’t yield anything useful either.


## Switching Gears

Since the flag format is predictable (`picoCTF{...}`), a simpler approach came to mind: just dump all printable text and grep for the flag.

On Linux, `strings` is perfect for this:

```bash
strings disko-1.dd | grep -i picoCTF
```

And sure enough, the flag popped out.


## The Flag

```
picoCTF{1t5_ju5t_4_5tr1n9_c63b02ef}
```


## Takeaways

* Forensics challenges don’t always require fancy tools — sometimes the classic Unix pipeline (`strings | grep`) is all you need.
* Recognizing patterns (like `picoCTF{}`) can save you from wasting time on dead ends.
* Always start simple before diving into heavy forensic frameworks.
