+++
title = 'Dynamic Array in C Simplified'
date = 2024-07-02T13:30:14+07:00
draft = false
description = ''
[cover]
image = "https://images.unsplash.com/photo-1644357655176-69d3fe7f2fcc?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
caption = "Source: [unsplash](https://unsplash.com/photos/a-building-with-a-clock-on-the-side-of-it-YWR9NKDHnls)"
+++

Array data structure is really useful, it can used to to store value
with same data types, we can access it really easy, updating the value
of array is also a trivial thing to do. One of the most important use
of array is that is it used to implement other more complex data structures
such as linked list, binary tree and hash tables.

But what is greater than array? Yup, dynamic array.

We will create an echo program to see how we can implement dynamic array
in C programming language.

Now, C doesn't support dynamic array natively, however we can implement it 
easily, this article will show you how.

## Reallocate Memory

Before implementing dynamic array in C, let's take a look on how to realloc
memory in C using `realloc`.

`realloc` has the following syntax:

```c
void *realloc(void *_Nullable ptr, size_t size);
```

pretty easy to use.

Here is a code to demonstrate the use of `realloc`.

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  int* ptr = (int*) malloc(2 * sizeof(int));
  *(ptr + 0) = 7;
  *(ptr + 1) = 5;

  // *(ptr + 2) = 3; // uncommenting this will result in undefined behavior
  
  ptr = (int*) realloc(3 * sizeof(int));
  *(ptr + 2) = 3; // valid

  free(ptr);

  return 0;
}
```

Using `realloc` is pretty straight forward, you only need to provide the pointer
you wanted to resize and the new size.

## Echo Program

Let's say we have a program that capture user input and then store it in
a pointer, after the user input new line, the program will print it to the
standard output.

Here is one way to implement it.

```c
#include <stdio.h>

int main()
{
  char s[10];
  int c, i;

  i = 0;
  while (i < 9 && (c = getchar()) != '\n') {
    s[i++] = c;
  }
  s[i] = '\0';
  printf("%s\n", s);

  return 0;
}
```

The code above will work just fine however, it will only able to print up to
9 characters long (10 characters with the `\0` delimiter).

What if user input more than 9 characters? Well, we can just allocate big enough
memory to store the user's input. However, this might not be the best choice for
our problem because allocating such big memory with no use is just impractical.
User can input only 5 characters but if we already allocated, say 1000 characters,
the rest of the memory will be unused.

Since we never know the exact length of the user's input, how about we start with
small array and then increase the size of the array accordingly. This is where we
use dynamic memory allocation.

Rewriting the above code will give us the following.

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char* s = (char*) malloc(10 * sizeof(char));
  int c, i;

  i = 0;
  while (i < 9 && (c = getchar()) != '\n') {
    *(s+i) = c;
    ++i;
  }
  *(s+i) = '\0';
  printf("%s\n", s);

  free(s);

  return 0;
}
```

Yes, it is still static.

We need to use `realloc` to resize the pointer `s`.

```c
#include <stdio.h>
#include <stdlib.h>
#define BUFSIZE 8

int main()
{
  char* s = (char*) malloc(BUFSIZE * sizeof(char));
  int c, i, j;

  i = 0;
  j = 1;
  while ((c = getchar()) != '\n') {
    *(s+i) = c;
    ++i;
    if (i % BUFSIZE == 0) {
      ++j;
      s = (char*) realloc(s, BUFSIZE * j * sizeof(char));
    }
  }

  *(s+i) = '\0';
  printf("%s\n", s);

  free(s);

  return 0;
}
```

Now the program will work as expected. Compile using `-Wall -Werror -fsanitize=address` using `gcc`
to check if the program compiles correctly.

## Afterword

We have seen how we can implement a dynamic array in C programming language,
there are a lot of things we can improve in our echo program like error handling
and non-ascii characters. I'll leave it to you to do that.

That's it for now, I'll see you on another one.

Stay safe!
