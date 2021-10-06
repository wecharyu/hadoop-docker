# Makefile for hadoop docler build

build_flag := --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g)
workers := $(shell cat ./base/configs/workers)

build:
	docker build $(build_flag) -t wechar/hadoop-base ./base
	docker build $(build_flag) -t wechar/hadoop-namenode ./namenode
	docker build $(build_flag) -t wechar/hadoop-resourcemanager ./resourcemanager
	docker build $(build_flag) -t wechar/hadoop-secondarynamenode ./secondarynamenode

.PHONY: clean
clean:
	docker image rm wechar/hadoop-secondarynamenode
	docker image rm wechar/hadoop-resourcemanager
	docker image rm wechar/hadoop-namenode
	docker image rm wechar/hadoop-base

mkdir_volumes:
	rm -rf ./volumes/hadoop
	$(foreach worker, $(workers), \
		mkdir -p ./volumes/hadoop/data/$(worker); \
		mkdir -p ./volumes/hadoop/logs/$(worker); \
	)

run: build mkdir_volumes
	docker-compose down
	docker-compose up
