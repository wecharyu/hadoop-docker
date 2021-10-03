build:
	docker build -t wechar/hadoop-base ./base
	docker build -t wechar/hadoop-namenode ./namenode
	docker build -t wechar/hadoop-resourcemanager ./resourcemanager
	docker build -t wechar/hadoop-secondarynamenode ./secondarynamenode

.PHONY: clean
clean:
	docker image rm wechar/hadoop-secondarynamenode
	docker image rm wechar/hadoop-resourcemanager
	docker image rm wechar/hadoop-namenode
	docker image rm wechar/hadoop-base

run: build
	docker-compose down
	docker-compose up
