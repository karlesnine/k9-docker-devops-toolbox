#!/bin/bash
echo "Enter the ip of your dns [ENTER]:"
read dnsIp
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

docker build -t docker-devops-toolbox ./

docker run --hostname=dev --dns=$dnsIp \
	-v $ansiblePath:/etc/ansible \
	-v $terraformPath:/etc/terraform \
	-v $HOME/.aws:/root/.aws \
	-p $listenPort:22 -d -P --name docker-devops-toolbox

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