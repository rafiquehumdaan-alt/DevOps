# Bash Notes - Part 4: Loops & Flow Control

> Covers:
>
> - while Loops
> - for Loops
> - break
> - continue
> - Loop Control
> - Best Practices

---

# What are Loops?

Loops allow you to repeat a block of code multiple times without rewriting it.

Instead of:

```bash
echo "Hello"
echo "Hello"
echo "Hello"
```

You can use a loop:

```bash
for i in {1..3}
do
    echo "Hello"
done
```

---

# Types of Loops in Bash

Bash has two main loop types:

- `while`
- `for`

---

# while Loop

A **while loop** runs as long as a condition is true.

Syntax:

```bash
while [ condition ]
do
    commands
done
```

---

# Example: Counting

```bash
count=1

while [ "$count" -le 5 ]
do
    echo "$count"
    count=$((count + 1))
done
```

Output:

```
1
2
3
4
5
```

---

# while Loop Flow

```text
Condition

│

├── True

│     │

│     ▼

│ Execute Commands

│

│ Update Variable

│

└──────────────┐
               │
               ▼

        Check Again

False

↓

Exit Loop
```

---

# Infinite Loop

A loop that never ends.

Example:

```bash
while true
do
    echo "Running..."
done
```

Useful for:

- Monitoring
- Background services

Stop it with:

```
Ctrl + C
```

---

# for Loop

A **for loop** repeats code for every item in a list.

Syntax:

```bash
for variable in list
do
    commands
done
```

---

# Example: List

```bash
for fruit in apple orange banana
do
    echo "$fruit"
done
```

Output:

```
apple
orange
banana
```

---

# Example: Number Range

```bash
for i in {1..5}
do
    echo "$i"
done
```

Output:

```
1
2
3
4
5
```

---

# Example: Increment

```bash
for i in {0..10..2}
do
    echo "$i"
done
```

Output:

```
0
2
4
6
8
10
```

---

# Looping Through Files

Example:

```bash
for file in *.txt
do
    echo "$file"
done
```

Useful for:

- Processing logs
- Renaming files
- Backups

---

# break

`break` immediately exits a loop.

Example:

```bash
for i in {1..10}
do
    if [ "$i" -eq 5 ]
    then
        break
    fi

    echo "$i"
done
```

Output:

```
1
2
3
4
```

The loop stops when `i` reaches 5.

---

# continue

`continue` skips the current iteration and moves to the next one.

Example:

```bash
for i in {1..5}
do
    if [ "$i" -eq 3 ]
    then
        continue
    fi

    echo "$i"
done
```

Output:

```
1
2
4
5
```

Only the number 3 is skipped.

---

# break vs continue

| Command | Purpose |
|----------|----------|
| `break` | Exit the loop completely |
| `continue` | Skip current iteration |

---

# Reading User Input in a Loop

Example:

```bash
while true
do
    read -p "Enter your name: " name

    if [ "$name" = "quit" ]
    then
        break
    fi

    echo "Hello $name"
done
```

The loop continues until the user types:

```
quit
```

---

# Real Example

```bash
#!/bin/bash

for user in Alice Bob Charlie
do
    echo "Creating account for $user"
done

echo "All users processed."
```

---

# Common Mistakes

### Forgetting to Update the Variable

Incorrect:

```bash
count=1

while [ "$count" -le 5 ]
do
    echo "$count"
done
```

This creates an **infinite loop** because `count` never changes.

Correct:

```bash
count=$((count + 1))
```

---

### Missing `done`

Every loop must end with:

```bash
done
```

---

### Incorrect Range

Incorrect:

```bash
for i in (1..5)
```

Correct:

```bash
for i in {1..5}
```

---

# Best Practices

- Use `for` loops when looping through a known list.
- Use `while` loops when the number of iterations is unknown.
- Avoid unnecessary infinite loops.
- Use `break` to exit early when appropriate.
- Use `continue` to skip unwanted iterations.
- Keep loops simple and readable.

---

# Key Takeaways

- Loops repeat code automatically.
- `while` loops continue while a condition is true.
- `for` loops iterate over lists or ranges.
- `break` exits a loop immediately.
- `continue` skips the current iteration.
- Loops reduce repetitive code and improve automation.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `while` | Repeat while condition is true |
| `for` | Loop through a list |
| `break` | Exit loop |
| `continue` | Skip current iteration |
| `done` | End a loop |

---

# Interview Questions

### What is the difference between a `for` loop and a `while` loop?

A `for` loop is used when iterating over a known list or range, while a `while` loop runs as long as a condition remains true.

### What does `break` do?

It immediately exits the current loop.

### What does `continue` do?

It skips the current iteration and moves to the next one.

### What causes an infinite loop?

A condition that never becomes false, often because the loop variable is never updated.

### When would you use a `for` loop?

When processing a list of items, files, or a known range of numbers.