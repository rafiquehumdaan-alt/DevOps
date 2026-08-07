# Level 15: Boss Battle 3 – Advanced Scripting

## Mission

Create an interactive Bash script that combines all the skills learned throughout the Bash Battle Arena.

The script should:

* Present a user-friendly menu.
* Allow the user to choose from multiple system tasks.
* Execute the selected task.
* Handle invalid input.
* Exit cleanly when requested.

The menu options are:

1. Check disk space.
2. Show system uptime.
3. Backup the `Arena` directory and keep only the last three backups.
4. Parse the `settings.conf` configuration file and display its values.
5. Exit the script.

---

## What I Learned

### 1. Combining Multiple Scripts

This level was different from the previous ones because it combined several independent scripts into one larger application.

Instead of writing one script for one task, I created one script that could perform multiple tasks depending on the user's selection.

---

### 2. Creating an Interactive Menu

A menu makes a script user-friendly by allowing the user to choose what they want the script to do.

Example:

```bash
echo "1. Check disk space"
echo "2. Show system uptime"
echo "3. Backup the Arena directory"
echo "4. Parse settings.conf"
echo "5. Exit"
```

This displays all available options before waiting for user input.

---

### 3. Reading User Input

The script waits for the user to enter a choice.

```bash
read -rp "Enter your choice (1-5): " choice
```

Breakdown:

* `read` waits for input.
* `-p` displays a prompt.
* `-r` reads the input literally without interpreting backslashes.
* `choice` is the variable that stores whatever the user types.

Example:

User enters:

```
3
```

Bash automatically stores:

```bash
choice="3"
```

I do **not** have to create the variable first.

`read` creates or updates the variable automatically.

---

### 4. Understanding the `case` Statement

A `case` statement is useful when one variable can have several possible values.

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

Think of it like a receptionist directing people to different departments.

If the user enters:

```
1
```

only option `1)` runs.

If the user enters something unexpected, the `*)` section runs.

---

### 5. Checking Disk Space

The command:

```bash
df -h
```

Displays disk usage for all mounted filesystems.

The `-h` option makes the output human-readable.

---

### 6. Displaying System Uptime

The command:

```bash
uptime
```

Shows:

* Current time.
* How long the system has been running.
* Number of logged-in users.
* System load averages.

---

### 7. Creating Backups

The backup section reused everything learned in the backup challenge.

Key concepts included:

* Variables.
* Timestamps.
* Creating directories.
* Creating compressed archives.
* Removing old backups.

Example:

```bash
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
```

creates a unique filename every time the script runs.

---

### 8. Keeping Only the Last Three Backups

After creating a new backup:

```bash
ls -t
```

sorts backups from newest to oldest.

Then:

```bash
sed -e '1,3d'
```

removes the first three lines from the list.

Only the older backups remain.

Finally:

```bash
while IFS= read -r file; do
    rm -f "$file"
done
```

deletes those older backups.

This automatically keeps only the newest three backup files.

---

### 9. Parsing a Configuration File

The configuration parser reused the script from the previous level.

```bash
while IFS='=' read -r key value; do
    echo "Key: $key, Value: $value"
done < "$CONF_FILE"
```

Explanation:

* Read one line at a time.
* Split at the `=` character.
* Store everything before `=` in `key`.
* Store everything after `=` in `value`.
* Display both values.

---

### 10. Error Handling

The script checks for common problems before continuing.

Examples:

```bash
if [ ! -d "$SOURCE_DIRECTORY" ]; then
```

Checks if the source directory exists.

```bash
if [ ! -f "$CONF_FILE" ]; then
```

Checks whether the configuration file exists.

If either check fails, the script prints an error and exits safely.

---

### 11. Exit Option

Adding:

```bash
5)
    exit 0
```

allows the user to leave the program cleanly.

`exit 0` means:

> The script completed successfully.

---

## My Final Solution

My final solution combined everything I learned throughout Levels 1–15 into one interactive script.

It included:

* Variables.
* User input.
* `case` statements.
* Error handling.
* File parsing.
* Backups.
* Loops.
* Pipelines.
* `sed`.
* `while read`.
* System commands.
* Clean program flow.

---

## Improvements Over the Exam Answer

Compared to the original exam solution, we made several improvements.

### Better user input

Instead of:

```bash
read choice
```

we used:

```bash
read -rp "Enter your choice (1-5): " choice
```

This provides a clear prompt and follows Bash best practices.

---

### Better error handling

Before creating a backup, we verify that the source directory exists.

This prevents `tar` from failing unexpectedly.

---

### Confirmation message

After the backup completes successfully, the script informs the user.

This gives clear feedback that the operation has finished.

---

### Cleaner formatting

The `case` statement was formatted consistently with each option on its own section, making the script easier to read and maintain.

---

### Exit option

We added an Exit option to allow the user to leave the menu cleanly rather than ending the script unexpectedly.

---

## Key Takeaways

* Use `read` to receive user input.
* `read` automatically stores the user's input inside the variable you specify.
* Use `case` when one variable has multiple possible values.
* Use `df -h` to display system disk usage.
* Use `uptime` to display how long the system has been running.
* Use `tar` to create compressed backups.
* Use timestamps to prevent backup files from overwriting one another.
* Use `ls -t` to sort files from newest to oldest.
* Use `sed -e '1,3d'` to remove the newest three entries from the list.
* Use `while IFS= read -r` to process files line by line.
* Use `cut` or `while IFS='=' read -r` when parsing structured text files.
* Always validate files and directories before using them.
* Interactive menus make Bash scripts much easier for users to operate.
