#!/bin/bash

if [ $(whoami) != root  ]; then
	echo -e "\nRun this script as root only.\nThe script will now exit\n"
	exit
fi

case $1 in
up)
	function ip_gen() {
		ips=()
		for i in $(seq 0 19)
		do
		ips+=( $((($RANDOM % 249) + 4)) )
		done
	}

	while true

	ip_gen
	result=$(echo ${ips[@]} | tr ' ' '\n' | sort -nu | wc -w)
	do
	if [ $result -eq 19 ] 
		then 
			break  
		else 
			ip_gen 
	fi
	done

	for i in $(seq 0 19)
	do
	eval ip$i=$(echo ${ips[$i]})
	done


    	#Randomize SSH pivot ports
	export P2PORT=$(( ($RANDOM % 65535) + 1000))
	export P3PORT=$(( ($RANDOM % 65535) + 1000))
	export P4PORT=$(( ($RANDOM % 65535) + 1000))
	export P5PORT=$(( ($RANDOM % 65535) + 1000))
	export P6PORT=$(( ($RANDOM % 65535) + 1000))

    	#Randomize SSH target ports
	export tgt1port=$(( ($RANDOM % 65535) + 1000))
	export tgt2port=$(( ($RANDOM % 65535) + 1000))
	export tgt3port=$(( ($RANDOM % 65535) + 1000))
	export tgt4port=$(( ($RANDOM % 65535) + 1000))
	export tgt5port=$(( ($RANDOM % 65535) + 1000))
	export tgt6port=$(( ($RANDOM % 65535) + 1000))
	export tgt7port=$(( ($RANDOM % 65535) + 1000))
	
	#Randomize pivot ips
	export ip2=$ip2
	export ip3=$ip3
	export ip4=$ip4
	export ip5=$ip5
	export ip6=$ip6

	#Randomize target ips
	export tgt1=$ip7
	export tgt2=$ip8
	export tgt3=$ip9
	export tgt4=$ip10
	export tgt5=$ip11
	export tgt6=$ip12
	export tgt7=$ip13
	
	#Rebuild Images with random ports
	#docker-compose build > /dev/null

	#Flush DOCKER-USER Chains in iptables
	iptables -F DOCKER-USER

	#Bring up docker
	docker-compose up -d 

	#Create iptables rules to segment the network
	#for i in $(seq 1 5); do
	#	iptables -I DOCKER-USER -s 172.16.$i.0/24 -d 172.16.$(expr $i + 1).0/24 -j ACCEPT
	#	iptables -I DOCKER-USER -s 172.16.$(expr $i + 1).0/24 -d 172.16.$i.0/24 -j ACCEPT
	#done

	#Block Connections to Targets from Pivots outside of thier subnets
	iptables -I DOCKER-USER -s 172.16.1.2 -d 172.16.2.$ip2 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.2.$ip2 -d 172.16.3.$ip3 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.3.$ip3 -d 172.16.2.$ip2 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.3.$ip3 -d 172.16.4.$ip4 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.4.$ip4 -d 172.16.3.$ip3 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.4.$ip4 -d 172.16.5.$ip5 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.5.$ip5 -d 172.16.4.$ip4 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.5.$ip5 -d 172.16.6.$ip6 -j ACCEPT
	iptables -I DOCKER-USER -s 172.16.6.$ip6 -d 172.16.5.$ip5 -j ACCEPT

	#Block Connections from the local machine to anything but 172.16.1.2 (Pivot 1)
	sudo iptables -I OUTPUT -s 172.16.2.1 -d 172.16.2.0/24 -j REJECT
	sudo iptables -I OUTPUT -s 172.16.3.1 -d 172.16.3.0/24 -j REJECT
	sudo iptables -I OUTPUT -s 172.16.4.1 -d 172.16.4.0/24 -j REJECT
	sudo iptables -I OUTPUT -s 172.16.5.1 -d 172.16.5.0/24 -j REJECT
	sudo iptables -I OUTPUT -s 172.16.6.1 -d 172.16.6.0/24 -j REJECT

	#Flush Masqurade rules from iptables POSTROUTING chain so auth.log/wtmp/lastlog output will be correct
	for i in $(seq 1 6); do
		iptables -t nat -D POSTROUTING 1
	done

	echo -e "\n\033[35;5mScenario Up\033[0m\n"
	;;
down)
	#Bring down the docker container
	echo "Bringing the scenario down"
	
	#Bring down Containers
	docker-compose down
	
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
