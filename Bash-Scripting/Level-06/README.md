# Level 6: Argument Parsing

## Mission

Write a script that:

* Accepts a filename as a command-line argument.
* Prints the number of lines in that file.
* If no filename is provided, display the message:

  ```
  No file provided
  ```

---

# What are Arguments?

Arguments are values passed to a script when it is executed.

Example:

```bash
./count.sh heroes.txt
```

* `./count.sh` → The script.
* `heroes.txt` → The first argument.

Bash automatically stores arguments in special variables:

* `$1` → First argument.
* `$2` → Second argument.
* `$3` → Third argument.

So after running:

```bash
./count.sh heroes.txt
```

Bash stores:

```bash
$1="heroes.txt"
```

If the user runs:

```bash
./count.sh
```

then:

```bash
$1=""
```

The first argument is empty.

---

# Checking if an Argument Exists

To check whether the user provided an argument, use:

```bash
[ -z "$1" ]
```

Breakdown:

* `[` `]` → Perform a test.
* `$1` → First argument.
* `-z` → Checks whether a string has **zero characters** (is empty).

Example:

```bash
if [ -z "$1" ]; then
```

Read it as:

> "If the first argument is empty..."

If no filename was supplied, the script can display:

```bash
echo "No file provided"
```

---

# Checking Whether a File Exists

The exam solution also checks whether the file actually exists.

```bash
if [ ! -f "$1" ]; then
```

Breakdown:

* `-f` → Does this file exist?
* `!` → NOT

Read it as:

> "If this file does NOT exist..."

This prevents commands from failing later.

Example output:

```
File not found!
```

---

# Counting Lines

The command used is:

```bash
wc -l filename.txt
```

Example:

If `heroes.txt` contains:

```
Knight
Mage
Rogue
Archer
```

Running:

```bash
wc -l heroes.txt
```

Outputs:

```
4 heroes.txt
```

* `4` → Number of lines.
* `heroes.txt` → Name of the file counted.

---

# Input Redirection (`<`)

The exam solution uses:

```bash
wc -l < "$1"
```

instead of:

```bash
wc -l "$1"
```

## What's the difference?

### Without `<`

```bash
wc -l heroes.txt
```

`wc` is given the **filename**.

Output:

```
4 heroes.txt
```

---

### With `<`

```bash
wc -l < heroes.txt
```

The contents of the file are fed into `wc`.

`wc` never receives the filename.

Output:

```
4
```

Think of `<` as saying:

> "Take the contents of this file and feed them into the command."

Visual example:

```
heroes.txt
     │
     ▼
  wc -l
     │
     ▼
     4
```

---

# Output Redirection (`>`)

`>` sends a command's output into a file.

Example:

```bash
wc -l heroes.txt > result.txt
```

Instead of displaying:

```
4 heroes.txt
```

on the terminal, Bash writes it into:

```
result.txt
```

Remember:

```
<  = Input goes INTO a command.

>  = Output comes OUT of a command.
```

---

# Command Substitution

The exam solution stores the result in a variable:

```bash
LINE_COUNT=$(wc -l < "$1")
```

Breakdown:

* `$(...)` → Run the command inside.
* Save its output.
* Store it in a variable.

If:

```bash
wc -l < heroes.txt
```

returns:

```
4
```

then:

```bash
LINE_COUNT
```

contains:

```
4
```

It can then be used later:

```bash
echo "The file '$1' has $LINE_COUNT lines."
```

Output:

```
The file 'heroes.txt' has 4 lines.
```

---

# Exit Codes

The exam solution uses:

```bash
exit 1
```

This means:

> Stop the script immediately because an error occurred.

Examples:

* No filename supplied.
* File does not exist.

Using `exit 1` prevents the script from continuing when something has already gone wrong.

---

# Key Commands Learned

| Command  | Purpose                                 |
| -------- | --------------------------------------- |
| `$1`     | First command-line argument             |
| `-z`     | Checks whether a string is empty        |
| `-f`     | Checks whether a file exists            |
| `!`      | Means NOT                               |
| `wc -l`  | Counts the number of lines              |
| `<`      | Redirects a file into a command (input) |
| `>`      | Redirects command output into a file    |
| `$(...)` | Runs a command and stores its output    |
| `exit 1` | Stops the script due to an error        |

---

# Exam Solution

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "No file provided"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File not found!"
    exit 1
fi

LINE_COUNT=$(wc -l < "$1")
echo "The file '$1' has $LINE_COUNT lines."
```

---

# Our Solution

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "No file provided"
else
    wc -l "$1"
fi
```

---

# Comparing Our Solution to the Exam Answer

Our solution successfully completed the core mission:

* ✔ Accepted a filename as an argument.
* ✔ Checked if a filename was provided.
* ✔ Counted the number of lines.

The exam solution improves on ours in several ways:

### 1. Stops the script after an error

We only printed:

```bash
echo "No file provided"
```

The exam adds:

```bash
exit 1
```

This immediately stops the script instead of allowing it to continue.

---

### 2. Checks whether the file exists

Our script assumed the file existed.

If the file didn't exist, `wc` would display a Linux error.

The exam solution checks first:

```bash
if [ ! -f "$1" ]; then
```

This produces a much cleaner and more user-friendly error message.

---

### 3. Uses input redirection

We used:

```bash
wc -l "$1"
```

which outputs:

```
4 heroes.txt
```

The exam uses:

```bash
wc -l < "$1"
```

which outputs only:

```
4
```

This matches the mission more closely.

---

### 4. Stores the result in a variable

Instead of printing the output directly, the exam stores it:

```bash
LINE_COUNT=$(wc -l < "$1")
```

This allows the value to be reused later in the script.

---

### 5. Produces a friendlier message

Instead of simply printing:

```
4
```

the exam prints:

```
The file 'heroes.txt' has 4 lines.
```

This is easier for users to understand and demonstrates good scripting practice.

---

# What We Learned

This level introduced several important Bash concepts that are used frequently in real-world scripting:

* Command-line arguments (`$1`)
* Checking for empty arguments using `-z`
* Checking whether files exist with `-f`
* Using `!` to negate a condition
* Counting lines with `wc -l`
* Input redirection using `<`
* Output redirection using `>`
* Command substitution with `$(...)`
* Stopping scripts using `exit 1`

Although our original solution met the mission requirements, the exam solution showed how to write a more robust, user-friendly, and professional Bash script by handling errors properly and producing cleaner output.

