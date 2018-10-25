#!/bin/sh
while inotifywait -e modify /var/log/nginx/access.log; do
        if tail -n 1 /var/log/nginx/access.log | grep spider; then
                echo "It appears !"
        fi
done
