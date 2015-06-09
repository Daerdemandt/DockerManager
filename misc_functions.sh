#!/bin/sh
# .../DockerManager/misc_functions.sh
# Functions used across various parts of DockerManager are stored here

get_dependants() {
# Expects folder name, whose dependants we're interested in
# Return folders with proper names only
# Proper names are made of nothing except lowercase ascii,
# digits and underscore

#return `ls $1 | grep --line-regexp --basic-regexp '[a-z0-9_]*'`
# grep and ls here are a bit simplier
ls -p $1 | grep -x -e '[a-z0-9_]*/'
}

get_image_name() {
# Expects string, which will be treated as target's location
# Replaces all slashes with hyphens to get image's name
echo $1 | sed 's/\//-/'
}

# It would be nice to add a function that traverses all the dependants
# and applies given function to them but as of now I don't see an elegant way
# to do it in sh.
