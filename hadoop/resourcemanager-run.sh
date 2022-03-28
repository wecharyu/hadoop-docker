#!/bin/bash

echo "resource manager starting..."

# create /tmp and /user directory on hdfs if not exists
$HADOOP_HOME/bin/hadoop fs -test -d /tmp
result=$?
if [ $result -ne 0 ]; then
  $HADOOP_HOME/bin/hadoop fs -mkdir /tmp
  $HADOOP_HOME/bin/hadoop fs -chmod 777 /tmp
  $HADOOP_HOME/bin/hadoop fs -mkdir /user
  $HADOOP_HOME/bin/hadoop fs -chmod 777 /user
fi

$HADOOP_HOME/sbin/start-yarn.sh

bash
