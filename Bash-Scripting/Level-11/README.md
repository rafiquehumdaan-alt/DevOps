# Level 11: Automated Disk Space Report

## Mission

Create a script that checks the disk space usage of a specified directory and sends an alert if the usage exceeds a given threshold.

---

## What I learned

### `du`

`du` stands for **Disk Usage**.

It is used to check how much disk space a file or directory is using.

Example:

```bash
du Arena
```

---

### `-s`

```bash
du -s Arena
```

`-s` means **summary**.

Instead of listing the size of every file and subdirectory, it only displays the total size of the directory.

Example:

Without `-s`

```text
1 Arena/file1.txt
2 Arena/file2.txt
3 Arena
```

With `-s`

```text
3 Arena
```

---

### `-m`

```bash
du -sm Arena
```

`-m` displays the size in **megabytes (MB)**.

For example:

```text
15 Arena
```

means the `Arena` directory is **15 MB** in size.

---

### `awk`

`awk` is used to extract specific columns from command output.

Example:

```text
15 Arena
```

Using:

```bash
awk '{print $1}'
```

returns:

```text
15
```

This leaves only the number, making it easy for Bash to compare.

---

### Command substitution

```bash
DISK_SPACE=$(du -sm "$DIRECTORY" | awk '{print $1}')
```

`$(...)` tells Bash to:

> Run the command inside the brackets and store its output in a variable.

If the command outputs:

```text
15
```

then Bash stores:

```bash
DISK_SPACE=15
```

---

### Threshold

```bash
THRESHOLD=1
```

The threshold is the limit that the directory size is compared against.

Because `du -m` reports the size in **megabytes**, the threshold is also measured in **megabytes**.

---

### Numeric comparison

```bash
if [ "$DISK_SPACE" -gt "$THRESHOLD" ]; then
```

`-gt` means **greater than**.

Example:

```text
15 > 1
```

If the condition is true, Bash runs the code inside the `then` block. Otherwise, it runs the `else` block.

---

## Script flow

1. Store the directory name in a variable.
2. Measure the directory size using `du -sm`.
3. Use `awk` to extract only the size.
4. Store the size in the `DISK_SPACE` variable.
5. Set a threshold value.
6. Compare the directory size with the threshold.
7. Display either a warning or a success message.

---

## Our improvements compared to the exam answer

Although we followed the exam solution, we also analysed and improved it:

* We removed the unnecessary standalone command:

```bash
du -sm "$DIRECTORY" | awk '{print $1}'
```

because the exact same command was already being run and stored in the `DISK_SPACE` variable. Running it twice was unnecessary.

* We changed the output messages to display **MB** instead of **%**.

The exam answer printed messages such as:

```text
Warning: Disk usage for Arena is at 15%!
```

However, the script uses:

```bash
du -sm
```

which measures **directory size in megabytes**, **not percentage disk usage**.

Our version reports the units correctly, making the output more accurate and less misleading.

* We also made the messages clearer by explicitly stating that they refer to the directory's disk space usage, making them easier for someone reading the output to understand.

---

## Key takeaway

This level introduced how to collect information from Linux commands, extract only the data needed using `awk`, store it in variables with command substitution, and compare numeric values using an `if` statement to automate monitoring tasks.

If you'd like, we can keep the formatting of all your README notes identical across every level so your GitHub repository has a consistent style.

