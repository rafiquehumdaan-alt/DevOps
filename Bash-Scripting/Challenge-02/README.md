# Bash Challenge 2 – File Operations Script

## Mission

Create a Bash script that automates creating a directory and a file, writes text containing the current date into the file, and then displays the file's contents.

---

# Commands Learned

## `mkdir`

Creates a new directory.

**Syntax:**

```bash
mkdir directory_name
```

**Example:**

```bash
mkdir bash_demo
```

Creates a directory called `bash_demo`.

---

## `cd`

Changes your current working directory.

**Syntax:**

```bash
cd directory_name
```

**Example:**

```bash
cd bash_demo
```

Moves into the `bash_demo` directory.

---

## `touch`

Creates an empty file.

**Syntax:**

```bash
touch filename
```

**Example:**

```bash
touch demo.txt
```

Creates an empty file called `demo.txt`.

---

## `echo`

Prints text to the terminal or to a file.

**Example:**

```bash
echo "Hello World"
```

Outputs:

```
Hello World
```

---

## `>`

Redirects output into a file.

* Creates the file if it doesn't exist.
* Overwrites the file if it already exists.

**Example:**

```bash
echo "Hello" > demo.txt
```

`demo.txt` will contain:

```
Hello
```

---

## `>>`

Appends text to the end of a file.

Unlike `>`, it **does not overwrite** existing content.

**Example:**

```bash
echo "Another line" >> demo.txt
```

If the file already contained:

```
Hello
```

It will now contain:

```
Hello
Another line
```

---

## `date`

Displays the current system date and time.

**Example:**

```bash
date
```

Output:

```
Thu Jul 2 19:20:14 BST 2026
```

---

## `$(command)` (Command Substitution)

Runs a command and inserts its output into another command.

**Syntax:**

```bash
$(command)
```

**Example:**

```bash
echo "Today's date is $(date)"
```

Bash first runs:

```bash
date
```

Then replaces `$(date)` with the result.

---

## `cat`

Displays the contents of a file.

**Syntax:**

```bash
cat filename
```

**Example:**

```bash
cat demo.txt
```

Displays everything stored inside `demo.txt`.

---

# Final Script

```bash
#!/bin/bash

mkdir bash_demo
cd bash_demo

touch demo.txt

echo "This file was created by a Bash script on $(date)" > demo.txt

cat demo.txt
```

---

# Example Output

```
This file was created by a Bash script on Thu Jul 2 19:20:14 BST 2026
```

---

# What I Learned

* How to create directories using `mkdir`.
* How to change directories using `cd`.
* How to create files using `touch`.
* How to write text into a file using `echo` and `>`.
* The difference between `>` (overwrite) and `>>` (append).
* How to display the contents of a file using `cat`.
* How to use `date` to get the current date and time.
* How to use command substitution `$(command)` to insert the output of one command into another.

---

# Improvement Over the Basic Solution

Although creating the file with `touch` works perfectly, it isn't actually required here.

Instead of:

```bash
touch demo.txt

echo "This file was created by a Bash script on $(date)" > demo.txt
```

you can simply write:

```bash
echo "This file was created by a Bash script on $(date)" > demo.txt
```

This is because the `>` operator automatically creates the file if it doesn't already exist.

Removing unnecessary commands makes scripts shorter, cleaner, and closer to real-world Bash scripting practices.

