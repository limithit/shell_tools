#!/bin/sh
set -x
function get_port()
{
datetime=`date '+%Y-%m-%d %H:%M:%S'`
 port=`netstat -tupln|grep -i $1 |awk '{print $4}'|cut -d : -f 2|awk '{print $1}'`

}

if [ ! -f port_monitor.log ]
then
	touch port_monitor.log
fi

while true
do
sleep 3
get_port 3308
if [ "$port" == "3308" ]
then
        echo success
else
        echo "$datetime port 3308" >> port_monitor.log
ssh -g -f -N -L 3308:192.168.11.2:3306 tomcat@192.168.30.1
sleep 3
fi
done
