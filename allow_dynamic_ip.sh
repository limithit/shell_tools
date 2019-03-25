#!/bin/sh
#*/30 * * * * root /bin/bash /root/allow.sh  >> /dev/null 2>&1
alias sshj="ssh -o \"ProxyCommand ssh -p 2233 root@192.168.18.22 nc -w 1800 %h %p\" -p22"
alias scpj="scp -o \"ProxyCommand ssh -p 2233 root@192.168.18.22 nc -w 1800 %h %p\""
ip=`curl ifconfig.me`
ipold=`cat /root/allowip.conf`
if [ "allow $ip;" = "$ipold" ]
then
	exit
elif [ "allow $ip;" != "$ipold" ]
then
	echo "allow $ip;" >allowip.conf
fi
scpj allowip.conf 192.168.18.33:/etc/nginx/
sshj 192.168.18.33 '/etc/init.d/nginx reload'
