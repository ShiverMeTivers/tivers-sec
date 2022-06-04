# Using Zeek-Capture 

1. Install Docker using directions from Docker's website -> [Docker Install Instructions](https://docs.docker.com/engine/install/ubuntu/)
2. Install `docker-compose` using apt or another package manager
3. Download and Unzip the Zeek-Capture directory
4. Set the **INTERFACE** variable in *zeek_capture.env* to set the interface you want to sniff traffic from.
5. Set the **ZEEKARGS1** variable to F to change the log format to TSV logs, else leave the value at default for JSON logs.
6. Execute `docker-compose up -d` to start the container
7. Check the folder **logs** in the present working directory for all zeek logs. 

