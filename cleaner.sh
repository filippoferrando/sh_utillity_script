#!/bin/bash

apt-get autoremove

sleep 1s

apt-get clean

sleep 1s

apt-get autoclean

sleep 1s

clear

echo -e "\e[32mCleaning-Complete!"

sleep 5s

clear

exit
