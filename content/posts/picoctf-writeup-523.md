---
title: 'PicoCTF Writeup #523'
date: 2025-10-18T14:33:57+07:00
draft: false
description: ''
tags: ['ctf']
---

Challenge: [Flag in Flame](https://play.picoctf.org/practice/challenge/523)


This picoCTF challenge demonstrates how easily data can be disguised by simple encoding. The “log file” provided is not a log at all, but a Base64-encoded PNG image that contains the flag written as hexadecimal text.



## Download and initial inspection

Start by downloading the provided file (for example, with `wget` or `curl`):

```bash
wget https://challenge-files.picoctf.net/c_saffron_estate/<filename>/logs.txt
```

or

```bash
curl -O https://challenge-files.picoctf.net/c_saffron_estate/<filename>/logs.txt
```

Before assuming it’s truly a text log, inspect it with a quick `cat`:

```bash
cat logs.txt
```

You’ll see a single, long Base64-encoded line — not the usual multi-line server or system log. That’s our first clue.



## Decode the Base64 content

Base64 encoding is a common way to hide or serialize binary data as plain text. Let’s decode it:

```bash
base64 -d logs.txt > dump
```

Explanation:

* `base64 -d` (or `--decode`) decodes Base64-encoded text.
* `> dump` redirects the binary output into a new file named `dump`.

  * Redirecting is important because the output is binary data (not human-readable) — printing it directly to the terminal would produce gibberish or control characters.



## Identify the decoded file type

Now we need to find out what this newly created `dump` file actually is:

```bash
file dump
```

Output (abbreviated):

```
dump: PNG image data, ...
```

So the original “log file” was just Base64-encoded **PNG** data. Time to treat it as an image.



## Check metadata (optional)

It’s good practice to check image metadata in forensics challenges. Use `exiftool`:

```bash
exiftool dump
```

Explanation:

* `exiftool` prints all known metadata fields (EXIF, JFIF, comment fields, etc.).
* In this case, no useful information is stored in the metadata — but it’s always worth checking.



## Open the image

Use any image viewer to inspect the file:

```bash
xdg-open dump
```

(Or use `open dump` on macOS, or double-click the file in your file manager.)

When you view the image, you’ll see a line of text written directly on the image itself:

```
7069636f4354467b666f72656e736963735f616e616c797369735f69735f616d617a696e675f35646161346132667d
```

Here is the image:

![Decoded Image from Logs](https://cdn.imgchest.com/files/7c18ac1afe42.png)


## Decode the hexadecimal string

That text isn’t a readable message yet — it’s hexadecimal. Each pair of hex digits represents one ASCII character. Decode it using your preferred tool. For example:

### Option 1: using `xxd`

```bash
echo "7069636f4354467b666f72656e736963735f616e616c797369735f69735f616d617a696e675f35646161346132667d" | xxd -r -p
```

Explanation:

* `xxd -r -p` converts a plain hex dump back to binary (or readable text when it represents ASCII).

Output:

```
picoCTF{forensics_analysis_is_amazing_5daa4a2f}
```

### Option 2: using a web decoder like CyberChef

If you prefer a graphical tool, paste the hex string into [CyberChef](https://gchq.github.io/CyberChef/), select the **“From Hex”** operation, and it will produce the same result.



## Result

Flag:

```
picoCTF{forensics_analysis_is_amazing_5daa4a2f}
```



## Summary of the workflow

| Step | Command                     | Purpose                     |
| ---- | --------------------------- | --------------------------- |
| 1    | `cat logs.txt`              | Inspect file contents       |
| 2    | `base64 -d logs.txt > dump` | Decode Base64 data          |
| 3    | `file dump`                 | Identify file type          |
| 4    | `exiftool dump`             | Examine metadata (optional) |
| 5    | `xdg-open dump`             | View the image              |
| 6    | `echo <hex> \| xxd -r -p`   | Decode hex to ASCII text    |



## Reflection

This challenge is a good reminder that:

* Encodings like Base64 or hex are simple but effective disguises for binary data.
* Tools such as `file`, `exiftool`, and `xxd` are indispensable in digital forensics work.
* Before reaching for complex stego tools, start with basic encodings — sometimes the “hidden” data just needs a different lens.
