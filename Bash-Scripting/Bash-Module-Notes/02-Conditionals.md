# Bash Notes - Part 3: Conditionals

> Covers:
>
> - if Statements
> - else
> - elif
> - Nested if Statements
> - Comparison Operators
> - String Tests
> - File Tests
> - Best Practices

---

# What are Conditionals?

Conditionals allow a Bash script to make decisions.

The script checks whether a condition is true or false and executes different code depending on the result.

Example:

```text
Is user an admin?

      │
      ▼

   Yes      No

    │        │

Grant     Deny
Access    Access
```

---

# Basic if Statement

Syntax:

```bash
if [ condition ]
then
    commands
fi
```

Example:

```bash
age=20

if [ "$age" -ge 18 ]
then
    echo "Adult"
fi
```

Output:

```
Adult
```

---

# if Statement Flow

```text
Condition

│

├── True

│     │

│     ▼

│ Execute Code

│

└── False

      │

      ▼

 Continue Script
```

---

# if...else Statement

Use **else** when you want to perform an action if the condition is false.

Example:

```bash
age=16

if [ "$age" -ge 18 ]
then
    echo "Adult"
else
    echo "Minor"
fi
```

Output:

```
Minor
```

---

# if...elif...else

Use **elif** to check multiple conditions.

Example:

```bash
score=75

if [ "$score" -ge 90 ]
then
    echo "Grade A"

elif [ "$score" -ge 70 ]
then
    echo "Grade B"

else
    echo "Grade C"
fi
```

---

# Nested if Statements

An **if statement inside another if statement** is called a nested if.

Example:

```bash
logged_in=true
admin=true

if [ "$logged_in" = true ]
then

    if [ "$admin" = true ]
    then
        echo "Welcome Admin"
    fi

fi
```

Nested if statements should only be used when necessary, as too many levels make scripts difficult to read.

---

# Numeric Comparisons

| Operator | Meaning |
|----------|---------|
| `-eq` | Equal |
| `-ne` | Not Equal |
| `-gt` | Greater Than |
| `-lt` | Less Than |
| `-ge` | Greater Than or Equal |
| `-le` | Less Than or Equal |

Example:

```bash
number=10

if [ "$number" -gt 5 ]
then
    echo "Greater than 5"
fi
```

---

# String Comparisons

| Operator | Meaning |
|----------|---------|
| `=` | Equal |
| `!=` | Not Equal |
| `-z` | String is empty |
| `-n` | String is not empty |

Example:

```bash
name="Humdaan"

if [ "$name" = "Humdaan" ]
then
    echo "Welcome!"
fi
```

---

# Checking Empty Strings

Example:

```bash
name=""

if [ -z "$name" ]
then
    echo "Name is empty"
fi
```

---

# Checking Non-Empty Strings

```bash
if [ -n "$name" ]
then
    echo "Name entered"
fi
```

---

# File Tests

Bash can check whether files or directories exist.

Common file test operators:

| Test | Meaning |
|------|---------|
| `-f` | File exists |
| `-d` | Directory exists |
| `-e` | File or directory exists |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |

Example:

```bash
if [ -f "notes.txt" ]
then
    echo "File exists"
fi
```

---

# Checking Directories

```bash
if [ -d "/home/humdaan" ]
then
    echo "Directory exists"
fi
```

---

# Logical AND

Both conditions must be true.

```bash
age=25
country="UK"

if [ "$age" -ge 18 ] && [ "$country" = "UK" ]
then
    echo "Allowed"
fi
```

---

# Logical OR

Only one condition needs to be true.

```bash
if [ "$age" -lt 18 ] || [ "$country" = "UK" ]
then
    echo "Condition met"
fi
```

---

# Real Example

```bash
#!/bin/bash

user=$1

if [ -z "$user" ]
then
    echo "Please provide a username."

elif [ "$user" = "admin" ]
then
    echo "Welcome Administrator."

else
    echo "Welcome $user."
fi
```

---

# Common Mistakes

### Forgetting Spaces

Incorrect:

```bash
if ["$age" -gt 18]
```

Correct:

```bash
if [ "$age" -gt 18 ]
```

---

### Forgetting Quotes

Incorrect:

```bash
if [ $name = Humdaan ]
```

Correct:

```bash
if [ "$name" = "Humdaan" ]
```

Quoting variables prevents errors when values contain spaces or are empty.

---

### Forgetting `fi`

Every `if` statement must end with:

```bash
fi
```

---

# Best Practices

- Always quote variables:

```bash
"$variable"
```

- Keep conditions simple and readable.
- Use `elif` instead of multiple separate `if` statements when checking related conditions.
- Avoid deeply nested `if` statements where possible.
- Check user input before using it.

---

# Key Takeaways

- `if` executes code when a condition is true.
- `else` runs when the condition is false.
- `elif` checks additional conditions.
- Numeric comparisons use operators like `-eq`, `-gt` and `-lt`.
- String comparisons use `=` and `!=`.
- File tests check whether files or directories exist.
- Logical operators (`&&` and `||`) combine multiple conditions.

---

# Quick Revision

| Syntax | Purpose |
|---------|---------|
| `if` | Start a conditional |
| `then` | Code to execute if true |
| `else` | Code if false |
| `elif` | Additional condition |
| `fi` | End the conditional |
| `-eq` | Equal |
| `-gt` | Greater than |
| `-lt` | Less than |
| `-f` | File exists |
| `-d` | Directory exists |
| `-z` | String is empty |
| `-n` | String is not empty |

---

# Interview Questions

### What is an `if` statement?

An `if` statement allows a Bash script to make decisions based on whether a condition is true or false.

### When would you use `elif`?

When you need to test multiple conditions without writing separate `if` statements.

### What is the difference between `-eq` and `=`?

`-eq` compares **numbers**, while `=` compares **strings**.

### Why should variables usually be wrapped in quotes?

To prevent errors when variables are empty or contain spaces.

### How do you check if a file exists?

```bash
if [ -f "file.txt" ]
then
    echo "File exists"
fi
```