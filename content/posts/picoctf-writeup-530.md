---
title: 'PicoCTF Writeup #530'
date: 2025-10-17T21:47:29+07:00
draft: false
description: ''
tags: ['ctf', 'forensics']
---

Challenge: [Riddle Registry](https://play.picoctf.org/practice/challenge/530)

Every digital file has a story to tell — some louder than others.
In this **picoCTF forensics challenge**, our mission was simple on paper (pun intended): *find the flag hidden inside a PDF file.*

Of course, as any seasoned Linux user knows, “simple” often means “prepare for several hours of creative command-line archaeology.”



## The Setup

> **Challenge:** A suspicious-looking PDF file
> **Goal:** Find the flag
> **Category:** Forensics

Opening the file showed nothing but Lorem Ipsum text and some odd blank spaces. That’s usually a hint in CTFs — if you can’t see it, it’s probably hidden somewhere else.

So, naturally, the investigation began in the terminal.



## The Usual Reconnaissance

Before getting fancy, it’s always good practice to try the basic Linux toolkit.

```bash
cat confidential.pdf
```

Result:
Gibberish. PDFs are structured binary files, not meant for casual `cat`-based reading (unless you enjoy visual noise).

Let’s check for readable strings that might contain the flag:

```bash
strings confidential.pdf | grep picoCTF
```

No hits. So the flag isn’t sitting in plain text. Time to go beyond surface-level inspection.



## Thinking Like a Forensic Analyst

In digital forensics, **metadata** is often where the interesting details live — information about *who*, *when*, and *how* a file was created.
A quick read through the CTF handbook reminded me of a particularly handy tool for this kind of investigation:

> `exiftool` — because sometimes the most useful information is what the file *says about itself.*



## Running `exiftool`

Let’s extract everything the PDF is willing to confess:

```bash
exiftool confidential.pdf
```

Here’s the relevant part of the output:

```
ExifTool Version Number         : 13.25
File Name                       : confidential.pdf
File Type                       : PDF
Producer                        : PyPDF2
Author                          : cGljb0NURntwdXp6bDNkX20zdGFkYXRhX2YwdW5kIV9jMjA3MzY2OX0=
```

Most of that looks ordinary — until we notice the **Author** field.
That string looks suspiciously like **Base64**.



## Decoding the Secret

When you see something that looks encoded, don’t guess — decode:

```bash
echo "cGljb0NURntwdXp6bDNkX20zdGFkYXRhX2YwdW5kIV9jMjA3MzY2OX0=" | base64 -d
```

Output:

```
picoCTF{puzzl3d_m3tadata_f0und!_c2073669}
```

And there it is — the hidden flag.



## Lessons Learned

This challenge reinforces a few key takeaways for forensic work and CTFs alike:

* Metadata often holds more value than visible content.
* `exiftool` is indispensable for analyzing files of all types (images, PDFs, audio, etc.).
* Don’t assume the answer will always be embedded in the main content — sometimes it’s right there in the file properties.



## TL;DR Summary

| Step | Command                                    | Purpose                       |
| ---- | ------------------------------------------ | ----------------------------- |
| 1    | `strings confidential.pdf \| grep picoCTF` | Quick check for visible flags |
| 2    | `exiftool confidential.pdf`                | Extract metadata              |
| 3    | `echo "<base64>" \| base64 -d`             | Decode Base64-encoded data    |



## Final Thoughts

CTFs have a way of reminding us that **curiosity is a technical skill**.
Sometimes the most efficient debugging tool isn’t a debugger — it’s simply asking, *“What else could this file be hiding?”*

When in doubt, let the metadata speak.
After all, as any good investigator knows: **the evidence is usually already in the file — you just need to ask the right command.**
