---
title: 'Javascript Promise Simplified'
date: 2024-10-21T20:08:35+07:00
draft: false
description: ''
tags: ['javascript', 'programming']
---

Promise has three different states: pending, resolve, and reject.

When you first create a promise, it will be in pending state. This
promise can be either "fulfilled" thus it will be resolved or it can
be "rejected" thus it will be rejected.

In other word, if promise resulted in success it resolve, else it reject.

To create a promise in javascript is really simple.

```js
const myPromise = new Promise(function (resolve, reject) {
  // do something
});
```

What you do inside the promise will decide whether it will resolve or reject.

Either way, the promise will return the value inside the resolve or reject function.

```js
const myPromise = new Promise(function (resolve, reject)) {
  // this promise will resolve if 8 is an even number
  if (8 % 2 === 0) resolve("8 is even");
  else reject("8 is not even");
}
```

After you create a promise, it's time to consume it. To do that, use the `then`, `catch`, and
`finally` sequence like so:

```js
myPromise
  .then(function (result) {
    // do something with resolved value
  })
  .catch(function (error) {
    // do something with rejected value
  })
  .finally(function () {
    // do the cleaning
  });
```

And that's how you use promise in javascript.

To deepen your understanding about promise in javascript,
you can read [this awesome article](https://javascript.info/promise-basics) from javascript.info

Anyway, see you on another one.

Stay safe!
