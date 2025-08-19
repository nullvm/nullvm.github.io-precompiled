---
title: 'Replicating Right Click Behavior using Vanilla Javascript'
date: 2024-10-24T19:36:18+07:00
draft: false
description: ''
tags: ['javascript']
---

The idea is simple.

First, disable the default event handler for right click in the browser.

Second, create a custom event handler for right click event.

Implementing the first idea, we can do something like the following.

```javascript
window.addEventListener("contextmenu", (event) => {
  event.preventDefault();
});
```

from here we can easily add any custom code for event handler
to our liking, here I will just log "Right Click detected!" into
the console.

```javascript
window.addEventListener("contextmenu", (event) => {
  event.preventDefault();
  console.log("Right Click detected!");
});
```

You can create additional html elements and put it into the window
to act as the replacement for the default context menu.

Anyway, that's it for now.

Stay safe!
