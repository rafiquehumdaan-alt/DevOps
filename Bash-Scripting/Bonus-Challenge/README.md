# Bash Bonus Challenge – System Monitor Script

## Mission

Create a Bash script that:

* Displays current CPU usage.
* Displays memory usage.
* Displays disk usage.
* Displays the top 5 processes using the most memory.
* Saves the report to a timestamped log file.
* Displays the report on the screen.

---

# Commands & Concepts Learned

## Creating a Timestamp

We use the `date` command to generate a unique timestamp for the log file.

```bash
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
```

Example output:

```text
2026-07-02_20-15-30
```

This ensures every log file has a unique name.

---

## Creating the Log File Name

We build the filename using variables.

```bash
LOG_FILE="system_monitor_$TIMESTAMP.log"
```

If:

```text
TIMESTAMP=2026-07-02_20-15-30
```

then:

```text
LOG_FILE=system_monitor_2026-07-02_20-15-30.log
```

---

# Curly Braces `{ }`

Curly braces group multiple commands together.

Example:

```bash
{
    echo "Hello"
    echo "World"
} > output.txt
```

Instead of redirecting every command individually:

```bash
echo "Hello" > output.txt
echo "World" >> output.txt
```

the braces allow us to redirect all commands at once.

This makes scripts much cleaner.

---

# Output Redirection `>`

The `>` operator sends output into a file.

```bash
echo "Hello" > output.txt
```

If the file already exists, its contents are overwritten.

When used after a group of commands:

```bash
{
    commands
} > output.txt
```

everything inside the braces is written to the file.

---

# `echo`

Displays text.

Example:

```bash
echo "Memory Usage"
```

Output:

```text
Memory Usage
```

---

# `echo ""`

Prints a blank line.

Example:

```bash
echo "CPU Usage"
echo ""
echo "Memory Usage"
```

Output:

```text
CPU Usage

Memory Usage
```

This improves readability.

You can also simply write:

```bash
echo
```

which produces the same result.

---

# Separator Lines

```bash
echo "--------------------------------"
```

Produces:

```text
--------------------------------
```

This is purely for formatting to make reports easier to read.

---

# CPU Usage

```bash
top -bn1 | grep "Cpu"
```

## `top`

Displays system information such as:

* CPU usage
* Running processes
* Memory usage

Normally it runs continuously.

---

### `-b`

Batch mode.

Instead of opening the interactive screen, it prints the information once.

---

### `-n1`

Run only one iteration.

Without it, `top` would continue updating forever.

---

### `grep "Cpu"`

Filters the output so only the CPU information is displayed.

Without `grep`:

```text
top
Tasks
CPU
Memory
Processes
...
```

With `grep`:

```text
%Cpu(s): 6.3 us, 2.1 sy, 91.6 id
```

---

# Memory Usage

```bash
free -h
```

Displays RAM usage.

Example:

```text
               total   used   free
Mem:            16Gi   5Gi    11Gi
Swap:           2Gi    0Gi    2Gi
```

### `-h`

Human-readable.

Displays values using MB or GB instead of large numbers of bytes.

---

# Disk Usage

```bash
df -h
```

Displays filesystem usage.

Example:

```text
Filesystem      Size Used Avail Use%
/dev/sda1       100G 42G 58G 42%
```

Again, `-h` means human-readable.

---

# Running Processes

```bash
ps aux --sort=-%mem
```

Displays all running processes.

### `ps`

Shows running processes.

### `a`

Processes for all users.

### `u`

Displays information in a user-friendly format.

### `x`

Includes background processes.

---

## Sorting

```bash
--sort=-%mem
```

Sorts processes by memory usage.

The minus sign (`-`) means:

> Highest memory usage first.

---

# `head`

```bash
head -n 6
```

Displays only the first six lines.

Why six?

* First line = column headings.
* Next five lines = top five processes.

---

# Pipes `|`

A pipe sends the output of one command into another command.

Example:

```bash
ps aux --sort=-%mem | head -n 6
```

1. `ps` lists every running process.
2. `head` keeps only the first six lines.

---

# `cat`

```bash
cat "$LOG_FILE"
```

Displays the contents of the log file.

This lets the user see the report immediately after it has been saved.

---

# Final Script

```bash
#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="system_monitor_$TIMESTAMP.log"

{
    echo "System Monitor Report"
    echo "Generated on: $(date)"
    echo "--------------------------------"

    echo ""
    echo "CPU Usage:"
    top -bn1 | grep "Cpu"

    echo ""
    echo "Memory Usage:"
    free -h

    echo ""
    echo "Disk Usage:"
    df -h

    echo ""
    echo "Top 5 Processes by Memory:"
    ps aux --sort=-%mem | head -n 6

} > "$LOG_FILE"

cat "$LOG_FILE"

echo ""
echo "System monitor report saved to: $LOG_FILE"
```

---

# Example Output

```text
System Monitor Report
Generated on: Thu Jul 2 20:15:30 BST 2026
--------------------------------

CPU Usage:
%Cpu(s): 4.2 us, 1.1 sy, 94.7 id

Memory Usage:
...

Disk Usage:
...

Top 5 Processes by Memory:
...
```

---

# What I Learned

* How to generate timestamps using `date`.
* How to build filenames using variables.
* How to group commands using `{ }`.
* How to redirect the output of multiple commands into a single file.
* How to display blank lines and separator lines for readability.
* How to check CPU usage using `top`.
* How to check memory usage using `free -h`.
* How to check disk usage using `df -h`.
* How to list processes using `ps`.
* How to sort processes by memory usage.
* How to use `head` to display only the first few lines.
* How to display a saved log file using `cat`.

---

# Improvements & Best Practices

## 1. Using Curly Braces

Instead of writing:

```bash
echo "CPU Usage" > "$LOG_FILE"
top -bn1 >> "$LOG_FILE"

echo "Memory Usage" >> "$LOG_FILE"
free -h >> "$LOG_FILE"
```

we grouped everything:

```bash
{
    commands
} > "$LOG_FILE"
```

This is much cleaner and easier to maintain.

---

## 2. Human-Readable Output

Using `-h` with `free` and `df` makes the report much easier to understand because values are displayed in MB and GB instead of bytes.

---

## 3. Filtering CPU Information

Rather than printing the entire output of `top`, we used:

```bash
top -bn1 | grep "Cpu"
```

This extracts only the CPU information, making the report shorter and easier to read.

---

## Key Takeaways

This challenge introduced several Linux system administration commands that are commonly used by IT engineers, system administrators, and DevOps engineers.

Unlike previous challenges, the focus was less on learning new Bash syntax and more on combining Bash with Linux administration commands to produce a useful system report.

