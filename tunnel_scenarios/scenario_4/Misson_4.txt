Mission:

Use proper SSH tunneling techniques to reach tgt-10 without violating the rules of engagement

Scheme of Maneuver:
- Displayed when scenario is created

Credentials:
- test:testpassword

Rules of Engagement:

1. You must follow the scheme of manuver
2. You cannot modify the knownhosts file on any device accessed.
2. You are not allowed to upload tools to any pivot. All tools must be tunnelled from the Operations Station.
3. You are not allowed to privelege escalate at any point, for any reason.
4. You are not allowed to use /dev/tcp

Startup Instructions:
1. Install docker engine and command line interface in Windows or Linux
   - https://docs.docker.com/engine/install/
2. Execute the script "scenario_4.sh" with the "up" argument to start the scenario and display the scheme of maneuver.
3. SSH into localhost port 2222 on using the credentials test:testpassword to begin.
  - Execute ss -ant or netstat -ant to see that port 2222 is listening on the device.

During Scenario Instructions:
1. Execute the script "scenario_4.sh" with the "check" command to show logs from each machine.
   - Use this to determine if you are using proper ssh techniques with master sockets and options.

Closing scenario:
1. Execute the script "scenario_4.sh" with the "down" argument to stop the scenario and remove docker containers

   
Note: IP addresses in this scenario are the same each time it is brought up.
Note: Container auth.logs are available with "docker compose logs -f" in intervals of 10 seconds.
Note: Check your technique with scenario_4.sh check. 
  - No more than one IP should be in the WTMP (last command) output
  - The IP within the output should be the previous IP from the scheme of manuever
  - The knownhosts file should always be blank.
