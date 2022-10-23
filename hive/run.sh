#!/bin/bash

echo "[INFO] hive starting..."

# create /user/hive directory on hdfs if not exists
$HADOOP_HOME/bin/hadoop fs -test -d /user/hive
result=$?
if [ $result -ne 0 ]; then
  # should create hdfs for hive user
  $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
  $HADOOP_HOME/bin/hadoop fs -chown -R hive /user/hive
  $HADOOP_HOME/bin/hadoop fs -chown -R hive:hdfs /user/hive/warehouse
  $HADOOP_HOME/bin/hadoop fs -chmod 777 /user/hive/warehouse
fi

# init mysql schema if not created
if [ ! -f /home/hive/.initSchema ]; then
  echo "[INFO] Initing schema for backend MySQL..."
  $HIVE_HOME/bin/schematool -initSchema -dbType mysql
  touch /home/hive/.initSchema
  echo "[INFO] Finished initing schema for backend MySQL..."
fi

# start metastore service
if [ ! -d /var/log/hive ]; then
  sudo mkdir -p /var/log/hive
  sudo chown -R hive:hdfs /var/log/hive
fi
echo "[INFO] Starting metastore service..."
nohup $HIVE_HOME/bin/hive --service metastore --hiveconf hive.log.file=hivemetastore.log --hiveconf hive.log.dir=/var/log/hive > /var/log/hive/hive.out 2> /var/log/hive/hive.err &
echo "[INFO] Finished starting metastore service..."

bash
