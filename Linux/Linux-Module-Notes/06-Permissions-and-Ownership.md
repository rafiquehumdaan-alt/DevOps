# Linux Notes - Part 6: File Permissions & Ownership

> Covers:
>
> - Linux File Permissions
> - Read, Write & Execute
> - Permission Groups
> - Binary, Octal & Symbolic Representation
> - `chmod`
> - Symbolic Operators
> - Numeric Permissions
> - `chown`
> - `chgrp`
> - Best Practices

---

# Why Do File Permissions Matter?

Linux is a multi-user operating system.

Permissions control:

- Who can read a file
- Who can modify a file
- Who can execute a file

This helps protect the operating system and user data.

---

# Viewing Permissions

Use:

```bash
ls -l
```

Example:

```text
-rwxr-xr-- 1 humdaan developers 2048 Aug 7 script.sh
```

The first section represents the file type and permissions.

---

# File Type

The first character indicates the file type.

| Symbol | Meaning |
|---------|----------|
| `-` | Regular file |
| `d` | Directory |
| `l` | Symbolic link |

Example:

```text
drwxr-xr-x
```

The `d` indicates a directory.

---

# Permission Groups

Permissions are split into three groups:

```text
rwx | r-x | r--
```

Which represent:

```text
Owner | Group | Others
```

---

# Read, Write & Execute

Each permission has a specific meaning.

| Permission | Symbol | Value |
|------------|--------|------:|
| Read | `r` | 4 |
| Write | `w` | 2 |
| Execute | `x` | 1 |

---

# Permission Meanings (Files)

| Permission | Meaning |
|------------|---------|
| Read | View the file contents |
| Write | Modify the file |
| Execute | Run the file as a program or script |

---

# Permission Meanings (Directories)

For directories, permissions work slightly differently.

| Permission | Meaning |
|------------|---------|
| Read | List directory contents |
| Write | Create, delete or rename files |
| Execute | Enter (`cd`) the directory |

---

# Binary Representation

Permissions can also be viewed as binary values.

| Permission | Binary | Value |
|------------|--------|------:|
| Read | 100 | 4 |
| Write | 010 | 2 |
| Execute | 001 | 1 |

Combine them to create permission values.

Example:

```text
111

↓

4 + 2 + 1

↓

7
```

---

# Octal Representation

The numeric (octal) system is commonly used with `chmod`.

| Number | Permissions |
|--------:|-------------|
| 7 | rwx |
| 6 | rw- |
| 5 | r-x |
| 4 | r-- |
| 3 | -wx |
| 2 | -w- |
| 1 | --x |
| 0 | --- |

---

# Common Permission Values

| Octal | Symbolic | Meaning |
|-------:|----------|---------|
| 777 | rwxrwxrwx | Everyone has full access |
| 755 | rwxr-xr-x | Owner full access, others read & execute |
| 700 | rwx------ | Owner only |
| 644 | rw-r--r-- | Owner read/write, others read |
| 600 | rw------- | Private file |

---

# Symbolic Representation

Permissions can also be modified using symbols.

| Symbol | Meaning |
|--------|---------|
| `u` | User (Owner) |
| `g` | Group |
| `o` | Others |
| `a` | All users |

---

# Using `chmod`

`chmod` changes file permissions.

Numeric example:

```bash
chmod 755 script.sh
```

Permissions become:

```text
rwxr-xr-x
```

---

# Symbolic Mode

Add execute permission:

```bash
chmod +x script.sh
```

Equivalent to:

```bash
chmod u+x script.sh
```

---

# Remove Write Permission

```bash
chmod g-w notes.txt
```

The group can no longer modify the file.

---

# Grant Read Permission to Others

```bash
chmod o+r notes.txt
```

---

# Multiple Symbolic Changes

```bash
chmod u+rwx,g+rx,o+r script.sh
```

Applies multiple permission changes in a single command.

---

# Making a Script Executable

Before:

```text
-rw-r--r--
```

Run:

```bash
chmod +x script.sh
```

After:

```text
-rwxr-xr-x
```

You can now execute it:

```bash
./script.sh
```

---

# Ownership

Every file has:

- An owner
- A group

View ownership:

```bash
ls -l
```

Example:

```text
-rw-r--r--

humdaan

developers
```

---

# Changing Owner

Use `chown`:

```bash
sudo chown john file.txt
```

The owner becomes:

```text
john
```

---

# Change Owner and Group

```bash
sudo chown john:developers file.txt
```

---

# Changing Group

Use `chgrp`:

```bash
sudo chgrp developers file.txt
```

Only the group changes.

---

# Example Workflow

```text
Create Script

↓

chmod +x script.sh

↓

Run Script

↓

Change Owner

↓

Assign Group
```

---

# Common Mistakes

### Using 777

Avoid:

```bash
chmod 777 file.txt
```

Everyone can read, write and execute the file.

Only use when absolutely necessary (rare).

---

### Forgetting Execute Permission

A script with:

```text
644
```

cannot be executed.

Use:

```bash
chmod +x script.sh
```

---

### Confusing Owner and Group

Changing the owner:

```bash
chown
```

does **not** automatically change the group.

---

# Best Practices

- Use the least privilege necessary.
- Avoid `777`.
- Use `755` for executable scripts and directories.
- Use `644` for most text files.
- Use `600` for sensitive files (e.g. SSH private keys).
- Assign users to groups rather than giving permissions individually.

---

# Key Takeaways

- Linux permissions control access to files and directories.
- Permissions are divided into owner, group and others.
- Read = 4, Write = 2, Execute = 1.
- `chmod` changes permissions.
- `chown` changes ownership.
- `chgrp` changes the group.
- `755` and `644` are the most commonly used permission values.
- Avoid overly permissive settings such as `777`.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `ls -l` | View permissions |
| `chmod 755` | Set numeric permissions |
| `chmod +x` | Make executable |
| `chmod g-w` | Remove group write |
| `chown` | Change owner |
| `chgrp` | Change group |

---

# Permission Values

| Number | Permissions |
|-------:|-------------|
| 7 | rwx |
| 6 | rw- |
| 5 | r-x |
| 4 | r-- |
| 0 | --- |

---

# Interview Questions

### What do Linux file permissions control?

They determine who can read, write or execute a file or directory.

### What do the numbers 755 represent?

- Owner: Read, Write, Execute (`7`)
- Group: Read, Execute (`5`)
- Others: Read, Execute (`5`)

Result:

```text
rwxr-xr-x
```

### What is the difference between `chmod` and `chown`?

`chmod` changes file permissions, while `chown` changes the file owner.

### Why is `chmod 777` discouraged?

Because it grants full read, write and execute permissions to everyone, creating a significant security risk.

### What permission is typically used for executable scripts?

`755`, which gives the owner full access and allows everyone else to read and execute the script.