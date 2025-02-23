#!/bin/bash

# Simple DNS lookup script
#
# author: @davimoreno

SERVER=172.16.1.140

for ((i=1; i <= 255; i++)) do
	IP=172.16.1.$i
	#nslookup $IP $SERVER | grep "name"
	host $IP $SERVER | grep "domain name"
	#echo $IP
done
