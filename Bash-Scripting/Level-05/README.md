# Level 5: The Boss Battle – Combining the Basics

## Mission

Write a Bash script that:

1. Creates a directory named `Battlefield`.
2. Inside `Battlefield`, creates the files:

   * `knight.txt`
   * `sorcerer.txt`
   * `rogue.txt`
3. Checks if `knight.txt` exists and, if it does, moves it to a new directory called `Archive`.
4. Lists the contents of both `Battlefield` and `Archive`.

---

# Official Solution

```bash
#!/bin/bash

mkdir Battlefield

touch Battlefield/knight.txt Battlefield/sorcerer.txt Battlefield/rogue.txt

if [ -f "Battlefield/knight.txt" ]; then
    mkdir -p Archive
    mv Battlefield/knight.txt Archive/
    echo "knight.txt has been moved to Archive."
else
    echo "knight.txt not found."
fi

echo "Contents of Battlefield:"
ls Battlefield

echo "Contents of Archive:"
ls Archive
```

---

# What I Learned

This level was a "boss battle" that combined everything learned so far into one script.

## Creating Multiple Files

`touch` can create several files at once:

```bash
touch Battlefield/knight.txt Battlefield/sorcerer.txt Battlefield/rogue.txt
```

This is shorter and cleaner than running `touch` multiple times.

---

## Working with File Paths

Instead of changing into a directory using `cd`, you can specify the full path to a file:

```bash
Battlefield/knight.txt
```

Using full paths makes it clear exactly where Bash is working.

---

## Checking if a File Exists

The `-f` test checks whether a regular file exists.

```bash
if [ -f "Battlefield/knight.txt" ]; then
```

If the file exists, the commands inside the `if` block are executed.

---

## Moving Files

The `mv` command moves a file from one location to another.

```bash
mv Battlefield/knight.txt Archive/
```

After this command, `knight.txt` is no longer in `Battlefield`; it now exists inside `Archive`.

---

## Creating Directories Safely

Instead of:

```bash
mkdir Archive
```

the script uses:

```bash
mkdir -p Archive
```

The `-p` option means:

* Create the directory if it doesn't already exist.
* Do nothing if it already exists.

This allows the script to be run multiple times without producing errors.

---

## Using `echo`

`echo` is not required for the script to work, but it provides useful feedback.

Example:

```bash
echo "knight.txt has been moved to Archive."
```

This tells the user exactly what happened.

---

## Quoting File Paths

The official solution writes:

```bash
[ -f "Battlefield/knight.txt" ]
```

instead of:

```bash
[ -f Battlefield/knight.txt ]
```

Although both work here, quoting file paths is considered good practice because it prevents problems if a filename contains spaces or special characters.

---

# Key Takeaways

* Combine multiple Bash concepts into a single script.
* Create multiple files with one `touch` command.
* Check whether files exist using `-f`.
* Move files with `mv`.
* Use full file paths instead of changing directories where possible.
* Use `mkdir -p` to safely create directories.
* Use `echo` to provide clear feedback.
* Quote file paths as a good Bash practice.

---

# My First Attempt

Before seeing the official solution, I wrote the following script:

```bash
#!/bin/bash

mkdir Battlefield Archive

cd Battlefield

touch knight.txt sorcerer.txt rogue.txt

if [ -f knight.txt ]; then
    mv knight.txt ../Archive/
fi

cd ..

ls Battlefield
ls Archive
```

This script successfully completed the mission by:

* Creating both directories.
* Creating all three files.
* Checking if `knight.txt` existed.
* Moving it into `Archive`.
* Listing the contents of both directories.

However, comparing it to the official solution highlighted several improvements.

### Why the Official Solution is Better

**1. It avoids using `cd`**

My solution changed into `Battlefield` before working with the files.

The official solution always uses full paths such as:

```bash
Battlefield/knight.txt
```

This makes scripts easier to read and avoids mistakes caused by being in the wrong directory.

---

**2. It creates `Archive` only when needed**

Instead of creating `Archive` immediately, the official solution creates it only if `knight.txt` exists and needs to be moved.

It also uses:

```bash
mkdir -p Archive
```

which safely handles the case where the directory already exists.

---

**3. It provides feedback**

The official solution tells the user what happened:

```bash
echo "knight.txt has been moved to Archive."
```

or

```bash
echo "knight.txt not found."
```

This makes scripts much easier to understand and debug.

---

**4. It follows common Bash best practices**

Using full paths, quoting file names, avoiding unnecessary directory changes, and creating directories safely are habits commonly seen in production Bash scripts and DevOps automation.

Although my solution was correct and completed the mission, the official solution is cleaner, more robust, and scales better as scripts become more complex.

