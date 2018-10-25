#!/bin/bash                                                                                               
                                                                                           
                                                                         
#DAT="`date +%Y%m%d`"                                                                                      
DAT="`date +%Y%m%d%H%M`"                                                                                               
HOUR="`date +%H`"                                                                                                              
#DIR="/home/oslog/host_${DAT}/${HOUR}"                                                                                              
DIR="/home/oslog/host_${DAT}"                                                                                             
DELAY=60                                                                                                                        
COUNT=60                                                                                                                           
# whether the responsible directory exist                                                                                    
if ! test -d ${DIR}                                                                                                             
then                                                                                                                                
/bin/mkdir -p ${DIR}                                                                                                               
fi                                                                                                                         
# general check                                                                                                            
export TERM=linux                                                                                                                
/usr/bin/top -b -d ${DELAY} -n ${COUNT} > ${DIR}/top_${DAT}.log 2>&1 &                                                       
# cpu check                                                                                                                    
/usr/bin/sar -u ${DELAY} ${COUNT} > ${DIR}/cpu_${DAT}.log 2>&1 &                                                                                                                      
# memory check                                                                                                                 
/usr/bin/vmstat ${DELAY} ${COUNT} > ${DIR}/vmstat_${DAT}.log 2>&1 &                                                           
# I/O check                                                                                                                   
/usr/bin/iostat ${DELAY} ${COUNT} > ${DIR}/iostat_${DAT}.log 2>&1 &                                                                 
# network check                                                                                                                     
/usr/bin/sar -n DEV ${DELAY} ${COUNT} > ${DIR}/net_${DAT}.log 2>&1 &                                                                
                                                    
find /home/oslog/ -mtime +1  -exec rm -rf {} \; 
