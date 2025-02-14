#!/bin/bash

#
# This file contains useful functions that can be called as terminal commands 
#
# Just add the following line to your ~/.bashrc file:
#     source /path/to/this/file
#
# author: @davimoreno
#

vpn_pe () {
    # Connect to the Pentest Experience VPN
    sudo openvpn /path/to/pe/openvpn/file
}

vpn_thm () {
    # Connect to TryHackMe VPN
    sudo openvpn /path/to/thm/openvpn/file
}

net_ping () {
    # PING a whole network and save in file alive IPs 

    if [ -z $1 ]; then
        echo "[!] Missing network parameter"
        echo "    net_ping 192.168.1.0/24"
    else
        # stderr to /dev/null to avoid "Host Unreachable" messages
        fping -a -g $1 2> /dev/null | tee -a alive.txt
    fi
}

ptscan () {
    # Scan all TCP Ports
    # Scan all TCP ports and save result into file
    if [ -z $1 ]; then
        echo "[!] Missing parameters"
        echo "    ptscan 192.168.1.50"
    else
        
        IP=$1
        
        mkdir -p nmap-$IP

        DATA=$(date +"%Y-%m-%d %H:%M:%S")
        FILENAME="SCAN-ALL-TCP.txt"
        DIR="nmap-$IP"
        
        echo "$DATA Scanning all TCP ports"
        
        sudo nmap -Pn -sS --open -p- -oA "$DIR/$FILENAME" $IP &>/dev/null
        
    fi
}

uptscan () {
    # Scan all UDP Ports
    # Scan all UDP ports and save result into file
    if [ -z $1 ]; then
        echo "[!] Missing parameters"
        echo "    uptscan 192.168.1.50"
    else
        
        IP=$1
        
        mkdir -p nmap-$IP

        DATA=$(date +"%Y-%m-%d %H:%M:%S")
        FILENAME="SCAN-ALL-UDP.txt"
        DIR="nmap-$IP"
        
        echo "$DATA Scanning all UDP ports"
        
        sudo nmap -Pn -sU --open -p- -oA "$DIR/$FILENAME" $IP &>/dev/null
        
    fi
}

top_ptscan () {
    # Top Ports TCP Scan
    # Scan top TCP ports and save result into file
    # By default it scans the top 1000 most common ports
    if [ -z $1 ]; then
        echo "[!] Missing parameters"
        echo "    top_ptscan 192.168.1.50 100"
    else
        
        IP=$1
        
        mkdir -p nmap-$IP
        
        if [ -z $2 ]; then
            PORTS_NUM=1000
        else
            PORTS_NUM=$(( $2 ))
        fi        

        DATA=$(date +"%Y-%m-%d %H:%M:%S")
        FILENAME="SCAN-$PORTS_NUM-TCP.txt"
        DIR="nmap-$IP"
        
        echo "$DATA Scanning $PORTS_NUM most common TCP ports"
        
        sudo nmap -Pn -sS --open --top-ports=$PORTS_NUM -oA "$DIR/$FILENAME" $IP &>/dev/null
        
    fi
}

top_uptscan () {
    # Top Ports UDP Scan
    # Scan top UDP ports and save result into file
    # By default it scans the top 100 most common ports
    if [ -z $1 ]; then
        echo "[!] Missing parameters"
        echo "    top_uptscan 192.168.1.50 100"
    else
        
        IP=$1
        
        if [ ! -d "nmap-$IP" ]; then
            mkdir nmap-$IP
        fi
        
        if [ -z $2 ]; then
            PORTS_NUM=100
        else
            PORTS_NUM=$(( $2 ))
        fi        

        DATA=$(date +"%Y-%m-%d %H:%M:%S")
        FILENAME="SCAN-$PORTS_NUM-UDP.txt"
        DIR="nmap-$IP"
        
        echo "$DATA Scanning $PORTS_NUM most common UDP ports"
        
        sudo nmap -Pn -sU --open --top-ports=$PORTS_NUM -oA "$DIR/$FILENAME" $IP &>/dev/null
        
    fi
}
