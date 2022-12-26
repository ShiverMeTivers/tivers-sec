# syntax=docker/dockerfile:1
#Ubuntu Baseline 
FROM ubuntu:20.04
SHELL ["/bin/bash","-c"]
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:testpassword' | chpasswd
RUN apt update 
RUN apt install wget curl net-tools iproute2 -y
#I really need to install ping...
#Infinite process to keep container running. It starts sshd as a service and pauses.
#ARG ports
RUN echo -e '#!/bin/bash\nservice rsyslog reload\n\nservice rsyslog start\n\nservice ssh start\nwhile true; do\n sleep 60\ndone' > /root/startup.sh \
    && chmod ug+x /root/startup.sh

#Runs the script to start the machine
#ENTRYPOINT ["service", "ssh", "start"]
ENTRYPOINT ["/root/startup.sh"]

