# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev curl gpg -y
RUN echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.04/ /' | tee /etc/apt/sources.list.d/security:zeek.list
RUN curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
#Workaround to get past required user input. Prints 3 blank new-lines.
RUN printf "n\nn\nn" | apt install dma -y
RUN apt update && apt install zeek -y
RUN apt install vim -y

#Install Filebeat for Shipping Logs to Elastic
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.14.0-amd64.deb \
    && dpkg -i filebeat-7.14.0-amd64.deb
#Link filebeat modules to default directory search path
#Link zeek log output directory to default log search path in filebeat's zeek module.
RUN mkdir -p /var/log/bro/current/
RUN ln -s /usr/share/filebeat/module/ /usr/share/filebeat/bin/module \
    && ln -s /opt/zeek/logs /var/log/bro/current/

#Configures Elastic with pre-generated yml files saved
COPY filebeat.yml /etc/filebeat/
COPY zeek.yml /etc/filebeat/modules.d/
RUN /usr/share/filebeat/bin/filebeat -c /etc/filebeat/filebeat.yml setup -e


#Runs Filebeat as a Service
RUN service filebeat start

#Set working directory for the zeek command. By default it saves logs to the zeek processes working directory.
WORKDIR /opt/zeek/logs/
SHELL ["/bin/bash","-c"]
ENTRYPOINT /opt/zeek/bin/zeek -C -i ${INTERFACE} local ${ZEEKARGS1} ${ZEEKARGS2} ${ZEEKARGS3} ${ZEEKARGS4}

#Debugging  only. 
#Use 'docker exec -it <container name> /bin/bash' to get a terminal in the container.
#Comment out the other ENTRYPOINT entry
#ENTRYPOINT ["top", "-b", "-c"]




