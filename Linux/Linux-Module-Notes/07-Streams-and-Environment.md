# Linux Notes - Part 7: Standard Streams, Environment Variables & Aliases

> Covers:
>
> - Standard Streams
> - Standard Input (stdin)
> - Standard Output (stdout)
> - Standard Error (stderr)
> - Redirection
> - Environment Variables
> - PATH
> - Aliases
> - Best Practices

---

# What are Standard Streams?

Every Linux program communicates using **three standard streams**.

These streams handle:

- Input
- Normal output
- Error messages

Understanding them is essential for shell scripting and automation.

---

# The Three Standard Streams

| Stream | Number | Purpose |
|---------|--------|---------|
| stdin | 0 | Standard Input |
| stdout | 1 | Standard Output |
| stderr | 2 | Standard Error |

---

# Standard Input (stdin)

**stdin** is where a program receives its input.

Usually, this is the keyboard.

Example:

```bash
cat
```

Anything you type is displayed back to you.

Stop with:

```text
Ctrl + D
```

---

# Standard Output (stdout)

**stdout** is the normal output produced by a program.

Example:

```bash
echo "Hello Linux"
```

Output:

```text
Hello Linux
```

By default, stdout is displayed in the terminal.

---

# Standard Error (stderr)

**stderr** is used for error messages.

Example:

```bash
cat missing.txt
```

Output:

```text
cat: missing.txt: No such file or directory
```

This message is sent to **stderr**, not stdout.

---

# Standard Streams Overview

```text
Keyboard

↓

stdin (0)

↓

Program

↓

stdout (1) ───► Terminal

↓

stderr (2) ───► Terminal
```

---

# Output Redirection

Redirect stdout into a file.

Example:

```bash
echo "Hello" > notes.txt
```

The output is written to:

```text
notes.txt
```

instead of the terminal.

---

# Append Output

Append instead of overwriting:

```bash
echo "Another Line" >> notes.txt
```

---

# Redirect Errors

Store errors in a file:

```bash
cat missing.txt 2> errors.txt
```

Normal output still appears on the terminal.

Only errors are redirected.

---

# Append Errors

```bash
command 2>> errors.txt
```

Appends errors rather than replacing the file.

---

# Redirect Both Output and Errors

```bash
command > output.txt 2>&1
```

Both stdout and stderr are stored in:

```text
output.txt
```

---

# Environment Variables

Environment variables store information used by Linux and applications.

Examples include:

- Username
- Home directory
- PATH
- Shell

Display one:

```bash
echo $HOME
```

Example output:

```text
/home/humdaan
```

---

# Viewing Environment Variables

Show all environment variables:

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
| `$HOME` | Home directory |
| `$USER` | Current username |
| `$PATH` | Search path for commands |
| `$PWD` | Current directory |
| `$OLDPWD` | Previous directory |
| `$SHELL` | Current shell |

---

# PATH

The `PATH` variable tells Linux where to look for executable programs.

Display it:

```bash
echo $PATH
```

Example:

```text
/usr/local/bin:/usr/bin:/bin
```

Each directory is separated by a colon (`:`).

---

# Why PATH is Important

When you type:

```bash
ls
```

Linux searches each directory in `$PATH` until it finds the executable.

Without PATH, you would need to type:

```bash
/bin/ls
```

every time.

---

# Temporary Environment Variables

Create a variable:

```bash
PROJECT="DevOps"
```

Display it:

```bash
echo $PROJECT
```

---

# Exporting Variables

To make a variable available to child processes:

```bash
export PROJECT="DevOps"
```

---

# Aliases

Aliases create shortcuts for frequently used commands.

Example:

```bash
alias ll="ls -la"
```

Now:

```bash
ll
```

runs:

```bash
ls -la
```

---

# Viewing Aliases

List all aliases:

```bash
alias
```

---

# Removing an Alias

```bash
unalias ll
```

The shortcut is removed for the current session.

---

# Permanent Aliases

Store aliases in:

Bash:

```text
~/.bashrc
```

ZSH:

```text
~/.zshrc
```

Example:

```bash
alias gs="git status"

alias dc="docker compose"

alias k="kubectl"
```

Reload:

```bash
source ~/.bashrc
```

or

```bash
source ~/.zshrc
```

---

# Example Workflow

```text
Run Command

↓

stdout

↓

Redirect to File

↓

Read File Later
```

---

# Common Mistakes

### Overwriting Files

```bash
>
```

overwrites existing content.

If you want to keep existing content, use:

```bash
>>
```

---

### Forgetting `export`

Without:

```bash
export
```

child processes cannot access the variable.

---

### Overusing Aliases

Aliases should simplify common commands.

Avoid creating too many obscure shortcuts that make your shell difficult to understand.

---

# Best Practices

- Learn the three standard streams.
- Redirect errors when troubleshooting scripts.
- Store useful aliases in your shell configuration.
- Use meaningful environment variable names.
- Understand the purpose of PATH before modifying it.

---

# Key Takeaways

- Linux programs use stdin, stdout and stderr.
- Output and errors can be redirected independently.
- Environment variables store system and application configuration.
- PATH tells Linux where to find executable programs.
- Aliases save time by creating command shortcuts.
- Shell configuration files allow permanent aliases and environment variables.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `>` | Redirect output |
| `>>` | Append output |
| `2>` | Redirect errors |
| `2>&1` | Redirect stdout and stderr |
| `printenv` | Show environment variables |
| `env` | Show environment variables |
| `echo $PATH` | Display PATH |
| `export` | Create environment variable |
| `alias` | Create shortcut |
| `unalias` | Remove shortcut |

---

# Interview Questions

### What are the three standard streams in Linux?

- stdin (Standard Input)
- stdout (Standard Output)
- stderr (Standard Error)

### What is the purpose of the PATH environment variable?

PATH tells Linux where to search for executable programs when a command is entered.

### What is the difference between `>` and `>>`?

`>` overwrites a file, while `>>` appends to the end of a file.

### Why do we use `export`?

`export` makes an environment variable available to child processes and applications launched from the current shell.

### What are aliases used for?

Aliases create shortcuts for commonly used commands, improving productivity and reducing typing.