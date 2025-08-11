+++
title = 'Linux Hard Link and Soft Link in a Nutshell'
date = 2024-06-24T20:47:46+07:00
draft = false
description = ''
[cover]
image = "https://images.unsplash.com/photo-1571171637578-41bc2dd41cd2?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
caption = "Source: [unsplash](https://unsplash.com/photos/black-computer-keyboard-DuHKoV44prg)"
+++

## Definition

Before we talk about hardlink and softlink in linux, we must
first know what is inode and filename, and what's the difference
between the two.

### What is inode?

Your computer needs a way to 'labelize' files in its filesystem.
Remember, [everything is a file](https://en.wikipedia.org/wiki/Everything_is_a_file) in linux.
One way to do this is to put a unique integer value to the file.
This unique integer value is what we called the _inode number_, which
is a number that's used to identify an _inode_. The [inode](https://en.wikipedia.org/wiki/Inode) is a data structure
that describe a file-system object.

Each file associated with inode, which is identified by an inode number.
The inode contains metadata about a file, that is it has data that describe
the data inside a file. A directory is just a file containing a list of
inodes.

An inode can only associated with one file. When you move a file, you actually
just putting a different path to the inode. Changing inode means changing
the identity of a file at hardware level, so it is not a trivial thing to do
and we rarely need to do that.

### What is filename?

> A filename or file name is a name used to uniquely identify a computer file in a file system.  
>  
> _~ [Wikipedia](https://en.wikipedia.org/wiki/Filename)_

Filename is pretty obvious, filename to a file is like a title to a book. The definition from
wikipedia said that is a unique identifier but actually _it must be unique only for current_
_directory_. You can, for example, have a file named fin.txt in ~/.config and ~/Downloads.

It is what's searched by software like `find`. File manager software also list filename
when displaying files instead of inode.

Changing a filename is easy compared to changing an inode. When you change a filename,
you just changing an attribute of a file and not its identity.

### Hard link

Every file in Linux Filesystem starts with a single hard link. It maps the filename into
the file. Let's say I have a file and its filename, I will call the file as `FILE` (pretty obvious)
and the filename as `HARD_LINK_1`, the simple way to visual the relation between the two is
as the following:

```
HARD_LINK_1 -> FILE
```

It implies that if I refer the `HARD_LINK_1` I actually referring `FILE`, any action I
do to `HARD_LINK_1` is done to `FILE`.

If I create another hard link that links to `FILE`, let's say `HARD_LINK_2`, now `FILE`
has two hard links. Here is how it looks like:

```
HARD_LINK_1 -> FILE
HARD_LINK_2 -> FILE
```

Both `HARD_LINK_1` and `HARD_LINK_2` has the same inode since both are referring to
the same file `FILE`. If I change the content via `HARD_LINK_1`, the content will
also changed when I access it from `HARD_LINK_2`. When I delete `HARD_LINK_1`,
the `FILE` will not gone since it has one remaining link `HARD_LINK_2`, it will
be removed from the filesystem when all links to the data has been removed.

Hard link only work for regular files and if the new hard links exist on the
same filesystem.

### Soft link

Unlike hard link that links the filename to the actual data, or inode if you
prefer, the soft link (also known as _symbolic link_) links to the filename.
Say that I have a file, a filename, and a soft link, the file is called `FILE`,
the filename is called `FNAME` and the soft link is called `SOFT_LINK`.
Here is how it looks like:

```
FNAME -> FILE
SOFT_LINK -> FNAME
```

When I access `SOFT_LINK` I'm actually accessing the `FNAME` that access the `FILE`,
in other words, when I use `SOFT_LINK` I don't know about the `FILE`, all I know
is that I'm accessing a file that has a filename named `FNAME`.

This raises a problem when `FNAME` is deleted, since there is no link left that
links to `FILE`, it will be removed from the filesystem, however since `SOFT_LINK`
only knows about `FNAME` it will still _points_ to `FNAME` even though it is now 
didn't exists in the filesystem. This situation is referred to as a _dangling soft link_.

## Using `ln` Command

We have talked about hard link and soft link. How do we create one? We can use
the linux command `ln` to create hard links and soft links. The syntax is pretty
simple.

To create a hard link, the syntax is as the following:

```bash
ln <source_file> <output_file>
```

To create a soft link, just add the `-s` flag:

```bash
ln -s <source_file> <output_file>
```

For example, if I have a file named `hello.txt`, to create the hard link in the
same directory with the name `hardlink_hello.txt` I can type:

```bash
ln hello.txt hardlink_hello.txt
```

if I want to create a soft link named `softlink_hello.txt`, I just need to add the `-s` flag, so:

```bash
ln -s hello.txt softlink_hello.txt
```


## Afterword

There you have it, a short and simplified explanation about hard link and soft link in
Linux. Using hard link and soft link are useful when you want to create a _shortcut_ to
a certain program or to give it to give it another name that suits you. You can create,
for example, a soft link to `cp` program named `copy`, so whenever you want to copy something
just type `copy` instead of `cp`, I don't know why you want to do that but you can.

Anyway, that's it for now. I'll see you on another post.

Stay safe.

## Further Reading

- [Hard links and soft links in Linux explained - RedHat](https://www.redhat.com/sysadmin/linking-linux-explained)
