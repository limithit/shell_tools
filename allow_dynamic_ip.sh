#!/bin/sh
#*/30 * * * * root /bin/bash /root/allow.sh  >> /dev/null 2>&1
ip=`curl ifconfig.me`
ipold=`ssh -o "ProxyCommand ssh -p 22 root@115.xx.xx.xx nc -w 1800 %h %p" -p22 116.xx.xx.xx 'cat /etc/nginx/allowip.conf'`
echo $ipold
if [ "allow $ip;" = "$ipold" ]
then
	exit
elif [ "allow $ip;" != "$ipold" ]
then
	echo "allow $ip;" >allowip.conf
fi
scp -o "ProxyCommand ssh -p 22 root@115.xx.xx.xx nc -w 1800 %h %p" allowip.conf   116.xx.xx.xx:/etc/nginx/  
ssh -o "ProxyCommand ssh -p 22 root@115.xx.xx.xx nc -w 1800 %h %p" -p22 116.xx.xx.xx '/etc/init.d/nginx reload'
