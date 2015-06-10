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

# Edit Dockerfile
DFILENAME="$TARGET_DIR_NAME_FULL/Dockerfile"
echo  "# .../DockerManager/dockerfiles/$TARGET/Dockerfile" > "$DFILENAME"
# Some of our actions depend on whether our target depends on something or not
if  [[ $DEP_NAME_FULL == $BASE_DIR_NAME ]] ; then
	# Root target, without dependencies.
	echo Adding new root target $TARGET
	# We'll just copy the template, starting with 2nd line
	tail -n +2 "$DFILENAME.template" >> $DFILENAME;
else
	# Target with dependencies
	echo Adding new target $TARGET depending on $(dirname $TARGET)
	# We'll represent the dependency using FROM directive
	STRING_TO_REPLACE='^\w*[Ff][Rr][Oo][Mm].*$'
	REPLACE_WITH="FROM $(tested_image_name $(dirname $TARGET))"
	SED_COM="s/$STRING_TO_REPLACE/$REPLACE_WITH/"
	echo "# This is a dockerfile for target $TARGET" >> $DFILENAME;
	tail -n +3 "$DFILENAME.template" | sed "$SED_COM" >> $DFILENAME;
	# Add a template for consequent dependent targets
	cp -r "$DEP_NAME_FULL/target-template" "$TARGET_DIR_NAME_FULL/target-template"

fi
