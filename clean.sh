#!/bin/sh
# .../DockerManager/clean.sh
# Removes images that have no name

if [ "$(docker images | grep "^<none>")" ]; then
	echo "Removing images without names"
	docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
fi
