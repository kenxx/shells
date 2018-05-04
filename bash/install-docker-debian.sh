#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!"
    exit 1
fi

# set some parameters
User=
DockerRegistry=
DockerMirrors='https://download.docker.com/linux/debian'

while getopts 'u:r:m:ch' OPT
do
	case $OPT in
		u)
		User=$OPTARG
		;;
		r)
		DockerRegistry=$OPTARG
		;;
		m)
		DockerMirrors=$OPTARG
		;;
		c)
		InstallCompose=$OPTARG
		;;
		h|?)
		echo "Usage: `basename $0` [-u 'user_add_to_docker'] [-r 'fast_docker_reg'] [-m 'fast_docker_mirrors'] [-c]"
		exit
		;;
	esac
done

apt-get remove docker docker-engine docker.io
apt-get update
apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common

curl -fsSL ${DockerMirrors}/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] $DockerMirrors $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

docker run hello-world

systemctl daemon-reload
systemctl restart docker

# install docker-compose
if [[ $InstallCompose ]]
then
	curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose --version
fi

# add user to docker group
if [[ $User ]]
then
	DockerGroup="docker"
	echo "Adding $User to group(docker)"
	egrep "^$DockerGroup" /etc/group >& /dev/null
	if [[ $? -ne 0 ]]
	then
		groupadd $DockerGroup
	fi
	usermod -aG $DockerGroup $User
fi

# set a faster registry
if [[ $DockerRegistry ]]
then
	echo "Set Docker mirror to $DockerRegistry, will generate file to /etc/docker/daemon.json:"
	mkdir -p /etc/docker
	tee /etc/docker/daemon.json <<-EOF
{
  "registry-mirrors": ["$DockerRegistry"]
}
EOF
fi
