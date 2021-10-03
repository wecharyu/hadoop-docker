FROM debian:9

WORKDIR /root

# install basic develop tools for contianer
RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
      openssh-server rsync grsync curl gnupg \
      openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# passwordless with ssh
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# install hadoop
RUN curl -sSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o /tmp/KEYS \
    && gpg --import /tmp/KEYS \
    && rm -rf /tmp/KEYS

ARG HADOOP_VERSION="3.3.1"
ARG HADOOP_URL="https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"

RUN curl -sSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -sSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

ENV HADOOP_HOME /opt/hadoop
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME

# get all encironment variables for ssh process
RUN echo "export \$(cat /proc/1/environ | tr '\\\0' '\\\n' | xargs)" >> /etc/profile

# the only user is root
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

# config environment shell files
RUN sed -i '/export JAVA_HOME/ s#.*#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64#' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# RUN sed -i '$a export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' $HADOOP_HOME/etc/hadoop/yarn-env.sh

# copy the config files
ADD configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD configs/workers $HADOOP_HOME/etc/hadoop/workers

RUN mkdir $HADOOP_HOME/logs
# data node path for all containers
RUN mkdir -p $HADOOP_HOME/data/dfs/node

# VOLUME $HADOOP_HOME/data/dfs/node

ADD entrypoint.sh /dockerentry/entrypoint.sh
RUN chmod a+x /dockerentry/entrypoint.sh

ENTRYPOINT ["/dockerentry/entrypoint.sh"]
