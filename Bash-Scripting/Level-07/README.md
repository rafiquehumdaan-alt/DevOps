# Level 7: File Sorting Script

## Mission

Write a script that sorts all `.txt` files in a directory by their size (smallest to largest) and displays the sorted list.

---

## What We Learnt

This level introduced several new Bash concepts and showed how multiple Linux commands can be combined into a single pipeline to produce clean, useful output.

### Parameters

Instead of hardcoding the directory name, we can accept it as a parameter.

```bash
DIRECTORY="$1"
```

This means the first argument supplied when running the script becomes the directory to search.

Example:

```bash
./sortfiles.sh Arena
```

or

```bash
./sortfiles.sh Backup
```

Using parameters makes scripts much more reusable because the same script can work with any directory.

---

### Checking the Parameter

Before using the directory, we should check that the user actually supplied one.

```bash
if [ -z "$DIRECTORY" ]; then
    echo "No directory provided."
    exit 1
fi
```

`-z` checks whether the variable is empty.

If no directory is supplied, the script displays an error and exits.

---

### Checking the Directory Exists

```bash
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi
```

`-d` checks whether something is a directory.

`!` means "not".

So this reads as:

> If the directory does **not** exist, display an error and stop the script.

---

### Finding Files

```bash
find "$DIRECTORY" -type f -name "*.txt"
```

This command searches inside the chosen directory.

* `find` searches for files.
* `-type f` means only regular files.
* `-name "*.txt"` limits the search to `.txt` files.

Unlike `ls`, `find` also searches inside subdirectories.

---

### Using `-exec`

```bash
-exec ls -lh {} +
```

`-exec` tells `find` to execute another command on the files it finds.

In this case:

```bash
ls -lh
```

is run on every `.txt` file.

`{}` is simply a placeholder meaning:

> "The current file that `find` has found."

The `+` at the end tells `find` to pass multiple files to one `ls` command, making it more efficient than running `ls` once per file.

---

### Sorting by File Size

```bash
sort -k 5,5 -h
```

This sorts the output produced by `ls`.

* `-k 5,5` tells `sort` to use only column 5.
* Column 5 contains the file size.
* `-h` tells `sort` to correctly understand human-readable sizes such as `2K`, `18K` and `1M`.

Without `-h`, the sorting would be alphabetical instead of numerical.

---

### Using `awk`

```bash
awk '{ print $5, $9 }'
```

`awk` prints only the information we want.

* `$5` = file size
* `$9` = filename/path

These are **awk fields**, not Bash variables.

`awk` automatically splits each input line into numbered columns, so no variables need to be created beforehand.

---

### Pipes (`|`)

This level also reinforced the use of pipes.

Each command performs one job before passing its output to the next command.

```
find
   │
   ▼
ls -lh
   │
   ▼
sort
   │
   ▼
awk
```

This is a common pattern used throughout Linux and DevOps.

---

## Our Improved Solution

```bash
#!/bin/bash

DIRECTORY="$1"

if [ -z "$DIRECTORY" ]; then
    echo "No directory provided."
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

find "$DIRECTORY" -type f -name "*.txt" -exec ls -lh {} + | sort -k 5,5 -h | awk '{ print $5, $9 }'
```

---

## Comparison with the Exam Answer

### Exam Answer

```bash
#!/bin/bash

DIRECTORY="Arena"

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

find "$DIRECTORY" -type f -name "*.txt" -exec ls -lh {} + | sort -k 5,5 -h | awk '{ print $5, $9 }'
```

### Improvements We Made

The exam answer hardcodes the directory:

```bash
DIRECTORY="Arena"
```

This means the script only works with the `Arena` directory unless the script itself is edited.

Our version improves this by using a parameter:

```bash
DIRECTORY="$1"
```

This allows the user to choose the directory when running the script instead of modifying the code.

We also added a check to ensure the user actually provides a directory before continuing.

As a result, our version is more flexible, reusable and closer to how Bash scripts are commonly written in real DevOps environments.

Overall, we learnt how to combine `find`, `ls`, `sort` and `awk` into a pipeline, how `-exec` works with `find`, how `awk` fields differ from Bash variables, and how accepting parameters makes scripts far more reusable.

