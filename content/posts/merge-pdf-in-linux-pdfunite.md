---
title: 'Merge Pdf in Linux using pdfunite'
date: 2024-10-24T20:22:38+07:00
draft: false
description: ''
tags: ['linux']
---

Merging pdf files in Linux is really simple, you can use a
command line called `pdfunite`.

Open a terminal and type the following

```bash
pdfunite --help
```

in my system, it prints

```bash
pdfunite version 24.06.0
Copyright 2005-2024 The Poppler Developers - http://poppler.freedesktop.org
Copyright 1996-2011, 2022 Glyph & Cog, LLC
Usage: pdfunite [options] <PDF-sourcefile-1>..<PDF-sourcefile-n> <PDF-destfile>
  -v             : print copyright and version info
  -h             : print usage information
  -help          : print usage information
  --help         : print usage information
  -?             : print usage information
```

Let's say we want to merge three pdf files `head.pdf`, `body.pdf`, and `foot.pdf` into
one file named `all.pdf`. Using `pdfunite` we can effortlessly merge all those pdf
files like so

```bash
pdfunite head.pdf body.pdf foot.pdf all.pdf
```

And that's literally the only thing we need to do to merge all those pdf files 
into one single file, the order of the merged file would follow the order in the
source file, so the above command will resulted a pdf file with the following
order `head.pdf`, `body.pdf`, `foot.pdf`.

Stay safe!
