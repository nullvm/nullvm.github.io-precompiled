---
title: 'Dummy File Watcher in C'
date: 2024-07-06T18:59:44+07:00
draft: false
description: ''
tags: ['c']
---

In this article we will build a dummy file watcher using C programming
language.

We say dummy file watcher because to build a proper file watcher, we
need to utilize os internal features which is a bit more complex.

Instead, we will create an infinite loop that checks a given directory
every 0.5 second and see if something has changed.

First thing we need to do is to create a function that tells if something
has changed in a given directory.

In order to do that, we will check the `st_ctime` property from each file
in a given directory. Which is a property that tells when was the last
time the file has been modified.

So, we will first list all the `st_ctime` property from each file and then
stored it in an array, after that, every 500ms we will check all the files'
`st_ctime` property and see if something has changed.

Here is the full code to do just that, it will print `"Something has changed, I can feel it...\n"`
whenever something changed in the given directory.

```c
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char* argv[])
{
  if (argc != 2) {
    fprintf(stderr, "syntax: prog <directory>\n");
    return 1;
  }

  DIR* dp;
  unsigned int fdl[64];
  struct dirent* ep;
  struct stat st;
  unsigned int c = 0;
  int setchg = 0;

  dp = opendir(argv[1]);
  if (dp == NULL) {
    perror("opendir");
    return 1;
  }

  // store every file's st_ctime property into an array
  while (ep = readdir(dp)) {
    stat(ep->d_name, &st);
    fdl[c++] = st.st_ctime;
  }

  // monitoring loop
  while (1) {
    c = 0;
    usleep(500000);
    dp = opendir(argv[1]);
    while ((ep = readdir(dp)) && c < 64) {
      stat(ep->d_name, &st);
      if (fdl[c] != st.st_ctime) { // if a file was modified or deleted or there is a new file
        setchg = 1;                // the previous array and the current array will differ
      }
      fdl[c++] = st.st_ctime;
    }

    if (setchg) {
      printf("Something has changed, I can feel it...\n");
      setchg = 0;
    }
  }

  closedir(dp);


  return 0;
}
```

The code is not perfect and needs a lot of improvement, for example
it can only monitor up to 64 files. I will leave it to you to improve
the code.

Stay safe!
