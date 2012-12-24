#!/bin/bash
#A super simple script for reporting used memory % and kb,free kb and total kb.
#Script will always exit 0 as long as the $result is successful
#Requiers the `bc` command
#for use with Nagios
#eftalor@gmail.com 
#http://github.com/eftalor 


free=`free -m | grep Mem |  awk '{print $4}'`
used=`free -m | grep Mem |  awk '{print $3}'`

total=$(($free+$used))

result=$(echo "$used / $total * 100" |bc -l |cut -c -2)

if [ -n $result ]; then
    echo "Mem U/F/T Used:$used kB($result%) Free:$free kB Total $total kB) | used=$used free=$free total=$total"
    exit 0;
else
echo "Problem getting memory usage"
exit 1
fi
