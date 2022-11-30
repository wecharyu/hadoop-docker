FROM wechar/cluster-base

WORKDIR /root

# passwordless with sudo for hadoop user
RUN echo "hadoop ALL=NOPASSWD: ALL" > "/etc/sudoers.d/hadoop-docker"

# install hadoop
ARG HADOOP_VERSION="3.3.1"

COPY packages/hadoop-$HADOOP_VERSION.tar.gz /tmp/hadoop.tar.gz
RUN tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz

ENV HADOOP_HOME /usr/share/hadoop

RUN ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME

# config environment shell files
RUN sed -i '/export JAVA_HOME/ s#.*#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64#' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# RUN sed -i '$a export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' $HADOOP_HOME/etc/hadoop/yarn-env.sh

# copy the config files
ADD hadoop/configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hadoop/configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD hadoop/configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD hadoop/configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD hadoop/configs/workers $HADOOP_HOME/etc/hadoop/workers

# hadoop logs and data node path for all containers
RUN mkdir $HADOOP_HOME/logs \
    && mkdir -p $HADOOP_HOME/data/dfs/node

# environment variables for all users
RUN echo "export HADOOP_HOME=/usr/share/hadoop" >> ~/.bash_profile \
    && echo "export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH" >> ~/.bash_profile

# create the hadoop client conf and set env
RUN mkdir -p /etc/hadoop-client \
    && echo "HADOOP_CONF_DIR=/etc/hadoop-client" >> /etc/environment
ADD hadoop/configs/hadoop-client /etc/hadoop-client

# add user and group
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID hdfs \
    && useradd -g $GID -u $UID -k /root -rm -s /bin/bash hadoop \
    && chown -R hadoop:hdfs $HADOOP_HOME/

# start script
ADD hadoop/namenode-run.sh /dockerentry/namenode-run.sh
RUN chown hadoop /dockerentry/namenode-run.sh
ADD hadoop/resourcemanager-run.sh /dockerentry/resourcemanager-run.sh
RUN chown hadoop /dockerentry/resourcemanager-run.sh
ADD hadoop/secondarynamenode-run.sh /dockerentry/secondarynamenode-run.sh
RUN chown hadoop /dockerentry/secondarynamenode-run.sh
