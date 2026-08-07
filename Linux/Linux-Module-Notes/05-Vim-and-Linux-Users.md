# Linux Notes - Part 5: Vim & Linux Users

> Covers:
>
> - Vim Text Editor
> - Vim Modes
> - Navigation
> - Editing Files
> - Saving & Quitting
> - `sudo`
> - Root User
> - Linux Users
> - Linux Groups

---

# What is Vim?

**Vim (Vi Improved)** is one of the most popular text editors on Linux.

Unlike graphical editors, Vim runs entirely in the terminal.

It is commonly used by:

- Linux Administrators
- DevOps Engineers
- Cloud Engineers
- Software Developers

You'll often use Vim when connected to remote Linux servers via SSH.

---

# Opening a File

Create or open a file:

```bash
vim notes.txt
```

If the file doesn't exist, Vim creates it when you save.

---

# Vim Modes

Vim operates in different modes.

```text
Normal Mode

↓

Insert Mode

↓

Normal Mode

↓

Command Mode
```

Each mode serves a different purpose.

---

# Normal Mode

This is the default mode.

You can:

- Navigate
- Copy
- Delete
- Paste
- Search

Typing letters does **not** insert text.

---

# Insert Mode

Insert Mode allows you to type text.

Press:

```text
i
```

to enter Insert Mode.

Type normally.

To return to Normal Mode:

```
Esc
```

---

# Common Insert Commands

| Key | Action |
|------|---------|
| `i` | Insert before cursor |
| `I` | Insert at beginning of line |
| `a` | Append after cursor |
| `A` | Append at end of line |
| `o` | Open new line below |
| `O` | Open new line above |

---

# Navigation

Move using the arrow keys or Vim keys:

| Key | Direction |
|------|-----------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |

These keys are commonly used by experienced Vim users.

---

# Jumping Around

Go to the beginning of a line:

```text
0
```

Go to the end:

```text
$
```

Go to the first line:

```text
gg
```

Go to the last line:

```text
G
```

---

# Deleting Text

Delete one character:

```text
x
```

Delete one line:

```text
dd
```

Delete multiple lines:

```text
5dd
```

Deletes five lines.

---

# Copy & Paste

Copy one line:

```text
yy
```

Paste below:

```text
p
```

Paste above:

```text
P
```

---

# Undo & Redo

Undo:

```text
u
```

Redo:

```text
Ctrl + r
```

---

# Searching

Search for text:

```text
/search
```

Example:

```text
/database
```

Move through results:

```text
n
```

Previous match:

```text
N
```

---

# Saving Files

From Normal Mode:

```text
:w
```

Save and continue editing.

---

# Save & Quit

```text
:wq
```

or

```text
:x
```

---

# Quit Without Saving

```text
:q!
```

Useful if you've made unwanted changes.

---

# Vim Workflow

```text
Open File

↓

Insert Mode

↓

Edit

↓

Esc

↓

:wq

↓

Saved
```

---

# What is `sudo`?

`sudo` stands for:

```text
Superuser Do
```

It allows a normal user to execute commands with administrative (root) privileges.

Example:

```bash
sudo apt update
```

---

# Why Use `sudo`?

Many system operations require administrator permissions.

Examples:

- Installing software
- Updating packages
- Editing system files
- Managing users

---

# The Root User

Linux has a special administrator account called:

```text
root
```

The root user has unrestricted access to the system.

Example:

```bash
sudo su
```

Switches to the root shell.

Exit the root shell:

```bash
exit
```

---

# Why Be Careful with Root?

Commands run as root can:

- Delete system files
- Break the operating system
- Remove user data

Always double-check commands before running them with `sudo`.

---

# Linux Users

Every person using Linux has a user account.

View your username:

```bash
whoami
```

Example output:

```text
humdaan
```

View the current user ID:

```bash
id
```

Example:

```text
uid=1000(humdaan)
gid=1000(humdaan)
groups=1000(humdaan),27(sudo)
```

---

# Creating Users

Create a user:

```bash
sudo adduser alice
```

The system will prompt you to:

- Set a password
- Enter optional user information

---

# Switching Users

Switch to another user:

```bash
su alice
```

Return to your own account:

```bash
exit
```

---

# Linux Groups

Groups simplify permission management.

Example:

```text
Developers

↓

Alice

Bob

Charlie
```

Permissions can be assigned to the group instead of each individual user.

---

# Viewing Groups

Show your groups:

```bash
groups
```

Example output:

```text
humdaan sudo docker
```

---

# Adding a User to a Group

Example:

```bash
sudo usermod -aG docker humdaan
```

Options:

- `-a` → Append
- `-G` → Secondary group

This allows the user to run Docker commands without using `sudo` (after logging out and back in).

---

# Example Workflow

```text
Create User

↓

Assign Groups

↓

Use sudo

↓

Edit Files with Vim

↓

Save

↓

Exit
```

---

# Common Mistakes

### Forgetting to Leave Insert Mode

If Vim behaves unexpectedly, press:

```
Esc
```

to return to Normal Mode.

---

### Closing Without Saving

Remember:

```text
:wq
```

to save your changes before quitting.

---

### Running Everything with `sudo`

Only use `sudo` when necessary.

Running commands as root increases the risk of accidental system damage.

---

# Best Practices

- Learn the basic Vim commands—they are widely used on Linux servers.
- Use `sudo` only when required.
- Avoid logging in directly as the root user.
- Use groups to manage permissions instead of granting root access.
- Verify commands before executing them with elevated privileges.

---

# Key Takeaways

- Vim is a terminal-based text editor commonly used on Linux systems.
- Vim has different modes for editing and navigation.
- `sudo` allows users to run commands with administrator privileges.
- The root user has unrestricted access to the system.
- Linux uses users and groups to manage access and permissions.
- Groups simplify permission management across multiple users.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `vim file.txt` | Open a file in Vim |
| `i` | Enter Insert Mode |
| `Esc` | Return to Normal Mode |
| `:w` | Save |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `whoami` | Show current user |
| `id` | Show user and group IDs |
| `groups` | Show group membership |
| `sudo` | Run command as administrator |
| `sudo adduser` | Create a new user |
| `sudo usermod -aG` | Add user to a group |

---

# Interview Questions

### What is Vim?

Vim is a powerful terminal-based text editor commonly used for editing files on Linux systems and remote servers.

### What is the purpose of `sudo`?

`sudo` allows a permitted user to execute commands with administrative (root) privileges.

### Who is the root user?

The root user is the Linux superuser with unrestricted access to the entire system.

### Why are Linux groups useful?

Groups make it easier to manage permissions by assigning access rights to multiple users at once.

### How do you save and quit in Vim?

Enter Normal Mode by pressing `Esc`, then type:

```text
:wq
```

and press **Enter**.