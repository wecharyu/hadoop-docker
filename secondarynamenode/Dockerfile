FROM wechar/hadoop-base

# 2nn ui port
EXPOSE 9868

# start script
ADD run.sh /dockerentry/run.sh
RUN chmod a+x /dockerentry/run.sh

USER hadoop
WORKDIR /home/hadoop

CMD ["/dockerentry/run.sh"]
