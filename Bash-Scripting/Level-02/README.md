# Level 2: Variables and Loops

## Objective

Create a Bash script that prints the numbers **1 to 10**, with each number displayed on a new line.

## Key Concepts

### Shebang

Every Bash script should begin with:

```bash
#!/bin/bash
```

The **shebang** tells Linux to execute the script using the **Bash interpreter**.

---

### Variables

A **variable** is a named container used to store data that can be accessed or changed throughout a script.

Example:

```bash
name="Humdaan"
```

Variables are referenced using the `$` symbol.

```bash
echo "$name"
```

Output:

```text
Humdaan
```

In this level, the variable is `i`.

As the loop runs, `i` automatically changes value:

```text
i = 1
i = 2
i = 3
...
i = 10
```

---

### For Loops

A **for loop** repeats a block of code for every item in a sequence.

Example:

```bash
for i in {1..10}
```

This means:

> For each number from **1** to **10**, store the current number inside the variable `i`.

---

### The `do` and `done` Keywords

A loop body begins with:

```bash
do
```

and finishes with:

```bash
done
```

Everything between these two keywords is repeated for every iteration of the loop.

---

### Printing the Variable

Inside the loop:

```bash
echo "$i"
```

`echo` prints the current value stored inside the variable `i`.

During execution, Bash performs something similar to:

```text
Iteration 1
i = 1
echo "$i"

Iteration 2
i = 2
echo "$i"

Iteration 3
i = 3
echo "$i"

...

Iteration 10
i = 10
echo "$i"
```

Result:

```text
1
2
3
4
5
6
7
8
9
10
```

---

## Complete Script

```bash
#!/bin/bash

for i in {1..10}
do
    echo "$i"
done
```

---

## Summary

In this level I learned:

* Why every Bash script starts with a **shebang**.
* How variables temporarily store values.
* How a **for loop** repeats code automatically.
* That the loop variable (`i`) changes automatically on each iteration.
* How `do` begins the loop body and `done` ends it.
* How `echo "$i"` prints the current value of the loop variable.
* How loops remove the need to write the same command multiple times, making scripts shorter, cleaner, and easier to maintain.

