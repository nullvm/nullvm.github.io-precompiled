+++
title = 'Review of Pointer in C'
date = 2024-07-03T15:07:47+07:00
draft = false
description = ''
tags = ["c"]
[cover]
image = "https://raw.githubusercontent.com/deniandriancode/website-assets/main/images/github-page/OIG1.Ae1bF6jUwFBOJBWiq48q.jpg"
caption = "Source: DALL-E"
+++

In this short article we will review pointers
in C programming language, if you are new to this
kind of topic please read the tutorial of pointers
for beginners first, try [this tutorial](https://www.geeksforgeeks.org/c-pointers/) for example.

### Defining Pointer

There are several ways to define a pointer in C.

```c
int* p;
int x = 5;

p = &x; // p pointer to address x
```

we can assign the address right away like so

```c
int x = 5;
int* p = &x;
```

### Dereferencing Pointer

Use `*` to dereference a pointer, this will
return the value that the address of pointer is
pointing at holds.

```c
int x = 7;
int* p = &x;

int y = *p + 5; // 7 + 5 = 12
```

### Updating the Address of Pointer

Assign the pointer to different address to make
it points to different address.

```c
int x = 5;
int y = 7;
int* p = &x;

printf("%d\n", *p); // 5

p = &y;

printf("%d\n", *p); // 7
```

### Updating the Value of the Address the Pointer Pointed at

Use the dereference operator to update the value of address
that pointer is pointing at.

```c
int x = 5;
int* p = &x;

printf("%d\n", *p); // 5
printf("%d\n", x); // 5

*p = 8;

printf("%d\n", *p); // 8
printf("%d\n", x); // 8
```

### Double Pointer

Use pointer to modify the **value** that the pointer is
pointing at, use double pointer to modify the **address** that
the pointer is pointing at.

Double pointer is commonly used as function parameters and
two dimensional array.

```c
char** s = (char**) malloc(2 * sizeof(char*));
s[0] = "hello";
s[1] = "there";
printf("%s\n", s[0]);
printf("%s\n", s[1]);
```

### Afterword

Pointer in C programming language is one of the most
feared aspect from its feature, however it is also the
easiest way to learn about memory management.

Anyway, I'll see you on another one.

Stay safe!
