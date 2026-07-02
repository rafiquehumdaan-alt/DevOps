# Bash Challenge 3 – File Checker with Permissions

## Mission

Create a Bash script that:

* Prompts the user for a filename.
* Checks whether the file exists.
* If it exists, checks whether it is:

  * Readable
  * Writable
  * Executable
* Displays an appropriate message for each permission.

---

# Commands & Concepts Learned

## `read -rp`

Reads user input into a variable while displaying a prompt.

**Syntax:**

```bash
read -rp "Prompt message: " variable
```

**Example:**

```bash
read -rp "Please provide a filename: " filename
```

If the user enters:

```text
demo.txt
```

The variable `filename` now contains:

```text
demo.txt
```

### What do the options mean?

* `-r` → Reads the input literally. It prevents Bash from treating backslashes (`\`) as escape characters. This is considered best practice.
* `-p` → Displays the prompt before waiting for input, so you don't need a separate `echo`.

Instead of:

```bash
echo "Please provide a filename:"
read filename
```

you can simply write:

```bash
read -rp "Please provide a filename: " filename
```

---

# File Test Operators

Bash has built-in tests that allow scripts to check files.

## `-f`

Checks whether a regular file exists.

```bash
if [ -f "$filename" ]; then
```

Returns **true** only if the file exists and is not a directory.

---

## `!`

Means **NOT**.

Example:

```bash
if [ ! -f "$filename" ]; then
```

Reads as:

> If the file does **not** exist...

---

## `-r`

Checks whether the file is readable.

```bash
if [ -r "$filename" ]; then
```

---

## `-w`

Checks whether the file is writable.

```bash
if [ -w "$filename" ]; then
```

---

## `-x`

Checks whether the file is executable.

```bash
if [ -x "$filename" ]; then
```

---

# Why Use Quotes Around Variables?

Always write:

```bash
"$filename"
```

instead of:

```bash
$filename
```

This prevents errors if the filename contains spaces.

Example:

```text
My Notes.txt
```

Without quotes, Bash would think there are two separate filenames:

```text
My
Notes.txt
```

With quotes, Bash correctly treats it as one filename.

---

# Nested If Statements

Once we know the file exists, we can perform more checks inside the same `else` block.

Example:

```bash
if [ ! -f "$filename" ]; then
    echo "File not found."
else
    # Additional permission checks here
fi
```

This avoids checking if the file exists multiple times.

---

# Final Script

```bash
#!/bin/bash

read -rp "Please provide a filename: " filename

if [ ! -f "$filename" ]; then
    echo "File '$filename' not found."
else
    echo "File '$filename' exists."

    if [ -r "$filename" ]; then
        echo "The file is readable."
    else
        echo "The file is not readable."
    fi

    if [ -w "$filename" ]; then
        echo "The file is writable."
    else
        echo "The file is not writable."
    fi

    if [ -x "$filename" ]; then
        echo "The file is executable."
    else
        echo "The file is not executable."
    fi
fi
```

---

# Example Output

If the file exists:

```text
Please provide a filename: demo.txt

File 'demo.txt' exists.
The file is readable.
The file is writable.
The file is not executable.
```

If the file does not exist:

```text
Please provide a filename: notes.txt

File 'notes.txt' not found.
```

---

# What I Learned

* How to prompt the user for input using `read -rp`.
* How to store user input inside a variable.
* How to check if a file exists using `-f`.
* How to check file permissions using:

  * `-r` (readable)
  * `-w` (writable)
  * `-x` (executable)
* How the `!` operator reverses a condition.
* Why variables should be enclosed in quotes.
* How to use nested `if` statements to avoid repeating checks.

---

# Improvements We Made

### 1. Avoided checking the file twice

Instead of writing:

```bash
if [ ! -f "$filename" ]; then
    ...
fi

if [ -f "$filename" ]; then
    ...
fi
```

we performed the permission checks inside the existing `else` block.

This makes the script cleaner and avoids unnecessary work.

---

### 2. Displayed the filename in the output

Instead of:

```bash
File found.
```

we improved it to:

```bash
File '$filename' exists.
```

This gives clearer feedback to the user, especially when checking multiple files.

---

### 3. Used `read -rp`

Rather than using:

```bash
echo "Please provide a filename:"
read filename
```

we combined both commands into:

```bash
read -rp "Please provide a filename: " filename
```

This is shorter, cleaner, and commonly used in professional Bash scripts.

