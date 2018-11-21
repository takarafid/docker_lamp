NAME=lamp
VERSION=latest
DOCKER_RUN_OPTIONS= \
	--privileged \
	--net=docker-lan \
	--ip=192.168.100.2 \
	-p 80:80 \
	-p 443:443 \
	-p 3306:3306 \
	-v `pwd`/mysql:/var/lib/mysql

include docker.mk
