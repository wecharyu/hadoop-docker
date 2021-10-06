# Hadoop Docker

Hadoop docker project is used to build and start up a hadoop cluster in some docker containers.

## Overview
![hadoop cluster overview](hadoop-cluster.png)

With 3 nodes hadoop cluster, hostname is `hadoop100`, `hadoop101`, `hadoop102`.

## Prerequisite
- docker, docker-compose
- make

## Usage

### 1. build images
```
git clone git@github.com:wecharyu/hadoop-docker.git
cd hadoop-docker
make build
```

### 2. startup cluster
- use the Makefile script:
```
make run
```
- restart existed containers
```
docker-compose start
```
### 3. stop containers
- remove containers when stopping:
```
docker-compose down
```
- stop containers which can be restarted
```
docker-compose stop
```
### 4. get into containers
```
docker exec -it hadoop100 bash
```

## Access web ui from host broswer

- HDFS UI: [http://localhost:9870](http://localhost:9870)
- YARN UI: [http://localhost:8088](http://localhost:8088)
