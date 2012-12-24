#!/bin/bash

#script for checking Linux software raid status (aka MD RAID)
#Requiers mdadm utility and a sudo to it.
#For use with Nagios
#eftalor@gmail.com 
#http://github.com/eftalo


#Redirect sterr to /dev/null, for debugging purpose, change the redirect to a file
exec 2> /dev/null

#Get list of MD arrays
export MD_LIST=`cat /proc/mdstat  | grep md  | cut -d ":" -f 1 | sed 's/^/\/dev\//g' | tr -d "\n"`
export MDADMCHK=$(/usr/bin/sudo /sbin/mdadm --detail $MD_LIST | grep -v RaidDevice | awk '{ print $0"," }' | egrep "/dev/md|Raid Level|Array Size|Devices|State" | sed '/Raid/!s/Devices//g' | sed 's/ : /:/g;s/ :/:/g'  | tr -d "\n")
export ARRAYSTAT=$(/usr/bin/sudo /sbin/mdadm --detail $MD_LIST | grep "State : " | awk '{ print $3 }' | tr -d "\n")

#Exit codes as per Nagios dev guide
STATOK=0
STATCRIT=2
STATUNKNOWN=3

case $ARRAYSTAT in
        *clean* ) echo -n "OK:" $MDADMCHK ;  exit $STATOK ;;
        *degraded* )  echo -n  "Critical! array degraded:" $MDADMCHK ; exit $STATCRIT ;;
        * ) echo "Unknown Error!, see outputs: array status:$ARRAYSTAT detected devices: $MD_LIST mdadm dheck output:$MDADMCHK" ; exit $STATUNKNOWN ;;
esac
