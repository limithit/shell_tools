#!/bin/sh
set -x
#curl http://127.0.0.1:9200/_cat/indices?v
if [ $# = 2 ]; then

for ((i=1; i<=9; i++))
 do
curl -H "Content-Type: application/json" -XDELETE 'http://localhost:9200/zipkin:span-'$1'-'$2'-0'$i'' -d '{
"query" : { 
        "match_all" : {}
}
}'
done

for ((i=10; i<=31; i++)) 
 do
curl -H "Content-Type: application/json" -XDELETE 'http://localhost:9200/zipkin:span-'$1'-'$2'-'$i'' -d '{
"query" : { 
	"match_all" : {}
}
}'
done
else 
  echo "Example: es.sh 2019 12"
   exit 1
fi
