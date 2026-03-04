#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: ./create_post.sh \"Post Title\""
    exit 1
fi

TITLE=$1
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g').md
/home/j-harvey/go/bin/hugo new post/"$FILENAME"
echo "Created new post: content/post/$FILENAME"
