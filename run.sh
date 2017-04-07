#!/usr/bin/env bash
#
# Executes setup.rb using the Ruby bundled with Vagrant.
#

if [ ! -d "phanbook" ]; then
	git clone --depth=1 https://github.com/phanbook/phanbook.git
fi


if ! which docker > /dev/null; then
	echo "Docker doesn't seem to be installed. Please download and install it"
	echo "from https://docs.docker.com/engine/installation/ and re-run phanbook."
	exit 3
fi
if [[ "destroy" == "$2" ]]; then
	# Stop and remove any existing containers
	docker rm -f $(docker ps -a -q)
	# Delete all images
	docker rmi -f $(docker images -q)
fi
if ! which docker-compose > /dev/null; then
	curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	sudo service docker start
fi
cp phanbook/{.env.example,.env}
chmod 777 -R phanbook/public phanbook/content

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	sed -i 's|DB_HOST=localhost|DB_HOST=mysql|g' phanbook/.env
else

	sed -i '' 's|DB_HOST=localhost|DB_HOST=mysql|g' phanbook/.env
fi
docker-compose up -d

# Docker setup





