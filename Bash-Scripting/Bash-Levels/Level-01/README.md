# Level 01 - The Basics

## Mission

Create a directory named `Arena`. Inside the directory, create three files:

* `warrior.txt`
* `mage.txt`
* `archer.txt`

Finally, list the contents of the `Arena` directory.

---

## My Approach

1. Created the `Arena` directory.
2. Changed into the `Arena` directory.
3. Created the three required text files.
4. Listed the contents of the directory to verify that the files had been created successfully.

---

## Script Used

See `script.sh`.

---

## Expected Output

```text
archer.txt
mage.txt
warrior.txt
```

*(The order may vary depending on your system settings.)*

---

## What I Learned

* A Bash script should begin with the shebang:

  ```bash
  #!/bin/bash
  ```

* `mkdir` creates a new directory.

* `cd` changes the current working directory.

* `touch` creates empty files.

* `ls` lists the contents of the current directory.

* Most Linux commands work relative to the **current working directory**.

* The `pwd` command displays the current working directory and is useful for checking where commands will be executed.

* A script runs commands from the directory it is executed in unless an absolute or relative path is specified.

---

## Reflection

This level reinforced the importance of understanding the current working directory. I learned that creating a directory does **not** automatically move me into it. I had to use `cd Arena` before creating the files so that they were placed inside the correct directory.

