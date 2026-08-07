# Linux Notes - Part 3: Linux File System

> Covers:
>
> - Linux File System
> - Directory Structure
> - Important System Directories
> - Absolute vs Relative Paths
> - `touch`
> - `echo`
> - `cat`
> - `head`
> - `tail`

---

# What is the Linux File System?

Linux stores everything in a single directory tree.

Unlike Windows, there are **no drive letters** such as `C:` or `D:`.

Everything begins at the **root directory**:

```text
/
```

Every file and directory exists somewhere beneath this root.

---

# Linux File System Structure

```text
/

├── bin
├── boot
├── dev
├── etc
├── home
├── lib
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin
├── srv
├── sys
├── tmp
├── usr
└── var
```

Each directory has a specific purpose.

---

# Important Directories

## `/`

The **root directory**.

This is the top of the Linux file system.

Everything starts here.

---

## `/home`

Contains user home directories.

Example:

```text
/home/humdaan
```

This is where users normally store their files and projects.

---

## `/root`

The home directory for the **root user**.

Do not confuse:

```text
/
```

with

```text
/root
```

They are different.

---

## `/etc`

Stores system configuration files.

Examples:

- Network configuration
- User configuration
- Service configuration

System administrators often work in this directory.

---

## `/bin`

Contains essential user commands.

Examples:

```text
ls

cp

mv

cat
```

These commands are available even in recovery mode.

---

## `/usr`

Contains user applications and libraries.

Examples:

- Installed software
- Documentation
- Libraries

Most applications are stored somewhere under `/usr`.

---

## `/var`

Stores files that change frequently.

Examples:

- Logs
- Databases
- Mail
- Cache

Example log directory:

```text
/var/log
```

---

## `/tmp`

Temporary files.

Linux may automatically delete files here after a reboot.

Useful for:

- Temporary downloads
- Testing
- Scratch files

---

## `/dev`

Contains device files.

Examples:

```text
/dev/sda

/dev/null

/dev/random
```

In Linux, hardware devices are represented as files.

---

## `/proc`

A virtual file system containing information about the running system.

Useful for viewing:

- Processes
- CPU information
- Memory usage

---

# Absolute vs Relative Paths

## Absolute Path

Starts from the root directory.

Example:

```text
/home/humdaan/projects
```

Always begins with:

```text
/
```

---

## Relative Path

Starts from your current directory.

Example:

```text
projects
```

or

```text
../Documents
```

Relative paths are shorter but depend on your current location.

---

# Checking Your Current Directory

```bash
pwd
```

Example output:

```text
/home/humdaan
```

---

# Creating Files with `touch`

Create an empty file:

```bash
touch notes.txt
```

Create multiple files:

```bash
touch file1.txt file2.txt file3.txt
```

If a file already exists, `touch` updates its timestamp.

---

# Creating Files with `echo`

Create a file with content:

```bash
echo "Hello Linux" > notes.txt
```

Append content:

```bash
echo "Second Line" >> notes.txt
```

---

# Viewing Files with `cat`

Display a file:

```bash
cat notes.txt
```

Output:

```text
Hello Linux
Second Line
```

Display multiple files:

```bash
cat file1.txt file2.txt
```

---

# Viewing the Start of a File

Use:

```bash
head notes.txt
```

Displays the first 10 lines.

Specify a different number:

```bash
head -5 notes.txt
```

---

# Viewing the End of a File

Use:

```bash
tail notes.txt
```

Displays the last 10 lines.

Specify a different number:

```bash
tail -20 logfile.log
```

---

# Monitoring Log Files

Follow a file as new lines are added:

```bash
tail -f logfile.log
```

Useful for:

- Web server logs
- Application logs
- System logs

Press:

```
Ctrl + C
```

to stop following the file.

---

# Example Workflow

```text
touch notes.txt

↓

echo "Linux" > notes.txt

↓

cat notes.txt

↓

head notes.txt

↓

tail notes.txt
```

---

# Common Mistakes

### Confusing `/` and `/root`

`/`

is the root of the file system.

`/root`

is the home directory of the root user.

---

### Overwriting Files

This command:

```bash
echo "Hello" > notes.txt
```

replaces all existing content.

To keep existing content:

```bash
echo "Hello" >> notes.txt
```

---

### Using Relative Paths Incorrectly

If you're unsure where you are, check first:

```bash
pwd
```

---

# Best Practices

- Store personal files in your home directory.
- Use absolute paths in scripts when reliability is important.
- Use `head` and `tail` instead of `cat` for very large files.
- Keep temporary files in `/tmp`.
- Learn the purpose of common Linux directories.

---

# Key Takeaways

- Linux uses a single directory tree starting at `/`.
- `/home` stores user files.
- `/etc` stores configuration files.
- `/var` stores logs and changing data.
- `/tmp` stores temporary files.
- Absolute paths start from `/`.
- Relative paths depend on the current directory.
- `touch` creates empty files.
- `echo` writes text to files.
- `cat`, `head` and `tail` display file contents.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `pwd` | Show current directory |
| `touch` | Create an empty file |
| `echo >` | Create or overwrite a file |
| `echo >>` | Append to a file |
| `cat` | Display a file |
| `head` | Show first lines |
| `tail` | Show last lines |
| `tail -f` | Monitor a file live |

---

# Important Directories

| Directory | Purpose |
|-----------|---------|
| `/` | Root of the file system |
| `/home` | User home directories |
| `/root` | Root user's home |
| `/etc` | Configuration files |
| `/bin` | Essential commands |
| `/usr` | Applications and libraries |
| `/var` | Logs and changing data |
| `/tmp` | Temporary files |
| `/dev` | Device files |
| `/proc` | System and process information |

---

# Interview Questions

### What is the Linux root directory?

The root directory (`/`) is the top-level directory of the Linux file system from which all other directories branch.

### What is the difference between an absolute and a relative path?

An absolute path starts from the root directory (`/`), while a relative path starts from the current working directory.

### What is the purpose of `/etc`?

`/etc` stores system-wide configuration files.

### What does the `touch` command do?

It creates an empty file or updates the timestamp of an existing file.

### When would you use `tail -f`?

To monitor a file, such as a log file, in real time as new content is added.