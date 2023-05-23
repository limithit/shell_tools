#!/bin/bash
set -x

# 设置阈值，当1分钟负载大小超过该值时，重启Tomcat
threshold=15

while true; do
    # 获取当前1分钟负载大小
    load=$(uptime | awk '{print $10}')
    num=`echo $load |awk '{print int($0)}'`
    # 判断是否需要重启Tomcat
    if [  $num -gt $threshold ]
       then
        echo "Load is too high, restarting Tomcat..."
        # 停止Tomcat
         echo stop 
        `ps -ef|grep tomcat|grep java|grep -v grep|awk '{print $2}'|xargs kill -9`
        # 等待Tomcat停止
        sleep 5
        # 启动Tomcat
         echo start
        `/home/tomcat/bin/startup.sh`
    fi
    # 等待一段时间后再次检查1分钟负载大小
    sleep 60
done

