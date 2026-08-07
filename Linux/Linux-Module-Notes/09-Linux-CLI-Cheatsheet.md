# Linux Notes - Part 9: Linux CLI Cheat Sheet

> A quick-reference guide for the most commonly used Linux commands. This is designed to be used as a revision sheet for interviews, labs and day-to-day DevOps work.

---

# Navigation

| Command | Purpose |
|----------|----------|
| `pwd` | Show current directory |
| `ls` | List files |
| `ls -la` | Long listing with hidden files |
| `cd folder` | Change directory |
| `cd ..` | Move up one directory |
| `cd ~` | Home directory |
| `cd /` | Root directory |
| `cd -` | Previous directory |

---

# File Management

| Command | Purpose |
|----------|----------|
| `touch file.txt` | Create empty file |
| `cat file.txt` | Display file contents |
| `head file.txt` | First 10 lines |
| `tail file.txt` | Last 10 lines |
| `tail -f app.log` | Follow log file |
| `cp file backup` | Copy file |
| `cp -r folder backup` | Copy directory |
| `mv old new` | Move or rename |
| `rm file` | Delete file |
| `rm -r folder` | Delete directory |
| `rm -rf folder` | Force delete directory |

---

# Directories

| Command | Purpose |
|----------|----------|
| `mkdir folder` | Create directory |
| `mkdir -p a/b/c` | Create nested directories |
| `rmdir folder` | Remove empty directory |

---

# Searching

| Command | Purpose |
|----------|----------|
| `find . -name "*.txt"` | Find files |
| `grep "text" file.txt` | Search text |
| `grep -r "text" folder/` | Search recursively |
| `which ls` | Locate executable |

---

# Permissions

| Command | Purpose |
|----------|----------|
| `ls -l` | View permissions |
| `chmod +x script.sh` | Make executable |
| `chmod 755 script.sh` | Set permissions |
| `chmod 644 file.txt` | Typical text file permissions |
| `chown user file` | Change owner |
| `chgrp group file` | Change group |

---

# Users & Groups

| Command | Purpose |
|----------|----------|
| `whoami` | Current user |
| `id` | User & group info |
| `groups` | Show group memberships |
| `sudo command` | Run as administrator |
| `adduser user` | Create user |
| `deluser user` | Delete user |
| `usermod -aG group user` | Add user to group |

---

# Vim

| Command | Purpose |
|----------|----------|
| `vim file.txt` | Open file |
| `i` | Insert mode |
| `Esc` | Normal mode |
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save & quit |
| `:q!` | Quit without saving |
| `dd` | Delete line |
| `yy` | Copy line |
| `p` | Paste |
| `u` | Undo |

---

# Standard Streams

| Command | Purpose |
|----------|----------|
| `>` | Redirect output |
| `>>` | Append output |
| `2>` | Redirect errors |
| `2>>` | Append errors |
| `2>&1` | Redirect stdout & stderr |

---

# Environment Variables

| Command | Purpose |
|----------|----------|
| `printenv` | Show environment variables |
| `env` | Show environment variables |
| `echo $HOME` | Home directory |
| `echo $PATH` | Display PATH |
| `export VAR=value` | Create environment variable |
| `unset VAR` | Remove variable |

---

# Aliases

| Command | Purpose |
|----------|----------|
| `alias` | List aliases |
| `alias ll="ls -la"` | Create alias |
| `unalias ll` | Remove alias |
| `source ~/.bashrc` | Reload Bash config |
| `source ~/.zshrc` | Reload ZSH config |

---

# Processes

| Command | Purpose |
|----------|----------|
| `ps aux` | Running processes |
| `top` | Live process viewer |
| `htop` | Interactive process viewer (if installed) |
| `kill PID` | Stop a process |
| `kill -9 PID` | Force stop a process |

---

# Disk & Memory

| Command | Purpose |
|----------|----------|
| `df -h` | Disk usage |
| `du -sh folder` | Folder size |
| `free -h` | Memory usage |

---

# Networking

| Command | Purpose |
|----------|----------|
| `ip addr` | View IP addresses |
| `ping google.com` | Test connectivity |
| `curl URL` | Make HTTP request |
| `wget URL` | Download file |
| `ssh user@host` | SSH into a server |

---

# Package Management (Ubuntu)

| Command | Purpose |
|----------|----------|
| `sudo apt update` | Update package list |
| `sudo apt upgrade` | Upgrade installed packages |
| `sudo apt install package` | Install package |
| `sudo apt remove package` | Remove package |

---

# Helpful Keyboard Shortcuts

| Shortcut | Purpose |
|-----------|----------|
| `Ctrl + C` | Stop running command |
| `Ctrl + D` | End input / logout |
| `Ctrl + L` | Clear terminal |
| `Ctrl + R` | Search command history |
| `Tab` | Auto-complete |
| `↑` / `↓` | Command history |
| `!!` | Repeat previous command |
| `history` | Show command history |

---

# Common Linux File Permissions

| Permission | Octal |
|------------|------:|
| `rwx` | 7 |
| `rw-` | 6 |
| `r-x` | 5 |
| `r--` | 4 |
| `---` | 0 |

Common combinations:

| Octal | Meaning |
|-------:|---------|
| `755` | Executable scripts & directories |
| `644` | Standard text files |
| `700` | Private directories |
| `600` | Sensitive/private files |

---

# Most Common DevOps Commands

```bash
pwd
ls -la
cd
mkdir
cp
mv
rm
cat
grep
find
chmod
chown
tail -f
ps aux
df -h
free -h
ssh
curl
vim
sudo
```

---

# Linux Troubleshooting Checklist

When something isn't working:

1. Check your current directory.

```bash
pwd
```

2. Confirm the file exists.

```bash
ls -la
```

3. Check permissions.

```bash
ls -l
```

4. Search the logs.

```bash
tail -f logfile.log
```

5. Check running processes.

```bash
ps aux
```

6. Verify disk space.

```bash
df -h
```

7. Check memory usage.

```bash
free -h
```

8. Read the error message carefully before making changes.

---

# DevOps Interview Essentials

Be comfortable explaining:

- Linux directory structure
- Absolute vs relative paths
- File permissions (`755`, `644`)
- Users and groups
- `chmod` vs `chown`
- Standard streams
- Environment variables
- `grep`, `find`, and `tail`
- Process management
- SSH basics
- Common troubleshooting steps

---

# Final Takeaways

- Master navigation before learning advanced topics.
- Understand permissions—they are frequently tested in interviews.
- Learn to troubleshoot using logs instead of guessing.
- Use `man` and `--help` to explore unfamiliar commands.
- Practise daily using the terminal instead of relying on graphical tools.
- Confidence with the Linux CLI is one of the most valuable skills for a DevOps engineer.