#!/bin/bash
set -x
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin
mysql -h127.0.0.1 -uaudit -paudit -e "use audit_sec; select sourceip,count(*) from loginfailed_day  where sourceip !='192.168.18' and loginstate=0 and time > NOW()-INTERVAL 5 MINUTE group by sourceip having count(*) >6" >denyip
cat denyip|while read line
do
                 redis-cli TTL_DROP_INSERT $line 86400
done
