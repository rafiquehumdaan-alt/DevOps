# Level 9: Script to Monitor Directory Changes

## Mission

Write a script that monitors a directory for any changes, such as file creation, modification, or deletion, and logs those changes with a timestamp.

## Final Script

```bash
#!/bin/bash

DIRECTORY="Arena"
LOG_FILE="change_log.txt"

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

fswatch -r "$DIRECTORY" | while read event; do
    if [ -e "$event" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') File modified/created: $event" >> "$LOG_FILE"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') File deleted: $event" >> "$LOG_FILE"
    fi
done
```

## What This Script Does

This script watches the `Arena` directory for changes.

If a file is created, modified, or deleted, the script writes a message into `change_log.txt`.

Each log entry includes:

* The date
* The time
* The type of change
* The file path

Example log output:

```text
2026-06-30 16:40:22 File modified/created: Arena/hero.txt
2026-06-30 16:42:10 File deleted: Arena/villain.txt
```

## Script Breakdown

```bash
#!/bin/bash
```

This tells Linux to run the script using Bash.

```bash
DIRECTORY="Arena"
```

This sets the directory that will be monitored.

```bash
LOG_FILE="change_log.txt"
```

This sets the file where changes will be logged.

```bash
if [ ! -d "$DIRECTORY" ]; then
```

This checks if the `Arena` directory does not exist.

```bash
echo "Directory does not exist."
exit 1
```

If the directory does not exist, the script prints an error message and stops.

```bash
fswatch -r "$DIRECTORY"
```

This monitors the `Arena` directory for changes.

The `-r` option means recursive, so it also watches files inside subdirectories.

```bash
| while read event; do
```

The pipe sends the output from `fswatch` into the loop.

`read event` stores each changed file path inside the variable called `event`.

For example, if `fswatch` detects:

```text
Arena/hero.txt
```

then Bash stores:

```bash
event="Arena/hero.txt"
```

```bash
if [ -e "$event" ]; then
```

This checks whether the changed file still exists.

`-e` means “does this path exist?”

If it exists, the file was probably created or modified.

If it does not exist, the file was deleted.

```bash
echo "$(date +'%Y-%m-%d %H:%M:%S') File modified/created: $event" >> "$LOG_FILE"
```

This logs a created or modified file with a timestamp.

```bash
echo "$(date +'%Y-%m-%d %H:%M:%S') File deleted: $event" >> "$LOG_FILE"
```

This logs a deleted file with a timestamp.

```bash
done
```

This ends the loop and keeps the script watching for more changes.

## Important Commands and Concepts

### `fswatch`

`fswatch` is used to monitor files and directories for changes.

### `-r`

The `-r` option means recursive.

It allows the script to monitor the main directory and its subdirectories.

### `while read event`

This reads each line of output from `fswatch`.

Each line is stored in the variable `event`.

### `-e`

The `-e` test checks whether a file or directory exists.

### `date +'%Y-%m-%d %H:%M:%S'`

This creates a formatted timestamp.

Example:

```text
2026-06-30 16:45:30
```

### `>>`

This appends text to a file without deleting the existing contents.

## What We Learnt

In this level, we learnt how to:

* Monitor a directory for changes.
* Use `fswatch` to detect file activity.
* Pipe command output into a `while read` loop.
* Store each detected change inside a variable.
* Use `-e` to check whether a file still exists.
* Use `date` to create timestamps.
* Append log entries to a file using `>>`.

## Why This Is Useful

This type of script is useful in real-world IT and DevOps tasks.

For example, it could be used to monitor:

* A shared upload folder
* A deployment folder
* A backup directory
* A configuration directory
* A logs folder

It gives administrators a simple record of what changed and when.

## Summary

This script continuously watches the `Arena` directory.

When something changes, `fswatch` reports the changed file path.

The script then checks whether the file still exists.

If it exists, the script logs it as modified or created.

If it does not exist, the script logs it as deleted.

All changes are saved in `change_log.txt` with a timestamp.

