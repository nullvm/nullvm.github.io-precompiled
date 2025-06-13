---
title: 'Vim Backup-Copy'
date: 2025-06-12T21:41:46+07:00
draft: false
description: ''
tags: ['vim']
---


While writing a custom version of the `tail -f` command in C, I stumbled upon an 
interesting behavior in the Vim/Neovim text editors. The purpose of the program is 
to continuously print any new data appended to the end of a file—just like `tail -f`,
which is commonly used for watching log files.

In my implementation, I have something like this:

```c
const char *filename = argv[1];
int fd = open(filename, O_RDONLY);
if (fd == -1) {
	perror("open");
	return 1;
}
```


The `open()` function, provided by `#include <fcntl.h>`, returns a file descriptor—a 
small, nonnegative integer that acts as an index into the process’s table of 
open file descriptors.

If you check the man page for `open` using `man 2 open`, you’ll find this line:

```
Each open() of a file creates a new open file description; thus,
there may be multiple open file descriptions corresponding to a
file inode.
```

The key concept here is the inode. When I call `open`, it gives me a file descriptor 
that maps to a particular file inode.

After calling open, I use the returned file descriptor to monitor any changes made 
to the file's content.

When I ran the program and used `echo` to append lines to the file, everything worked 
as expected. The program picked up the changes and printed them out immediately.

However, things got weird when I tried editing the file using Neovim. I added a 
line at the end and saved it.

Nothing happened.

My program didn’t detect any changes. But when I used nano to modify the file, 
the output appeared as expected. This raised a question: what exactly makes Vim 
and Neovim behave differently when saving changes to a file?

Since my program keeps track of the file's inode, I started wondering: 
when Vim/Neovim saves changes to a file, does it do something that affects the inode?

Editing a file with Vim/Neovim doesn’t change the filename, so I checked whether it
modifies the inode in some way.

I used `ls -li` to inspect the file’s inode before and after editing:

```bash
$ touch a.txt
$ ls -li
12085572 -rw-rw-r-- 1 deni deni 0 Jun 13 18:23 a.txt
```

Then I made some changes using Neovim:

```bash
$ nvim a.txt
$ ls -li
12085597 -rw-rw-r-- 1 deni deni 76 Jun 13 18:24 a.txt
```

Yup, the inode changed.

That explains why my program didn’t detect the changes. It was still 
watching the original file, whose inode no longer existed.

From the Vim manual:

```man
'backup' 'bk'		boolean	(default off)
			global
			{not in Vi}
	Make a backup before overwriting a file.  Leave it around after the
	file has been successfully written.  If you do not want to keep the
	backup file, but you do want a backup while the file is being
	written, reset this option and set the 'writebackup' option (this is
	the default).  If you do not want a backup file at all reset both
	options (use this if your file system is almost full).  See the
	|backup-table| for more explanations.
	When the 'backupskip' pattern matches, a backup is not made anyway.
	When 'patchmode' is set, the backup may be renamed to become the
	oldest version of a file.
	
	...
	
	
'backupcopy' 'bkc'	string	(Vi default for Unix: "yes", otherwise: "auto")
			global
			{not in Vi}
	When writing a file and a backup is made, this option tells how it's
	done.  This is a comma separated list of words.

	The main values are:
	"yes"	make a copy of the file and overwrite the original one  
	"no"	rename the file and write a new one  
	"auto"	one of the previous, what works best
```

So yeah, since Vim/Neovim has 'backup' set to off by default, it doesn't create a backup and overwrite the
original file directly. Instead, it renames the original and writes a new file with the same name—resulting
in a new inode.

After realizing that, I modified my program to re-check the file's inode in case it changes.

Quite an interesting experience, to say the least.

Stay safe.

References: 
- https://vimdoc.sourceforge.net/htmldoc/options.html
- https://man7.org/linux/man-pages/man2/open.2.html
