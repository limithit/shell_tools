#! /bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
cat /var/log/messages |awk '/Failed/{print $(NF-3)}'|grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$"|grep -E -v '192.168|172.16|10.0.0'|sort|uniq -c|awk '{print $2"="$1;}' >/root/blackpasswd.txt

DEFINE="10"
for i in `cat  /root/blackpasswd.txt`
do
         IP=`echo $i |awk -F= '{print $1}'`
        NUM=`echo $i|awk -F= '{print $2}'`
        if [ $NUM -gt $DEFINE ];
        then
         grep $IP /etc/hosts.deny > /dev/null
          if [ $? -gt 0 ];
          then
          echo "sshd:$IP" >> /etc/hosts.deny
         # echo "vsftpd:$IP" >> /etc/hosts.deny
          fi
        fi
done
