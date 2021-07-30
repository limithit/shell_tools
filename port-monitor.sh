#!/bin/sh

if [ ! -f port_monitor.log ]
then
	touch port_monitor.log
fi

while true
do

datetime=`date '+%Y-%m-%d %H:%M:%S'`
 port=`netstat -tupln|grep -i 8899|awk '{print $4}'|cut -d : -f 2|awk '{print $1}'`
if [ "$port" == "" ]
then
        echo $datetime >> port_monitor.log
        /bin/startup.sh
fi
sleep 3
done
