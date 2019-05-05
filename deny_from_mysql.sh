#!/bin/bash
set -x
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin
add_tables() 
{
        check=$(echo $@ | sed -e 's/-I/-C/g')
                xtables-multi iptables $check ;ret=$?
                if [ "$ret" -eq 0 ]; then
                        return 0;
                else
                        xtables-multi iptables $@;
                fi
}
mysql -h127.0.0.1 -uaudit -paudit -e "use audit_sec; select sourceip,count(*) from loginfailed_day  where  loginstate=0 and time  <DATE_SUB(CURDATE(),INTERVAL 1 WEEK) group by sourceip having count(*) >6 " >denyip
cat denyip|grep -v "172.16" |awk '{if (NR>1){print $1"  "$2}}'|while read line
do
number=$(echo $line |awk '{print $2}')
ip=$(echo $line |awk '{print $1}')
if [ $number -gt 6 ]
then
        if [ "$ip" = "192.168.11.1" ]
        then
                continue
        elif [ "$ip" = "192.168.11.5" ]
        then
                continue

        elif [ "$ip" = "192.168.11.6" ]
        then
                continue
        else
                add_tables -I INPUT -s $ip -j DROP  >> /dev/null 2>&1
        fi
fi
done
