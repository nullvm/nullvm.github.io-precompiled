+++
title = 'Pointer and Const in C++'
date = 2024-06-15T20:59:34+07:00
draft = false
description = ''
[cover]
image = "https://images.unsplash.com/photo-1586296188195-89285b63f670?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
caption = "Source: [unsplash](https://unsplash.com/photos/white-and-black-star-print-textile-4993XnXQKHY)"
+++

The following paragraphs are the summary of pointer
and const in C++, I always forget about this topic
so I decided to create a post about it.

## Regular Pointers

Regular pointers are pointers the we usually use when
working with pointers in C++.

```cpp
int main()
{
  int x = 5;
  int* ptr = &x; // regular pointer to x

  x = 6; // *ptr would be 6
  
  // we can change the value at the address being held
  *ptr = 1; // x and *ptr would be 1

  int y = 88;
  ptr = &y; // changing the address that ptr is pointing at

  return 0;
}
```

## Pointer to a const value

I won't explain what is it and the rest of the it since it
is easier to explain it using code rather than using words.
(The definitions are still confusing to me💀)

```cpp
int main()
{
  const int x = 5;
  const int* ptr = &x; // ptr is pointing to a "const int"
  int* ptr = &x; // this will cause compilation error

  *ptr = 8; // this is not allowed; changing the value of "const int"

  const int y = 8;
  ptr = &y; // this is allowed; the pointer is not const, only the value of
            // the pointer that's const

  return 0;
}
```

Pointer to const can point to non-const variable.

```cpp
int main()
{
  int x = 5;
  const int* ptr = &x; // allowed

  *ptr = 6; // not allowed; changing the value of pointer to const
  x = 6; // allowed; x is not const

  return 0;
}
```

## Const pointers

```cpp
int main()
{
  int x = 5;
  int y = 6;
  int* const ptr = &x; // this is the const pointer, we can't change
                       // the address of ptr

  ptr = &y; // this is not allowed

  *ptr = 8; // allowed; the value it is pointing at is not const

  return 0;
}
```

## Const pointer to a const value

```cpp
int main()
{
  int x = 5;
  int y = 7;
  const int* const ptr = &x; // const pointer to a const value

  *ptr = 7; // not allowed
  ptr = &y; // also not allowed

  return 0;
}
```

## Afterword

This is just a note I write so I can comeback to it when I forget.

Anyway, see you on another post.

Stay safe!
