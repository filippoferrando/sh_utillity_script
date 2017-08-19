#!/bin/bash

apt-get update

sleep 1s

apt-get upgrade

sleep 1s

apt-get dist-upgrade

sleep 1s

clear

echo -e "\e[32mUpdating-Complete!"

sleep 5s

clear

exit
