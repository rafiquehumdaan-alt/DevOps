# Linux Notes - Part 2: Shells & ZSH

> Covers:
>
> - What is a Shell?
> - How the Shell Works
> - Common Linux Shells
> - Bash
> - ZSH
> - Installing ZSH
> - Changing the Default Shell
> - Shell Configuration Files
> - Bash vs ZSH

---

# What is a Shell?

A **Shell** is a program that acts as an interface between you and the Linux operating system.

It reads the commands you type, passes them to the operating system, and displays the results.

Without a shell, you cannot interact with Linux through the command line.

---

# How the Shell Works

```text
User

↓

Shell

↓

Linux Kernel

↓

Hardware
```

The shell translates your commands into actions that the operating system understands.

---

# Example

You type:

```bash
ls
```

The shell:

1. Finds the `ls` program.
2. Executes it.
3. Displays the output.

---

# What Does the Shell Do?

The shell is responsible for:

- Running commands
- Executing scripts
- Managing environment variables
- Handling input and output
- Expanding variables
- Managing command history
- Tab completion

---

# Common Linux Shells

Linux supports several different shells.

| Shell | Description |
|--------|-------------|
| Bash | Default on many Linux distributions |
| ZSH | Feature-rich shell popular with developers |
| SH | Original Unix shell |
| Fish | User-friendly shell with modern features |
| KSH | Korn Shell |

The two most common are **Bash** and **ZSH**.

---

# Bash

**Bash (Bourne Again Shell)** is the default shell on many Linux systems.

Features:

- Stable
- Widely supported
- Excellent scripting language
- Large community
- Available on almost every Linux distribution

Check your current shell:

```bash
echo $SHELL
```

Example output:

```text
/bin/bash
```

---

# ZSH

**Z Shell (ZSH)** is an enhanced shell with many productivity features.

Benefits include:

- Better tab completion
- Smarter command suggestions
- Improved auto-completion
- Easier navigation
- Better customisation
- Plugin support

Many DevOps engineers and developers prefer ZSH for daily use.

---

# Bash vs ZSH

| Bash | ZSH |
|------|-----|
| Default on many systems | Often installed separately |
| Excellent scripting | Excellent interactive use |
| Basic auto-completion | Advanced auto-completion |
| Fewer built-in features | Rich plugin ecosystem |
| Very stable | Highly customisable |

Both shells can run most of the same commands and scripts.

---

# Installing ZSH

On Ubuntu:

```bash
sudo apt update

sudo apt install zsh
```

Verify the installation:

```bash
zsh --version
```

Example output:

```text
zsh 5.x.x
```

---

# Running ZSH

Start a ZSH session:

```bash
zsh
```

This only switches to ZSH for the current terminal session.

---

# Changing the Default Shell

To make ZSH your permanent default shell:

```bash
chsh -s $(which zsh)
```

You may be asked for your password.

Log out and back in for the change to take effect.

---

# Confirm the Change

Check your current shell:

```bash
echo $SHELL
```

Expected output:

```text
/bin/zsh
```

---

# If the Change Doesn't Apply

Sometimes the terminal still starts Bash.

Possible solutions:

- Log out and log back in.
- Restart the terminal.
- Restart your computer.
- Check that ZSH is listed in `/etc/shells`.

View available shells:

```bash
cat /etc/shells
```

---

# Shell Configuration Files

Each shell has configuration files that run when a terminal starts.

### Bash

```text
~/.bashrc
```

### ZSH

```text
~/.zshrc
```

These files are commonly used to:

- Create aliases
- Modify the PATH
- Set environment variables
- Customise the prompt

---

# Reloading Configuration

After editing `.bashrc`:

```bash
source ~/.bashrc
```

After editing `.zshrc`:

```bash
source ~/.zshrc
```

This applies changes without opening a new terminal.

---

# Aliases

Aliases create shortcuts for frequently used commands.

Example:

```bash
alias ll="ls -la"
```

Now:

```bash
ll
```

runs:

```bash
ls -la
```

Aliases are usually stored in `.bashrc` or `.zshrc`.

---

# Why Developers Use ZSH

ZSH improves productivity with features such as:

- Intelligent tab completion
- Command auto-suggestions (with plugins)
- Syntax highlighting (with plugins)
- Better history search
- Custom prompts (e.g. Oh My Zsh)

These features make working in the terminal faster and more convenient.

---

# Real Example

```text
Open Terminal

↓

ZSH Starts

↓

Load ~/.zshrc

↓

Aliases Loaded

↓

PATH Updated

↓

Ready for Commands
```

---

# Common Mistakes

### Forgetting to Reload the Configuration

After editing:

```text
~/.zshrc
```

Run:

```bash
source ~/.zshrc
```

Otherwise, changes won't take effect until a new terminal session starts.

---

### Confusing Bash and ZSH Files

Changes made to:

```text
.bashrc
```

do **not** automatically apply to ZSH.

ZSH uses:

```text
.zshrc
```

---

### Assuming ZSH is Installed

Some systems only have Bash installed.

Check first:

```bash
zsh --version
```

---

# Best Practices

- Learn Bash first, as it is widely supported.
- Use ZSH for a more productive interactive experience.
- Keep your shell configuration files organised.
- Store aliases in `.bashrc` or `.zshrc`.
- Avoid adding unnecessary plugins that slow startup.

---

# Key Takeaways

- A shell provides the command-line interface to Linux.
- Bash is the traditional default shell.
- ZSH offers enhanced features and customisation.
- `chsh` changes your default shell.
- `.bashrc` and `.zshrc` store shell configuration.
- `source` reloads configuration files without restarting the terminal.
- Aliases help simplify frequently used commands.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `echo $SHELL` | Display current shell |
| `zsh` | Start a ZSH session |
| `zsh --version` | Show ZSH version |
| `which zsh` | Locate ZSH executable |
| `chsh -s $(which zsh)` | Change default shell |
| `source ~/.bashrc` | Reload Bash configuration |
| `source ~/.zshrc` | Reload ZSH configuration |
| `cat /etc/shells` | View available login shells |

---

# Interview Questions

### What is a shell?

A shell is a command-line interpreter that accepts user commands, executes programs and provides an interface to the Linux operating system.

### What is the difference between Bash and ZSH?

Bash is the traditional default shell, while ZSH provides additional features such as improved auto-completion, customisation and plugin support.

### How do you check your current shell?

```bash
echo $SHELL
```

### How do you permanently change your default shell to ZSH?

```bash
chsh -s $(which zsh)
```

### What is the purpose of `.bashrc` and `.zshrc`?

These configuration files customise the shell environment by storing aliases, environment variables, PATH changes and other startup settings.