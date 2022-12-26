#!/bin/bash


export scriptdir=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")
export configdir="$scriptdir/config"
source $configdir/traffic-gen-functions.sh

##Function to check if script is running as root. Exits if it is not
rootcheck_func(){
  if [ $(id -u) -eq 0 ]
  then
    echo "Script is running as root. Continuing..."
  else
    echo "This script must be run as root. Exiting..."
    exit
  fi

  scriptdir=
  echo -e "Script running from $scriptdir\n\n"
}

## Builds the ubuntu-trafficgen image. Will check to see if it exists before creating it.
## Note: if connected to the internet and the base image of Ubuntu20.04 updates, the script will download and rebuild any images present.
build_funct(){
  imgchk=$(docker image list -f reference=ubuntu-trafficgen:latest | wc -l)
  if [ $imgchk -gt 1  ]
  then
    echo -e "\nLatest ubuntu-trafficgen image present\n"
	return
  else
    echo -e "\nLatest ubuntu-trafficgen building image not present.\nBuoldign image from Dockerfile...\n"
	if [ -r config/Dockerfile ]
    then
      echo "DockerFile exists. Starting build. Ensure you are connected to the internet."
	  docker build -t ubuntu-trafficgen:latest  - < $configdir/Dockerfile
	else 
	  echo "\nDockerfile is missing from $configdir/. Returning to main menu\n"
    fi
  fi

}

##Traffic generation starter function. Creates networks, containers, and starts the rotation function to change ip addresses every X seconds.
tgstart_func(){
	if [ -e $scriptdir/tg.pid ]
	then
      echo "Traffic generation is already running as PID: $(cat $scriptdir/tg.pid)"
	else
	  ##(ping localhost > /dev/null) &
	  makenets_func
	  makeips_funct
      makecontainers_func
	  (rotate_ips) &
	  echo $! | tee $scriptdir/tg.pid
	fi	
}

##Traffic generation exit function. Removes containers and networks.
tgstop_func(){
	if [ -e $scriptdir/tg.pid ]
	then
	  kill -s 9 $(cat $scriptdir/tg.pid)
	  rm -f $scriptdir/tg.pid
	else
	  echo -e "$scriptdir/tg.pid not found. Killing docker containers and networks.."
	fi
	removecontainers_func
    removenets_func
}

## Status function. Shows currently executing containers along with the IP address associated with them.
tgcheck_func(){
	if [ -e $scriptdir/tg.pid ]
	then
      tg_run=$(cat $scriptdir/tg.pid)
	  echo -e "PID: $tg_run\n"
	  ps --pid $tg_run
	else
	  echo -e "PID file not found in $scriptdir/tg.pid\n"
	fi
	
	status=($(docker inspect -f '{{printf "%q--%q--" .Name .State.Status}}{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq -f name=instance*) 2>/dev/null))
	echo $?
	if [ $? == 0 ]
	then
	  echo -e "Instance_name--Status--IPAddress"
	  for container in ${status[@]}
	  do
	    echo $container
	  done
	fi
}

##Exit function. Removes all containers (even if they do not exist) and exits with code 0
cleanup_func() {
  echo "Stopping containers"
  tgstop_func

  echo "Deleting $scriptdir/.env"
  rm $configdir/.env 
  
  echo "Done. Exiting script"
  exit
}

menu_func(){
  echo -e "########\nWARNING\n########\n\n Do not exit this script wil traffic generation is occuring. Ensure that you kill the process before the script exits.\nFailure to do so will result in an orphaned process."
  echo -e "1. Initilize docker images\n2. Start traffic generation\n3. Stop traffic generation\n4. Get status traffic generation containers\n5. Clear docker containers and networks"
  read -e -p "Selection: " select
  case $select in
    1)
	  clear
	  echo 1
	  build_funct
	  ;;
	2)
	  echo 2
	  clear
	  tgstart_func 2&>1 /dev/null #Uncommment this for verbose docker output.
	  ;;
	3) 
	  clear
	  echo 3
	  tgstop_func
	  ;;
	4)
	  echo 4
	  clear
	  tgcheck_func
	  ;;	
	5)
	  echo 5
	  clear
	  cleanup_func
	  ;;	  
	*)
	  echo "Invalid Option"
	  ;;
  esac
  
}

#####################################


rootcheck_func
while true
do
  menu_func
done

#I never got this to work..it is supposed to catch ctrl^c and kill all containers, but it does not capture that.
trap cleanup_func SIGHUP SIGINT SIGTERM