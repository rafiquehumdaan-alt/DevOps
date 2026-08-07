# Bash Notes - Part 1: Variables & Parameters

> Covers:
>
> - Variables
> - Parameters
> - Positional Parameters
> - Special Variables
> - Arithmetic Expansion
> - Arithmetic with Variables

---

# What are Variables?

A variable stores data that can be reused later in your script.

Think of it as a **named container** for information.

Example:

```bash
name="Humdaan"

echo $name
```

Output:

```
Humdaan
```

---

# Variable Syntax

Creating a variable:

```bash
name="John"
age=23
city="London"
```

Using a variable:

```bash
echo $name
```

or

```bash
echo "${name}"
```

Both produce the same output.

---

# Variable Naming Rules

Variable names:

- Can contain letters, numbers and underscores
- Cannot begin with a number
- Cannot contain spaces
- Are case-sensitive

Valid:

```bash
username
USER_NAME
age
```

Invalid:

```bash
1name
my name
user-name
```

---

# Quotes

### Double Quotes

Variables are expanded.

```bash
name="Alice"

echo "Hello $name"
```

Output:

```
Hello Alice
```

---

### Single Quotes

Variables are treated as plain text.

```bash
echo 'Hello $name'
```

Output:

```
Hello $name
```

---

# Command Substitution

Store the output of a command inside a variable.

Example:

```bash
current_date=$(date)
```

or

```bash
current_user=$(whoami)
```

Display the value:

```bash
echo "$current_user"
```

---

# Parameters

Parameters pass information to a Bash script.

Example:

```bash
./script.sh John 25
```

The script receives:

```
John

25
```

---

# Positional Parameters

| Parameter | Meaning |
|-----------|---------|
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$3` | Third argument |
| `$9` | Ninth argument |

Example:

```bash
#!/bin/bash

echo $1
```

Run:

```bash
./script.sh Humdaan
```

Output:

```
Humdaan
```

---

# Special Parameters

| Variable | Meaning |
|-----------|---------|
| `$#` | Number of arguments |
| `$@` | All arguments individually |
| `$*` | All arguments as one string |
| `$$` | Current process ID |
| `$?` | Exit status of previous command |

---

## Example: Number of Arguments

```bash
echo $#
```

Run:

```bash
./script.sh one two three
```

Output:

```
3
```

---

## Example: All Arguments

```bash
echo $@
```

Run:

```bash
./script.sh apple orange banana
```

Output:

```
apple orange banana
```

---

# Arithmetic Expansion

Bash performs calculations using:

```bash
$(( ))
```

Example:

```bash
echo $((5 + 3))
```

Output:

```
8
```

---

# Basic Operators

| Operator | Meaning |
|----------|---------|
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulus (Remainder) |

Examples:

```bash
echo $((8 + 2))
echo $((10 - 5))
echo $((6 * 7))
echo $((20 / 4))
echo $((10 % 3))
```

---

# Arithmetic with Variables

Variables can be used inside calculations.

Example:

```bash
a=10
b=5

echo $((a + b))
```

Output:

```
15
```

---

# Updating Variables

Increase a variable:

```bash
count=5

count=$((count + 1))
```

or

```bash
count=$((count += 1))
```

Result:

```
6
```

---

# Combining Variables

```bash
first="Humdaan"
last="Ahmed"

echo "$first $last"
```

Output:

```
Humdaan Ahmed
```

---

# Real Example

```bash
#!/bin/bash

name=$1
age=$2

echo "Name: $name"
echo "Age: $age"

next_year=$((age + 1))

echo "Next year you will be $next_year."
```

Run:

```bash
./script.sh Humdaan 23
```

Output:

```
Name: Humdaan
Age: 23
Next year you will be 24.
```

---

# Best Practices

- Use meaningful variable names.
- Use double quotes around variables:

```bash
"$name"
```

instead of

```bash
$name
```

- Prefer `$(command)` instead of older backticks.
- Use `${variable}` when joining text.

Example:

```bash
echo "${name}_backup"
```

instead of

```bash
echo "$name_backup"
```

---

# Common Mistakes

Incorrect:

```bash
name = "John"
```

Correct:

```bash
name="John"
```

---

Incorrect:

```bash
echo '$name'
```

Correct:

```bash
echo "$name"
```

---

Incorrect:

```bash
echo (5 + 2)
```

Correct:

```bash
echo $((5 + 2))
```

---

# Key Takeaways

- Variables store reusable data.
- Use `$variable` or `${variable}` to access values.
- Parameters allow values to be passed into scripts.
- `$1`, `$2`, etc. represent positional parameters.
- `$#` returns the number of arguments.
- `$@` returns all arguments.
- `$(( ))` performs arithmetic calculations.
- Variables can be used inside arithmetic expressions.

---

# Quick Revision

| Symbol | Meaning |
|---------|---------|
| `$name` | Variable value |
| `${name}` | Variable value (safe syntax) |
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$#` | Number of arguments |
| `$@` | All arguments |
| `$?` | Exit code of previous command |
| `$$` | Process ID |
| `$(( ))` | Arithmetic expansion |

---

# Interview Questions

### What is a variable in Bash?

A named container used to store values that can be reused within a script.

### What is the difference between `$1` and `$0`?

`$0` is the script name, while `$1` is the first argument passed to the script.

### How do you perform arithmetic in Bash?

Using arithmetic expansion:

```bash
$((5 + 3))
```

### What does `$#` return?

The number of arguments passed to a script.

### What is command substitution?

Using the output of a command as a value, for example:

```bash
today=$(date)
```