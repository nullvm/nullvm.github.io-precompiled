---
title: 'WebInfo GET - log 2'
date: 2026-06-25T10:54:18+07:00
draft: false
description: ''
tags: ['python', 'http']
---

### checkpoint

revisiting BeautifulSoup and using news.ycombinator as a sample site
to scrape content and store it into json files.

here is the full code.

```python
import httpx
from bs4 import BeautifulSoup
import json

url = "https://news.ycombinator.com/"

r = httpx.get(url)

soup = BeautifulSoup(r.text, "html.parser")

tds = soup.table.find_all("td", class_="title")

mydata = []

for i in tds[:-1]:
    hreflink = i.find("a")
    if hreflink is None:
        continue
    title = hreflink.string
    link = hreflink.get("href")
    mydata.append({"title": title, "link": link})


with open("./output/outputdata.json", "w") as j:
    json.dump(mydata, j, indent=4)

print("finished page 1")


for i in range(2, 11):
    r = httpx.get(f"{url}?p={i}")
    while r is None:
        r = httpx.get(f"{url}?p={i}")

    soup = BeautifulSoup(r.text, "html.parser")

    tds = soup.table.find_all("td", class_="title")

    mydata = []

    for k in tds[:-1]:
        hreflink = k.find("a")
        if hreflink is None:
            continue
        title = hreflink.string
        link = hreflink.get("href")
        mydata.append({"title": title, "link": link})


    with open(f"./output/outputdata{i}.json", "w") as j:
        json.dump(mydata, j, indent=4)

    print(f"finished page {i}")
```

still don't know what to do when the website is protected by
cloudflare.

might need to do more research on that part later.