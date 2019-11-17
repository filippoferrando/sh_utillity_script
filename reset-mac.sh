#! /bin/bash
#change interface with yours
ifconfig wlp3s0 down

macchanger --permanent wlp3s0

ifconfig wlp3s0 up

ifconfig wlp3s0

echo -e "Mac Restore Succeful!"

exit
