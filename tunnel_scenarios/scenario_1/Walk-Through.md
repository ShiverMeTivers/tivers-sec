# Mission:
---
Gain access through SSH to the Target IP

---
## Scheme of Maneuver:
Start-Linux/Windows Operations Station:
1. P1-172.16.1.2
2. P2-172.16.2.X
3. P3-172.16.3.X
4. P4-172.16.4.X
5. P5-172.16.5.X 
6. T1-172.16.6.X

---
## Credentials:
---
- test:testpassword

---
## Misson Failure if:
---

1. Connections are detected from the interface of the Linux/Windows Operations Station
2. You are not allowed to upload tools to any pivot. All tools must be tunnelled from the Operations Station.
3. You are not allowed to privelege escalate at any point, for any reason.
4. You are not allowed to use /dev/tcp

---
## Links
---
[Netcat Scanning](https://linuxhint.com/port-scan-netcat/)

[Proxychains](https://linuxhint.com/proxychains-tutorial/)

---
## Pivot 1
---
Target IP
```bash
172.16.1.2
```
Target Port
```bash
22
```
Hostname
```bash
e7df627d9777
```
---
### Actions Taken
---
1. Host Discovery
2. Port Enumeration
3. Establish Pivot

---
### 1.Host Discovery
---
Ping host to see if up
```bash
ping 172.16.1.2 -c 1
```
Resuts
```bash
PING 172.16.1.2 (172.16.1.2) 56(84) bytes of data.
64 bytes from 172.16.1.2: icmp_seq=1 ttl=64 time=0.100 ms

--- 172.16.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.100/0.100/0.100/0.000 ms
```
---
### 2. Port Enumeration
---
Enumerate ports via NetCat
```bash
nc -zvn 172.16.1.2 1-65535 2>&1| grep 'succeeded!'
```
Result
```bash
Connection to 172.16.1.2 22 port [tcp/*] succeeded!
```
---
### 3. Establish Pivot
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
for i in $(seq 2 254); do ping 172.16.2.$i -c1 -W1 & done | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1 
```
Result
```bash
172.16.2.46
```
Setup Dynamic Portforwarding
```bash
ssh test@172.16.1.2 -D 9050 -NT
```
---
## Pivot 2
---
Target IP
```bash
172.16.2.46
```
Target Port
```bash
14558
```
Hostname
```bash
67ff46b9d514
```
---
### Actions Taken
---
1. Port Enumeration
2. Establish Pivot

---
### 1. Port Enumeration
---
Enumerate ports via NetCat script from attack box
```bash
proxychains ./portscan.sh  172.16.2.46 
```
Result
```bash
Connection to 172.16.2.46 14558 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.2.46 14558
```
Result
```
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.2.46:14558-<><>-OK
Connection to 172.16.2.46 14558 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```
---
### 2. Establish Pivot
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
proxychains ssh test@172.16.2.46 -p 14558
```
```bash
for i in $(seq 2 254); do ping 172.16.3.$i -c1 -W1 & done | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1 
```
Result
```bash
172.16.3.114
```
Close dynamic tunnel

Establish port forwarding 
```bash
ssh test@172.16.1.2 -L 1111:172.16.2.46:14558 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 1111 -D 9050 -NT
```
---
## Pivot 3
---
Target IP
```bash
172.16.3.114
```
Target Port
```bash
12949
```
Hostname
```bash
1efac73a07dd
```
---
### Actions Taken
---
1. Port Enumeration
2. Establish Pivot

---
### 1. Port Enumeration
---
Enumerate ports via NetCat script from attack box
```bash
proxychains ./portscan.sh  172.16.3.114
```
Result
```bash
Connection to 172.16.3.114 12949 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.3.114 12949
```
Result
```
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.3.114:12949-<><>-OK
Connection to 172.16.3.114 12949 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5

```
---
### 2. Establish Pivot
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
proxychains ssh test@172.16.3.114 -p 12949
```

```bash
for i in $(seq 2 254); do ping 172.16.4.$i -c1 -W1 & done | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1 
```
Result
```bash
172.16.4.225
```
Close dynamic tunnel

Establish port forwarding 
```bash
ssh test@localhost -p 1111 -L 2222:172.16.3.114:12949 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 2222 -D 9050 -NT
```
---
## Pivot 4
---
Target IP
```bash
172.16.4.225
```
Target Port
```bash
3546
```
Hostname
```bash
0192888a3b68
```
---
### Actions Taken
---
1. Port Enumeration
2. Establish Pivot


---
### 1. Port Enumeration
---
Enumerate ports via NetCat script from attack box
```bash
proxychains ./portscan.sh  172.16.4.225
```
Result
```bash
Connection to 172.16.4.225 3546 port [tcp/*] succeeded!

```
Banner grabbing
```bash
proxychains nc -v 172.16.4.225 3546
```
Result
```
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.4.225:3546-<><>-OK
Connection to 172.16.4.225 3546 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5

```
---
### 2. Establish Pivot
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
proxychains ssh test@172.16.4.225 -p 3546
```

```bash
for i in $(seq 2 254); do ping 172.16.x.$i -c1 -W1 & done | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1 
```
Result
```bash
172.16.5.64
```
Close dinamic tunnel

Establish port forwarding 
```bash
ssh test@localhost -p 2222 -L 3333:172.16.4.225:3546 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 3333 -D 9050 -NT
```
---
## Pivot 5
---
Target IP
```bash
172.16.5.64
```
Target Port
```bash
32037
```
Hostname
```bash
d9eaea5ba26c
```
---
### Actions Taken
---
1. Port Enumeration
2. Establish Pivot


---
### 1. Port Enumeration
---
Enumerate ports via NetCat script from attack box
```bash
proxychains ./portscan.sh  172.16.5.64
```
Result
```bash
Connection to 172.16.5.64 32037 port [tcp/*] succeeded!

```
Banner grabbing
```bash
proxychains nc -v 172.16.5.64 32037
```
Result
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.5.64:32037-<><>-OK
Connection to 172.16.5.64 32037 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```

---
## 2. Establish Pivot
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
proxychains ssh test@172.16.5.64 -p 32037
```

```bash
for i in $(seq 2 254); do ping 172.16.6.$i -c1 -W1 & done | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1 
```
Result
```bash
172.16.6.81
```
Close dinamic tunnel

Establish port forwarding 
```bash
ssh test@localhost -p 3333 -L 4444:172.16.5.64:32037 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 4444 -D 9050 -NT
```
---
## TARGET
---
Target IP
```bash
172.16.6.81
```
Target Port
```bash
30398
```
Hostname
```bash
e07ce16db7a2
```
---
### Actions Taken
---
1. Port Enumeration
2. Gain Access
---
### 1. Port Enumeration
---
Enumerate ports via NetCat script from attack box
```bash
proxychains ./portscan.sh  172.16.6.81
```
Result
```bash
Connection to 172.16.6.81 30398 port [tcp/*] succeeded!

```
Banner grabbing
```bash
proxychains nc -v 172.16.6.81 30398
```
Result
```
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.6.81:30398-<><>-OK
Connection to 172.16.6.81 30398 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5

```

---
## 2. Gain Access
---
SSH into machine and enumerate next subnet with a Ping sweep.
```bash
proxychains ssh test@172.16.6.81 -p 30398
```

