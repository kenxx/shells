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
DockerMirrors='https://download.docker.com/linux/centos/docker-ce.repo'
InstallCompose=

while getopts 'u:n:m:c' OPT; do
	case $OPT in
		u)
		User=$OPTARG
		;;
		n)
		DockerRegistry=$OPTARG
		;;
		m)
		DockerMirrors=$OPTARG
		;;
		c)
		InstallCompose=$OPTARG
		;;
		?)
		echo "Usage: `basename $0` [-u 'user_add_to_docker'] [-n 'fast_docker_reg'] [-m 'fast_docker_mirrors'] [-c]"
		;;
	esac
done


yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine

yum install -y yum-utils device-mapper-persistent-data lvm2 curl

yum-config-manager --add-repo $DockerMirrors
yum makecache fast
yum install -y docker-ce

systemctl start docker
systemctl enable docker
docker run hello-world

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

