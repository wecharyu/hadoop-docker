# Makefile for hadoop docler build

build_flag := --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g)
workers := $(shell cat ./hadoop/configs/workers)

build:
	docker build $(build_flag) -t wechar/cluster-base ./base
	docker build $(build_flag) -t wechar/hadoop ./hadoop

.PHONY: clean
clean:
	docker image rm wechar/hadoop
	docker image rm wechar/cluster-base

mkdir_volumes:
	rm -rf ./volumes/hadoop
	$(foreach worker, $(workers), \
		mkdir -p ./volumes/hadoop/data/$(worker); \
		mkdir -p ./volumes/hadoop/logs/$(worker); \
	)

run: build mkdir_volumes
	docker-compose down
	docker-compose up
