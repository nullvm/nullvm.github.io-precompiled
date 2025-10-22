---
title: 'PicoCTF Writeup #519'
date: 2025-10-22T18:24:07+07:00
draft: false
description: ''
tags: ['ctf', 'forensics']
---

This is a forensics challenge from picoCTF (challenge ID 519). The goal is to recover a corrupted image file and extract the flag. The walkthrough includes exact commands, outputs, and common pitfalls encountered during solving.

## Challenge Setup
- **Platform**: [picoCTF Practice](https://play.picoctf.org/practice/challenge/519)
- **Category**: Forensics
- **Difficulty**: Beginner-Intermediate
- **File**: Download the provided "file" (no extension)

Work in a fresh directory:  
```bash
mkdir picoctf-519 && cd picoctf-519
```

## Initial File Analysis
Run the basic file type check:

```bash
$ file file
file: data
```

The "data" result indicates the file command cannot identify the format. Use hexdump for deeper inspection:

```bash
$ hexdump -C file > out.txt
$ head out.txt
```

Output:
```
0000000 78 5c e0 ff 10 00 46 4a 46 49 46 00 01 00 01 00
0000010 01 00 00 00 db ff 43 00 08 00 06 06 06 07 08 05
0000020 07 07 09 07 08 09 0c 0a 0d 14 0b 0c 0c 0b 12 19
0000030 0f 13 1d 14 1f 1a 1d 1e 1c 1a 20 1c 2e 24 20 27
0000040 2c 22 1c 23 28 1c 29 37 30 2c 34 31 34 34 27 1f
0000050 3d 39 32 38 2e 3c 34 33 ff 32 00 db 01 43 09 09
0000060 0c 09 0c 0b 0d 18 18 0d 21 32 21 1c 32 32 32 32
0000070 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32
*
0000090 32 32 32 32 32 32 32 32 c0 ff
```

The `JFIF` string at offset 0x06 indicates a JPEG file. However, the first two bytes `78 5c` do not match the standard JPEG header `FF D8`.

## Raw Header Inspection
View the first 20 bytes with escape characters:

```bash
$ head -c 20 file | cat -A
\x^�^�^@^FJFIF^@^A^@^A^@
```

Confirms the mangled header followed by valid JFIF marker.

## Rename and Validate
Add the JPEG extension:

```bash
$ mv file file.jpg
```

Test with an image viewer:
```bash
$ feh file.jpg
```
Result: Invalid image error.

Validate with exiftool:
```bash
$ exiftool file.jpg
```
Output includes:
```
File Format           : Error
Warning: [minor] Corrupt Image Data Tag
```

## Header Correction with Hexedit
Install hexedit if needed: `sudo apt install hexedit`.

Edit the file:
```bash
$ hexedit file.jpg
```

- Navigate to offset `0x00`
- Change `78` to `FF`
- Change `5C` to `D8`
- Save and exit

This sets the correct JPEG header: `FF D8 FF E0 ... JFIF`.

**Pitfall**: Backup the original file first (`cp file.jpg file.jpg.bak`) to avoid data loss from editing errors.

## Extract the Flag
Open the corrected image:
```bash
$ feh file.jpg
```

The image displays the flag:  
`picoCTF{r3st0r1ng_th3_by73s_2326ca93}`

## Tools Summary

| Tool/Command | Purpose | Notes |
|--------------|---------|-------|
| `file` | File type identification | Fails on corrupted headers |
| `hexdump -C` | Hexadecimal + ASCII dump | Use `-C` for clean output |
| `head -c N \| cat -A` | Raw bytes with escapes | Ideal for header inspection |
| `exiftool` | Metadata analysis | Detects corruption details |
| `hexedit` | Byte-level editing | Alternative: `xxd` for vim users |

## Automation Option
Script the header fix:
```bash
xxd -s 0 -l 2 -p file.jpg | sed 's/785c/ffd8/' | xxd -r -p > fixed.jpg
```

## Key References
- [JPEG File Interchange Format](https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format)
- [File Signatures](https://en.wikipedia.org/wiki/List_of_file_signatures)
