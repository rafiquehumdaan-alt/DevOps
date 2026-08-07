# Bash Notes - Part 8: Working with Files

> Covers:
>
> - Reading Files
> - Writing Files
> - Appending to Files
> - File Checksums
> - Verifying File Integrity
> - Best Practices

---

# Working with Files

One of the most common tasks in Bash is reading from and writing to files.

Typical use cases include:

- Reading configuration files
- Processing log files
- Creating backups
- Writing reports
- Verifying downloaded files

---

# Reading Files

There are several ways to read a file.

---

# Using `cat`

Displays the entire contents of a file.

Example:

```bash
cat notes.txt
```

Output:

```text
AWS Notes
Linux Notes
Bash Notes
```

Best for small files.

---

# Using `less`

Displays one page at a time.

```bash
less largefile.log
```

Useful for:

- Large log files
- Configuration files

Controls:

- **Space** → Next page
- **b** → Previous page
- **q** → Quit

---

# Using `head`

Displays the first 10 lines.

```bash
head notes.txt
```

Custom number of lines:

```bash
head -5 notes.txt
```

---

# Using `tail`

Displays the last 10 lines.

```bash
tail notes.txt
```

Example:

```bash
tail -20 logfile.log
```

---

# Live Log Monitoring

Monitor a file as it grows.

```bash
tail -f logfile.log
```

Useful for:

- Web server logs
- Application logs
- System logs

Stop with:

```
Ctrl + C
```

---

# Reading Line by Line

Example:

```bash
while read line
do
    echo "$line"
done < notes.txt
```

Output:

```text
Line 1
Line 2
Line 3
```

This is commonly used in Bash scripts to process files.

---

# Writing Files

Create or overwrite a file using:

```bash
echo "Hello" > notes.txt
```

Contents:

```text
Hello
```

If the file already exists, it is overwritten.

---

# Appending to Files

Use:

```bash
echo "Second Line" >> notes.txt
```

Contents:

```text
Hello
Second Line
```

The existing file is preserved.

---

# Writing Multiple Lines

Example:

```bash
cat <<EOF > notes.txt
Line One
Line Two
Line Three
EOF
```

This technique is called a **Here Document (Heredoc)**.

Useful for:

- Creating configuration files
- Multi-line output
- Scripts

---

# File Checksums

A checksum is a unique value generated from a file.

If the file changes, the checksum also changes.

Checksums are used to verify:

- Downloads
- Backups
- File integrity

---

# Common Checksum Algorithms

| Command | Algorithm |
|----------|-----------|
| `md5sum` | MD5 |
| `sha1sum` | SHA-1 |
| `sha256sum` | SHA-256 |
| `sha512sum` | SHA-512 |

**SHA-256** is commonly used today because it is much more secure than MD5 or SHA-1.

---

# Generating a Checksum

Example:

```bash
sha256sum ubuntu.iso
```

Output:

```text
8f6d4b...

ubuntu.iso
```

---

# Verifying a Download

Suppose Ubuntu publishes this checksum:

```text
8f6d4b...
```

After downloading:

```bash
sha256sum ubuntu.iso
```

If the values match:

✅ File is authentic.

If they differ:

❌ The file may be corrupted or modified.

---

# Real Example

```bash
sha256sum backup.tar.gz
```

Save the checksum:

```bash
sha256sum backup.tar.gz > backup.sha256
```

Later verify it:

```bash
sha256sum -c backup.sha256
```

Output:

```text
backup.tar.gz: OK
```

---

# Why Checksums Matter

Checksums help detect:

- Corrupted downloads
- Accidental file changes
- Tampering
- Backup errors

They are commonly used in:

- Linux ISO downloads
- Software releases
- CI/CD pipelines
- Backup verification

---

# Example Workflow

```text
Download File

↓

Generate SHA-256

↓

Compare With Official Checksum

↓

Match?

│

├── Yes → Safe

└── No → Download Again
```

---

# Useful File Commands

| Command | Purpose |
|----------|----------|
| `cat` | Display file contents |
| `less` | View large files |
| `head` | First lines |
| `tail` | Last lines |
| `tail -f` | Follow file changes |
| `echo >` | Overwrite file |
| `echo >>` | Append to file |
| `sha256sum` | Generate SHA-256 checksum |

---

# Common Mistakes

### Accidentally Overwriting Files

Incorrect:

```bash
echo "New Data" > important.txt
```

This deletes the previous contents.

If you want to keep existing data, use:

```bash
echo "New Data" >> important.txt
```

---

### Using `cat` on Huge Files

Avoid:

```bash
cat huge.log
```

Instead use:

```bash
less huge.log
```

or

```bash
tail -f huge.log
```

---

### Trusting Downloads

Always verify important downloads using the published SHA-256 checksum.

---

# Best Practices

- Use `less` for large files.
- Use `tail -f` when monitoring logs.
- Use `>>` if you want to keep existing file contents.
- Verify important downloads with SHA-256.
- Store checksum files alongside backups.
- Read files line by line when processing them in scripts.

---

# Key Takeaways

- `cat` displays file contents.
- `head` shows the beginning of a file.
- `tail` shows the end of a file.
- `tail -f` monitors live log files.
- `>` overwrites files.
- `>>` appends to files.
- Checksums verify file integrity.
- SHA-256 is the preferred checksum algorithm for verifying downloads.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `cat` | Display file |
| `less` | View large file |
| `head` | First 10 lines |
| `tail` | Last 10 lines |
| `tail -f` | Live log monitoring |
| `>` | Overwrite file |
| `>>` | Append to file |
| `sha256sum` | Generate SHA-256 checksum |
| `sha256sum -c` | Verify checksum |

---

# Interview Questions

### What is the difference between `cat` and `less`?

`cat` displays the entire file at once, while `less` allows you to scroll through large files page by page.

### When would you use `tail -f`?

To monitor a log file in real time as new lines are added.

### What is the difference between `>` and `>>`?

`>` overwrites a file, while `>>` appends new content to the end of the file.

### What is a checksum?

A unique value generated from a file that can be used to verify its integrity.

### Why is SHA-256 commonly used?

Because it provides a secure way to verify that files have not been corrupted or modified.