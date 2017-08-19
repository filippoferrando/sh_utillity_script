#!/bin/bash

clear

echo "Welcome To Net-Utils!"

sleep 3s

echo "ifconfig"

ifconfig wlp3s0

sleep 2s

echo "iwconfig"

iwconfig wlp3s0

sleep 3s

clear

echo "Test Connection"

sleep 2s

clear

sleep 2s

echo "Traceroute"

sleep 2s

traceroute www.google.com

sleep 2s

traceroute www.cisco.com

sleep 5s

clear

echo -e "\e[32mTest Complete!"

sleep 4s

clear

exit
