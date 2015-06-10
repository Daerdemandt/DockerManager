#!/bin/sh
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

UNTESTED_ID=$(docker images | grep "$(untested_image_name $TARGET)" | awk '{print $3}')
if [[ -n $UNTESTED_ID ]] ; then
	docker rmi -f "$UNTESTED_ID"
fi

TESTED_ID=$(docker images | grep "$(tested_image_name $TARGET)" | awk '{print $3}')
if [[ -n $TESTED_ID ]] ; then
	docker rmi -f "$TESTED_ID"
fi

echo "$TARGET removed"
