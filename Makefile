# Makefile for hadoop docler build

uid = $(shell id -u)
gid = $(shell id -g)

build_flag = --build-arg UID=$(uid) --build-arg GID=$(gid)
workers := $(shell cat ./hadoop/configs/workers)

target ?= hadoop

build: build_$(target)_images
	if [[ "$(docker images -q wechar/cluster 2> /dev/null)" != "" ]]; then docker image rm wechar/cluster; fi
	docker image tag wechar/$(target) wechar/cluster

# build images for different targets
build_hadoop_images:
	docker build $(build_flag) -t wechar/cluster-base ./base
	docker build $(build_flag) -t wechar/hadoop ./hadoop
	$(eval uid=$(shell echo $$(($(uid)+1))))

build_mysql_images: build_hadoop_images
	docker build $(build_flag) -t wechar/mysql ./mysql

build_hive_images: build_mysql_images
	docker build $(build_flag) -t wechar/hive ./hive
	$(eval uid=$(shell echo $$(($(uid)+1))))

# clean the images
.PHONY: clean
clean: clean_$(target)

clean_hadoop:
	docker image rm wechar/hadoop
	docker image rm wechar/cluster-base

clean_mysql: clean_hadoop
	docker image rm wechar/mysql

clean_hive: clean_mysql
	docker image rm wechar/hive

mkdir_volumes_hadoop:
	rm -rf ./volumes/hadoop
	$(foreach worker, $(workers), \
		mkdir -p ./volumes/hadoop/data/$(worker); \
		mkdir -p ./volumes/hadoop/logs/$(worker); \
	)

mkdir_volumes_mysql: mkdir_volumes_hadoop

mkdir_volumes_hive: mkdir_volumes_mysql

# run the docker cluster
run: down build mkdir_volumes_$(target) generate_compose_yml_$(target)
	docker-compose up

down:
	if [ -f docker-compose.yml ]; then docker-compose down; fi;

generate_compose_yml_hadoop:
	cp -rf docker-compose-head.yml docker-compose.yml
	sed '1,/services:/ d' hadoop/docker-compose.yml >> docker-compose.yml

generate_compose_yml_mysql: generate_compose_yml_hadoop
	sed '1,/services:/ d' mysql/docker-compose.yml >> docker-compose.yml

generate_compose_yml_hive: generate_compose_yml_mysql
	sed '1,/services:/ d' hive/docker-compose.yml >> docker-compose.yml
