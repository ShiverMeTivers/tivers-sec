# tivers-sec

Goal:

The goal of this project is to create and maintain containers to perform network analysis with minimal configuration required by the user. 

Directory Layou

* Zeek-Standalone - Zeek as an executable docker container for creating packet flow data from one or multiple pre-captured pcap
* Zeek-Capture - Zeek as an executable docker container for capturing packets from a connected physical or virtual interface
* Zeek-Kibana - *NYI* Zeek logs fed into Logstash, then visualized by Kibana running in three docker containers. Still janky, but functional.
* Tunnel Scenarios - SSH Tunneling Training in a Scenario format using Docker Images on a Linux host.

More information about Zeek here:
* https://zeek.org/
