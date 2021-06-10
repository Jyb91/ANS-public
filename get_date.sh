#!/usr/bin/bash
#echo "hwclock --set --date '"`date +%D" "%r`"'" >/var/www/html/ubuntu/Packages/set_date.sh
echo timedatectl set-ntp 0 > /var/www/html/ubuntu/Packages/set_date.sh
timedatectl |grep 'RTC time'|awk '{printf("timedatectl set-time \"%s %s\"\n",$4,$5)}' >>/var/www/html/ubuntu/Packages/set_date.sh
echo timedatectl set-ntp 1 >> /var/www/html/ubuntu/Packages/set_date.sh

