# Bash Notes - Part 7: Environment Variables & PATH

> Covers:
>
> - Environment Variables
> - Reading Environment Variables
> - Common Environment Variables
> - PATH
> - Changing PATH Permanently
> - Exporting Variables
> - Best Practices

---

# What are Environment Variables?

Environment Variables are special variables stored by the operating system.

They provide information that programs and scripts can use while running.

Examples include:

- Current user
- Home directory
- Default shell
- Search path for commands

Unlike normal variables, environment variables are inherited by child processes.

---

# Normal Variables vs Environment Variables

| Normal Variable | Environment Variable |
|-----------------|----------------------|
| Exists only in current shell | Available to child processes |
| Not shared automatically | Shared with programs and scripts |
| Created with `name=value` | Exported using `export` |

---

# Viewing Environment Variables

Display one variable:

```bash
echo $HOME
```

Example output:

```text
/home/humdaan
```

---

Display all environment variables:

```bash
printenv
```

or

```bash
env
```

---

# Common Environment Variables

| Variable | Description |
|----------|-------------|
| `$HOME` | User's home directory |
| `$USER` | Current username |
| `$PATH` | Directories searched for commands |
| `$PWD` | Current working directory |
| `$OLDPWD` | Previous working directory |
| `$SHELL` | Current shell |
| `$HOSTNAME` | Computer name |
| `$TERM` | Terminal type |

---

# HOME

Displays your home directory.

Example:

```bash
echo $HOME
```

Output:

```text
/home/humdaan
```

Useful for creating files in your home folder.

---

# USER

Displays the current logged-in user.

```bash
echo $USER
```

Example output:

```text
humdaan
```

---

# PWD

Shows the current working directory.

```bash
echo $PWD
```

Example:

```text
/home/humdaan/projects
```

---

# SHELL

Shows the current shell.

```bash
echo $SHELL
```

Example:

```text
/bin/bash
```

---

# What is PATH?

`PATH` is one of the most important environment variables.

It tells Linux where to look for executable programs.

Example:

```bash
echo $PATH
```

Output:

```text
/usr/local/bin:/usr/bin:/bin
```

Each directory is separated by a colon (`:`).

---

# How PATH Works

When you run:

```bash
ls
```

Linux searches each directory in `$PATH` until it finds the `ls` executable.

```text
PATH

↓

/usr/local/bin

↓

/usr/bin

↓

/bin

↓

Found: ls
```

---

# Why PATH Matters

Without PATH, you would need to type the full path to every command.

Instead of:

```bash
ls
```

You would need:

```bash
/bin/ls
```

PATH makes command execution much easier.

---

# Viewing PATH

Display PATH:

```bash
echo $PATH
```

Each directory is searched from left to right.

If two programs have the same name, the first one found in PATH is used.

---

# Adding a Directory to PATH (Temporary)

Example:

```bash
export PATH=$PATH:/home/humdaan/scripts
```

Your scripts can now be run from anywhere.

Example:

Instead of:

```bash
./backup.sh
```

You can simply type:

```bash
backup.sh
```

This change only lasts for the current shell session.

---

# Making PATH Permanent

To keep the change after restarting the terminal, add it to your shell configuration file.

For Bash:

```bash
nano ~/.bashrc
```

Add:

```bash
export PATH="$PATH:/home/humdaan/scripts"
```

Save the file and reload it:

```bash
source ~/.bashrc
```

Now the PATH change is permanent.

---

# Creating Environment Variables

Temporary variable:

```bash
project="DevOps"
```

Only available in the current shell.

---

Exported variable:

```bash
export PROJECT="DevOps"
```

Now child processes can access it.

Example:

```bash
echo $PROJECT
```

Output:

```text
DevOps
```

---

# Unsetting Variables

Remove a variable:

```bash
unset PROJECT
```

The variable no longer exists.

---

# Real Example

```bash
#!/bin/bash

echo "Current User: $USER"
echo "Home Directory: $HOME"
echo "Current Directory: $PWD"
echo "Current Shell: $SHELL"
```

Example output:

```text
Current User: humdaan
Home Directory: /home/humdaan
Current Directory: /home/humdaan/projects
Current Shell: /bin/bash
```

---

# Common Mistakes

### Forgetting `export`

Incorrect:

```bash
MY_VAR="Hello"
```

Other programs cannot access it.

Correct:

```bash
export MY_VAR="Hello"
```

---

### Overwriting PATH

Incorrect:

```bash
export PATH=/home/humdaan/scripts
```

This removes all standard directories.

Correct:

```bash
export PATH="$PATH:/home/humdaan/scripts"
```

Always append or prepend to the existing PATH.

---

### Forgetting to Reload `.bashrc`

After editing:

```bash
~/.bashrc
```

Run:

```bash
source ~/.bashrc
```

Otherwise the changes won't take effect until you open a new terminal.

---

# Best Practices

- Never overwrite PATH completely.
- Use `export` for variables that child processes need.
- Store permanent PATH changes in `~/.bashrc`.
- Use meaningful variable names.
- Check PATH if a command cannot be found.

---

# Key Takeaways

- Environment variables store information used by the shell and programs.
- `printenv` and `env` display environment variables.
- `$PATH` tells Linux where to find executable commands.
- Use `export` to make variables available to child processes.
- Add custom script directories to PATH for easier command execution.
- Store permanent PATH changes in `~/.bashrc`.

---

# Quick Revision

| Variable | Purpose |
|----------|---------|
| `$HOME` | Home directory |
| `$USER` | Current user |
| `$PWD` | Current directory |
| `$OLDPWD` | Previous directory |
| `$SHELL` | Current shell |
| `$PATH` | Search path for executables |
| `printenv` | Display environment variables |
| `export` | Create environment variable |
| `unset` | Remove variable |
| `source ~/.bashrc` | Reload Bash configuration |

---

# Interview Questions

### What is an environment variable?

A variable provided by the operating system that stores configuration or system information and can be accessed by programs and scripts.

### What is the purpose of the PATH variable?

PATH tells Linux which directories to search when executing a command.

### Why do you use `export`?

To make a variable available to child processes and other programs launched from the current shell.

### How do you permanently add a directory to PATH?

Add an `export PATH="$PATH:/your/directory"` line to `~/.bashrc` and reload it using `source ~/.bashrc`.

### What command displays all environment variables?

Either:

```bash
printenv
```

or

```bash
env
```