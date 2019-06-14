#!/bin/sh
set -x
cat tables | while read line
do
comeback=`ls $line |cut -d . -f -1`
`mysql -uroot -proot -e "use bbs; load data infile '$line' into table $comeback;"`
done
