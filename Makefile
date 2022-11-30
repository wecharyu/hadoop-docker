# Makefile for hadoop docler build

# basic configuration
hadoop_version := 3.3.2
hive_version := 3.1.2
spark_version := 3.3.1
spark_builtin_hadoop_version := hadoop3

# common url
hadoop_url := https://www.apache.org/dist/hadoop/common/hadoop-$(hadoop_version)/hadoop-$(hadoop_version).tar.gz
hive_url := https://downloads.apache.org/hive/hive-$(hive_version)/apache-hive-$(hive_version)-bin.tar.gz
spark_url := https://dlcdn.apache.org/spark/spark-$(spark_version)/spark-$(spark_version)-bin-$(spark_builtin_hadoop_version).tgz

uid := $(shell id -u)
gid := $(uid)

build_flag = --build-arg UID=$(uid) --build-arg GID=$(gid)
workers := $(shell cat ./hadoop/configs/workers)

target ?= hadoop

build: build_network build_$(target)_images

build_network:
	-docker network create hadoop-docker-bridge

# build images for different targets
build_hadoop_images: download_hadoop_tarball
	docker build $(build_flag) -t wechar/cluster-base ./base
	docker build $(build_flag) --build-arg HADOOP_VERSION=$(hadoop_version) -t wechar/hadoop -f ./hadoop/Dockerfile .
	$(eval uid=$(shell echo $$(($(uid)+1))))

build_mysql_images: build_hadoop_images
	docker build $(build_flag) -t wechar/mysql ./mysql

build_hive_images: build_mysql_images download_hive_tarball
	docker build $(build_flag) --build-arg HIVE_VERSION=$(hive_version) -t wechar/hive -f ./hive/Dockerfile .
	$(eval uid=$(shell echo $$(($(uid)+1))))

build_spark_images: build_hive_images download_spark_tarball
	docker build $(build_flag) --build-arg SPARK_VERSION=$(spark_version) --build-arg SPARK_BUILTIN_HADOOP_VERSION=$(spark_builtin_hadoop_version) -t wechar/spark -f ./spark/Dockerfile .
	$(eval uid=$(shell echo $$(($(uid)+1))))

# download tarballs
download_hadoop_tarball:
	mkdir -p ./packages
	test -f ./packages/hadoop-$(hadoop_version).tar.gz && echo "hadoop tarball already exists" || curl -SL $(hadoop_url) -o ./packages/hadoop-$(hadoop_version).tar.gz

download_hive_tarball:
	mkdir -p ./packages
	test -f ./packages/apache-hive-$(hive_version)-bin.tar.gz && echo "hive tarball already exists" || curl -SL "$(hive_url)" -o ./packages/apache-hive-$(hive_version)-bin.tar.gz

download_spark_tarball:
	mkdir -p ./packages
	test -f ./packages/spark-$(spark_version)-bin-$(spark_builtin_hadoop_version).tgz && echo "spark tarball already exists" || curl -SL "$(spark_url)" -o ./packages/spark-$(spark_version)-bin-$(spark_builtin_hadoop_version).tgz

# clean the images
.PHONY: clean
clean: down clean_$(target)

clean_hadoop:
	-docker image rm wechar/hadoop
	-docker image rm wechar/cluster-base

clean_mysql: clean_hadoop
	-docker image rm wechar/mysql

clean_hive: clean_mysql
	-docker image rm wechar/hive

clean_spark: clean_hive
	-docker image rm wechar/spark

mkdir_volumes_hadoop:
	rm -rf ./volumes/hadoop
	$(foreach worker, $(workers), \
		mkdir -p ./volumes/hadoop/data/$(worker); \
		mkdir -p ./volumes/hadoop/logs/$(worker); \
	)

mkdir_volumes_mysql: mkdir_volumes_hadoop

mkdir_volumes_hive: mkdir_volumes_mysql

mkdir_volumes_spark: mkdir_volumes_hive

# run the docker cluster
run: down build mkdir_volumes_$(target) generate_compose_yml_$(target)
	docker-compose up

down:
	-docker-compose down

generate_compose_yml_hadoop:
	cp -rf docker-compose-head.yml docker-compose.yml
	sed '1,/services:/ d' hadoop/docker-compose.yml >> docker-compose.yml

generate_compose_yml_mysql: generate_compose_yml_hadoop
	sed '1,/services:/ d' mysql/docker-compose.yml >> docker-compose.yml

generate_compose_yml_hive: generate_compose_yml_mysql
	sed '1,/services:/ d' hive/docker-compose.yml >> docker-compose.yml

generate_compose_yml_spark: generate_compose_yml_hive
	sed '1,/services:/ d' spark/docker-compose.yml >> docker-compose.yml
