#!/bin/sh
#code by Gandalf 
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#############whitelist ###########
if [ ! -f whitelist ]
then
echo "127.0.0.1" >  whitelist
fi

if [ ! -f Reverse_link_detection.log ]
then
	touch Reverse_link_detection.log
fi

while : 
do 
	#netstat -tupln4|grep -i listen|awk '{print $4}'|cut -d : -f 2|awk '{print $1}' >listen
	ss -tup4 |awk '{if (NR>1)print $5}'|cut -d : -f 2 >listen
	#netstat -tapln4| grep -i  established|awk '{if (NR >1){print $4}}'|sort -rn|uniq|awk '{print $1}'|cut -d : -f 2|sort -rn |uniq >ESTABLISHED
	ss -p4|awk '{if (NR>1)print $5}'|cut -d : -f 2|sort -rn|uniq >ESTABLISHED
	cat ESTABLISHED | while read port 
do
	cat listen | grep $port >> /dev/null 2>&1
	ret=$?
	if [ $ret -eq 1  ]
	then
		message=$(netstat -tapln4|grep $port)
		address=$(netstat -tapln4|grep $port|awk '{print $5}'|cut -d : -f 1)
		grep  $address /root/whitelist >> /dev/null 2>&1
		sucess=$?
		if [ $sucess -eq 0 ]
		then
			continue
		elif [ $sucess -eq 1 ]
		then
			echo attack from $address {$message} >>  Reverse_link_detection.log
		#	echo "$address" |mail -s "{$message}" **@139.com 
		fi
	fi
done
sleep 3 
done
