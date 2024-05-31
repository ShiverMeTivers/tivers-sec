Mission:

Use Perform an Nmap port scan of the target 172.16.6.2.

Scheme of Maneuver:
<Start>Linux/Windows Operations Station:
-<P1>172.16.1.2
--<P2>172.16.2.X
---<P3>172.16.3.X
----<P4>172.16.4.X
-----<P5>172.16.5.X 
------<T1>172.16.6.X

Credentials:
- test:testpassword

Misson Failure if:

1. Connections are detected from the interface of the Linux/Windows Operations Station
2. You are not allowed to upload tools to any pivot. All tools must be tunnelled from the Operations Station.
3. You are not allowed to privelege escalate at any point, for any reason.
4. You are not allowed to use /dev/tcp

Instructions:
1. Install docker engine and command line interface in Windows or Linux
   - https://docs.docker.com/engine/install/
2. Execute the script "scenario_1.sh" with one of the following arguments:
   - up : Downloads and builds images, creates networks, and sets firewall rules for the environment on the local machine
   - down : Removes networks and containers from the local machine.
   
Note: Every time "scenario_1.sh" is executed with "up" the last octet of each IP address is randomized. Have fun! 
Note: Container auth.logs are available with "docker compose logs -f" in intervals of 30 seconds.
