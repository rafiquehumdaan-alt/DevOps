# Bash Notes - Part 6: Piping, Error Handling & Exit Codes

> Covers:
>
> - Pipes (`|`)
> - Redirection (`>`, `>>`, `<`)
> - Error Redirection (`2>`, `2>>`, `2>&1`)
> - Exit Codes
> - Error Handling
> - `set -e`
> - `set -u`
> - `set -x`
> - `set -eux`
> - Other Useful `set` Commands

---

# What is a Pipe?

A **pipe (`|`)** sends the output of one command directly into another command.

Instead of saving output to a file, it is passed straight to the next command.

Syntax:

```bash
command1 | command2
```

---

# Pipe Example

```bash
ls | wc -l
```

Explanation:

```text
ls

↓

List Files

↓

wc -l

↓

Count Files
```

Output:

```
15
```

---

# Another Example

```bash
cat users.txt | grep Humdaan
```

Flow:

```text
users.txt

↓

cat

↓

grep

↓

Matching Lines
```

Only lines containing **Humdaan** are displayed.

---

# Output Redirection

`>` writes output to a file.

Example:

```bash
echo "Hello" > notes.txt
```

Contents of `notes.txt`:

```
Hello
```

If the file already exists, it is **overwritten**.

---

# Append Redirection

`>>` appends to an existing file.

Example:

```bash
echo "Second Line" >> notes.txt
```

File now contains:

```
Hello
Second Line
```

---

# Input Redirection

`<` sends the contents of a file as input to a command.

Example:

```bash
wc -l < notes.txt
```

Counts the number of lines in the file.

---

# Standard Streams

Linux uses three standard streams.

| Stream | Number | Purpose |
|---------|---------|----------|
| stdin | 0 | Input |
| stdout | 1 | Normal output |
| stderr | 2 | Error output |

---

# Redirecting Errors

Redirect only error messages:

```bash
ls missing.txt 2> errors.txt
```

Normal output appears on the screen.

Errors are written to:

```
errors.txt
```

---

# Append Errors

```bash
command 2>> errors.txt
```

Errors are added to the end of the file.

---

# Redirect Output and Errors Together

```bash
command > output.txt 2>&1
```

Explanation:

```text
stdout

↓

output.txt

stderr

↓

output.txt
```

Both normal output and errors are stored in the same file.

---

# Exit Codes

Every Linux command returns an **exit code**.

Exit codes indicate whether the command succeeded or failed.

| Exit Code | Meaning |
|-----------|----------|
| 0 | Success |
| Non-zero | Failure |

---

# Checking Exit Codes

Use:

```bash
echo $?
```

Example:

```bash
mkdir test

echo $?
```

Output:

```
0
```

Successful command.

---

Example:

```bash
cat missing.txt

echo $?
```

Output:

```
1
```

The command failed because the file does not exist.

---

# Error Handling

Scripts should check whether important commands succeed before continuing.

Example:

```bash
mkdir backup

if [ $? -eq 0 ]
then
    echo "Backup created."
else
    echo "Failed."
fi
```

---

# Better Error Handling

Instead of checking `$?`, it's cleaner to test the command directly.

Example:

```bash
if mkdir backup
then
    echo "Success"
else
    echo "Failed"
fi
```

This is the preferred approach.

---

# set -e

```bash
set -e
```

Meaning:

Exit the script immediately if **any command fails**.

Example:

```bash
set -e

mkdir backup

cp missing.txt backup

echo "Finished"
```

If `cp` fails, the script stops immediately.

---

# Why Use `set -e`?

Without:

```text
Command Fails

↓

Script Continues

↓

More Problems
```

With:

```text
Command Fails

↓

Script Stops Immediately
```

---

# set -u

```bash
set -u
```

Treat **undefined variables** as errors.

Example:

```bash
set -u

echo "$username"
```

If `username` doesn't exist, Bash reports an error instead of silently using an empty value.

---

# set -x

```bash
set -x
```

Debug mode.

Every command is printed before execution.

Example:

```bash
set -x

echo "Hello"
```

Output:

```text
+ echo Hello

Hello
```

Useful when troubleshooting scripts.

---

# set -eux

Many production Bash scripts start with:

```bash
set -eux
```

This enables:

- `-e` → Exit on errors
- `-u` → Undefined variables become errors
- `-x` → Print commands while executing

A very common DevOps practice.

---

# Other Useful `set` Commands

| Command | Purpose |
|----------|----------|
| `set +x` | Disable debug mode |
| `set +e` | Disable exit-on-error |
| `set +u` | Allow undefined variables again |
| `set -o pipefail` | Fail a pipeline if **any** command fails |

---

# Why Use `pipefail`?

Without:

```bash
false | true
```

Pipeline returns success because the last command succeeded.

With:

```bash
set -o pipefail
```

The pipeline correctly reports failure.

Very useful in CI/CD scripts.

---

# Real Example

```bash
#!/bin/bash

set -eux

mkdir backup

cp notes.txt backup/

echo "Backup completed."
```

If any command fails, the script exits immediately and displays the failing command.

---

# Common Mistakes

### Ignoring Exit Codes

Bad:

```bash
cp important.txt backup/
```

Always consider what happens if the command fails.

---

### Overwriting Files Accidentally

```bash
>
```

overwrites a file.

If you want to keep existing content, use:

```bash
>>
```

---

### Forgetting Quotes

Always quote variables when possible.

Good:

```bash
cp "$file" backup/
```

---

# Best Practices

- Use pipes to combine commands efficiently.
- Use `>>` when you want to append to a file.
- Redirect errors separately when debugging.
- Start important scripts with:

```bash
set -euo pipefail
```

> Many production scripts use `set -euo pipefail` instead of `set -eux`. You can temporarily add `-x` while debugging.

- Check for failures before continuing.
- Log important errors to files.

---

# Key Takeaways

- Pipes send output from one command to another.
- `>` overwrites files.
- `>>` appends to files.
- `2>` redirects error messages.
- Exit code `0` means success.
- Non-zero exit codes indicate failure.
- `set -e` stops on errors.
- `set -u` prevents undefined variables.
- `set -x` prints commands for debugging.
- `pipefail` improves error detection in pipelines.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `|` | Pipe output |
| `>` | Overwrite file |
| `>>` | Append to file |
| `<` | Input redirection |
| `2>` | Redirect errors |
| `2>&1` | Combine output & errors |
| `$?` | Previous exit code |
| `set -e` | Exit on error |
| `set -u` | Undefined variables are errors |
| `set -x` | Debug mode |
| `set -o pipefail` | Pipeline fails if any command fails |

---

# Interview Questions

### What is a pipe in Bash?

A pipe (`|`) passes the output of one command directly as the input to another command.

### What is the difference between `>` and `>>`?

`>` overwrites a file, while `>>` appends to the end of a file.

### What does an exit code of `0` mean?

The command completed successfully.

### Why is `set -e` useful?

It stops a script immediately when a command fails, preventing later commands from running with unexpected state.

### What does `set -x` do?

It enables debug mode by printing each command before it is executed.

### Why is `set -o pipefail` recommended?

It ensures a pipeline reports failure if **any** command in the pipeline fails, not just the last one.