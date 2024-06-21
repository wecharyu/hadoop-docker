#!/bin/bash

export HADOOP_HOME=${HADOOP_HOME:-/usr/share/hadoop}

export HIVE_HOME=${HIVE_HOME:-/usr/share/hive}
export HIVE_LIB=$HIVE_HOME/lib/

export HIVE_METASTORE_HADOOP_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

export METASTORE_PORT=9083
