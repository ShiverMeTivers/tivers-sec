# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev curl gpg -y
RUN echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.04/ /' | tee /etc/apt/sources.list.d/security:zeek.list
RUN curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
RUN apt update
#Workaround to get past required user input. Prints 3 blank new-lines.
RUN printf "n\nn\nn" | apt install dma -y
RUN apt install zeek iproute2 tcpdump -y

WORKDIR /opt/zeek/logs/
SHELL ["/bin/bash","-c"]
ENTRYPOINT /opt/zeek/bin/zeek -C -i ${INTERFACE} local ${ZEEKARGS1} ${ZEEKARGS2} ${ZEEKARGS3} ${ZEEKARGS4}

#Debugging  only. 
#Use 'docker exec -it <container name> /bin/bash' to get a terminal in the container.
#Comment out the other ENTRYPOINT entry
#ENTRYPOINT ["top", "-b", "-c"]




