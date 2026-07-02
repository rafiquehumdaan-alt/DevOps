#!/bin/bash

CONF_FILE="settings.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file '$CONF_FILE' not found!"
    exit 1
fi

while IFS='=' read -r key value; do

echo "Key: $key, Value: $value"

done < "$CONF_FILE"