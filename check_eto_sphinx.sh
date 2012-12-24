#!/bin/bash

#Nagios plugin for checking running a query ("mystring") in Sphinx 
#Change "mystring" to your desired string
#Requiers mysql client binary!
#eftalor@gmail.com 
#http://github.com/eftalor 

if [ ! -e /usr/bin/mysql ] ; then
echo "Warning: mysql client binary not found!, abotring!"
exit 1
fi

QUERY_CMD=`echo "select * from index1 where match('mystring');" | mysql -h $HOSTNAME -P 9306 | wc -l`

if [ -n $QUERY_CMD ]
then
   echo "Sphinx query OK ($QUERY_CMD returned)" 
   exit 0
else
   echo "Critical!: Sphinx error: no queries returned!"
   exit 2
fi
