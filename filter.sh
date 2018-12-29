#!/bin/sh
#code by 西门吹雪
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
while :
do
cat  /var/log/nginx/access.log |grep  -E '\/mountainVillage\/app\/user\/sendRegCode.do\?username\=' >denyip
cat denyip |awk '{print $1}'|sort|uniq -c|sort -nr|awk '{print $1" "$2}' |while read line
do

number=$(echo $line |awk '{print $1}')
ip=$(echo $line |awk '{print $2}')
if [ $number -gt 20 ]    #More than 20 rejections
then
        if [ "$ip" = "115.23.*.*" ]   #white list
        then
                continue
        elif [ "$ip" = "115.*.*.*" ]
        then
                continue
        elif [ "$ip" = "115.*.*.*" ]
        then
                continue
        elif [ "$ip" = "115.*.*.*" ]
        then
                continue
        else
                add_tables -I INPUT -s $ip -j DROP  >> /dev/null 2>&1
        fi
fi
done
#sleep 30
exit 0
done
