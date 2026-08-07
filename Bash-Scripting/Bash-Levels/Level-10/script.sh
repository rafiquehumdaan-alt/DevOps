#!/bin/bash

mkdir Arena_Boss

for i in {1..5}
do
    FILE="Arena_Boss/file$i.txt"
    LINES=$((RANDOM % 11 + 10))
    for j in $(seq 1 $LINES)
    do
        echo "This is line $j" >> "$FILE"
    done
done

echo "Files sorted by size:"
find Arena_Boss -type f -exec ls -lh {} + | sort -k 5,5 -h


mkdir -p Victory_Archive
for FILE in Arena_Boss/*.txt
do
    if grep -q "Victory" "$FILE"; then
        mv "$FILE" Victory_Archive/
        echo "$FILE contains 'Victory' and has been moved to Victory_Archive."
    fi
done