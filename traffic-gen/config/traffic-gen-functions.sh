#!/bin/bash

## configuration section
#Instance count must always be greater than 1. It is tested up to 100.
instance_count=30
#Mode 1 will randomize the 4th octet of the subnets in subnets.conf. This makes traffic come from /24 address spaces
#Mode 2 will randomize the 3rd and 4th octets of subnets in subnet.conf. This makes traffic potentially come up /16 address spaces.
mode=2
#This sets the delay on rotating ip addresses. The default is 60 seconds. The value must be in seconds form. So 1 hour is 3600 seconds.
rotation_delay=60
##

## Dont change these options
## These variables are used in the functions below. Change them only if you know what your are doing.
subnets_conf="$configdir/subnets.conf"
env_file="$configdir/.env"
driver_opts="--opt com.docker.network.bridge.enable_ip_masquerade=false --opt internal=false --driver=bridge"
net_prefix="tg"
docker_image="ubuntu-trafficgen:latest"
cmd="/webscript.sh"
##

##dont change these
##Really don't. They form the basis for all the flow statements in each function. 
## Note: Because arrays count from 0, the instance count configuration option is always reduced by 1. 
instance_count=$((instance_count - 1))
ip_array=($(cat $subnets_conf| grep -v "#"))
ip_count=$(seq 0 $((${#ip_array[@]}-1)))
ip_length=${#ip_array[@]}


######
makeips_funct() {
  
  echo -e "\nChanging initial ip addresses.\nCheck $configdir/.env for new data\n"

  octetlist=("")
  cat /dev/null > $configdir/.env
  
  for i in `seq 0 $instance_count`
  do
    octetlist+=($(echo $((($RANDOM % 249) + 4 ))),$((($RANDOM % 249) + 4 )))
  done
  
  for ip_env in ${octetlist[@]}
  do
    #echo $ip_env |tee -a $configdir/.env
	echo $ip_env >> $configdir/.env
  done
  
  if [ $mode == 1 ]
  then
    octet4=($(cat $env_file| awk -F "," '{ print $1 }'))
  elif [ $mode == 2 ]
  then
    octet3=($(cat $env_file| awk -F "," '{ print $1 }'))
    octet4=($(cat $env_file| awk -F "," '{ print $2 }'))
  fi
  
}

makenets_func(){
  
  for i in $ip_count  #For each network in subnets.conf - Create a network. Subtract 1 because arrays start from 0. Do not do division on $ip_count if only only one subnet is there.
  do
    #echo $i
	#echo ${ip_array[$i]}
	gw=$(echo ${ip_array[$i]} | awk -F "." '{ print $1"."$2"."$3"."1}') #Mutate the subnet to create a Gateway address for docker. Ex: 10.0.0.0/24 will return a 10.0.0.1 GW address
	echo $gw
    docker network create --subnet ${ip_array[$i]} --gateway $gw  $driver_opts tg$i  
  done 
}

removenets_func(){

  for i in $ip_count
  do
	#echo "Removed ${ip_array[$i]}"
    docker network rm  tg$i
  done 
}


makecontainers_func(){
if [ $mode == 1 ]
then
  #echo -e "address:\t4th\ttg#\tarry#\trand_ip" ////Troubleshooting
  for i in `seq 0 $instance_count` # for every instance in instance_count create a container
  do  
    net=$(( ($RANDOM % $ip_length) )) #select a random integer that represents an index postion in subnets.conf
	  ip=$(echo ${ip_array[$net]} | awk -F "." -v o4=${octet4[$i]} '{ print $1"."$2"."$3"."o4}') # Mutate the subnet assigned to change the 4th octet with one from config/.env
	  #echo -e "$ip\t${octet4[$i]}\t:$net\t:$i" //Troubleshooting
	  docker container run -d -v $configdir/webscript.sh:/webscript.sh --entrypoint /webscript.sh --network tg$net --ip $ip --name instance$i $docker_image  
  done
elif [ $mode == 2 ]
then
  echo -e "address:\t4th\ttg#\tarry#\trand_ip"
  duptest=()
  for i in `seq 0 $instance_count`
  do  
    net=$(( ($RANDOM % $ip_length) ))
	rand_ip=$(( ($RANDOM % $instance_count) ))
	ip=$(echo ${ip_array[$net]} | awk -F "." -v o3=${octet3[$i]} -v o4=${octet4[$i]} '{ print $1"."$2"."o3"."o4}')
	#duptest+=($ip)
	#echo -e "$ip\t${octet4[$i]}\t:$net\t$i:\t$rand_ip:\t${octet4[$rand_ip]}"
	docker container run -d -v $configdir/webscript.sh:/webscript.sh --entrypoint /webscript.sh --network tg$net --ip $ip --name instance$i $docker_image
  done
  #for ip in "${duptest[@]}"; do echo "${ip}"; done
  #uniqs_arr=($(for ip in "${duptest[@]}"; do echo "${ip}"; done | sort -u|wc -l))
  #echo $uniqs_arr
else
  echo "Error, Please choose mode 1 or 2"
fi
}

removecontainers_func(){
  for i in `seq 0 $instance_count`
  do
    docker container rm -f instance$i
  done 
}

rotate_ips(){
 while true
 do
    sleep "$rotation_delay"s
	removecontainers_func
    makeips_funct
	makecontainers_func	
 done
}
#echo $ip | awk -F "." '{ print $1"."$2'.'$3}'^C

#makenets_func
#makecontainers_func
#sleep 3s
#removecontainers_func
#removenets_func
##trap cleanup_FUNCTION SIGHUP SIGINT SIGTERM



