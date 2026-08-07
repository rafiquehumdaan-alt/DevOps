# Linux Notes - Part 1: Terminal & Basic Commands

> Covers:
>
> - What is the Terminal?
> - Ubuntu Terminal
> - Linux Commands
> - Manual Pages (`man`)
> - Basic Navigation (`ls`, `pwd`, `cd`)
> - File Viewing (`cat`)
> - Searching (`grep`)
> - Output (`echo`)
> - Creating Files
> - Programs & Binaries

---

# What is the Terminal?

The **Terminal** (also called the Command Line Interface or CLI) is a text-based interface used to interact with the operating system.

Instead of clicking icons, you type commands to perform tasks.

Example:

```bash
ls
```

The terminal executes the command and displays the result.

---

# Why Learn the Terminal?

The terminal is widely used by:

- Linux System Administrators
- DevOps Engineers
- Cloud Engineers
- Software Developers

Benefits:

- Faster than graphical interfaces
- Easy to automate tasks
- Required for remote servers
- Powerful scripting capabilities

---

# Ubuntu Terminal

Ubuntu includes a built-in terminal.

Open it using:

```
Ctrl + Alt + T
```

or search for **Terminal** in the applications menu.

---

# What is a Command?

A command is an instruction given to the operating system.

Example:

```bash
pwd
```

The operating system runs the corresponding program and returns the output.

General syntax:

```bash
command [options] [arguments]
```

Example:

```bash
ls -l /home
```

- `ls` → command
- `-l` → option
- `/home` → argument

---

# Manual Pages (`man`)

Linux includes built-in documentation for most commands.

Syntax:

```bash
man command
```

Example:

```bash
man ls
```

This opens the manual page for `ls`.

Useful controls:

- **Space** → Next page
- **b** → Previous page
- **/** → Search
- **q** → Quit

---

# Getting Quick Help

Many commands also support:

```bash
command --help
```

Example:

```bash
ls --help
```

Useful for a quick overview of available options.

---

# Present Working Directory (`pwd`)

Displays your current location in the file system.

Example:

```bash
pwd
```

Output:

```text
/home/humdaan
```

---

# Listing Files (`ls`)

Displays the contents of the current directory.

Example:

```bash
ls
```

---

## Useful `ls` Options

Long listing:

```bash
ls -l
```

Shows:

- Permissions
- Owner
- File size
- Date
- Filename

---

Show hidden files:

```bash
ls -a
```

Hidden files begin with a dot (`.`).

Example:

```text
.bashrc
.gitignore
```

---

Combine options:

```bash
ls -la
```

Shows all files in long format.

---

# Changing Directories (`cd`)

Move between directories.

Example:

```bash
cd Documents
```

Go to the home directory:

```bash
cd
```

Go up one level:

```bash
cd ..
```

Go to the previous directory:

```bash
cd -
```

Go to the root directory:

```bash
cd /
```

---

# Directory Navigation Example

```text
/home/humdaan

↓

cd projects

↓

/home/humdaan/projects

↓

cd ..

↓

/home/humdaan
```

---

# Echo

The `echo` command prints text to the terminal.

Example:

```bash
echo "Hello Linux"
```

Output:

```text
Hello Linux
```

---

# Display Variables

```bash
echo $HOME
```

Example output:

```text
/home/humdaan
```

---

# Creating Files with `echo`

```bash
echo "Hello World" > notes.txt
```

Creates:

```text
notes.txt
```

with the specified content.

---

# Viewing Files (`cat`)

Display the contents of a file.

Example:

```bash
cat notes.txt
```

Output:

```text
Hello World
```

---

# Creating Empty Files (`touch`)

Create an empty file:

```bash
touch notes.txt
```

If the file already exists, `touch` updates its timestamp.

---

# Searching with `grep`

`grep` searches for text inside files.

Example:

```bash
grep "error" logfile.txt
```

Displays only lines containing:

```text
error
```

---

# grep Example

File:

```text
Login successful
Login failed
Server started
```

Command:

```bash
grep "Login" logfile.txt
```

Output:

```text
Login successful
Login failed
```

---

# Programs vs Commands

When you type:

```bash
ls
```

you are actually running a **program**.

Linux searches for the executable using the `PATH` environment variable.

Commands are simply programs that the shell can locate and execute.

---

# What is a Binary?

A binary is an executable program compiled into machine code.

Example:

```bash
/bin/ls
```

is the binary that runs when you type:

```bash
ls
```

You can locate a command using:

```bash
which ls
```

Example output:

```text
/bin/ls
```

---

# Common Commands

| Command | Purpose |
|----------|----------|
| `pwd` | Show current directory |
| `ls` | List files |
| `ls -l` | Long listing |
| `ls -a` | Show hidden files |
| `cd` | Change directory |
| `echo` | Display text |
| `touch` | Create an empty file |
| `cat` | Display file contents |
| `grep` | Search text |
| `man` | View manual pages |
| `which` | Locate a command |

---

# Common Mistakes

### Forgetting Spaces

Incorrect:

```bash
cd..
```

Correct:

```bash
cd ..
```

---

### Using the Wrong Directory

Always check your current location before creating or deleting files:

```bash
pwd
```

---

### Overwriting Files

This command:

```bash
echo "Hello" > notes.txt
```

overwrites the file.

Use:

```bash
echo "Hello" >> notes.txt
```

to append instead.

---

# Best Practices

- Use `pwd` regularly to confirm your location.
- Learn `ls -la`—it's one of the most useful Linux commands.
- Use `man` whenever you're unsure about a command.
- Prefer `grep` over manually searching through files.
- Understand what a command does before running it.

---

# Key Takeaways

- The terminal is a text-based interface for interacting with Linux.
- Commands execute programs installed on the system.
- `pwd` shows your current directory.
- `ls` lists files and directories.
- `cd` changes directories.
- `echo` displays text or writes to files.
- `cat` displays file contents.
- `grep` searches text.
- `man` provides built-in documentation.
- `which` shows the location of an executable.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `pwd` | Current directory |
| `ls` | List files |
| `ls -la` | Long listing with hidden files |
| `cd` | Change directory |
| `cd ..` | Move up one directory |
| `cd -` | Previous directory |
| `echo` | Print text |
| `touch` | Create empty file |
| `cat` | View file |
| `grep` | Search text |
| `man` | Manual pages |
| `which` | Find executable |

---

# Interview Questions

### What is the Linux Terminal?

The Terminal is a command-line interface (CLI) that allows users to interact with the operating system by entering text commands.

### What is the difference between `pwd` and `ls`?

`pwd` displays the current working directory, while `ls` lists the files and directories within the current location.

### What does `grep` do?

`grep` searches files or command output for lines containing a specified pattern or text.

### How do you view the manual for a command?

Use:

```bash
man <command>
```

For example:

```bash
man ls
```

### What is the purpose of the `which` command?

It displays the location of the executable that will run when you type a command.