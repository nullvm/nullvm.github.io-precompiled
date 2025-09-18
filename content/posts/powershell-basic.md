---
title: 'Powershell Basics for Bash User'
date: 2025-09-16T10:42:48+07:00
draft: false
description: ''
tags: ['windows', 'powershell']
---

As someone coming from linux, there is one thing that I miss when trying to
daily driving windows, and that is the terminal. Windows has great terminal
emulator nowadays, with powershell being windows' most powerful shell.

You see, it's really natural for me to spend most of my time in the terminal
when I'm using linux, it's just much more simple and more focused. Not only that,
the commands in linux are really short consisting of 2-6 letters on average, and
once you know your way, you can combine any of that commands to make everything
even more concise and quick.

That being said, here we will take a look on how to navigate windows file system
and do simple actions in windows using powershell.

### pwd

A lot of powershell commands that has been aliased to that of the bash counterpart,
however `pwd` is not one of them. We need to use `Get-Location` to print current
working directory.

```pwsh
> Get-Location

Path
----
C:\Users\deni
```

### ls

Powershell counterpart `Get-ChildItem`. Alias `ls`, `dir`, `gci`.

```pwsh
> ls

    Directory: C:\Users\deni


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-r---         9/13/2025     22:28                Desktop
d-r---         9/16/2025     11:07                Documents
d-r---         9/15/2025     19:18                Downloads
d-r---         8/23/2025     12:25                Favorites
d-----          9/5/2025     16:39                Games
d-r---         8/23/2025     12:25                Links
```

### cd

Powershell counterpart `Set-Location`. Alias `cd`, `sl`.

```pwsh
> cd $HOME
```

### cp

Powershell counterpart `Copy-Item`. Alias `cp`, `copy`.

```pwsh
> cp file1.txt file2.txt
```

### mv

Powershell counterpart `Move-Item`. Alias `mv`, `move`.

```pwsh
> mv oldname.txt newname.txt
```

### rm

Powershell counterpart `Remove-Item`. Alias `rm`, `del`, `erase`.

```pwsh
> rm file.txt
```

### cat

Powershell counterpart `Get-Content`. Alias `cat`, `gc`, `type`.

```pwsh
> cat file.txt
```

### echo

Powershell counterpart `Write-Output`. Alias `echo`.

```pwsh
> echo "hi"
```

### grep

Powershell counterpart `Select-String`.

```pwsh
> Select-String "word" file.txt
```

### which

Powershell counterpart `Get-Command`. Alias `gcm`.

```pwsh
> gcm git
```

### man

Powershell counterpart `Get-Help`.

```pwsh
> Get-Help Get-Location
```

### whoami

Powershell counterpart `whoami`.

```pwsh
> whoami
```

### printenv

```pwsh
> Get-ChildItem Env:
```

### export VAR=value

```pwsh
$env:VAR="value"
```

### ps

```pwsh
> Get-Process
```

### kill

```pwsh
> Stop-Process -Id <PID>
```

### history

```pwsh
> Get-History
```

### ifconfig

```pwsh
> Get-NetIPAddress
```

### curl

```pwsh
> Invoke-WebRequest <URL>
```

### df

```pwsh
> Get-PSDrive
```

### stat

```pwsh
> Get-Item file
```


You can also view the list of aliases possible in powershell by using command `alias`.

