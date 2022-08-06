#!/usr/bin/env bash

export JAVA_HOME=${JAVA_HOME:-/etc/alternatives/jre}

# Alternate conf dir. (Default: ${SPARK_HOME}/conf)
export SPARK_CONF_DIR=${SPARK_CONF_DIR:-/usr/share/spark/conf}

export HADOOP_HOME=/usr/share/hadoop
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-/etc/hadoop-client}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
