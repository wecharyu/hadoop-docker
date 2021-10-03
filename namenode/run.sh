#!/bin/bash

namedir=`sed -n '/dfs.namenode.name.dir/{N;p}' $HADOOP_HOME/etc/hadoop/hdfs-site.xml | sed -r '2s#<value>(.*)</value>#\1#' | sed -n '2p'`
# namedir="/opt/hadoop/data/dfs/name"

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
