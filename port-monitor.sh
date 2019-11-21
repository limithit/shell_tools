#!/bin/sh

if [ ! -f port_monitor.log ]
then
	touch port_monitor.log
fi

while true
do
sleep 3
datetime=`date '+%Y-%m-%d %H:%M:%S'`
 port=`netstat -tupln|grep -i 8899|awk '{print $4}'|cut -d : -f 2|awk '{print $1}'`
if [ $port -eq 8899 ]
then
        continue
else
        echo $datetime >> nacos_monitor.log
        /bin/startup.sh
        sleep 5
fi
done
