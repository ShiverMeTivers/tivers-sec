#!/bin/bash

if [ $(whoami) != root  ]; then
	echo -e "\nRun this script as root only.\nThe script will now exit\n"
	exit
fi

case $1 in
up)

    #Randomize SSH ports
	export P2PORT=$(( ($RANDOM % 65535) + 1000))
	export P3PORT=$(( ($RANDOM % 65535) + 1000))
	export P4PORT=$(( ($RANDOM % 65535) + 1000))
	export P5PORT=$(( ($RANDOM % 65535) + 1000))
	export P6PORT=$(( ($RANDOM % 65535) + 1000))
	
	#Randomize pivot ips
	export ip2=$(( ($RANDOM % 249) + 4))
	export ip3=$(( ($RANDOM % 249) + 4))
	export ip4=$(( ($RANDOM % 249) + 4))
	export ip5=$(( ($RANDOM % 249) + 4))
	export ip6=$(( ($RANDOM % 249) + 4))
	
	#Rebuild Images with random ports
	docker-compose build > /dev/null

	#Flush DOCKER-USER Chains in iptables
	iptables -F DOCKER-USER

	#Bring up docker
	docker-compose up -d > /dev/null

	#Create iptables rules to segment the network
	for i in $(seq 1 5); do
		iptables -I DOCKER-USER -s 172.16.$i.0/24 -d 172.16.$(expr $i + 1).0/24 -j ACCEPT
		iptables -I DOCKER-USER -s 172.16.$(expr $i + 1).0/24 -d 172.16.$i.0/24 -j ACCEPT
	done

	#Block SSH from the local machine to anything but 172.16.1.1 (Localhost)
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.2.0/24 -d 172.16.2.0/24 -j DROP
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.3.0/24 -d 172.16.3.0/24 -j DROP
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.4.0/24 -d 172.16.4.0/24 -j DROP
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.5.0/24 -d 172.16.5.0/24 -j DROP
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.6.0/24 -d 172.16.6.0/24 -j DROP
	sudo iptables -I OUTPUT -p tcp --dport 22 -s 172.16.1.1 -d 172.16.1.2 -j ACCEPT

	#Flush Masqurade rules from iptables POSTROUTING chain so auth.log/wtmp/lastlog output will be correct
	for i in $(seq 1 6); do
		iptables -t nat -D POSTROUTING 1
	done

	echo -e "\n\033[35;5mScenario Up\033[0m\n"
	;;
down)
	#Bring down the docker container
	echo "Bringing the scenario down"
	docker-compose down
	;;
*)
	cat << EOF
	Invalid argument given. Please give "up" or "down" as arguments
	
	up - creates Scenario environment and adds iptables rules
	down - removes the scenario and flushes Ip table rules
EOF
	;;

esac