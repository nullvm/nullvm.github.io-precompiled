---
title: 'Generate Ranged Random Integer in Javascript'
date: 2024-10-26T20:25:23+07:00
draft: false
description: ''
tags: ['javascript', 'programming']
---

Here I will show you a simple way to generate a ranged random
integer number in javascript. Since javascript doesn't have built in
function to generate ranged integer number, we will create one.
```js
function randInt(left, right) {
  return Math.floor(Math.random() * (right - left + 1)) + left;
}
```

And that's it, this is just me passing by and dropping some code snippets.

See you later.

Stay safe!
