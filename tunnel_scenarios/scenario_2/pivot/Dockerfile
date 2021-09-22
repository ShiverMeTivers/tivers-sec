# syntax=docker/dockerfile:1
#Ubuntu Baseline 
FROM ubuntu:latest
SHELL ["/bin/bash","-c"]
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:testpassword' | chpasswd
RUN apt update && apt install openssh-server sudo -y 
RUN apt install iproute2 net-tools rsyslog -y
RUN apt install iputils-ping -y
ARG ports
#RUN sed -i "s/#Port 22/Port $ports/g" /etc/ssh/sshd_config
#Infinite process to keep container running. It starts sshd as a service and pauses.
RUN echo -e '#!/bin/bash\nsed -i "s/#Port 22/Port ${SSH_PORT}/g" /etc/ssh/sshd_config\nservice rsyslog start\n\nservice ssh start\nwhile true; do\n sleep 60\ndone' > /root/startup.sh \
    && chmod ug+x /root/startup.sh

#Runs the script to start the machine
#ENTRYPOINT ["service", "ssh", "start"]
ENTRYPOINT ["/root/startup.sh"]



