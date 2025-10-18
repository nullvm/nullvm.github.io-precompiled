---
title: 'PicoCTF Writeup #527'
date: 2025-10-18T14:19:19+07:00
draft: false
description: ''
tags: ['ctf', 'forensics']
---

Challenge: [Log Hunt](https://play.picoctf.org/practice/challenge/527)

Short version: a plain text server log contained the flag split across repeated log entries. A few simple POSIX utilities (`grep`, `awk`, `uniq`, `head`, `tr`) and a tiny bit of shell plumbing reveal the flag. Below is a clean, reproducible walk-through with explicit command explanations so you know not only *what* to run, but *why* each step works.



## Setup and file inspection

Download the provided file:

```
https://challenge-files.picoCTF.net/c_saffron_estate/1a0b2a2a67149850cd0e6d34da005c381bbbed4c558e529fec8b3be3f8619046/server.log
```

Open a terminal and inspect the file with some basics:

```bash
# show the file on stdout (quick look)
cat server.log

# count lines to get a sense of file size / structure
wc -l server.log

# open interactively if you want to browse / search manually
vim server.log
```

**Why these commands?**

* `cat file` streams the entire file to stdout. Good for quick checks or piping into other tools.
* `wc -l file` prints the number of lines, which helps estimate scale (useful for deciding whether to script or manual inspect).
* `vim file` (or `less`) is for interactive exploration — search, jump to line numbers, etc.



## Pattern search: grep for likely candidates

We’re looking for a flag; common picoCTF flags often contain the string `picoCTF`. Use `grep` to find lines that mention that substring:

```bash
# case-insensitive search, show line numbers
cat server.log | grep -i -n pico
```

* `grep -i` : case-insensitive match.
* `-n` : prefix each matching line with its line number (handy for references).
* Piping `cat` into `grep` is functionally equivalent to `grep -i -n pico server.log`. Either is fine; the pipe form is explicit about "streaming the file into the next tool".

Output (excerpted):

```
1:[1990-08-09 10:00:10] INFO FLAGPART: picoCTF{us3_
728:[1990-08-09 11:04:27] INFO FLAGPART: picoCTF{us3_
729:[1990-08-09 11:04:29] INFO FLAGPART: picoCTF{us3_
...
1546:[1990-08-09 12:19:32] INFO FLAGPART: picoCTF{us3_
```

So: the log contains entries that include `FLAGPART` and fragments that look like parts of a flag. There are duplicates — typical in logs that repeat events.



## Narrow the matches by keyword

Search explicitly for the `FLAGPART` tag so we don’t pull unrelated `pico` mentions:

```bash
cat server.log | grep -i flagpart
```

This returns lines like:

```
[1990-08-09 10:00:10] INFO FLAGPART: picoCTF{us3_
[1990-08-09 10:02:55] INFO FLAGPART: y0urlinux_
[1990-08-09 10:05:54] INFO FLAGPART: sk1lls_
...
[1990-08-09 10:10:54] INFO FLAGPART: cedfa5fb}
```

Each relevant line follows the same pattern: a timestamp, a log level, a tag `FLAGPART:`, and then the fragment we care about. That regular structure lets us extract the fragment reliably.



## Extract the fragment/token using awk

We only want the token after `FLAGPART:`. The log is whitespace-separated, so the fragment is the fifth whitespace-delimited field. Use `awk` to print that field:

```bash
cat server.log | grep -i flagpart | awk '{print $5}'
```

Explanation:

* `awk` processes each line and `{print $5}` outputs the 5th space-separated field.
* Field counting in `awk` starts at `$1` for the first token.

Output (excerpt):

```
picoCTF{us3_
y0urlinux_
sk1lls_
sk1lls_
cedfa5fb}
...
```

You can see the flag is already split into ordered fragments (including underscores and the closing brace in the last fragment).



## De-duplicate noisy repeats with uniq

Logs often contain repeated entries. `uniq` removes *adjacent* duplicate lines. Combine it with the previous pipeline:

```bash
cat server.log | grep -i flagpart | awk '{print $5}' | uniq
```

Important nuance: `uniq` only collapses **consecutive** duplicate lines. If the same fragment appears in separate parts of the file separated by other content, `uniq` will not remove the non-adjacent duplicates. That’s why you may still see repeated groups when you run `uniq` on the whole output — the log contains repeating blocks, not one big contiguous block of duplicates.

In this case the output shows repeated groups like:

```
picoCTF{us3_
y0urlinux_
sk1lls_
cedfa5fb}
picoCTF{us3_
y0urlinux_
sk1lls_
cedfa5fb}
...
```

We only need one instance of each part, in order.



## Take the first (ordered) set of fragments

Since the repeated pattern appears in blocks and the first block is the earliest complete set, we can take the top four unique fragments with `head`:

```bash
cat server.log | grep -i flagpart | awk '{print $5}' | uniq | head -n 4
```

* `head -n 4` selects the first four lines. That gives the sequence of pieces that form the flag.

Result:

```
picoCTF{us3_
y0urlinux_
sk1lls_
cedfa5fb}
```

These are the pieces in order.



## Reassemble the pieces into a single string

Now combine the lines into one continuous string. The original steps use `tr '\n' '\0'` which replaces newlines with NUL characters. NULs are invisible on the terminal, and some tools treat or display them differently. A more straightforward approach is removing newlines entirely:

```bash
cat server.log | grep -i flagpart | awk '{print $5}' | uniq | head -n 4 | tr -d '\n'
```

Explanation of `tr` usage:

* `tr -d '\n'` deletes newline characters, concatenating the lines into one string.
* The earlier `tr '\n' '\0'` replaces newlines with NUL bytes; that also yields a single line visually, but produces NUL bytes in the output stream which may be undesirable for further processing.

Running the `tr -d '\n'` pipeline yields:

```
picoCTF{us3_y0urlinux_sk1lls_cedfa5fb}
```

That is the flag.

(If you prefer a NUL-separated result for machine consumption, `tr '\n' '\0'` is acceptable — just be aware that NULs are non-printable and can confuse some tools.)



## Compact full pipeline

One compact, readable pipeline that reproduces the steps:

```bash
grep -i flagpart server.log \
  | awk '{print $5}' \
  | uniq \
  | head -n 4 \
  | tr -d '\n'
```

Notes:

* `grep -i flagpart server.log` is equivalent to `cat server.log | grep -i flagpart` but avoids the extra `cat`.
* The pipeline is composed of small tools, each doing one thing: find lines, extract the field, remove adjacent duplicates, choose the first block, and concatenate.



## Final result (flag)

```
picoCTF{us3_y0urlinux_sk1lls_cedfa5fb}
```



## Postmortem / tips

* `awk` by default splits on runs of whitespace (spaces, tabs). If lines contain variable spacing or you need a different delimiter, use `awk -F` or `cut -d` accordingly.
* `uniq` only collapses **adjacent** duplicates. If you need to remove all duplicates regardless of order/position, combine `sort -u` (but sorting will change order) or use `awk`/`perl` to keep first occurrence while preserving order.
* When joining lines:

  * `tr -d '\n'` removes newlines (simple and portable).
  * `paste -sd '' -` concatenates preserving order.
  * `xargs -n1 echo -n` also works.
* Prefer `grep pattern file` over `cat file | grep pattern` unless you need to pre-process the stream; avoid the useless use of `cat`.



## Closing thought

The challenge is an example of “small utilities, big results.” Logs are structured data — once you recognize the pattern and pick the right token (field), standard text tools will get you to the answer quickly. This is exactly the kind of problem that rewards pattern recognition and knowing which tiny tool to apply next.
