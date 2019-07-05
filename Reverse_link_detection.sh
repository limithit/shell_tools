#!/bin/sh
set -x
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
	netstat -tupln|grep -i listen|awk '{print $4}'|cut -d : -f 2|awk '{print $1}' >listen
	netstat -tapln| grep -i  established|awk '{if (NR >1){print $4}}'|sort -rn|uniq|awk '{print $1}'|cut -d : -f 2|sort -rn |uniq >ESTABLISHED
	cat ESTABLISHED | while read port 
do
        datetime=`date '+%Y-%m-%d %H:%M:%S'`
	cat listen | grep $port >> /dev/null 2>&1
	ret=$?
	if [ $ret -eq 1  ]
	then
		message=$(netstat -tapln|grep $port)
		address=$(netstat -tapln|grep $port|awk '{print $5}'|cut -d : -f 1)
		pid=$(netstat -tapln|grep $port|awk '{print $7}'|awk -F "" '
			{
			  for(i=1;i<=NF;i++) 
			  {  
			    if ($i ~ /[[:digit:]]/)     
			    {
			      str=$i
			      str1=(str1 str)
			    }  
			  } 
			  print str1
			}')
            pidbin=`lsof -p $pid |grep txt`
		grep  $address whitelist >> /dev/null 2>&1
		sucess=$?
		if [ $sucess -eq 0 ]
		then
			continue
		elif [ $sucess -eq 1 ]
		then
		         if [ "$address" != "" ]
                        then
			echo " ###### Messages start ##########" >>  Reverse_link_detection.log
			echo $datetime attack from $address {$message} >>  Reverse_link_detection.log
			echo  {$pidbin} >>  Reverse_link_detection.log
			echo " ###### Messages end   ##########" >>  Reverse_link_detection.log
                        
		#	echo "$address" |mail -s "{$message}" **@139.com 
		        fi
		fi
	fi
done
sleep 3 
done
