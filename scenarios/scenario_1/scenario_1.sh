#!/bin/bash

if [ $(whoami) != root  ]; then
	echo -e "\nRun this script as root only.\nThe script will now exit\n"
	exit
fi

case $1 in
up)

	#Randomize pivot ips
	export ip2=$(( ($RANDOM % 249) + 4))
	export ip3=$(( ($RANDOM % 249) + 4))
	export ip4=$(( ($RANDOM % 249) + 4))
	export ip5=$(( ($RANDOM % 249) + 4))
	export ip6=$(( ($RANDOM % 249) + 4))
	
	#Rebuild Images with random ports
	docker compose build > /dev/null

	#Flush DOCKER-USER Chains in iptables
	iptables -F DOCKER-USER

	#Bring up docker
	docker compose up -d > /dev/null

	#Create iptables rules to segment the network
	for i in $(seq 1 5); do
		iptables -I DOCKER-USER -s 172.16.$i.0/24 -d 172.16.$(expr $i + 1).0/24 -j ACCEPT
		iptables -I DOCKER-USER -s 172.16.$(expr $i + 1).0/24 -d 172.16.$i.0/24 -j ACCEPT
	done

	#Block SSH from the local machine to anything but 172.16.1.2  (Localhost)
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

	echo "PIVOT-1: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-1)"
	echo "PIVOT-2: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-2)"
	echo "PIVOT-3: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-3)"
	echo "PIVOT-4: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-4)"
	echo "PIVOT-5: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-5)"
	echo "PIVOT-6: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pivot-6)"

	echo -e "\n\033[35;5mScenario Up\033[0m\n"
	;;
down)
	#Bring down the docker container
	echo "Bringing the scenario down"
	
	#Bring down Containers
	docker compose down
	
	#FLush Created Rules in OUTPUT CHAIN
	iptables -F OUTPUT
	
	#Remove 10 created rules from Docker User
	for i in $(seq 10); do
                iptables -D DOCKER-USER 1
        done

	#Restart docker.service #Note: Do I reallly need to do this?
	systemctl restart docker.service

	;;
*)
	cat << EOF
	Invalid argument given. Please give "up" or "down" as arguments
	
	up - creates Scenario environment and adds iptables rules
	down - removes the scenario and flushes Ip table rules
EOF
	;;

esac
