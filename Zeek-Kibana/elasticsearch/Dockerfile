# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install apt-transport-https wget gnupg1 gnupg gnupg2  vim -y
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" >> /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install elasticsearch
SHELL ["/bin/bash","-c"]
WORKDIR "/usr/share/elasticsearch"
#EXPOSE 9200/tcp
#EXPOSE 9300/tcp
#Debugging  only. 
#Use 'docker exec -it <container name> /bin/bash' to get a terminal in the container.
#Comment out the other ENTRYPOINT entry
#ENTRYPOINT ["top", "-b", "-c"]
ENTRYPOINT ["runuser", "-u", "elasticsearch", "bin/elasticsearch"]

#runuser -u elasticsearch bin/elasticsearch

