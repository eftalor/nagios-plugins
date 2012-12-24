#!/bin/bash

#Script for checking 3ware raid controller unit status and disks status.
#For use with Nagios
#Will display information both when OK and CRITICAL
#This script requiers the following line in the sudoers "nagios ALL=(ALL) NOPASSWD: /usr/local/sbin/tw_cli" 
#eftalor@gmail.com 
#http://github.com/eftalor 

#Getting some information from the controller
ARRAYNFO=`/usr/local/bin/tw_cli /c1 show | sed -n '/u0/{;p;q;}' | awk ' { print "Unit:"$1 " , "  "Type:"$2 " , " "Status:"$3 " , "  "Size:" $7 " | " } '`
DISKNFO=`/usr/local/bin/tw_cli /c1 show | egrep ^p | awk '{ print $1 " " $2 " " $4$5 " | " }'|tr -d "\n"`
ARRAYSTAT=`/usr/local/bin/tw_cli /c1 show | sed -n '/u0/{;p;q;}' | awk ' { print $3 } '`

#Exit codes as per Nagios dev guide
STATOK=0
STATCRIT=2
STATUNKNOWN=3


if [[ "$ARRAYSTAT" = OK ]]
then
  echo -n "OK:" $ARRAYNFO $DISKNFO
  exit $STATOK
fi 

if [[ "$ARRAYSTAT" = DEGRADED ]]
then
  echo -n  "Critical: $ARRAYNFO $DISKNFO"
  exit $STATCRIT

else 
echo "Unknown Error"  
exit $STATUNKNOWN
fi


