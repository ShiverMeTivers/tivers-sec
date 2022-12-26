#!/bin/bash

url_array=(
"/"
"/test.html"
"/test2.html"
)

while true
do
for url in ${url_array[*]}
do
  wget http://192.168.0.118$url -O /dev/null
  sleep $(( ($RANDOM % 5) + 4 ))
done  
done
