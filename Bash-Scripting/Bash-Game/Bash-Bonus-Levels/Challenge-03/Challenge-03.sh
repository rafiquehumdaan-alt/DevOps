#!/bin/bash

read -rp "Please provide a filename: " filename

if [ ! -f "$filename" ]; then
    echo "File not found."
else
    echo "File found."

    if [ -r "$filename" ]; then
        echo "The file is readable."
    else
        echo "The file is not readable."
    fi

    if [ -w "$filename" ]; then
        echo "The file is writable."
    else
        echo "The file is not writable."
    fi

    if [ -x "$filename" ]; then
        echo "The file is executable."
    else
        echo "The file is not executable."
    fi
fi