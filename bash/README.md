
## install-docker

Easy way to install docker.

### on centos

```bash
$ ./install-docker-centos.sh
```

Options:
	-u User_name        add user to group(docker)
	-m Docker_Mirrors   set your own docker mirror
	-n Docker_Registry  set your own docker registry mirror
	-c                  automatically install docker-compose

### on debain

```bash
 $ ./install-docker-debian.sh
```

Options:
	-u User_name        add user to group(docker)
	-m Docker_Mirrors   set your own docker mirror
	-n Docker_Registry  set your own docker registry mirror
	-c                  automatically install docker-compose

### tips

Docker Mirror in China:

* Aliyun: `https://opsx.alibaba.com/mirror` [More Info](https://yq.aliyun.com/articles/110806)

Docker Register Mirror in China:

* Docker-cn: `https://registry.docker-cn.com` [More Info](https://www.docker-cn.com/registry-mirror)
* Aliyun: `https://{your_own_id}.mirror.aliyuncs.com` [More Info](https://cr.console.aliyun.com/#/accelerator)

Websites:

* [Official Site](https://www.docker.com/)
* [DaoCloud Download](http://get.daocloud.io/)
* [Docker Hub](https://hub.docker.com/)
