#!/bin/bash
if [ $# != 1 ]
  then
  exit 1
fi
#tail -n 1 -f /data/v4/nohub_log/qqsk-api-mobile.log|while read var
tail -n 1 -f ${1}|while read var
do 
	value=`echo $var|grep -i "java.lang.NullPointerException"`
	if [ "$value" != "" ]
	then
		string=`echo $value | tr '\r\n' '\n'`
                md5=`echo -n "'$string'"|md5sum|awk '{print $1}'`
               md5_value=`redis-cli -h 172.16.xx.xx -n 0 get $md5`
               if [ "$md5_value" == "" ]
                then 
                   redis-cli -h 172.16.xx.xx -n 0 setex $md5 300 $md5
                 ssh  172.16.xx.xx '/usr/local/zabbix/share/zabbix/alertscripts/monitor.py 15988177 message "'$string'"'
               else
                   continue
               fi
       	else
		continue
	fi
done

