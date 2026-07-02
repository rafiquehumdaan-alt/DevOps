#!/bin/bash

SOURCE_DIRECTORY="Arena"
BACKUP_DIRECTORY="Backups"

mkdir -p "$BACKUP_DIRECTORY"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIRECTORY/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIRECTORY"

cd "$BACKUP_DIRECTORY" || exit

ls -t | sed -e '1,5d' | while IFS= read -r file; do
    rm -f "$file"
done