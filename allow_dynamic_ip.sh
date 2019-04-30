#!/bin/sh
#*/30 * * * * root /bin/bash /root/allow.sh  >> /dev/null 2>&1
ip=`curl ifconfig.me`
ipold=`ssh -o "ProxyCommand ssh -p 2288 root@115.236.xx.xx nc -w 1800 %h %p" -p22 115.238.xx.xx 'cat /etc/nginx/allowip.conf'`
echo $ipold
if [ "allow $ip;" = "$ipold" ]
then
	exit
elif [ "allow $ip;" != "$ipold" ]
then
	echo "allow $ip;" >allowip.conf
fi
scp -o "ProxyCommand ssh -p 2288 root@115.236.xx.xx nc -w 1800 %h %p" allowip.conf   115.238.xx.xx:/etc/nginx/  
ssh -o "ProxyCommand ssh -p 2288 root@115.236.xx.xx nc -w 1800 %h %p" -p22 115.238.xx.xx '/etc/init.d/nginx reload'
