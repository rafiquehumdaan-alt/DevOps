# Level 12: Simple Configuration File Parser

## Mission

Write a Bash script that reads a configuration file in the format `KEY=VALUE` and prints each key-value pair.

Example configuration file (`settings.conf`):

```text
NAME=Humdaan
AGE=23
CITY=London
```

Expected output:

```text
Key: NAME, Value: Humdaan
Key: AGE, Value: 23
Key: CITY, Value: London
```

---

## Final Script

```bash
#!/bin/bash

CONF_FILE="settings.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file '$CONF_FILE' not found!"
    exit 1
fi

while IFS='=' read -r key value; do
    echo "Key: $key, Value: $value"
done < "$CONF_FILE"
```

---

# What I Learned

This level introduced configuration files and how Bash can automatically split a line into multiple variables.

Unlike previous levels where I read an entire line into one variable, this level showed how to split each line into two parts using `IFS`.

---

# Script Breakdown

### `#!/bin/bash`

The shebang line.

It tells Linux to execute the script using the Bash shell.

---

### `CONF_FILE="settings.conf"`

Creates a variable containing the name of the configuration file.

Using a variable means I only need to change the filename in one place if it changes in the future.

---

### `if [ ! -f "$CONF_FILE" ]; then`

Checks whether the configuration file exists.

* `-f` = checks if it is a file.
* `!` = NOT.

So this means:

> "If the file does not exist..."

---

### `echo`

Prints an error message to the user explaining what went wrong.

---

### `exit 1`

Stops the script immediately because there is no file to read.

An exit code of `1` indicates an error.

---

### `while IFS='=' read -r key value; do`

This is the most important line of the script.

It combines several Bash features together:

* `while` keeps looping until every line in the file has been read.
* `IFS='='` tells Bash to split each line wherever it finds an equals sign (`=`).
* `read` reads one line at a time.
* `-r` reads the line exactly as written without treating backslashes specially.
* `key` stores everything before the `=`.
* `value` stores everything after the `=`.
* `do` begins the loop.

Example:

```text
PORT=8080
```

becomes:

```bash
key="PORT"
value="8080"
```

It is important to understand that **`key` and `value` are not special Bash keywords**.

They are simply variable names chosen by the programmer.

These would work exactly the same:

```bash
read -r first second
```

or

```bash
read -r left right
```

The reason `key` and `value` are used is because they clearly describe what each variable contains, making the script easier to understand.

---

### `echo "Key: $key, Value: $value"`

Prints the key and value that were extracted from the current line.

For example:

```text
USERNAME=admin
```

produces:

```text
Key: USERNAME, Value: admin
```

---

### `done < "$CONF_FILE"`

This tells the `while` loop to read its input from `settings.conf`.

Without this line, Bash would wait for the user to type input into the terminal instead of reading the file.

---

# Example

If `settings.conf` contains:

```text
NAME=Humdaan
AGE=23
CITY=London
```

The loop runs three times.

**Iteration 1**

```bash
key="NAME"
value="Humdaan"
```

Output:

```text
Key: NAME, Value: Humdaan
```

---

**Iteration 2**

```bash
key="AGE"
value="23"
```

Output:

```text
Key: AGE, Value: 23
```

---

**Iteration 3**

```bash
key="CITY"
value="London"
```

Output:

```text
Key: CITY, Value: London
```

After the last line is read, the loop finishes automatically.

---

# Key Concepts Learned

* How configuration files are commonly written as `KEY=VALUE`.
* How `IFS` (Internal Field Separator) tells Bash where to split text.
* How `read` can populate multiple variables at once.
* Why `read -r` is considered best practice.
* How `while` loops can process a file one line at a time.
* How `<` redirects a file into a command.
* That `key` and `value` are ordinary variables created by the programmer, not built-in Bash keywords.

---

# Comparison With the Exam Answer

### Exam Answer

```bash
#!/bin/bash

CONFIG_FILE="settings.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file does not exist."
    exit 1
fi

while IFS='=' read -r key value; do
    echo "Key: $key, Value: $value"
done < "$CONFIG_FILE"
```

### Our Solution

```bash
#!/bin/bash

CONF_FILE="settings.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file '$CONF_FILE' not found!"
    exit 1
fi

while IFS='=' read -r key value; do
    echo "Key: $key, Value: $value"
done < "$CONF_FILE"
```

---

# Improvements We Made

* Used a shorter variable name (`CONF_FILE`). This is a style preference rather than a functional improvement.
* Improved the error message by including the filename that could not be found:

```text
Configuration file 'settings.conf' not found!
```

instead of the more generic:

```text
Configuration file does not exist.
```

This makes troubleshooting easier because the user immediately knows which file is missing.

* Spent time understanding **how** the script works rather than simply copying the solution. In particular, I learned:

  * what `IFS` does,
  * how `read` can populate multiple variables,
  * why `done < "$CONF_FILE"` redirects the file into the loop,
  * and that `key` and `value` are programmer-defined variable names rather than special Bash keywords.

Overall, our script performs the same task as the exam solution but provides a more informative error message while reinforcing a deeper understanding of the Bash concepts introduced in this level.

