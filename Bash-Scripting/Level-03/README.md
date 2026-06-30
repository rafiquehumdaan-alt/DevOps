# Level 3: Conditional Statements

## Mission

Create a script that checks if a file named `hero.txt` exists in the `Arena` directory. If it does, print `Hero found!`; otherwise, print `Hero missing!`.

---

## What I Learned

### Conditional Statements (`if`)

Conditional statements allow a Bash script to make decisions based on whether a condition is **true** or **false**.

Think of it as:

> **If** something is true, do one thing.
> **Otherwise**, do something else.

### Basic Syntax

```bash
if [ condition ]
then
    # Runs if the condition is true
else
    # Runs if the condition is false
fi
```

### Keywords

* `if` → Starts the conditional statement.
* `[ ]` → Contains the condition (the test).
* `then` → Executes if the condition is true.
* `else` → Executes if the condition is false.
* `fi` → Ends the conditional statement.

### Checking if a File Exists

The `-f` test checks whether a **regular file** exists.

Example:

```bash
#!/bin/bash

if [ -f Arena/hero.txt ]; then
    echo "Hero found!"
else
    echo "Hero missing!"
fi
```

### Useful File Tests

* `-f` → File exists and is a regular file.
* `-d` → Directory exists.
* `-e` → File or directory exists.

---

## Key Takeaways

* Conditional statements allow Bash scripts to make decisions.
* `if` checks whether a condition is true.
* `then` runs the code when the condition is true.
* `else` runs when the condition is false.
* `fi` always closes an `if` statement.
* `-f` is used to check whether a file exists.
* Always use the correct file path (e.g. `Arena/hero.txt`) when the file is inside another directory.
* Conditional statements are commonly used in DevOps scripts to verify files, directories, users, services, and configurations before taking action.

