+++
title = "rinzler"
description = "A blazing fast, multithreading web crawler and vulnerability scanner written for the command line in rust."
weight = 1

[extra]
local_image = "img/rinzler.png"
+++
:construction: *Coming soon, check back here for updates* :construction:

```
         _             __         
   _____(_)___  ____  / /__  _____
  / ___/ / __ \/_  / / / _ \/ ___/
 / /  / / / / / / /_/ /  __/ /    
/_/  /_/_/ /_/ /___/_/\___/_/     
                                  
🙌       a fast webcrawler        🙌
🙌       from seska with ♡♡♡      🙌
```
# Features
- Webcrawler
- Vulnerabilty Scanner
- Force Browser
- Easy to use
- Can be configured with environment variables

# Rinzler in action
## multi-threaded forced browsing
[![asciicast](https://asciinema.org/a/v4TnGvjh3Jp8qgr7nUR78hUZl.svg)](https://asciinema.org/a/v4TnGvjh3Jp8qgr7nUR78hUZl)

# Usage by example
```bash
## get help
```bash
rnz --help
```
## crawling a single host
```bash
rnz https://crawler-test.com 
```
## crawling multiple hosts
```bash
rnz --host https://crawler-test.com --host https://seska.io 
```
## rate limiting requests (50ms per request)
```bash
rnz --host https://crawler-test.com --rate-limit 50
```
## run an unscoped crawl
```bash
rnz --host https://crawler-test.com --scoped=false 
```
## customize the UA header
```bash
rnz --host https://crawler-test.com --user-agent="Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36" 
```
## suppress the banner on start
```bash
rnz --host https://crawler-test.com --quiet 
```