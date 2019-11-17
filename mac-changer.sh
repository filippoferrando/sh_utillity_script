#!/bin/bash

#change interfaces with your's

ifconfig wlp3s0 down

macchanger -r wlp3s0

ifconfig wlp3s0 up

ifconfig wlp3s0

echo -e "Mac Changing Succes!"

exit

