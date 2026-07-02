#!/bin/bash

echo "Choose an option and select between 1 and 5:"
echo "1. Check disk space"
echo "2. Show system uptime"
echo "3. Backup the Arena directory and keep the last three backups"
echo "4. Parse settings.conf and display values"
echo "5. Exit"

read -rp "Enter your choice (1-5): " choice

case $choice in
    1)
        echo "Checking disk space..."
        df -h
        ;;

    2)
        echo "Showing system uptime..."
        uptime
        ;;

    3)
        echo "Backing up the Arena directory..."

        SOURCE_DIRECTORY="Arena"
        BACKUP_DIRECTORY="Backups"

        if [ ! -d "$SOURCE_DIRECTORY" ]; then
            echo "Source directory '$SOURCE_DIRECTORY' not found!"
            exit 1
        fi

        mkdir -p "$BACKUP_DIRECTORY"

        TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
        BACKUP_FILE="$BACKUP_DIRECTORY/backup_$TIMESTAMP.tar.gz"

        tar -czf "$BACKUP_FILE" "$SOURCE_DIRECTORY"

        cd "$BACKUP_DIRECTORY" || exit

        ls -t | sed -e '1,3d' | while IFS= read -r file; do
            rm -f "$file"
        done

        echo "Backup completed successfully."
        ;;

    4)
        echo "Parsing settings.conf and displaying values..."

        CONF_FILE="settings.conf"

        if [ ! -f "$CONF_FILE" ]; then
            echo "Configuration file '$CONF_FILE' not found!"
            exit 1
        fi

        while IFS='=' read -r key value; do
            echo "Key: $key, Value: $value"
        done < "$CONF_FILE"
        ;;

    5)
        echo "Exiting..."
        exit 0
        ;;

    *)
        echo "Invalid choice. Please select a number between 1 and 5."
        ;;
esac