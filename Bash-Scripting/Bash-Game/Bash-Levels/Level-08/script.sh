#!/bin/bash

# Store the command-line arguments in variables
SEARCH_TERM="$1"
DIRECTORY="$2"

# Check that a search term was provided
if [ -z "$SEARCH_TERM" ]; then
    echo "Search term is required."
    exit 1
fi

# Check that a directory was provided
if [ -z "$DIRECTORY" ]; then
    echo "Directory is required."
    exit 1
fi

# Check that the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

# Search all .log files and store matching filenames
RESULTS=$(grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log)

# Display the results
if [ -z "$RESULTS" ]; then
    echo "No matching log files found."
else
    echo "Files containing '$SEARCH_TERM':"
    echo "$RESULTS"
fi