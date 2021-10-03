# Hadoop Docker

Hadoop docker project is used to build and start up a hadoop cluster in some docker containers.

## Overview
![hadoop cluster overview](hadoop-cluster.png)

With 3 nodes hadoop cluster, hostname is `hadoop100`, `hadoop101`, `hadoop102`.

## prerequisite
- docker, docker-compose
- make

## Usage

### 1. build images
```
git clone
cd hadoop-docker
make build
```

### 2. startup cluster
- Use the docker-compose command:
```
docker-compose up -d
```
- Use the Makefile script:
```
make run
```

### 3. stop containers
- remove containers when stopping:
```
docker-compose down
```
