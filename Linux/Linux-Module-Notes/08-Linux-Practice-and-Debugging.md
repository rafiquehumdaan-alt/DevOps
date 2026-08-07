# Linux Notes - Part 8: Linux Practice & Debugging

> Covers:
>
> - OverTheWire Bandit
> - SadServers
> - Linux Troubleshooting
> - Debugging Mindset
> - Common Linux Interview Tasks
> - Best Practices

---

# Why Practice Linux?

Reading Linux commands is useful, but real learning comes from solving problems.

Platforms such as **OverTheWire Bandit** and **SadServers** provide realistic scenarios that improve:

- Command-line confidence
- Troubleshooting skills
- Problem-solving
- DevOps readiness

---

# OverTheWire Bandit

Bandit is a free Linux wargame that teaches command-line skills through progressively harder levels.

Each level requires you to use Linux commands to find the password for the next level.

Skills covered include:

- File navigation
- Searching files
- Permissions
- Hidden files
- SSH
- Compression
- Networking
- Scripting

Bandit is excellent for beginners.

---

# Example Bandit Workflow

```text
Read Challenge

↓

Investigate Files

↓

Use Linux Commands

↓

Find Password

↓

Login to Next Level
```

---

# Useful Commands in Bandit

| Command | Purpose |
|----------|----------|
| `ls` | List files |
| `pwd` | Current directory |
| `cd` | Change directory |
| `cat` | View files |
| `find` | Search for files |
| `grep` | Search text |
| `file` | Identify file type |
| `strings` | Extract readable text |
| `ssh` | Remote login |

---

# SadServers

SadServers provides broken Linux servers that must be fixed.

Instead of solving puzzles, you troubleshoot real system issues.

Typical problems include:

- Web servers not starting
- Services failing
- Full disks
- Broken networking
- Incorrect permissions
- Configuration errors

This closely resembles real DevOps work.

---

# Typical Debugging Process

```text
Problem Reported

↓

Investigate

↓

Identify Root Cause

↓

Apply Fix

↓

Verify Solution
```

---

# The Debugging Mindset

When something is broken:

1. **Don't panic.**
2. Read the error message carefully.
3. Reproduce the issue.
4. Gather information.
5. Test one fix at a time.
6. Verify the solution.

Avoid making multiple changes at once, as it becomes difficult to identify what actually fixed the issue.

---

# Common Debugging Commands

View current directory:

```bash
pwd
```

List files:

```bash
ls -la
```

Check file contents:

```bash
cat file.txt
```

View logs:

```bash
tail -f logfile.log
```

Search for errors:

```bash
grep "error" logfile.log
```

Check running processes:

```bash
ps aux
```

Check disk space:

```bash
df -h
```

Check memory usage:

```bash
free -h
```

---

# Finding Files

Search by name:

```bash
find / -name "config.yml"
```

Search by extension:

```bash
find . -name "*.log"
```

Very useful when troubleshooting unknown file locations.

---

# Checking Permissions

View permissions:

```bash
ls -l
```

If a script cannot run:

```bash
chmod +x script.sh
```

---

# Reading Log Files

Many problems can be diagnosed by checking logs.

Useful commands:

```bash
tail -50 app.log
```

```bash
grep ERROR app.log
```

```bash
less app.log
```

Logs are often stored in:

```text
/var/log
```

---

# SSH Troubleshooting

Test a connection:

```bash
ssh user@server
```

Common issues:

- Wrong username
- Incorrect key
- Firewall blocking port 22
- SSH service not running

---

# Thinking Like a DevOps Engineer

Instead of guessing:

❌ Restart everything.

Try to understand:

- What changed?
- What failed?
- What evidence supports your conclusion?

Good troubleshooting is evidence-based.

---

# Common Linux Interview Tasks

You may be asked to:

- Navigate the filesystem.
- Find a specific file.
- Search a log file.
- Change permissions.
- Create users.
- Compress files.
- Edit configuration files.
- Explain file permissions.
- Write a simple Bash script.
- Debug a broken command.

These tasks assess practical Linux knowledge rather than memorisation.

---

# Debugging Checklist

When something doesn't work:

- Check the error message.
- Verify the current directory (`pwd`).
- Confirm the file exists (`ls`, `find`).
- Check permissions (`ls -l`).
- Read the logs (`tail`, `grep`, `less`).
- Verify processes (`ps aux`).
- Check disk space (`df -h`).
- Confirm environment variables if needed (`printenv`).

---

# Common Mistakes

### Ignoring Error Messages

Linux often tells you exactly what is wrong.

Read the full error before trying random fixes.

---

### Changing Too Many Things

Make one change at a time.

Test after each change.

---

### Not Checking Logs

Logs usually provide the fastest route to identifying the root cause.

Always check them before guessing.

---

# Best Practices

- Practise Linux daily.
- Use Bandit to learn commands.
- Use SadServers to build troubleshooting skills.
- Read logs before making changes.
- Understand the root cause instead of applying random fixes.
- Develop a systematic debugging process.

---

# Key Takeaways

- Practical experience is essential for learning Linux.
- OverTheWire Bandit teaches command-line fundamentals.
- SadServers simulates real-world troubleshooting.
- Good debugging follows a structured process.
- Linux logs are one of the most valuable troubleshooting resources.
- Most DevOps interviews include practical Linux questions.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `find` | Search for files |
| `grep` | Search text |
| `tail -f` | Monitor logs |
| `less` | Read large files |
| `ps aux` | View running processes |
| `df -h` | Disk usage |
| `free -h` | Memory usage |
| `ssh` | Connect to remote server |
| `ls -l` | View permissions |

---

# Interview Questions

### Why is OverTheWire Bandit useful?

It teaches practical Linux command-line skills through progressively challenging exercises.

### What is SadServers?

SadServers is a platform that provides intentionally broken Linux servers, allowing users to practise real-world troubleshooting.

### What should you do first when debugging a Linux issue?

Read the error message carefully and gather information before making any changes.

### Why are log files important?

Logs provide detailed information about application and system events, making them one of the most valuable tools for diagnosing problems.

### What is the most important debugging principle?

Work methodically—collect evidence, change one thing at a time, and verify each fix before moving on.