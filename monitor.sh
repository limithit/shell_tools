#!/bin/sh

# monitor_mysql_slave status
ip=192.168.18.55
cmd=/usr/local/mysql/bin/mysql
mysqluser=maxscale
mysqlpwd=maxscale
log=/var/tmp/monitor.log
while true
do
  datetime=`date '+%Y-%m-%d %H:%M:%S'`
  
  array=$($cmd -u$mysqluser -h$ip -p$mysqlpwd -e "show slave status\G"|grep -iE "_running|last_error")

  io_running=`echo $array|grep -i slave_io_running|awk '{print $2}'`
 
  sql_running=`echo $array|grep -i slave_sql_running|awk '{print $2}'`
  
  last_error=`echo $array|grep -i last_error|awk '{print $2}'`

  if [ "$io_running" = "Yes" ] && [ "$sql_running" = "Yes" ]
  then
    echo "$datetime | OK | Slave is running!" >> $log
  else
    echo "$datetime | FAIL | Slave is not running!" >> $log
    echo "$datetime | FAIL | $last_error" >> $log
    $cmd -u$mysqluser -h$ip -p$mysqlpwd -e "stop slave;set global sql_slave_skip_counter=1;start slave;"
    char="$datatime $ip MySQL slave is not running"
    echo "$last_error"|mail -s "$char" ****@139.com
    continue
  fi
  sleep 30
done
