#!/bin/bash

ifconfig wlp3s0 down

macchanger -r wlp3s0

ifconfig wlp3s0 up

ifconfig wlp3s0

echo -e "\e[1mMac Changing Succes!"

exit

