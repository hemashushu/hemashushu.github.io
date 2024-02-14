#!/bin/bash
# there are many ways to optimize images, such as:
# - jpegoptim
# - optipng
# - pngcrush
# however, a more efficient way to optimize PNG is
# convert it to WEBP format.

FILES=$(find ./content -type f -name "*.png")
for NAMEPATH in $FILES; do
	#echo $NAMEPATH
	NAMEPATH_WITHOUT_EXTENSION=${NAMEPATH%.*}
	FROM="$NAMEPATH_WITHOUT_EXTENSION.png" 
        TO="$NAMEPATH_WITHOUT_EXTENSION.webp"
	echo "---"
	cwebp "$FROM" -o "$TO"
done

