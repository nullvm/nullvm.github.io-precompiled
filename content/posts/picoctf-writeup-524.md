---
title: 'PicoCTF Writeup #524'
date: 2025-10-18T14:23:16+07:00
draft: false
description: ''
tags: ['ctf', 'forensics']
---

Challenge: [Hidden in Plainsight](https://play.picoctf.org/practice/challenge/524)

Short summary: the image contains a Base64-encoded hint in its JPEG comment. That hint decodes to a string which itself is Base64-encoded — the result is the passphrase for `steghide`. Use `steghide` to extract `flag.txt`, then `cat` the file to read the flag.



## Fetch the challenge file

If you haven't downloaded the file yet, use `curl` or `wget`:

```bash
# with curl
curl -O https://challenge-files.picoctf.net/c_saffron_estate/25925d893c04723f46e8d1412559b15ef58509751801aac366c65441fed3e40e/img.jpg

# or with wget
wget https://challenge-files.picoctf.net/c_saffron_estate/25925d893c04723f46e8d1412559b15ef58509751801aac366c65441fed3e40e/img.jpg
```

What this does:

* `curl -O` saves the remote file using its original filename.
* `wget` behaves similarly if you prefer it.



## Inspect the image metadata

Use `exiftool` to read image metadata; many stego challenges hide hints there:

```bash
exiftool img.jpg
```

Why `exiftool`?

* It prints all standard and custom metadata fields (EXIF, JFIF, comments, etc.), which are common places to hide clues.

Relevant output (excerpt) included a suspicious `Comment` field:

```
Comment : c3RlZ2hpZGU6Y0VGNmVuZHZjbVE9
```

That string looks like Base64.



## Decode the Base64 hint

Decode the `Comment` value. Use `base64 --decode` (or `base64 -d`) to convert Base64 to text:

```bash
echo "c3RlZ2hpZGU6Y0VGNmVuZHZjbVE9" | base64 --decode
```

Explanation:

* `echo "..."` writes the Base64 string to stdout.
* `base64 --decode` decodes the input.
* Using `echo -n` is sometimes preferable to avoid a trailing newline, but `base64 --decode` handles trailing newlines fine for this usage.

Decoded output:

```
steghide:cEF6endvcmQ=
```

Interpretation:

* The comment contains the literal `steghide:` prefix followed by another Base64 string `cEF6endvcmQ=`. That second string very likely encodes the passphrase for `steghide`.



## Decode the passphrase

Decode the second Base64 string to get the passphrase:

```bash
echo "cEF6endvcmQ=" | base64 --decode
```

Output:

```
pAzzword
```

So `pAzzword` is the passphrase (case-sensitive) we will use with `steghide`.



## Install `steghide` (if needed)

If `steghide` is not installed on your machine, install it:

```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install steghide

# Fedora
sudo dnf install steghide

# macOS with Homebrew
brew install steghide
```

Why `steghide`?

* `steghide` is a common steganography tool that embeds/extracts data from JPEG/WAV/PGP files using a passphrase.



## Extract the hidden file with `steghide`

You can run `steghide` interactively or pass the passphrase in the command line. To be explicit:

Interactive (prompts for passphrase):

```bash
steghide --extract -sf img.jpg
# then type: pAzzword
```

Non-interactive (supply passphrase inline):

```bash
steghide --extract -sf img.jpg -p pAzzword
```

Flags explained:

* `--extract` tells `steghide` to extract embedded data.
* `-sf img.jpg` specifies the stego file (the file containing hidden data).
* `-p pAzzword` provides the passphrase on the command line (convenient, but note command-line passphrases may be visible in shell history or process lists).

`steghide` will write whatever it finds (in this challenge it writes `flag.txt`). Example output:

```
wrote extracted data to "flag.txt".
```



## Read the flag

Now simply print the extracted file:

```bash
cat flag.txt
```

Output:

```
picoCTF{h1dd3n_1n_1m4g3_871ba555}
```

That is the flag.



## Compact pipeline & reproducible commands

For convenience, here are the essential commands in order:

```bash
# 1. Download (if needed)
curl -O https://challenge-files.picoctf.net/.../img.jpg

# 2. Inspect metadata
exiftool img.jpg

# 3. Decode the JPEG comment (example using the decoded string shown above)
echo "c3RlZ2hpZGU6Y0VGNmVuZHZjbVE9" | base64 --decode

# 4. Decode the embedded passphrase
echo "cEF6endvcmQ=" | base64 --decode

# 5. Extract with steghide (non-interactive)
steghide --extract -sf img.jpg -p pAzzword

# 6. Read the extracted file
cat flag.txt
```



## Small notes and best practices

* When decoding Base64 from untrusted sources, be mindful of potential binary output — redirect to a file if you expect binary.
* Avoid putting sensitive passphrases in shell history or process arguments on shared systems; use interactive prompts or environment-secure mechanisms when appropriate.
* `exiftool` is a powerful reconnaissance tool for stego and forensics; always check metadata fields like `Comment`, `UserComment`, and any nonstandard tags.
* If `steghide` extraction fails, try common stego verification steps: check file size, look for appended data (e.g., `xxd`, `tail`), or try other stego tools — but in this puzzle the metadata directly pointed at `steghide`.
