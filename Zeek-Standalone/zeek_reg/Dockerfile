# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev curl gpg -y
RUN echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.04/ /' | tee /etc/apt/sources.list.d/security:zeek.list
RUN curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
RUN apt update
#Workaround to get past required user input. Prints 3 blank new-lines.
RUN printf "n\nn\nn" | apt install dma -y
RUN apt install zeek iproute2 tcpdump -y
WORKDIR /root
SHELL ["/bin/bash","-c"]
#Checks /root in the container for pcap files. if it finds pcap, it processes it with zeek, else it exits.
#If it finds pcap, the zeek logs are saved in the pwd the docker command was run from.
ENTRYPOINT  \
files=$(ls /root | grep pcap | wc -w); \ 
	if [ $files -gt 0 ]; \
		then echo "The container found $files pcaps in /root. Logs will be saved in the pwd. Start Analysis..."; \ 
		else echo "No Pcap Files found in the pwd." && exit; \
	fi; \
for i in $(find /root -name *.pcap 2>/dev/null); do /opt/zeek/bin/zeek -C -r $i LogAscii::use_json=T ; done; \
echo "Zeek is done with $files files. Check the pwd for the zeek logs."
# Debugging  only. Use 'docker exec -it <container name> /bin/bash' to get a terminal in the container.
#ENTRYPOINT ["top", "-b", "-c"]
#CMD ["--help"]



