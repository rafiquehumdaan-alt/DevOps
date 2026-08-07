# Level 8: Multi-File Searcher

## Mission

Create a Bash script that searches for a specific word or phrase across all `.log` files in a directory and outputs the names of the files that contain the word or phrase.

---

# What I Learned

## 1. Using Multiple Parameters

This script introduced using **multiple command-line parameters**.

```bash
./search.sh Error Arena
```

- `$1` = Search term (`Error`)
- `$2` = Directory (`Arena`)

To make the script easier to read, I stored these in variables:

```bash
SEARCH_TERM="$1"
DIRECTORY="$2"
```

This is much clearer than repeatedly writing `$1` and `$2`.

---

## 2. Validating User Input

Before doing any work, the script checks that the user has provided everything required.

### Check that a search term was provided

```bash
if [ -z "$SEARCH_TERM" ]; then
    echo "Search term is required."
    exit 1
fi
```

`-z` checks whether a variable is empty.

If no search term is supplied, the script prints an error and stops.

---

### Check that a directory was provided

```bash
if [ -z "$DIRECTORY" ]; then
    echo "Directory is required."
    exit 1
fi
```

Again, the script stops immediately if the user forgets to provide the directory.

---

### Check that the directory exists

```bash
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi
```

`-d` checks whether something is a directory.

`!` means "NOT".

So this reads as:

> If this is NOT a directory, print an error and stop.

---

# Searching the Log Files

The main search command is:

```bash
grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log
```

Breaking it down:

- `grep` → searches text
- `-l` → only outputs filenames containing a match
- `"$SEARCH_TERM"` → the word or phrase to search for
- `"$DIRECTORY"/*.log` → every `.log` file inside the chosen directory

For example:

```text
Arena/
├── server.log
├── app.log
├── backup.log
```

Running:

```bash
./search.sh Error Arena
```

might output:

```text
Arena/server.log
Arena/app.log
```

---

# Why We Use `*.log`

This part confused me at first.

```bash
"$DIRECTORY"/*.log
```

Suppose:

```bash
DIRECTORY="Arena"
```

Bash expands:

```bash
"$DIRECTORY"/*.log
```

into

```text
Arena/server.log
Arena/app.log
Arena/backup.log
```

Without `/*.log`, Bash would only pass the directory itself to `grep`, which isn't what we want.

---

# Improving the Script

A more professional version stores the search results in a variable.

```bash
RESULTS=$(grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log)
```

This is called **command substitution**.

Instead of assigning fixed text to a variable, Bash:

1. Runs the command
2. Captures the output
3. Stores that output inside the variable

Example:

```bash
FILES=$(ls)
```

If `ls` outputs:

```text
README.md
script.sh
notes.md
```

Then:

```bash
FILES
```

contains those filenames.

The same idea applies to:

```bash
RESULTS=$(grep -l ...)
```

---

# Handling No Matches

Once the results are stored, the script can check whether anything was found.

```bash
if [ -z "$RESULTS" ]; then
    echo "No matching log files found."
else
    echo "$RESULTS"
fi
```

This is much friendlier than simply printing nothing.

---

# My Final Script

```bash
#!/bin/bash

SEARCH_TERM="$1"
DIRECTORY="$2"

if [ -z "$SEARCH_TERM" ]; then
    echo "Search term is required."
    exit 1
fi

if [ -z "$DIRECTORY" ]; then
    echo "Directory is required."
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

RESULTS=$(grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log)

if [ -z "$RESULTS" ]; then
    echo "No matching log files found."
else
    echo "Files containing '$SEARCH_TERM':"
    echo "$RESULTS"
fi
```

---

# Exam Solution

```bash
#!/bin/bash

DIRECTORY="Arena"
SEARCH_TERM="Error"

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist."
    exit 1
fi

grep -l "$SEARCH_TERM" "$DIRECTORY"/*.log
```

---

# What We Improved

## 1. Parameters Instead of Hardcoded Values

The exam solution hardcodes:

```bash
DIRECTORY="Arena"
SEARCH_TERM="Error"
```

To search another directory or another word, the script has to be edited.

Our version accepts parameters:

```bash
./search.sh Error Arena
```

or

```bash
./search.sh Warning Logs
```

The same script can be reused without modification.

---

## 2. Better Validation

Our script checks:

- Search term provided
- Directory provided
- Directory exists

The exam solution only checks whether the directory exists.

---

## 3. Better User Experience

If no matching files exist, the exam solution prints nothing.

Our script clearly tells the user:

```text
No matching log files found.
```

---

## 4. Clearer Output

Instead of only printing:

```text
Arena/server.log
Arena/app.log
```

our script prints:

```text
Files containing 'Error':
Arena/server.log
Arena/app.log
```

This makes it obvious what the results represent.

---

# Key Commands Learned

| Command | Purpose |
|----------|---------|
| `grep` | Search text inside files |
| `grep -l` | Print only filenames containing matches |
| `-z` | Check if a variable is empty |
| `-d` | Check if a directory exists |
| `!` | NOT operator |
| `exit 1` | Stop the script because of an error |
| `*.log` | Match every `.log` file |
| `$(command)` | Run a command and store its output in a variable (command substitution) |

---

# Key Takeaways

- Use parameters instead of hardcoding values whenever possible.
- Validate all user input before running commands.
- Store parameters in descriptive variables to improve readability.
- `grep -l` is useful when you only need filenames.
- `*.log` tells Bash to search every log file in a directory.
- Command substitution (`$(...)`) lets a variable store the output of another command.
- Adding helpful error messages makes scripts much more user-friendly.
- Writing reusable, well-validated scripts is a good habit for real-world DevOps work.
