#!/bin/bash

certsDir=/home/username/certs
workDir=/home/username
wildcardDomain=*.domain.com
domain=domain.com

case $1 in
	renew)
	docker run -it --rm --name get_cert -p 80:80 -p 443:443 -v "/home/kenneth/certs:/etc/letsencrypt" -v "/home/kenneth/lible:/var/lib/letsencrypt" kenx/dnspod-certbot:latest renew -a certbot-dns-dnspod:dns-dnspod --certbot-dns-dnspod:dns-dnspod-credentials /etc/letsencrypt/credentials.ini -d $wildcardDomain -d $domain
	;;
	new)
	docker-compose -f $workDir/production/docker-compose.yml down
	docker run -it --rm --name get_cert -p 80:80 -p 443:443 -v "/home/kenneth/certs:/etc/letsencrypt" -v "/home/kenneth/lible:/var/lib/letsencrypt" kenx/dnspod-certbot:latest certonly -a certbot-dns-dnspod:dns-dnspod --certbot-dns-dnspod:dns-dnspod-credentials /etc/letsencrypt/credentials.ini  -d $wildcardDomain -d $domain
	docker-compose -f $workDir/production/docker-compose.yml up
	;;
	copy)
	for file in cert fullchain chain privkey; do
		for path in production project; do
			echo "cp ${certsDir}/live/${domain}/${file}.pem ${workDir}/${path}/certs"
			sudo cp ${certsDir}/live/${domain}/${file}.pem ${workDir}/${path}/certs
		done
	done
	;;
	*)
	echo "parameter 1 must be new or renew!"
	;;
esac
