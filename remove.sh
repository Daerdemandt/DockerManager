#!/bin/bash
# .../DockerManager/remove.sh
# Used to remove targets
# Expects one argument - target to remove

# TODO: also remove corresponding images

# include some functions
. "$(dirname $0)/shared_code.sh"

parse_target_name $@

if [ -z "$TARGET" ]; then
	echo No target given;
	exit 1;
fi

if ! target_exists $TARGET_DIR_NAME_FULL ; then
	# there's no such directory
	echo "Error: could not find $TARGET_DIR_NAME_FULL";
	exit 1;
fi

rm -rf $TARGET_DIR_NAME_FULL
docker rmi "$(untested_image_name $TARGET)"
docker rmi "$(tested_image_name $TARGET)"
echo "$TARGET removed"
