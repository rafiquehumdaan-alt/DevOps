#!/bin/bash

DIRECTORY="$1"

if [ -z "$DIRECTORY" ]; then
    echo "No directory provided."
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

find "$DIRECTORY" -type f -name "*.txt" -exec ls -lh {} + | sort -k 5,5 -h | awk '{ print $5, $9 }'