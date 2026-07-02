# Level 14: User-Friendly Menu Script

## Mission

Create an interactive Bash script that presents a menu with options for different system tasks (e.g. check disk space, show system uptime, list users), and executes the task selected by the user.

---

## What I Learned

### 1. Displaying a Menu

A menu makes a script interactive by giving the user a list of choices.

Example:

```bash
echo "Press 1 to check disk usage"
echo "Press 2 to check system uptime"
echo "Press 3 to list users"
```

This simply prints the available options to the terminal.

---

### 2. Reading User Input

The `read` command pauses the script and waits for the user to type something.

Example:

```bash
read choice
```

If the user types:

```
2
```

Bash automatically stores the value inside the variable:

```bash
choice="2"
```

Unlike variables such as:

```bash
DIRECTORY="Arena"
```

where I assign the value myself, `read` allows the **user** to provide the value.

A better practice is:

```bash
read -rp "Enter your choice [1-3]: " choice
```

* `-p` displays a prompt.
* `-r` reads the input literally without interpreting backslashes.

---

### 3. The `case` Statement

A `case` statement is used when one variable can have several possible values.

Instead of writing multiple `if` and `elif` statements, `case` provides a cleaner structure.

General syntax:

```bash
case VARIABLE in
    value1)
        commands
        ;;
    value2)
        commands
        ;;
    *)
        default commands
        ;;
esac
```

Think of it like a receptionist directing people to different departments:

* If the user chooses **1**, run the first task.
* If the user chooses **2**, run the second task.
* If the user chooses **3**, run the third task.
* If anything else is entered, display an error message.

---

### 4. Understanding `;;`

Each option in a `case` statement ends with:

```bash
;;
```

This tells Bash:

> "I'm finished with this option."

Without it, Bash would continue into the next option.

---

### 5. Understanding `*)`

The final option:

```bash
*)
```

is the **default case**.

It means:

> "If none of the previous options matched."

This is useful for handling invalid user input.

Example:

```
Invalid choice
```

---

### 6. Understanding `esac`

A `case` statement finishes with:

```bash
esac
```

Just like:

* `if` ends with `fi`
* `for` ends with `done`
* `while` ends with `done`

`case` ends with `esac` ("case" backwards).

---

### 7. Commands Used

#### `df -h`

Displays disk usage for the system in a human-readable format.

Example:

```bash
df -h
```

---

#### `uptime`

Displays how long the system has been running along with the current load.

Example:

```bash
uptime
```

---

#### `cut -d: -f1 /etc/passwd`

Lists usernames stored in `/etc/passwd`.

Breakdown:

```bash
cut
```

Extract part of each line.

```bash
-d:
```

Use `:` as the delimiter.

```bash
-f1
```

Print only field 1.

Example:

```
humdaan:x:1000:1000:/home/humdaan:/bin/bash
```

becomes:

```
humdaan
```

---

## My Final Solution

```bash
#!/bin/bash

echo "Press 1 to check disk usage"
echo "Press 2 to check system uptime"
echo "Press 3 to list users"

read -rp "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Disk Usage:"
        df -h
        ;;
    2)
        echo "System Uptime:"
        uptime
        ;;
    3)
        echo "List of Users:"
        cut -d: -f1 /etc/passwd
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
```

---

## Comparison With the Exam Answer

The overall logic is the same as the exam solution.

### Improvement We Made

Instead of simply writing:

```bash
read choice
```

we improved the user experience by using:

```bash
read -rp "Enter your choice [1-3]: " choice
```

This:

* Gives the user a clear prompt.
* Uses `-r`, which is considered best practice for reading user input safely.
* Makes the script easier and more professional to use.

---

## Key Takeaways

* Use `echo` to display menu options.
* Use `read` to accept keyboard input.
* `read` automatically stores the user's input in the variable you specify.
* Use `case` when one variable has multiple possible values.
* End each `case` option with `;;`.
* Use `*)` as the default option for invalid input.
* End every `case` statement with `esac`.
* `df -h` displays system disk usage.
* `uptime` displays how long the system has been running.
* `cut -d: -f1 /etc/passwd` lists usernames from the system.

