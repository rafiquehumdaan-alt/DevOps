#!/bin/bash

DIRECTORY="Arena"

DISK_SPACE=$(du -sm "$DIRECTORY" | awk '{print $1}')

THRESHOLD=1 

if [ "$DISK_SPACE" -gt "$THRESHOLD" ]; then
    echo "Disk space used by $DIRECTORY exceeds threshold: ${DISK_SPACE}MB"
else
    echo "Disk space used by $DIRECTORY is within the threshold: ${DISK_SPACE}MB"
fi