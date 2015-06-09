#!/bin/sh
# .../DockerManager/misc_functions.sh
# Pieces of code used across various parts of DockerManager are stored here

get_dependants() {
# Expects folder name, whose dependants we're interested in
# Return folders with proper names only
# Proper names are made of nothing except lowercase ascii, digits and
# underscores
	ls -p $1 | grep -x -e '[a-z0-9_]*/'
}

basic_image_name() {
# Expects string, which will be treated as target's location
# Replaces all slashes with hyphens to get image's name
	echo $1 | sed 's/\//-/'
}

untested_image_name() {
# Expects string, which will be treated as target's location
	echo "untested/$(basic_image_name $1)"
}

tested_image_name() {
# Expects string, which will be treated as target's location
	echo "deployable/$(basic_image_name $1)"
}

target_exists() {
# Expects target name. Target name is a folder name.
# Returns TRUE if such folder exists and FALSE otherwise.
# TODO: check if target name is a proper name
	[[ -d "$1" && ! -L "$1" ]]
}



# It would be nice to add a function that traverses all the dependants
# and applies given function to them but as of now I don't see an elegant way
# to do it in sh.


parse_input(){
# Sets variables BASE_DIR_NAME, TARGET, TARGET_DIR_NAME_FULL
	# We assume that base folder is in the same directory with our script.
	# We assume that it's named "dockerfiles"
	BASE_DIR_NAME="$(dirname $0)/dockerfiles/"

	# Remove trailing slash in input, if any
	TARGET=$(echo $1 | sed 's/\/$//')
	TARGET_DIR_NAME_FULL=$(echo "$BASE_DIR_NAME$TARGET" | sed 's/\/$//');
}
