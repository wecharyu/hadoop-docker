FROM wechar/hadoop-base

# resourcemanager ui port
EXPOSE 8088

# start script
ADD run.sh /dockerentry/run.sh
RUN chmod a+x /dockerentry/run.sh

CMD ["/dockerentry/run.sh"]
