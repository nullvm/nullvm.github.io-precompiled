---
title: 'PicoCTF Writeup #472'
date: 2025-10-04T20:57:27+07:00
draft: false
description: ''
tags: ['ctf', 'reverse engineering']
---

Challenge: [Flag Hunters](https://play.picoctf.org/practice/challenge/505)

This challenge provides a Python script that at first glance looks like a quirky program for singing along to a set of lyrics. Buried inside, however, is the real objective: a flag hidden within the program’s text handling logic.

Here is the full source code.

```python
import re
import time


# Read in flag from file
flag = open('flag.txt', 'r').read()

secret_intro = \
'''Pico warriors rising, puzzles laid bare,
Solving each challenge with precision and flair.
With unity and skill, flags we deliver,
The ether’s ours to conquer, '''\
+ flag + '\n'


song_flag_hunters = secret_intro +\
'''

[REFRAIN]
We’re flag hunters in the ether, lighting up the grid,
No puzzle too dark, no challenge too hid.
With every exploit we trigger, every byte we decrypt,
We’re chasing that victory, and we’ll never quit.
CROWD (Singalong here!);
RETURN

[VERSE1]
Command line wizards, we’re starting it right,
Spawning shells in the terminal, hacking all night.
Scripts and searches, grep through the void,
Every keystroke, we're a cypher's envoy.
Brute force the lock or craft that regex,
Flag on the horizon, what challenge is next?

REFRAIN;

Echoes in memory, packets in trace,
Digging through the remnants to uncover with haste.
Hex and headers, carving out clues,
Resurrect the hidden, it's forensics we choose.
Disk dumps and packet dumps, follow the trail,
Buried deep in the noise, but we will prevail.

REFRAIN;

Binary sorcerers, let’s tear it apart,
Disassemble the code to reveal the dark heart.
From opcode to logic, tracing each line,
Emulate and break it, this key will be mine.
Debugging the maze, and I see through the deceit,
Patch it up right, and watch the lock release.

REFRAIN;

Ciphertext tumbling, breaking the spin,
Feistel or AES, we’re destined to win.
Frequency, padding, primes on the run,
Vigenère, RSA, cracking them for fun.
Shift the letters, matrices fall,
Decrypt that flag and hear the ether call.

REFRAIN;

SQL injection, XSS flow,
Map the backend out, let the database show.
Inspecting each cookie, fiddler in the fight,
Capturing requests, push the payload just right.
HTML's secrets, backdoors unlocked,
In the world wide labyrinth, we’re never lost.

REFRAIN;

Stack's overflowing, breaking the chain,
ROP gadget wizardry, ride it to fame.
Heap spray in silence, memory's plight,
Race the condition, crash it just right.
Shellcode ready, smashing the frame,
Control the instruction, flags call my name.

REFRAIN;

END;
'''

MAX_LINES = 100

def reader(song, startLabel):
  lip = 0
  start = 0
  refrain = 0
  refrain_return = 0
  finished = False

  # Get list of lyric lines
  song_lines = song.splitlines()
  
  # Find startLabel, refrain and refrain return
  for i in range(0, len(song_lines)):
    if song_lines[i] == startLabel:
      start = i + 1
    elif song_lines[i] == '[REFRAIN]':
      refrain = i + 1
    elif song_lines[i] == 'RETURN':
      refrain_return = i

  # Print lyrics
  line_count = 0
  lip = start
  while not finished and line_count < MAX_LINES:
    line_count += 1
    for line in song_lines[lip].split(';'):
      if line == '' and song_lines[lip] != '':
        continue
      if line == 'REFRAIN':
        song_lines[refrain_return] = 'RETURN ' + str(lip + 1)
        lip = refrain
      elif re.match(r"CROWD.*", line):
        crowd = input('Crowd: ')
        song_lines[lip] = 'Crowd: ' + crowd
        lip += 1
      elif re.match(r"RETURN [0-9]+", line):
        lip = int(line.split()[1])
      elif line == 'END':
        finished = True
      else:
        print(line, flush=True)
        time.sleep(0.5)
        lip += 1



reader(song_flag_hunters, '[VERSE1]')
```

Although the file looks long and perhaps intimidating, most of the code is simply song lyrics wrapped in string variables and some straightforward branching logic to print them out. The actual vulnerability lies in how the script processes user input during the “crowd participation” parts of the song.

Let’s carefully walk through the important pieces.

### The Flag Placement

At the very beginning of the script, the program reads a flag directly from a file:

```python
flag = open('flag.txt', 'r').read()
```


That value is then embedded inside a string called `secret_intro`, which forms the start of the song:

```python
secret_intro = (
    "Pico warriors rising, puzzles laid bare,\n"
    "Solving each challenge with precision and flair.\n"
    "With unity and skill, flags we deliver,\n"
    "The ether’s ours to conquer, " + flag + "\n"
)
```


This means the flag is not hidden in memory or generated dynamically — it is simply appended to the opening lyrics. If we can cause the program to print that introduction, we will see the flag.

### How Lyrics are Processed

The script includes a `reader()` function that steps through the lyrics line by line. Each line may contain ordinary text, or it may include special directives like `REFRAIN`, `RETURN`, or `END`, which alter the program’s flow.

A simplified view of the main loop looks like this:

```python
for line in song_lines[lip].split(';'):
    if re.match(r"CROWD.*", line):
        crowd = input('Crowd: ')
        song_lines[lip] = 'Crowd: ' + crowd
    elif re.match(r"RETURN [0-9]+", line):
        lip = int(line.split()[1])
    elif line == 'END':
        finished = True
    else:
        print(line, flush=True)
```

Two details here are critical:

Splitting on `;` — Every lyric line is split into multiple parts if it contains semicolons. This means user input can introduce new “commands” simply by including a `;`.
`RETURN` tokens — If a token looks like `RETURN n`, the program jumps `(lip = n)` to another line in the lyrics. This effectively allows manual control of the script’s reading position.
The vulnerability

During the `[CROWD]` sections, the program calls `input()` and then places the raw user input back into the lyrics list. Importantly, this input is not sanitized. Because of the `split(';')` step, any semicolons in user input will be interpreted as new tokens — and tokens are processed by the same logic as actual lyrics.

This allows us to “smuggle” in a control command. For example, typing:

```python
php;RETURN 0
```

creates two tokens:

`php` → harmless text  
`RETURN 0` → special directive that forces the program to jump back to the beginning of the lyrics `(lip = 0)`  

Since the very beginning contains the `secret_intro` with the flag, the program dutifully prints it.

### Exploiting The Bug

Step-by-step:

Run the script until it reaches a `[CROWD]` prompt.
At the prompt, enter:  
`php;RETURN 0`

(The `php` part can be anything — it only exists to satisfy the first token.)
The `RETURN 0` command resets the lyric pointer to the start of the file.
The introduction is printed again, including the hidden flag.
Example output

After submitting the crafted input, the output includes:

```bash
Pico warriors rising, puzzles laid bare,
Solving each challenge with precision and flair.
With unity and skill, flags we deliver,
The ether’s ours to conquer, picoCTF{70637h3r_f0r3v3r_befbccb7}
```

### Conclusion

What initially appears to be a playful lyric-printing script actually hides a classic injection-style vulnerability. Because user input is not sanitized and is later reinterpreted as program instructions, it becomes