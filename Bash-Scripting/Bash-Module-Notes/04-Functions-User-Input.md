# Bash Notes - Part 5: Functions & User Input

> Covers:
>
> - Functions
> - Function Parameters
> - User Input
> - Input Validation
> - Handling Bad Data
> - Best Practices

---

# What are Functions?

A **function** is a reusable block of code that performs a specific task.

Instead of writing the same code multiple times, you write it once inside a function and call it whenever needed.

Benefits:

- Reusable code
- Easier to read
- Easier to maintain
- Reduces duplication

---

# Basic Function

Syntax:

```bash
function_name() {
    commands
}
```

Example:

```bash
hello() {
    echo "Hello, World!"
}

hello
```

Output:

```
Hello, World!
```

---

# Function Flow

```text
Script Starts

↓

Function Defined

↓

Function Called

↓

Commands Execute

↓

Continue Script
```

Functions do **not** run until they are called.

---

# Calling a Function

Simply use its name.

Example:

```bash
greet() {
    echo "Welcome!"
}

greet
greet
greet
```

Output:

```
Welcome!
Welcome!
Welcome!
```

---

# Functions with Parameters

Functions can accept arguments, just like scripts.

Example:

```bash
greet() {
    echo "Hello $1"
}

greet Humdaan
```

Output:

```
Hello Humdaan
```

---

# Multiple Parameters

```bash
user_info() {
    echo "Name: $1"
    echo "Age: $2"
}

user_info Humdaan 23
```

Output:

```
Name: Humdaan
Age: 23
```

---

# Returning Values

Bash functions don't return strings like other programming languages.

Instead, they usually:

- Print output using `echo`
- Set variables
- Return an exit code (`0` = success, non-zero = failure)

Example:

```bash
say_hello() {
    echo "Hello!"
}

message=$(say_hello)

echo "$message"
```

Output:

```
Hello!
```

---

# What is User Input?

User input allows scripts to receive information while they are running.

The `read` command is used to collect input.

---

# Basic Input

Example:

```bash
read name

echo "Hello $name"
```

---

# Prompting the User

Using `-p` displays a prompt.

Example:

```bash
read -p "Enter your name: " name

echo "Hello $name"
```

Output:

```
Enter your name: Humdaan

Hello Humdaan
```

---

# Hidden Input

Use `-s` for sensitive information such as passwords.

Example:

```bash
read -sp "Password: " password
```

The text entered will not be displayed.

---

# Reading Multiple Values

Example:

```bash
read first_name last_name

echo "$first_name $last_name"
```

Input:

```
Humdaan Ahmed
```

Output:

```
Humdaan Ahmed
```

---

# Input Validation

Never assume user input is valid.

Always check:

- Empty values
- Invalid numbers
- Incorrect options
- Unexpected characters

---

# Example: Empty Input

```bash
read -p "Enter your name: " name

if [ -z "$name" ]
then
    echo "Name cannot be empty."
fi
```

---

# Example: Number Validation

```bash
read -p "Enter your age: " age

if [[ "$age" =~ ^[0-9]+$ ]]
then
    echo "Valid age."
else
    echo "Please enter a number."
fi
```

---

# Handling Bad Data

Good scripts should handle incorrect input gracefully.

Example:

```bash
read -p "Continue? (y/n): " answer

if [ "$answer" = "y" ]
then
    echo "Continuing..."
elif [ "$answer" = "n" ]
then
    echo "Cancelled."
else
    echo "Invalid choice."
fi
```

---

# Repeating Until Valid Input

A common pattern is to keep asking until the user enters valid data.

Example:

```bash
while true
do
    read -p "Enter yes or no: " answer

    if [ "$answer" = "yes" ] || [ "$answer" = "no" ]
    then
        break
    fi

    echo "Invalid input."
done
```

---

# Real Example

```bash
#!/bin/bash

greet() {
    echo "Welcome $1!"
}

read -p "Enter your name: " username

if [ -z "$username" ]
then
    echo "Name cannot be empty."
    exit 1
fi

greet "$username"
```

---

# Common Mistakes

### Forgetting Quotes

Incorrect:

```bash
echo Hello $name
```

Better:

```bash
echo "Hello $name"
```

---

### Forgetting to Call the Function

Incorrect:

```bash
hello() {
    echo "Hi"
}
```

Nothing happens because the function isn't called.

Correct:

```bash
hello
```

---

### Trusting User Input

Incorrect:

```bash
read age

echo $((age + 1))
```

If the user enters text, the script may fail or behave unexpectedly.

Always validate input first.

---

# Best Practices

- Keep functions small and focused.
- Give functions descriptive names.
- Reuse functions instead of copying code.
- Validate all user input.
- Use `read -p` to display prompts.
- Quote variables to avoid unexpected behaviour.

---

# Key Takeaways

- Functions group reusable code.
- Functions run only when called.
- Functions can accept parameters (`$1`, `$2`, etc.).
- `read` collects user input.
- `read -p` displays a prompt.
- `read -s` hides sensitive input.
- Always validate user input before using it.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `function_name()` | Define a function |
| `read` | Read user input |
| `read -p` | Prompt the user |
| `read -s` | Hidden input |
| `$1` | First function argument |
| `$2` | Second function argument |
| `-z` | Check for empty input |

---

# Interview Questions

### What is a function in Bash?

A reusable block of code that performs a specific task and can be called multiple times.

### How do you pass arguments to a function?

Arguments are passed after the function name and accessed using positional parameters such as `$1`, `$2`, etc.

### What does the `read` command do?

It reads input from the user and stores it in a variable.

### Why should user input be validated?

To prevent errors, unexpected behaviour and invalid data from being processed.

### What is the difference between `read` and `read -s`?

`read` displays the user's input, while `read -s` hides the input, making it suitable for passwords.