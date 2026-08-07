# Level X: Basic Arithmetic Calculator

## Mission

Create a Bash script that:

* Prompts the user for two numbers.
* Performs addition, subtraction, multiplication, and division.
* Displays the results.
* Handles division by zero safely.

---

# Concepts Learned

## 1. Reading User Input

The `read` command pauses the script and waits for the user to type something. Whatever the user types is stored in a variable.

Example:

```bash
echo "Enter first number:"
read NUM1
```

If the user types:

```text
10
```

Then Bash stores:

```text
NUM1=10
```

The same applies for the second number:

```bash
echo "Enter second number:"
read NUM2
```

If the user enters:

```text
5
```

Then:

```text
NUM2=5
```

Think of `read` as asking the user for information and saving their answer inside a variable.

---

## 2. Variables

Variables store data so it can be reused later in the script.

Example:

```bash
NUM1=10
NUM2=5
```

Instead of typing `10` and `5` everywhere, we simply use `NUM1` and `NUM2`.

---

## 3. Arithmetic Expansion

Bash performs mathematical calculations using:

```bash
$(( ))
```

Everything inside these brackets is treated as a calculation.

Examples:

```bash
SUM=$((NUM1 + NUM2))
DIFFERENCE=$((NUM1 - NUM2))
PRODUCT=$((NUM1 * NUM2))
DIVISION=$((NUM1 / NUM2))
```

Operators:

| Operator | Meaning        |
| -------- | -------------- |
| `+`      | Addition       |
| `-`      | Subtraction    |
| `*`      | Multiplication |
| `/`      | Division       |

Example:

```bash
NUM1=10
NUM2=5

SUM=$((NUM1 + NUM2))
```

Bash calculates:

```text
10 + 5
```

and stores:

```text
SUM=15
```

Without `$(( ))`, Bash would treat the expression as plain text instead of doing the maths.

---

## 4. Displaying Variables

Variables are displayed using the `$` symbol.

Example:

```bash
echo "$NUM1 + $NUM2 = $SUM"
```

Output:

```text
10 + 5 = 15
```

Bash replaces every variable with its stored value before printing it.

---

## 5. Numeric Comparisons

When comparing numbers inside an `if` statement, use numeric comparison operators.

Example:

```bash
if [ "$NUM2" -eq 0 ]; then
```

`-eq` means **equal to**.

Other useful numeric operators:

| Operator | Meaning               |
| -------- | --------------------- |
| `-eq`    | Equal to              |
| `-ne`    | Not equal             |
| `-gt`    | Greater than          |
| `-lt`    | Less than             |
| `-ge`    | Greater than or equal |
| `-le`    | Less than or equal    |

---

## 6. Handling Division by Zero

Dividing by zero is impossible and causes Bash to produce an error.

Instead of immediately doing:

```bash
DIVISION=$((NUM1 / NUM2))
```

we first check:

```bash
if [ "$NUM2" -eq 0 ]; then
    echo "Cannot divide by zero."
else
    DIVISION=$((NUM1 / NUM2))
    echo "$NUM1 ÷ $NUM2 = $DIVISION"
fi
```

If the second number is zero, the script skips the division and displays a friendly message instead of crashing.

---

## 7. Why We Used `if` Instead of `case`

This script only has one decision to make:

> Is the second number equal to zero?

That is a **yes/no** question, making `if` the correct choice.

`case` is used when choosing between multiple options, such as a menu.

Example:

```bash
case $choice in
    1)
        echo "Addition"
        ;;
    2)
        echo "Subtraction"
        ;;
    3)
        echo "Multiplication"
        ;;
    4)
        echo "Division"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
```

### Easy Rule to Remember

* **`if`** = Yes/No decision.
* **`case`** = Multiple choices.

---

# Example Output

If the user enters:

```text
10
5
```

The output will be:

```text
Enter first number:
10

Enter second number:
5

Results:
10 + 5 = 15
10 - 5 = 5
10 × 5 = 50
10 ÷ 5 = 2
```

If the user enters:

```text
10
0
```

The output becomes:

```text
Enter first number:
10

Enter second number:
0

Results:
10 + 0 = 10
10 - 0 = 10
10 × 0 = 0
Cannot divide by zero.
```

---

# Final Script

```bash
#!/bin/bash

echo "Enter first number:"
read NUM1

echo "Enter second number:"
read NUM2

SUM=$((NUM1 + NUM2))
DIFFERENCE=$((NUM1 - NUM2))
PRODUCT=$((NUM1 * NUM2))

echo
echo "Results:"
echo "$NUM1 + $NUM2 = $SUM"
echo "$NUM1 - $NUM2 = $DIFFERENCE"
echo "$NUM1 × $NUM2 = $PRODUCT"

if [ "$NUM2" -eq 0 ]; then
    echo "Cannot divide by zero."
else
    DIVISION=$((NUM1 / NUM2))
    echo "$NUM1 ÷ $NUM2 = $DIVISION"
fi
```

---

# Key Takeaways

* `read` waits for user input and stores it in a variable.
* Variables allow values to be reused throughout a script.
* `$(( ))` performs arithmetic calculations in Bash.
* `$VARIABLE` retrieves the value stored inside a variable.
* `echo` prints text and variables to the terminal.
* `if` is used for yes/no decisions.
* `case` is used when selecting between multiple choices.
* Always validate user input before performing operations that could fail, such as division by zero.
* A common Bash scripting workflow is:

1. Read input.
2. Store it in variables.
3. Process the data.
4. Validate the data.
5. Display the results.

