#!/bin/bash

namedir=$HADOOP_HOME/data/dfs/name

if [ ! -d $namedir ]; then
  echo "Name node directory not found, creating $namedir now..."
  mkdir -p $namedir
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode, name directory: $namedir"
  $HADOOP_HOME/bin/hdfs namenode -format $CLUSTER_NAME
fi

$HADOOP_HOME/sbin/start-dfs.sh

# create /tmp directory on hdfs if not exists
$HADOOP_HOME/bin/hadoop fs -test -d /tmp
result=$?
if [ $result -ne 0 ]; then
  # should create hdfs for hive user
  $HADOOP_HOME/bin/hadoop fs -mkdir /tmp
  $HADOOP_HOME/bin/hadoop fs -chmod 777 /tmp
fi

bash
