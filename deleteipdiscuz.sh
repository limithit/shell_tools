#!/bin/sh
while :
do
mysql -uultrax -pultrax820 -e "use ultrax; DELETE  from pre_ucenter_failedlogins where ip = (SELECT n.max_ip 
from (select ip as max_ip from pre_ucenter_failedlogins WHERE ip ='13.107.27.2') as n);"
sleep 30
done
