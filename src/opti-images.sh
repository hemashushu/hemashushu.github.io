#!/bin/bash
# there are many ways to optimize images, such as:
# - jpegoptim
# - optipng
# - pngcrush
# however, a more efficient way to optimize PNG is
# convert it to WEBP format.

# usage:
# ./opti-images.sh [PATH_TO_FOLDER]
#
# the default path is './content'

DST_PATH=$1

if [ -z "$DST_PATH" ]; then
	DST_PATH="./content"
fi

FILES=$(find "$DST_PATH" -type f -name "*.png")
for NAMEPATH in $FILES; do
	#echo $NAMEPATH
	NAMEPATH_WITHOUT_EXTENSION=${NAMEPATH%.*}
	FROM="$NAMEPATH_WITHOUT_EXTENSION.png" 
        TO="$NAMEPATH_WITHOUT_EXTENSION.webp"
	echo "---"
	cwebp "$FROM" -o "$TO"
done

