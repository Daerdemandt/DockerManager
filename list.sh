#!/bin/sh
# .../DockerManager/list.sh
# Lists targets depending on given target
# Usage: list.sh [target [prefix]]
# If no target provided, all targets are listed
# Prefix will be printed before the target. Don't use it.

# include some functions
. "$(dirname $0)/shared_code.sh"

parse_target_name $@

# For prefix, we need 4 symbols to represent blank space, vertical bar,
# vertical bar extending right and corner.
# We'll use placeholders for them (B, V, E, C respectively) to avoid
# nontrivial mess with quotations when passing prefix further)

# TODO: use ASCII instead of Unicode
B=' '
V='│'
E='├'
C='└'

# Replace, if any, last vertical bar with horisontally extending
PREFIX=$(echo $2 | sed "s/V\$/E/")

#echo "PP $PREFIX"
PREFIX_INHERITABLE=$(echo $PREFIX | sed "s/C/B/" | sed "s/E/V/")
#echo "PI: $TARGET ${PREFIX_INHERITABLE}lel"
CHILD_PREFIX="${PREFIX_INHERITABLE}E"
LAST_CHILD_PREFIX="${PREFIX_INHERITABLE}C"

if [[ -n "$1" ]]; then 
#	PREFIX_PRINTABLE=$(echo $PREFIX | sed "y/BVEC/$B$V$E$C/")
	PREFIX_PRINTABLE=$(echo $PREFIX | sed "s/B/$B/g" | sed "s/V/$V/g" | sed "s/E/$E/g" | sed "s/C/$C/g")
	echo "$PREFIX_PRINTABLE$TARGET"
else
	if [ "$(get_dependants $TARGET_DIR_NAME_FULL)" ] ; then
		echo "Listing all targets:"
		CHILD_PREFIX=""
		LAST_CHILD_PREFIX=""
	else
		echo "Nothing to list"
	fi
fi

# For all dependants except last
for child in $(get_dependants $TARGET_DIR_NAME_FULL | head -n -1); do
	# remove slash from beginning if any
	CHILD_TARGET_NAME=$(echo "$TARGET/$child" | sed 's/^\///' )
	$0 $CHILD_TARGET_NAME "$CHILD_PREFIX"
done

LAST_CHILD=$(get_dependants $TARGET_DIR_NAME_FULL | tail -n 1);
if [[ -n "$LAST_CHILD" ]]; then
	LAST_CHILD=$(echo "$TARGET/$LAST_CHILD" | sed 's/^\///' | sed 's/\/$//')
	$0 $LAST_CHILD "$LAST_CHILD_PREFIX"
fi

