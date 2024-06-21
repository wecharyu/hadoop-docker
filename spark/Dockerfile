FROM wechar/hadoop

USER root
WORKDIR /root

# passwordless with sudo for spark user
RUN echo "spark ALL=NOPASSWD: ALL" > "/etc/sudoers.d/spark-docker"

# install spark
ARG SPARK_VERSION="3.3.0"
ARG SPARK_BUILTIN_HADOOP_VERSION="hadoop3"

COPY packages/spark-${SPARK_VERSION}-bin-${SPARK_BUILTIN_HADOOP_VERSION}.tgz /tmp/spark-bin-hadoop.tgz
RUN tar -xvf /tmp/spark-bin-hadoop.tgz -C /opt/ \
    && rm /tmp/spark-bin-hadoop.tgz

ENV SPARK_HOME /usr/share/spark

RUN ln -s /opt/spark-${SPARK_VERSION}-bin-${SPARK_BUILTIN_HADOOP_VERSION} $SPARK_HOME

ENV HADOOP_CONF_DIR /etc/hadoop-client

# create spark conf dir
ENV SPARK_CONF_DIR /etc/spark-conf
RUN mkdir -p $SPARK_CONF_DIR \
    && echo "SPARK_CONF_DIR=/etc/spark-conf" >> /etc/environment
ADD spark/configs/spark-conf $SPARK_CONF_DIR

# environment variables for all users
RUN echo "export SPARK_HOME=/usr/share/spark" >> ~/.bash_profile \
    && echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> ~/.bash_profile \
    && echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bash_profile

# add user and group
ARG UID=1000
ARG GID=1000

RUN useradd -g $GID -u $UID -k /root -rm -s /bin/bash spark \
    && chown -R spark:hdfs $SPARK_HOME/

ADD spark/run.sh /dockerentry/run.sh
RUN chmod a+x /dockerentry/run.sh

CMD ["/dockerentry/run.sh"]
