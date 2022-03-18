FROM debian:9

WORKDIR /root

# install basic develop tools for contianer
RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
    openssh-server rsync grsync curl gnupg sudo \
    openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# passwordless with ssh
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# environment variables for all users
RUN echo "source ~/.bash_profile" >> ~/.bashrc \
    && echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bash_profile

ADD entrypoint.sh /dockerentry/entrypoint.sh
RUN chmod a+x /dockerentry/entrypoint.sh

ENTRYPOINT ["/dockerentry/entrypoint.sh"]
