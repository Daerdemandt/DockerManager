#!/bin/sh
# .../DockerManager/remove.sh
# Used to remove targets
# Expects one argument - target to remove

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

# Before removing our target, let's remove targets that depend on it
for child in $(get_dependants $TARGET_DIR_NAME_FULL); do
	# remove slash from beginning if any
	CHILD_TARGET_NAME=$(echo "$TARGET/$child" | sed 's/^\///' )
	$0 $CHILD_TARGET_NAME
done

rm -rf $TARGET_DIR_NAME_FULL

UNTESTED_ID=$(docker images | grep "$(basic_image_name $TARGET)\s*tested" | awk '{print $3}')
if [ $UNTESTED_ID ] ; then
	docker rmi -f "$UNTESTED_ID"
fi

TESTED_ID=$(docker images | grep "$(basic_image_name $TARGET)\s*tested" | awk '{print $3}')
if [ $TESTED_ID ] ; then
	docker rmi -f "$TESTED_ID"
fi

echo "$TARGET removed"
