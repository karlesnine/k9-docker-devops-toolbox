#!/bin/bash
echo "Enter the path of your ansible folder, followed by [ENTER]:"
read ansiblePath
echo "Enter the path of your terraform folder, followed by [ENTER]:"
read terraformPath

echo "Enter your public ssh key (optionnal) (to override root key), followed by [ENTER]:"
read sshPubKey

echo "Enter the listen port (default 8001), followed by [ENTER]:"
read listenPort

if [ -z $listenPort ]
then
    listenPort=8001
fi

if [ "$(uname)" == "Darwin" ]; then
  docker run --hostname=dev --dns=192.168.136.7 \
	-v $ansiblePath:/etc/ansible:delegated \
	-v $terraformPath:/etc/terraform:delegated \
	-v $HOME/.aws:/root/.aws \
	-p $listenPort:22 -d -P --name devops-toolbox gitlab.vestiairecollective.com:4567/tools/docker-devops-toolbox:latest
else
  docker run --hostname=dev --dns=192.168.136.7 \
	-v $ansiblePath:/etc/ansible \
	-v $terraformPath:/etc/terraform \
	-v $HOME/.aws:/root/.aws \
	-p $listenPort:22 -d -P --name devops-toolbox gitlab.vestiairecollective.com:4567/tools/docker-devops-toolbox:latest
fi
	#statements


if [ ! -z "$sshPubKey" ]
then
    docker exec -it devops-toolbox sh -c "echo \"$sshPubKey\" > /root/.ssh/id_rsa.pub"
    docker exec -it devops-toolbox sh -c "echo \"$sshPubKey\" > /root/.ssh/authorized_keys"
fi

gitConfigName=$(git config --global user.name)
gitConfigMail=$(git config --global user.email)
if [ ! -z "$gitConfigName" ]
then
	docker exec -it devops-toolbox git config --global user.name $gitConfigName
fi

if [ ! -z "$gitConfigMail" ]
then
	docker exec -it devops-toolbox git config --global user.email $gitConfigMail
fi