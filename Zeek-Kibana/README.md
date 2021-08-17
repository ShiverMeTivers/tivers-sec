# Using Zeek-Capture 

1. Download and Unzip the Zeek-Capture directory
2. Set the **INTERFACE** variable in *zeek_capture.env* to set the interface you want to sniff traffic from.
3. Set the **ZEEKARGS1** variable to F to change the log format to TSV logs, else leave the value at default for JSON logs.
4. Execute `docker-compose up -d` to start the container
5. Examine the directory where `docker-compose up -d` was executed for any logs that were generated.

