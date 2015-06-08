#!/bin/sh
# /home/docker/update.sh
# Scrip to recursively update docker images
# Script needs directory to work with.
# If not provided, /home/docker/dockerfiles is assumed

get_dependants() {
# Return folders with proper names only
# Proper names are made of nothing except lowercase ascii,
# digits and underscore
# Expects folder name, whose dependants we're interested in

#return `ls $1 | grep --line-regexp --basic-regexp '[a-z0-9_]*'`
# grep and ls here are a bit simplier
ls -p $1 | grep -x -e '[a-z0-9_]*/'
}

get_image_name() {
# replace all slashes with hyphens
# Expects string
echo $1 | sed 's/\//-/'
}

# If folder was not specified, we'll fall back to default.
# We assume that base folder is in the same directory with our script.
# We assume that it's named "dockerfiles"
# We get its name by replacing sequence of all non-slash symbols at the 
# end of script's filename with "dockerfiles"
BASE_DIR_NAME=$(realpath $0 | sed 's/[^\/]*$/dockerfiles\//')

# Remove trailing slash in input, if any
TARGET=$(echo $1 | sed 's/\/$//')
TARGET_DIR_NAME_FULL="$BASE_DIR_NAME$TARGET";

if [[ -n "$1" ]]; then # Target is specified, do some building
	# TODO: check if target exists
	IMAGE_NAME=$(get_image_name $TARGET);
	# Build
	docker build --tag="untested/$IMAGE_NAME" $TARGET_DIR_NAME_FULL
	# Test
	# TODO: tests!
	# If tests are OK, update 'deployable' repo
	# TODO: updating repo
	
fi

# Let's process dependants, in parallel.
for child in $(get_dependants $TARGET_DIR_NAME_FULL); do
	$0 $child &
done

