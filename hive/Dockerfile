FROM wechar/hadoop

USER root
WORKDIR /root

# passwordless with sudo for hive user
RUN echo "hive ALL=NOPASSWD: ALL" > "/etc/sudoers.d/hive-docker"

# install hive
RUN curl -sSL https://downloads.apache.org/hive/KEYS -o /tmp/KEYS \
    && gpg --import /tmp/KEYS \
    && rm -rf /tmp/KEYS

ARG HIVE_VERSION="3.1.2"
ARG HIVE_URL="https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"

RUN curl -SL "${HIVE_URL}" -o /tmp/hive.tar.gz \
    && curl -sSL "${HIVE_URL}.asc" -o /tmp/hive.tar.gz.asc \
    && gpg --verify /tmp/hive.tar.gz.asc \
    && tar -xvf /tmp/hive.tar.gz -C /opt/ \
    && rm /tmp/hive.tar.gz*

ENV HIVE_HOME /usr/share/hive

RUN ln -s /opt/apache-hive-${HIVE_VERSION}-bin $HIVE_HOME

# copy the config files
ADD configs/hivemetastore-site.xml $HIVE_HOME/conf/hivemetastore-site.xml
ADD configs/hive-env.sh $HIVE_HOME/conf/hive-env.sh

# environment variables for all users
RUN echo "export HIVE_HOME=/usr/share/hive" >> ~/.bash_profile \
    && echo "export PATH=\$HIVE_HOME/bin:\$PATH" >> ~/.bash_profile

# install java mysql connector
ARG MYSQL_CONNECTOR_VERSION="8.0.28"
ARG MYSQL_CONNECTOR_URL="http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz"
RUN curl -SL "${MYSQL_CONNECTOR_URL}" -o /tmp/connector.tar.gz \
    && tar zxf /tmp/connector.tar.gz -C /opt/ \
    && ln -sf /opt/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${HIVE_HOME}/lib/mysql-connector-java.jar \
    && rm /tmp/connector.tar.gz

# add user and group
ARG UID=1000
ARG GID=1000

RUN useradd -g $GID -u $UID -k /root -rm -s /bin/bash hive \
    && chown -R hive:hdfs $HIVE_HOME/

ADD run.sh /dockerentry/run.sh
RUN chmod a+x /dockerentry/run.sh

CMD ["/dockerentry/run.sh"]
