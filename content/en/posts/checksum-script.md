---
title: 'Checksum Made Easy using Script'
date: 2025-02-01T09:33:38+07:00
draft: false
description: ''
ShowCodeCopyButtons: true
tags: ['linux', 'cryptography', 'bash']
---

Script below is one of a simple way to checksum of a file and get the report
immediately.

```bash
#!/usr/bin/bash

# syntax: ./checksum.sh <algorithm> <file> <cert>

diff <(echo -n $($1 $2 | cut -d ' ' -f 1)) $3 -s
```

Here I named the script `checksum.sh` but you can name it however you want.

It's pretty straightforward script, if you want to learn more about the command
used in the script, you can copy the content and paste it in [explainshell.com](https://explainshell.com/).

Anyway, that's it for now.

Stay safe.
