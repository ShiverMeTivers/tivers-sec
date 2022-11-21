# Mission:
---
SSH to T1 through SSH tunneling
![[Pasted image 20221120135550.png]]
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
# P1
---

Scan every port and return successful results
```bash
nc -zvn $p1 1-65535 2>&1| grep 'succeeded!'| tee p1scan.txt
```

Establish dynamic port forwarding 
```bash
ssh test@172.16.1.2 -D 9050 -NT
```
---
## P2
---
### Host Descovery
---
Ping Sweep for next machine.
Use Script below
```bash
#!/bin/bash

#Ping Sweep tarket subnet
for ip in $(seq 2 254); do
  ping -c 1 $1.$ip 2>/dev/null | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f1  &
done
```

```bash
proxychains ./pingsweep.sh 172.16.2
```
Identify target IP
```bash
172.16.2.96
```
---
### Port enumeration
---
Port enumeration with script below.
```bash
nc -zvn $1 1-65535 2>&1| grep 'succeeded!'
```
Run Port enumeration script
```bash
proxychains ./portscan.sh  172.16.3.228
```

Result
```bash
Connection to 172.16.2.96 30725 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.2.96 30725
```
Result
```
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.2.96:30725-<><>-OK
Connection to 172.16.2.96 30725 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```
---
### Pivot to Host
---
Test SSH Connection

```bash
proxychains ssh test@172.16.2.96 -p 30725
```
Logged in successfully

Close dynamic tunnel

Establish port forwarding 
```bash
ssh test@172.16.1.2 -L 1111:172.16.2.96:30725 -NT
```

Establish dynamic port forwarding
```bash
ssh test@localhost -p 1111 -D 9050 -NT
```
---
## P3
---
### Host Discovery
---
Ping Sweep for next machine.

```bash
proxychains ./pingsweep.sh 172.16.3
```
Identify target IP
```bash
172.16.3.228
```
---
### Port enumeration
---

Run Port enumeration script
```bash
proxychains ./portscan.sh  172.16.3.228
```
Result
```bash
Connection to 172.16.3.228 29732 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.3.228 29732
```
Result
```bash
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.3.228:29732-<><>-OK
Connection to 172.16.3.228 29732 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```
---
### Pivot to Host
---
Test SSH Connection

```bash
proxychains ssh test@172.16.3.228 -p 29732
```

Hostname
```bash
569797312dc1
```
Close dynamic tunnel

Establish port forwarding on 
```bash
ssh test@localhost -p 1111 -L 2222:172.16.3.228:29732 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 2222 -D 9050 -NT
```
---
## P4
---
### Host Discovery
---
Ping Sweep for next machine.

```bash
proxychains ./pingsweep.sh 172.16.4
```
Identify target IP
```bash
172.16.4.192
```
---
### Port enumeration
---

Run Port enumeration script
```bash
proxychains ./portscan.sh  172.16.4.192
```
Result
```bash
Connection to 172.16.4.192 10182 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.4.192 10182
```
Result
```bash
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.4.192:10182-<><>-OK
Connection to 172.16.4.192 10182 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```
---
### Pivot to Host
---
Test SSH Connection

```bash
proxychains ssh test@172.16.4.192 -p 10182
```

Hostname
```bash
8bf05152550e
```
Close dynamic tunnel

Establish port forwarding on 
```bash
ssh test@localhost -p 2222 -L 3333:172.16.4.192:10182 -NT
```

Establish dynamic port forwarding  
```bash
ssh test@localhost -p 3333 -D 9050 -NT
```
---
## P5
---
### Host Discovery
---
Ping Sweep for next machine.

```bash
proxychains ./pingsweep.sh 172.16.5
```
Identify target IP
```bash
172.16.5.72
```
---
### Port enumeration
---

Run Port enumeration script
```bash
proxychains ./portscan.sh  172.16.5.72

```
Result
```bash
Connection to 172.16.5.72 7700 port [tcp/*] succeeded!
```
Banner grabbing
```bash
proxychains nc -v 172.16.5.72 7700 
```
Result
```bash
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.5.72:7700-<><>-OK
Connection to 172.16.5.72 7700 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```
---
### Pivot to Host
---
Test SSH Connection

```bash
proxychains ssh test@172.16.5.72 -p 7700 
```

Hostname
```bash
1c05cadac866
```
Close dynamic tunnel

Establish port forwarding on P1 to P2
```bash
ssh test@localhost -p 3333 -L 4444:172.16.5.72:7700 -NT
```

Establish dynamic port forwarding on 
```bash
ssh test@localhost -p 4444 -D 9050 -NT
```

---
## T1
---
### Host Discovery
---
Ping Sweep for next machine.

```bash
proxychains ./pingsweep.sh 172.16.6
```
Identify target IP
```bash
172.16.6.86
```
---
### Port enumeration
---

Run Port enumeration script
```bash
proxychains ./portscan.sh  172.16.6.86

```
Result
```bash
Connection to 172.16.6.86 15855 port [tcp/*] succeeded!

```
Banner grabbing
```bash
proxychains nc -v 172.16.6.86 15855 
```
Result
```bash
|S-chain|-<>-127.0.0.1:9050-<><>-172.16.6.86:15855-<><>-OK
Connection to 172.16.6.86 15855 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5

```
---
### Pivot to Host
---
Test SSH Connection

```bash
proxychains ssh test@172.16.6.86 -p 15855
```

Hostname
```bash
3ca9d50a6e96
```
Close dynamic tunnel

Establish port forwarding on 
```bash
ssh test@localhost -p 4444 -L 5555:172.16.6.86:15855 -NT
```

Establish dynamic port forwarding 
```bash
ssh test@localhost -p 5555 -D 9050 -NT
```

![[Pasted image 20221120135409.png]]