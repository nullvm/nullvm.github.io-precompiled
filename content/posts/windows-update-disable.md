---
title: 'How I Declared War on Windows Updates (and Won… Kind of)'
date: 2025-08-27T13:33:34+07:00
draft: false
description: ''
tags: ['windows']
---


Ever since I installed my first Linux distro (good old Ubuntu), I never once thought about going back to Windows. I mean, why would I? Before Linux, I only touched computers for gaming. Anything beyond that—writing documents, checking emails, or wrestling with random **Blue Screen of Death** encounters—sounded like the digital equivalent of watching paint dry.

Linux changed everything. Suddenly, computers weren’t these boring office machines—they were *fun*. They were obedient little metal pets that did whatever I told them to. Want to customize your entire desktop? Sure. Want to write a bash script that does absolutely nothing useful but makes you feel like a hacker? Go for it. Want to nuke your bootloader at 2 AM and spend the next 4 hours fixing it? Linux says, *“Challenge accepted.”*

That was the magic for me. Linux taught me that computers could be playful, powerful, and… chaotic in a good way. So I dove into the Linux rabbit hole and never looked back. Until reality hit me.



## The Windows Reality Check

Here’s the problem: normal people—like, actual humans who don’t compile their own kernels for fun—still use Windows. At work, in college, at grandma’s house… it’s Windows everywhere. So, for survival, I knew I had to at least *understand* how Windows works. Which is how I ended up **daily driving Windows 11**.

And let me tell you something, friends: there is one thing about Windows that makes me want to throw my PC into a volcano—**forced updates**.



## Why, Microsoft, Why?!

Imagine this: You’re in the middle of something important, maybe coding, maybe watching cat videos in glorious 4K, and suddenly Windows is like:

> “Hey buddy, just a quick restart for an update… OR I’LL DO IT MYSELF IN 15 MINUTES.”

Excuse me, what? My Linux brain cannot process this tyranny. On Linux, updates are like polite guests—they knock, you open the door when you feel like it. On Windows? They’re SWAT teams kicking down your door at 3 AM because *some DLL needs a security patch.*

So, naturally, I decided to fight back.



## How to Make Windows Updates Cry

Here’s the trick. The Windows Update service depends on a very specific DLL file to work. If that file… mysteriously disappears (or, you know, gets renamed), the service won’t even start. And without the service, updates can’t run.

That file lives here:

```
C:\Windows\System32\wuaueng.dll
```

Rename it to:

```
wuaueng.dll.bak
```

And boom—Windows Update is dead in the water. Just make sure to **stop the Windows Update service** first, or it’ll yell at you.



## The Catch (Because There’s Always One)

Some apps—*cough* Microsoft Store *cough*—need the Windows Update service to work. So if you want to install something from the Store, you’ll need to:

1. Rename `wuaueng.dll.bak` back to `wuaueng.dll`.
2. Start the Windows Update service.
3. Do your Store thing.
4. Rename the DLL back and stop the service again.

It’s like babysitting a stubborn toddler. But hey, it works.



## But What About TrustedInstaller?

If you try renaming the file and Windows slaps you with a **TrustedInstaller** error, don’t panic. You just need to take ownership of the file first. This guide explains how:
[How to Control Files in Windows](https://www.techrepublic.com/article/how-to-control-files-windows/)



## Final Thoughts

Do I recommend this to everyone? No. Is it a dumb hack that made me feel like a sysadmin wizard? Absolutely. Sometimes, you just want your machine to do what you tell it to—without threatening you with an unwanted restart while you’re neck-deep in a Python script or mid-game in Elden Ring.

So yeah, I declared war on Windows Updates… and for now, I’m winning.
