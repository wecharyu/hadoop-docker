FROM debian:9

WORKDIR /root

# install basic develop tools for contianer
RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
    openssh-server rsync grsync curl gnupg sudo \
    openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# passwordless with sudo and ssh
RUN echo "hadoop ALL=NOPASSWD: ALL" > "/etc/sudoers.d/hadoop-docker" \
    && ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
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

ENV HADOOP_HOME /usr/share/hadoop

RUN ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME

# config environment shell files
RUN sed -i '/export JAVA_HOME/ s#.*#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64#' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# RUN sed -i '$a export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' $HADOOP_HOME/etc/hadoop/yarn-env.sh

# copy the config files
ADD configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD configs/workers $HADOOP_HOME/etc/hadoop/workers

# hadoop logs and data node path for all containers
RUN mkdir $HADOOP_HOME/logs \
    && mkdir -p $HADOOP_HOME/data/dfs/node

# environment variables for all users
RUN echo "source ~/.bash_profile" >> ~/.bashrc \
    && echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bash_profile \
    && echo "export HADOOP_HOME=/usr/share/hadoop" >> ~/.bash_profile \
    && echo "export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH" >> ~/.bash_profile

# add user and group
ARG UID=1000
ARG GID=1000

RUN groupadd --non-unique -g $GID hadoop \
    && useradd -g $GID -u $UID -k /root -rm -s /bin/bash hadoop \
    && chown -R hadoop:hadoop $HADOOP_HOME/

ADD entrypoint.sh /dockerentry/entrypoint.sh
RUN chmod a+x /dockerentry/entrypoint.sh

ENTRYPOINT ["/dockerentry/entrypoint.sh"]
