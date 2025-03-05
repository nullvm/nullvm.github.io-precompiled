---
title: 'CTF Hacker101 Flag 1 - A Little Something to Get You Started'
date: 2025-01-31T18:16:37+07:00
draft: false
description: ''
tags: ['ctf', 'programming', 'cybersecurity']
---

Another challange I do while learning programming, this is episode 1 by the way.

You can visit [hacker101](https://ctf.hacker101.com/) if you want to play it too.

I start the level and it redirected me to a website with white background
and a paragraph which said:

```txt
Welcome to level 0. Enjoy your stay.
```

Nothing out of ordinary here. So, I inspect the page and look at the source
code. Seems normal. Until I take a look at the `<style>` tag and saw the
following lines:

```css
body {
	background-image: url("background.png");
}
```

It's weird because the background is white and there is no image at all.

Inspecting the `<body>` and looking at the `styles` section at the developer
window gives me the url to the `background.png`. I opened it on the browser
and get the flag.

This level is trivial so there is nothing much happened here.

Anyway, I'll see you on the next one.

Stay safe.
