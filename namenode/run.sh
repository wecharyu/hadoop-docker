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

bash
