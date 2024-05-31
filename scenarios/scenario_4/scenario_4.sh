#!/bin/bash

if [ $(whoami) != root  ]; then
	echo -e "\nRun this script as root only.\nThe script will now exit\n"
	exit
fi

case $1 in
up)
	
	#Bring up docker
	docker compose up -d > /dev/null
	
	#Flush DOCKER-USER Chains in iptables
	iptables -F DOCKER-USER
	iptables -F DOCKER-ISOLATION-STAGE-1
	iptables -F DOCKER-ISOLATION-STAGE-2
	iptables -F FORWARD

	
	#Display Scheme of Maneuver
	#clear
	
	getdockip() {
		docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
	} 
		
	services=$(docker compose config --services)
	test=()
	for service in $services; do test+=($service); done
	sorted_services=($(for i in "${test[@]}"; do echo $i; done | sort -k 2 -t "-" -n ))
	
	echo "Scheme of Manuever"
	echo "------------------"
	printf "> RDR : %s\n" "$(getdockip sc4-${sorted_services[0]}-1)"
	printf '=> P1 : %s\n' "$(getdockip sc4-${sorted_services[1]}-1)"
	printf "==> P2 : %s\n" "$(getdockip sc4-${sorted_services[2]}-1)"
	printf "===> P3 : %s\n" "$(getdockip sc4-${sorted_services[3]}-1)"
	printf "====> P4 : %s\n" "$(getdockip sc4-${sorted_services[4]}-1)"
	printf "======> P6 : %s\n" "$(getdockip sc4-${sorted_services[5]}-1)"
	printf "=======> P7 : %s\n" "$(getdockip sc4-${sorted_services[6]}-1)"
	printf "========> P8 : %s\n" "$(getdockip sc4-${sorted_services[7]}-1)"
	printf "=========> P9 : %s\n" "$(getdockip sc4-${sorted_services[8]}-1)"
	printf "==========> P10 : %s\n" "$(getdockip sc4-${sorted_services[9]}-1)"
	printf "===========> TGT : %s\n" "$(getdockip sc4-${sorted_services[10]}-1)"
	
	echo -e "\n\033[35;5mScenario Up\033[0m\n"
	;;
down)
	#Bring down the docker container
	echo "Bringing the scenario down"
	
	#Bring down Containers
	docker compose down
	
	#Restart docker.service #Note: Do I reallly need to do this?
	systemctl restart docker.service

	;;
check) 

	services=$(docker compose config --services)
	test=()
	for service in $services; do test+=($service); done
	sorted_services=($(for i in "${test[@]}"; do echo $i; done | sort -k 2 -t "-" -n ))
	
	for service in ${sorted_services[@]}
	do
		echo "------------------"
		echo "service : $service"
		echo "------------------"
		docker compose exec $service last
		docker compose exec $service /bin/bash -c "wc -l /home/ubuntu/.ssh/known_hosts"
		echo -e "\n\n"
	done
	
	;;
*)
	cat << EOF
	Invalid argument given. Please give "up" or "down" as arguments
	
	up - creates Scenario environment and adds iptables rules
	down - removes the scenario and flushes Ip table rules
	logins - get last login per service
EOF
	;;

esac



