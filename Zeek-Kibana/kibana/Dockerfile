# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install apt-transport-https wget gnupg1 gnupg gnupg2 vim -y
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" >> /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install kibana
COPY --chown=root:kibana kibana.yml /etc/kibana/ 
SHELL ["/bin/bash","-c"]
#Debugging  only. 
#Use 'docker exec -it <container name> /bin/bash' to get a terminal in the container.
#Comment out the other ENTRYPOINT entry
ENTRYPOINT ["runuser", "-u", "kibana", "/usr/share/kibana/bin/kibana"]
#ENTRYPOINT ["top", "-b", "-c"]



