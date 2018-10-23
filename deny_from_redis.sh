#!/bin/sh
#code by 西门吹雪
set -x
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin
iptables -N WAF
iptables -A WAF -j DROP
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
redis-cli -h 127.0.0.1 -n 2 scan 0 count 10000 |awk '{if (NR>1){print $1}}' >WAFdenyip
cat WAFdenyip|while read line
do
        add_tables -I INPUT -s $line -j WAF  >> /dev/null 2>&1
done
