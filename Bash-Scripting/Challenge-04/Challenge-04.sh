#!/bin/bash

read -rp "Please provide a source directory: " source_dir

if [ ! -d "$source_dir" ]; then
    echo "Source directory not found."
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d%H%M%S)

BACKUP_DIR="${source_dir}_backup_${TIMESTAMP}"

mkdir -p "$BACKUP_DIR"
echo "Backup directory created: $BACKUP_DIR"

echo "Copying .txt files..."
cp "$source_dir"/*.txt "$BACKUP_DIR"

FILE_COUNT=$(ls "$BACKUP_DIR" | wc -l)

echo "Backup complete! Files backed up: $FILE_COUNT"