# Level 4: File Manipulation

## Mission

Create a script that copies all `.txt` files from the `Arena` directory to a new directory called `Backup`.

## What I Learned

### `cp` (Copy)

The `cp` command is used to copy files or directories from one location to another.

**Syntax:**

```bash
cp source destination
```

**Example:**

```bash
cp file.txt Backup/
```

This copies `file.txt` into the `Backup` directory.

---

### Wildcards (`*`)

The `*` wildcard matches **any number of characters**.

**Example:**

```bash
Arena/*.txt
```

This means:

* Look inside the `Arena` directory.
* Match every file ending in `.txt`.

Examples it would match:

* `hero.txt`
* `notes.txt`
* `enemy.txt`

It would **not** match:

* `image.png`
* `script.sh`

---

### File Paths

When working with files in another directory, you must specify the path.

Instead of:

```bash
*.txt
```

use:

```bash
Arena/*.txt
```

because the `.txt` files are inside the `Arena` directory, not the current directory.

---

### Creating Directories

The `mkdir` command creates a new directory.

**Example:**

```bash
mkdir Backup
```

A more common option in scripts is:

```bash
mkdir -p Backup
```

The `-p` option:

* Creates the directory if it doesn't exist.
* Does nothing if it already exists (avoids an error).
* Can create nested directories if needed.

This makes scripts safe to run multiple times (idempotent).

---

## Final Script

```bash
#!/bin/bash

mkdir Backup
cp Arena/*.txt Backup/
```

---

## Key Takeaways

* `cp` copies files from a source to a destination.
* `*` is a wildcard that matches multiple filenames.
* `Arena/*.txt` means "all `.txt` files inside the `Arena` directory."
* Always use the correct file path when files are in another directory.
* `mkdir -p` is preferred in real-world Bash scripts because it prevents errors if the directory already exists.

