+++
title = "The Chosen Few, Capture The Flag (TCF CTF) - 2024"
date = "2024-08-03"
[taxonomies]
tags = ["RE", "CTF", "writeups"]
+++

For no other reason that 'why not?', I entered the TCF Capture The Flag, looking for reverse engineering
challenges to have fun with over a weekend.

So, here's the challenges I succeeded at (I failed at plenty)

## Signal - Reverse Engineering - Easy Challenge 
### Value
50 points

### Description
Can you catch the right signals for the flag?
The flag length is 32 bytes (without the flag format).
Flag format: TFCCTF{flag}

Challenge is provided as an ELF binary.

### Solution
#### TL;DR 
This is a pretty simple reverse engineering challenge that requires us to find a series of 
characters that the program insists upon receiving via the command line. The first step is to figure 
out how many arguments are require (1) and then to follow program execution, paying attention to knock out
conditions in the form of 'if' statements. Stitching these values together produces the flag.

#### Details

First, I threw the binary into my linux VM and did some basic checks

```shell
$ file signal                                    
signal: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), 
dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, 
BuildID[sha1]=c5498de35b7c7f1572dc84095add74b9b0c39984, for GNU/Linux 4.4.0, not stripped
```
The last two words usually mean things are going to be simpler because `not stripped` refers not to 
the promiscuity level of the binary, dear reader, but to the fact that it has not had its debugging symbols
removed. That is to say, this binary is not a 'release' binary in the traditional sense.