# Level 10 – Boss Battle 2: Intermediate Scripting

## Mission

Write a Bash script that:

* Creates a directory called `Arena_Boss`.
* Creates 5 text files (`file1.txt` to `file5.txt`).
* Generates a random number of lines (between 10 and 20) in each file.
* Sorts the files by size and displays them.
* Searches each file for the word `Victory` and, if found, moves it to a directory called `Victory_Archive`.

---

# What I Learned

## 1. Nested Loops

This level introduced **nested loops** (a loop inside another loop).

The **outer loop** runs once for each file:

```bash
for i in {1..5}
```

The **inner loop** runs once for every line that needs to be written into that file.

Think of it like this:

```
Create file1
    Write lines into file1

Create file2
    Write lines into file2

Create file3
    Write lines into file3
```

The outer loop controls the files, while the inner loop controls the lines inside each file.

---

## 2. Variables

Two variables are used:

### FILE

Stores the name of the current file.

Example:

```bash
FILE="Arena_Boss/file$i.txt"
```

Instead of repeatedly typing:

```bash
Arena_Boss/file1.txt
```

the script simply uses:

```bash
"$FILE"
```

### LINES

Stores a random number between 10 and 20.

Example:

```bash
LINES=$((RANDOM % 11 + 10))
```

If Bash chooses 17, then:

```
LINES = 17
```

The inner loop then writes 17 lines into that file.

---

## 3. RANDOM

`RANDOM` is a built-in Bash variable that generates a random number.

The expression:

```bash
RANDOM % 11 + 10
```

works as follows:

* `RANDOM` generates a random number.
* `% 11` limits the result to 0–10.
* `+10` shifts the range to 10–20.

This guarantees every file has between 10 and 20 lines.

---

## 4. seq

Because Bash cannot use a variable inside brace expansion like:

```bash
{1..$LINES}
```

the script uses:

```bash
seq 1 $LINES
```

If:

```
LINES = 15
```

then:

```bash
seq 1 15
```

produces:

```
1
2
3
...
15
```

allowing the loop to run exactly 15 times.

---

## 5. Appending to a File

The script writes to each file using:

```bash
>> "$FILE"
```

`>>` appends text to the end of the file instead of replacing its contents.

---

## 6. Sorting Files by Size

The command:

```bash
find Arena_Boss -type f -exec ls -lh {} + | sort -k 5,5 -h
```

works in stages:

* `find Arena_Boss` → Search inside the directory.
* `-type f` → Only include files.
* `-exec ls -lh {} +` → Display file information including file size.
* `|` → Pass the output to the next command.
* `sort -k 5,5 -h` → Sort by column 5 (the file size) using human-readable sizes.

---

## 7. Searching for a Word

The script checks each file using:

```bash
grep -q "Victory" "$FILE"
```

`grep` searches for text.

The `-q` option means **quiet mode**:

* If the word exists, the command succeeds.
* If the word does not exist, it fails.
* Nothing is printed to the screen.

This makes it ideal inside an `if` statement.

---

## 8. Moving Files

If `grep` finds the word `Victory`, the script runs:

```bash
mv "$FILE" Victory_Archive/
```

which moves the file into the archive directory.

---

## Important Concept I Learned

The variable `FILE` is used in two different ways.

### First loop

I manually assign the variable:

```bash
FILE="Arena_Boss/file$i.txt"
```

### Second loop

```bash
for FILE in Arena_Boss/*.txt
```

Here, the `for` loop automatically assigns `FILE` to each filename one by one.

For example:

```
FILE = Arena_Boss/file1.txt
FILE = Arena_Boss/file2.txt
FILE = Arena_Boss/file3.txt
```

This helped me understand that `for` loops can automatically update a variable on every iteration.

---

# Overall Script Flow

```
Create Arena_Boss

Repeat 5 times

    Create a file

    Generate a random number (10–20)

    Write that many lines into the file

Display all files sorted by size

Create Victory_Archive

For every text file

    Search for the word "Victory"

    If found

        Move the file into Victory_Archive
```

---

# Comparison to the Exam Solution

The exam solution is well structured and uses several important Bash concepts together:

* Variables
* Nested loops
* Random number generation
* `seq`
* `find`
* `sort`
* `grep`
* `mv`

While working through this level, I first focused on creating the files and writing a fixed number of lines before learning how to generate a random number. Breaking the script into small sections made it much easier to understand.

One important improvement to my understanding was recognising the difference between:

* Manually assigning a variable:

```bash
FILE="Arena_Boss/file$i.txt"
```

and allowing a `for` loop to assign it automatically:

```bash
for FILE in Arena_Boss/*.txt
```

Although both use the same variable name, they work differently. The second loop updates the variable automatically as it processes each file, which is an important Bash concept that I now understand.

