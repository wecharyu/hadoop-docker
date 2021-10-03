FROM wechar/hadoop-base

# namenode data
RUN mkdir -p $HADOOP_HOME/data/dfs/name
# VOLUME $HADOOP_HOME/data/dfs/name

# nn ui port
EXPOSE 9870

# start script
ADD run.sh /dockerentry/run.sh
RUN chmod a+x /dockerentry/run.sh

CMD ["/dockerentry/run.sh"]
