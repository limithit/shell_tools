#!/bin/sh
log=/var/tmp/m.log
while :
do

if [ "`pidof minerd`" != "" ]
then
 datetime=`date '+%Y-%m-%d %H:%M:%S'`
 echo "$datetime  >> $log
rm -f /tmp/minerd
kill -9 `pidof minerd`
fi

if [ "`ls /tmp/minerd 2> /dev/null`" != "" ]
then
rm -f /tmp/minerd

fi
echo "found" | mail -s "minerd" *****@139.com
sleep 5
done
