---
title: 'PicoCTF Writeup #475'
date: 2025-08-26T11:59:43+07:00
draft: false
description: ''
tags: ['cryptography', 'ctf']
---

The **`hashcrack`** challenge from PicoCTF is a practical demonstration of the security risks posed by weak hashing algorithms for passwords. In this write-up, I will detail the steps taken to solve the challenge, the reasoning behind each decision, and the security lessons that can be learned from this exercise. You can try and solve it yourself [here](https://play.picoctf.org/practice/challenge/475).



## Challenge Overview

The challenge description states that a company’s server was breached because the administrator used weakly hashed passwords. Our goal is to gain access to the secret message stored on that server. To start, we are given the connection details:

```bash
nc verbal-sleep.picoctf.net 51671
```

This means the challenge requires interacting with a remote service over Netcat. No additional information is provided beyond the context that weak hashing is involved.



## Initial Interaction with the Service

After connecting to the given host and port using Netcat, the service displays the following prompt:

```bash
Welcome!! Looking For the Secret?

We have identified a hash: 482c811da5d5b4bc6d497ffa98491e38
Enter the password for identified hash: test
Incorrect. Goodbye.
```

From this output, we can infer that the server provides a hash and expects us to supply the correct plaintext password. If the input is incorrect, the connection is closed immediately.



## Analyzing the Problem

The first step is to understand what kind of hash we are dealing with. The hash provided is a 32-character hexadecimal string, which is a strong indicator of the **MD5** algorithm. MD5 is widely recognized as an insecure hashing algorithm that is easy to reverse due to precomputed databases and rainbow tables.

Considering the challenge difficulty is marked as **easy**, it would be inefficient to attempt a brute-force attack using tools such as `hashcat` or `John the Ripper`. Large wordlists like `rockyou.txt` could solve the problem eventually, but they would consume unnecessary time and resources. Instead, this situation calls for a more direct and practical solution.



## Choosing the Approach

The most efficient approach for this challenge is to use an online MD5 reverse lookup service. Many such services exist, and they work by checking the hash against massive precomputed databases of known hashes. Since this is a Capture The Flag (CTF) environment and the password is almost certainly a common word, this method is quick and effective.


## Step-by-Step Solution

The first thing I did was grab the hash the server handed me:

```
482c811da5d5b4bc6d497ffa98491e38
```

Now, I could have gone full hacker mode—spinning up `hashcat`, loading `rockyou.txt`, and watching my CPU slowly turn into a space heater—but this was an **easy** challenge. That means the solution probably isn’t brute force; it’s something much simpler.

So I took the pragmatic route. Instead of brute-forcing, I opened Google and typed:

```
482c811da5d5b4bc6d497ffa98491e38 pattern
```

Adding the word “pattern” helps Google return relevant reverse-hash lookups instead of random hash algorithm explanations. Sure enough, the very first result was a site called **[md5hashing.net](https://md5hashing.net)**.

This site is essentially a cheat code for CTFs—it told me the exact plaintext for the hash and even confirmed it was MD5. No guesswork.

I took that plaintext, reconnected to the server, and entered it. Boom—the server accepted it but immediately gave me **another** hash. So the game was on:

* Copy the new hash.
* Search again using the same “`<HASHVALUE> pattern`” trick.
* Get the plaintext from the website.
* Submit it to the server.

I repeated this process a few times, like solving a puzzle where the answer unlocks the next piece. Finally, after the last submission, the server revealed the ultimate reward: the flag.


## The Result

The flag obtained from the challenge is:

```
picoCTF{UseStr0nG_h@shEs_&PaSswDs!_eb2f8459}
```



## Key Takeaways

This challenge illustrates why MD5 is no longer suitable for password hashing. MD5 hashes can be reversed with ease using publicly available tools and precomputed hash databases. Any system still relying on MD5 for password storage is vulnerable to trivial attacks.

Instead of MD5, modern applications should implement secure, computationally expensive hashing algorithms designed for password storage, such as **bcrypt**, **scrypt**, or **Argon2**. These algorithms incorporate salting and adjustable work factors, which significantly reduce the effectiveness of brute-force and dictionary attacks.



## Tools Used

* **Netcat (`nc`)** – for interacting with the remote service.
* **[md5hashing.net](https://md5hashing.net)** – for reversing MD5 hashes using precomputed databases.



## Afterword

This solution emphasizes the importance of avoiding outdated security practices and demonstrates how easy it is to exploit weak hashing in real-world scenarios. The simplicity of this challenge is deliberate—it serves as a reminder that security through obscurity is not security at all.
