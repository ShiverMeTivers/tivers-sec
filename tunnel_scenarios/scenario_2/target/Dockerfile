# syntax=docker/dockerfile:1
#Target Baseline 
FROM cirros:latest
SHELL ["/bin/bash","-c"]
ARG ports
RUN echo 'test:testpassword' | chpasswd
#RUN sed -i "s/#Port 22/Port $ports/g" /etc/ssh/sshd_config
#Infinite process to keep container running. It starts sshd as a service and pauses.
RUN echo -e '#!/bin/bash\nsed -i "s/#Port 22/Port ${SSH_PORT}/g" /etc/ssh/sshd_config\nservice rsyslog start\n\nservice ssh start\nwhile true; do\n sleep 60\ndone' > /root/startup.sh \
    && chmod ug+x /root/startup.sh

#Runs the script to start the machine
#ENTRYPOINT ["service", "ssh", "start"]
ENTRYPOINT ["/root/startup.sh"]



