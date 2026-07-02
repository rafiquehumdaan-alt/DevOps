# Level 13: Backup Script with Rotation

## Mission

Create a script that backs up a directory to a specified location and keeps only the last 5 backups.

---

## Final Script

```bash
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
```

---

## What This Script Does

This script creates a compressed backup of the `Arena` directory and stores it inside the `Backups` directory.

Each backup has a timestamp in its filename, so every backup has a unique name and does not overwrite the previous one.

The script then keeps only the newest 5 backups and deletes anything older.

---

## Line-by-Line Explanation

```bash
#!/bin/bash
```

This tells the system to run the script using Bash.

```bash
SOURCE_DIRECTORY="Arena"
```

This stores the directory we want to back up.

```bash
BACKUP_DIRECTORY="Backups"
```

This stores the directory where backups will be saved.

```bash
mkdir -p "$BACKUP_DIRECTORY"
```

This creates the backup directory if it does not already exist.

The `-p` option prevents errors if the folder already exists.

```bash
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
```

This creates a timestamp using the current date and time.

Example output:

```text
2026-07-01_16-30-15
```

This makes every backup filename unique.

```bash
BACKUP_FILE="$BACKUP_DIRECTORY/backup_$TIMESTAMP.tar.gz"
```

This creates the full backup file path.

Example:

```text
Backups/backup_2026-07-01_16-30-15.tar.gz
```

```bash
tar -czf "$BACKUP_FILE" "$SOURCE_DIRECTORY"
```

This creates the actual backup.

Breakdown:

```text
tar = archive tool
-c  = create archive
-z  = compress using gzip
-f  = use the following filename
```

So this command takes the `Arena` directory, packages it into one compressed `.tar.gz` file, and saves it inside `Backups`.

The original `Arena` folder is not deleted or moved.

```bash
cd "$BACKUP_DIRECTORY" || exit
```

This changes into the backup directory.

The `|| exit` part means:

```text
If changing directory fails, stop the script.
```

This is important because we do not want the script deleting files from the wrong directory.

```bash
ls -t
```

This lists the backup files by time, with the newest files first.

```bash
sed -e '1,5d'
```

This removes lines 1 to 5 from the list.

Important: `sed` is only editing the text output, not deleting files.

Because `ls -t` puts the newest backups first, `sed -e '1,5d'` removes the newest 5 from the list, leaving only the older backups.

```bash
while IFS= read -r file; do
```

This reads each remaining filename one at a time.

`IFS=` means read the whole line properly.

`read -r` means read the line raw, without treating backslashes specially.

```bash
rm -f "$file"
```

This deletes each old backup file.

The `-f` means force, so it will not complain if the file does not exist.

```bash
done
```

This ends the while loop.

---

## How the Rotation Works

The key line is:

```bash
ls -t | sed -e '1,5d' | while IFS= read -r file; do
    rm -f "$file"
done
```

The logic is:

```text
1. ls -t lists backups newest first.
2. sed -e '1,5d' removes the newest 5 from the list.
3. Only old backups remain in the pipeline.
4. while read processes each old backup filename.
5. rm -f deletes each old backup.
```

Example:

```text
backup_2026-07-01.tar.gz   keep
backup_2026-06-30.tar.gz   keep
backup_2026-06-29.tar.gz   keep
backup_2026-06-28.tar.gz   keep
backup_2026-06-27.tar.gz   keep
backup_2026-06-26.tar.gz   delete
backup_2026-06-25.tar.gz   delete
```

---

## Why We Used `tar -czf`

We used `tar -czf` because the mission is to back up a whole directory.

Using:

```bash
touch backup.bak
```

would only create an empty file.

It would not contain the files from `Arena`.

Using `tar -czf` creates one compressed archive containing the full directory.

Think of it like creating a ZIP file in Windows.

---

## What `sed` Does

`sed` stands for stream editor.

It edits text as it flows through a pipeline.

In this script, `sed` does not delete files. It only removes the newest 5 backup names from the text list, so that only the older backups are passed to `rm`.

---

## Improvements We Made Compared to the Exam Answer

The exam answer used:

```bash
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"
```

Our version used:

```bash
BACKUP_FILE="$BACKUP_DIRECTORY/backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" "$SOURCE_DIRECTORY"
```

This is an improvement because `BACKUP_FILE` stores the full backup path in one variable.

That makes the `tar` command cleaner and easier to read.

We also used clearer variable names:

```bash
SOURCE_DIRECTORY
BACKUP_DIRECTORY
BACKUP_FILE
```

These names are more descriptive than shorter names like:

```bash
SOURCE_DIR
BACKUP_DIR
BACKUP_NAME
```

Both versions work, but our version is slightly easier to understand when reading the script later.

---

## Key Commands Learned

```bash
mkdir -p
```

Creates a directory safely, even if it already exists.

```bash
date +%Y-%m-%d_%H-%M-%S
```

Creates a timestamp.

```bash
tar -czf
```

Creates a compressed `.tar.gz` backup archive.

```bash
cd "$DIRECTORY" || exit
```

Changes directory safely and stops the script if it fails.

```bash
ls -t
```

Lists files newest first.

```bash
sed -e '1,5d'
```

Deletes lines 1 to 5 from the text output.

```bash
while IFS= read -r file
```

Reads each line safely, one at a time.

```bash
rm -f
```

Force deletes a file without asking or complaining.

---

## What We Learned

In this level, we learned how to create a real backup script.

The most important lesson was that backing up a directory is not the same as creating an empty `.bak` file.

A real backup needs to contain the files and folders from the source directory.

We also learned how backup rotation works:

```text
Create a new backup.
Sort backups newest first.
Keep the newest 5.
Delete the older ones.
```

This is a practical scripting pattern used in real system administration and DevOps tasks.

