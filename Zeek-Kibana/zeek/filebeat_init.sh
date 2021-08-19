#!/bin/bash

##
#Script takes an argument of 1 or 2 to either:
# 1 - Configure Filebeat during docker-compose up and start Zeek. 
# Required due to Filebeat's kibana and elastic port dependencies.
# docker-compose.yml will change this argument to 2
#
# 2 - Start Zeek with no filebeat. 
# Use during docker-compose build to create a functional container. 
# Default argument; Does not need to be set
##
function elasticsearch_checker(){
	counter=0
	while true ; do
		echo EOF >/dev/tcp/localhost/9200
		if [ $? -eq 0  ]; then
			sleep 3
			echo 0
			return
		elif [ $? -eq 1 ]; then
			sleep 3
			counter=$(($counter+1))
		fi

		if [ $counter -eq 20 ]; then
			echo "Error..Port 9200 unreachable after 1 minute on localhost"
			return
		fi

	done
}

function kibana_checker(){
	counter=1
	while true ; do
		echo EOF >/dev/tcp/localhost/5601 
		if [ $? -eq 0  ]; then
			sleep 3
			echo 0
			return 
		elif [ $? -eq 1 ]; then
			sleep 3
			counter=$(($counter+1))
			echo $counter
		fi

		if [ $counter -eq 20 ]; then
			echo "Error..Port 5601 unreachable after 1 minute on localhost"
			return
		fi
	done
}

#Checks if ports 9200 and 5601 are reachable, then configures and starts filebeat if they are.
#After the filebeat service is started, start Zeek.
if [ "$1" -eq "1" ]; then
	x=$(elasticsearch_checker)
	y=$(kibana_checker)	

	sleep 300s
	echo $x $y

	if [ $x -eq 0 -a $y -eq 0 ]; then
		/usr/share/filebeat/bin/filebeat -c /etc/filebeat/filebeat.yml setup -e
		service filebeat start
		/opt/zeek/bin/zeek -C -i ${INTERFACE} local ${ZEEKARGS1} ${ZEEKARGS2} ${ZEEKARGS3} ${ZEEKARGS4}
	else
		echo "Filebeat didn't start"
	fi
#Start Zeek during build so it can complete.
elif [ "$1" -eq 2 ]; then
	/opt/zeek/bin/zeek -C -i ${INTERFACE} local ${ZEEKARGS1} ${ZEEKARGS2} ${ZEEKARGS3} ${ZEEKARGS4}
fi
	


 



