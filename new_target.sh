#!/bin/sh
# .../DockerManager/new_target.sh
# Used to create new targets from templates
# Expects 1 argument - address of new target.

# include some functions
. "$(dirname $0)/shared_code.sh"

parse_input $@

if [ -z "$TARGET" ]; then
	echo No target given;
	exit 1;
fi

# Let's see what our target depends on
# It will be set to .../dockerfiles/ if target depends on nothing
DEP_NAME_FULL="$(dirname $TARGET_DIR_NAME_FULL)/"
if ! target_exists $DEP_NAME_FULL ; then
        # there's no such directory
        echo "Error: could not find $DEP_NAME_FULL";
        exit 1;
fi

if  target_exists $TARGET_DIR_NAME_FULL ; then
	# It already exists
	echo "Target '$TARGET' already exists";
	exit 1;
fi

# Use template
cp -r "$DEP_NAME_FULL/target-template" $TARGET_DIR_NAME_FULL
DFILENAME="$TARGET_DIR_NAME_FULL/Dockerfile"
echo DFILENAME $DFILENAME
echo  "# .../DockerManager/dockerfiles/$TARGET/Dockerfile" > "$DFILENAME"
tail -n +2 "$DFILENAME.template" >> $DFILENAME

# Edit Dockerfile
# Some of our actions depend on whether our target depends on something or not
if  [[ $DEP_NAME_FULL == $BASE_DIR_NAME ]] ; then
	# Root target, without dependencies.
	echo root target;
else
	# Target with dependencies
	echo We have a target depending on $(dirname $TARGET);
fi
