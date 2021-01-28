#!/bin/sh
set -x
ls --full-time|awk '{print $6, $9}'>/tmp/ls.txt
cat /tmp/ls.txt|while read line
do
date=`echo $line | awk '{print $1}'|cut -d - -f 1,2`
file=`echo $line | awk '{print $2}'`
echo $date 
    if [ ! -d "${date}" ]; then
		mkdir "${date}"
	fi
      mv $file "${date}"
echo $file
done
