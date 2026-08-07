# Linux Notes - Part 4: File & Directory Management

> Covers:
>
> - Copying Files (`cp`)
> - Moving & Renaming Files (`mv`)
> - Deleting Files (`rm`)
> - Creating Directories (`mkdir`)
> - Removing Directories (`rmdir`, `rm -r`)
> - Handling Spaces in File Names
> - Wildcards
> - Best Practices

---

# File Management in Linux

Linux provides simple commands for managing files and directories.

The most commonly used are:

- `cp` → Copy
- `mv` → Move or rename
- `rm` → Remove
- `mkdir` → Create directories
- `rmdir` → Remove empty directories

These commands are used daily by Linux administrators and DevOps engineers.

---

# Copying Files (`cp`)

Copy a file:

```bash
cp file.txt backup.txt
```

Result:

```text
file.txt

↓

backup.txt
```

The original file remains unchanged.

---

# Copying to Another Directory

```bash
cp notes.txt Documents/
```

Copies `notes.txt` into the `Documents` directory.

---

# Copy Multiple Files

```bash
cp file1.txt file2.txt backup/
```

Both files are copied into the `backup` directory.

---

# Copy Entire Directories

Use the recursive option:

```bash
cp -r project backup/
```

The `-r` (recursive) flag copies the directory and all of its contents.

---

# Moving Files (`mv`)

Move a file:

```bash
mv notes.txt Documents/
```

The file is removed from its original location and placed in `Documents`.

---

# Renaming Files

Rename a file:

```bash
mv old.txt new.txt
```

The file contents remain the same; only the name changes.

---

# Renaming Directories

```bash
mv old-folder new-folder
```

Works exactly the same as renaming a file.

---

# Moving Multiple Files

```bash
mv *.txt Documents/
```

Moves every `.txt` file into the `Documents` directory.

---

# Deleting Files (`rm`)

Delete a file:

```bash
rm notes.txt
```

The file is permanently removed.

There is **no recycle bin** when using `rm`.

---

# Delete Multiple Files

```bash
rm file1.txt file2.txt
```

Deletes both files.

---

# Interactive Removal

Ask before deleting:

```bash
rm -i notes.txt
```

Example:

```text
Remove file?

y/n
```

Useful for preventing accidental deletions.

---

# Force Delete

```bash
rm -f notes.txt
```

Removes the file without asking for confirmation.

Use with caution.

---

# Creating Directories (`mkdir`)

Create one directory:

```bash
mkdir projects
```

---

Create multiple directories:

```bash
mkdir docs images backups
```

---

Create nested directories:

```bash
mkdir -p project/src/config
```

The `-p` option creates parent directories if they don't already exist.

---

# Removing Empty Directories (`rmdir`)

```bash
rmdir old-folder
```

Only works if the directory is empty.

---

# Removing Directories Recursively

Delete a directory and all of its contents:

```bash
rm -r project
```

Everything inside the directory is permanently removed.

---

# Force Recursive Removal

```bash
rm -rf project
```

Options:

- `-r` → Recursive
- `-f` → Force (no confirmation)

⚠️ This is one of the most dangerous Linux commands.

Always double-check the path before running it.

---

# Handling Spaces in File Names

Example file:

```text
My Notes.txt
```

Option 1 (quotes):

```bash
cat "My Notes.txt"
```

Option 2 (escape spaces):

```bash
cat My\ Notes.txt
```

Using quotes is generally easier and more readable.

---

# Wildcards

Wildcards match multiple files.

### All files

```bash
*
```

---

### All text files

```bash
*.txt
```

---

### All log files

```bash
*.log
```

---

### Example

Delete all log files:

```bash
rm *.log
```

Copy all text files:

```bash
cp *.txt backup/
```

---

# Example Workflow

```text
mkdir project

↓

touch notes.txt

↓

cp notes.txt project/

↓

mv notes.txt archive.txt

↓

rm archive.txt

↓

rmdir project
```

---

# Common Mistakes

### Using `rm -rf` Carelessly

Never run:

```bash
rm -rf /
```

This attempts to remove the entire filesystem and can destroy a Linux installation.

Always verify the path before using `rm -rf`.

---

### Forgetting `-r`

Incorrect:

```bash
cp project backup/
```

Directories require:

```bash
cp -r project backup/
```

---

### Spaces in File Names

Incorrect:

```bash
cat My Notes.txt
```

Correct:

```bash
cat "My Notes.txt"
```

or

```bash
cat My\ Notes.txt
```

---

# Best Practices

- Use `cp -r` when copying directories.
- Use `mkdir -p` for nested directories.
- Use `rm -i` if you're unsure about deleting a file.
- Be extremely careful with `rm -rf`.
- Quote file names containing spaces.
- Use wildcards carefully to avoid deleting unintended files.

---

# Key Takeaways

- `cp` copies files and directories.
- `mv` moves or renames files and directories.
- `rm` permanently deletes files.
- `mkdir` creates directories.
- `rmdir` removes empty directories.
- `rm -r` removes directories recursively.
- Quotes or escape characters are required for file names containing spaces.
- Wildcards allow commands to work on multiple files at once.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `cp` | Copy file |
| `cp -r` | Copy directory |
| `mv` | Move or rename |
| `rm` | Remove file |
| `rm -i` | Remove with confirmation |
| `rm -r` | Remove directory recursively |
| `rm -rf` | Force recursive removal |
| `mkdir` | Create directory |
| `mkdir -p` | Create nested directories |
| `rmdir` | Remove empty directory |

---

# Interview Questions

### What is the difference between `cp` and `mv`?

`cp` creates a copy of a file or directory, while `mv` moves it to a new location or renames it.

### What does `mkdir -p` do?

It creates nested directories and automatically creates any missing parent directories.

### What is the difference between `rmdir` and `rm -r`?

`rmdir` only removes empty directories, whereas `rm -r` removes a directory and all of its contents.

### Why is `rm -rf` considered dangerous?

It permanently deletes directories and files without asking for confirmation, making accidental data loss much more likely.

### How do you work with file names containing spaces?

Either wrap the file name in quotation marks or escape the spaces using a backslash (`\`).