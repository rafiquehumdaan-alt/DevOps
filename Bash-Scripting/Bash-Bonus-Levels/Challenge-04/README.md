# Bash Challenge 4 – Backup Script for Text Files

## Mission

Create a Bash script that:

* Prompts the user for a source directory.
* Checks that the directory exists.
* Creates a backup directory with a timestamp.
* Copies all `.txt` files into the backup directory.
* Displays how many files were backed up.

---

# Commands & Concepts Learned

## `read -rp`

Prompts the user for input and stores it in a variable.

**Syntax:**

```bash
read -rp "Prompt: " variable
```

**Example:**

```bash
read -rp "Please provide a source directory: " source_dir
```

If the user enters:

```text
Arena
```

The variable `source_dir` now contains:

```text
Arena
```

---

## `-d`

Checks whether a directory exists.

**Example:**

```bash
if [ -d "$source_dir" ]; then
```

Returns **true** if the directory exists.

---

## `!`

Reverses a condition.

Example:

```bash
if [ ! -d "$source_dir" ]; then
```

Reads as:

> If the directory does **not** exist...

---

## `exit 1`

Stops the script because an error occurred.

Example:

```bash
echo "Source directory not found."
exit 1
```

Without `exit 1`, the script would continue trying to back up a directory that doesn't exist, causing more errors.

---

## Creating Timestamps

We can save the current date and time into a variable.

Example:

```bash
TIMESTAMP=$(date +%Y%m%d%H%M%S)
```

If today's date and time is:

```text
2 July 2026 19:45:30
```

The variable becomes:

```text
20260702194530
```

---

## Variables Inside Strings

Variables can be inserted into text.

Example:

```bash
BACKUP_DIR="${source_dir}_backup_${TIMESTAMP}"
```

If:

```text
source_dir = Arena
TIMESTAMP = 20260702194530
```

Then:

```text
BACKUP_DIR = Arena_backup_20260702194530
```

Curly braces `{}` make it easier for Bash to identify where the variable name begins and ends, especially when text follows immediately after it.

---

## `mkdir -p`

Creates a directory.

The `-p` option prevents an error if the directory already exists.

Example:

```bash
mkdir -p "$BACKUP_DIR"
```

Without `-p`:

```text
mkdir: cannot create directory: File exists
```

With `-p`, Bash simply continues.

---

## `cp`

Copies files.

Example:

```bash
cp "$source_dir"/*.txt "$BACKUP_DIR"
```

This copies every file ending in `.txt` from the source directory into the backup directory.

### Wildcards

```bash
*.txt
```

Means:

> Every file whose name ends with `.txt`

Example:

```text
notes.txt
todo.txt
report.txt
```

It will **not** copy:

```text
image.png
music.mp3
document.pdf
```

---

## `wc -l`

Counts lines.

Example:

```bash
ls "$BACKUP_DIR" | wc -l
```

If `ls` outputs:

```text
file1.txt
file2.txt
file3.txt
```

Then:

```text
3
```

This allows us to count how many files were copied.

---

## Pipes (`|`)

A pipe sends the output of one command into another command.

Example:

```bash
ls "$BACKUP_DIR" | wc -l
```

1. `ls` lists the files.
2. `wc -l` counts how many lines it receives.

---

# Final Script

```bash
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
```

---

# Example Output

```text
Please provide a source directory: Arena

Backup directory created: Arena_backup_20260702194530
Copying .txt files...

Backup complete! Files backed up: 5
```

---

# What I Learned

* How to prompt the user for a directory.
* How to check whether a directory exists using `-d`.
* Why `exit 1` is useful for stopping a script when an error occurs.
* How to create timestamps using the `date` command.
* How to build descriptive directory names using variables.
* How to create directories safely using `mkdir -p`.
* How to copy files using `cp`.
* How wildcards (`*.txt`) work.
* How to use pipes (`|`) to send output between commands.
* How `wc -l` can count files by counting the output of `ls`.

---

# Improvements We Made

## 1. More descriptive backup directory

Instead of:

```bash
BACKUP_DIR="backup_$TIMESTAMP"
```

we created:

```bash
BACKUP_DIR="${source_dir}_backup_${TIMESTAMP}"
```

Example:

```text
Arena_backup_20260702194530
```

This immediately tells us which directory was backed up.

---

## 2. Removed the unnecessary `-r` option

Initially we wrote:

```bash
cp -r "$source_dir"/*.txt "$BACKUP_DIR"
```

However, `-r` (recursive) is only required when copying directories.

Since we are copying files, the correct command is:

```bash
cp "$source_dir"/*.txt "$BACKUP_DIR"
```

This is cleaner and more appropriate.

---

## 3. Human-readable timestamps

Although we used:

```bash
TIMESTAMP=$(date +%Y%m%d%H%M%S)
```

we discussed that a more readable format is:

```bash
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
```

Example:

```text
2026-07-02_19-45-30
```

This makes it much easier to identify when each backup was created.

---

## 4. A More Reliable Way to Count Files

Our script uses:

```bash
FILE_COUNT=$(ls "$BACKUP_DIR" | wc -l)
```

which is acceptable for learning and small scripts.

A more robust solution is:

```bash
FILE_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.txt" | wc -l)
```

This only counts `.txt` files, ignores subdirectories, and is the preferred approach in production scripts.

---

## Key Takeaways

This challenge combined many concepts from previous exercises:

* Variables
* User input
* Directory checks
* Conditional statements
* File copying
* Wildcards
* Command substitution (`$(...)`)
* Pipes (`|`)
* Counting output with `wc -l`

Rather than introducing lots of new commands, it showed how Bash scripts are often built by combining a small set of simple commands into a useful automation.

