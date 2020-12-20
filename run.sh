#!/bin/bash

source ./run.init

if [ -z $listenPort ]
then
    listenPort=8001
fi

if [ "$(uname)" == "Darwin" ]; then
  docker container run --hostname=DevK9 \
	-v $ansiblePath:/etc/ansible:delegated \
	-v $terraformPath:/etc/terraform:delegated \
	-v $HOME/.aws:/root/.aws \
	-p $listenPort:22 -d -P --name $ContainerName $ImageName:latest
else
  docker container run --hostname=DevK9 \
	-v $ansiblePath:/etc/ansible \
	-v $terraformPath:/etc/terraform \
	-v $HOME/.aws:/root/.aws \
	-p $listenPort:22 -d -P --name $ContainerName $ImageName:latest
fi
	#statements


if [ ! -z "$sshPubKey" ]
then
    docker exec -it $ContainerName sh -c "echo \"$sshPubKey\" > /root/.ssh/id_rsa.pub"
    docker exec -it $ContainerName sh -c "echo \"$sshPubKey\" > /root/.ssh/authorized_keys"
fi

if [ ! -z "$gitConfigName" ]
then
	docker exec -it $ContainerName git config --global user.name $gitConfigName
fi

if [ ! -z "$gitConfigMail" ]
then
	docker exec -it $ContainerName git config --global user.email $gitConfigMail
fi
