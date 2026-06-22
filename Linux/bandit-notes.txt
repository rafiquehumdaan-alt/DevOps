# OverTheWire Bandit - Level Notes

## Level 0 → 1

Concept: SSH login

Commands:

* ssh

Learned:

* How to connect to a remote Linux system.

---

## Level 1 → 2

Concept: Files with unusual names

Commands:

* cat

Learned:

* How to read files whose names contain special characters.

---

## Level 2 → 3

Concept: Filenames with spaces

Commands:

* cat

Learned:

* How to escape spaces and quote filenames.

---

## Level 3 → 4

Concept: Hidden files

Commands:

* ls -la

Learned:

* Hidden files begin with a dot (.).

---

## Level 4 → 5

Concept: Identifying file types

Commands:

* file

Learned:

* How to determine the type of a file before opening it.

---

## Level 5 → 6

Concept: Finding files

Commands:

* find

Learned:

* Searching for files by size, ownership and permissions.

---

## Level 6 → 7

Concept: Searching system-wide

Commands:

* find
* 2>/dev/null

Learned:

* Redirecting errors and searching across the filesystem.

---

## Level 7 → 8

Concept: Text searching

Commands:

* grep

Learned:

* Finding specific strings inside files.

---

## Level 8 → 9

Concept: Unique values

Commands:

* sort
* uniq

Learned:

* Sorting data and locating unique entries.

---

## Level 9 → 10

Concept: Extracting readable text

Commands:

* strings

Learned:

* Finding human-readable text inside binary files.

---

## Level 10 → 11

Concept: Base64

Commands:

* base64 -d

Learned:

* Decoding Base64 encoded data.

---

## Level 11 → 12

Concept: ROT13

Commands:

* tr

Learned:

* Translating characters and simple ciphers.

---

## Level 12 → 13

Concept: Data extraction

Commands:

* xxd
* gzip
* bzip2
* tar

Learned:

* Working through multiple layers of compression and encoding.

---

## Level 13 → 14

Concept: SSH private keys

Commands:

* ssh -i

Learned:

* Authenticating with SSH keys instead of passwords.

---

## Level 14 → 15

Concept: Network services

Commands:

* nc

Learned:

* Connecting to services using Netcat.

---

## Level 15 → 16

Concept: SSL/TLS connections

Commands:

* openssl s_client

Learned:

* Secure communication with encrypted services.

---

## Level 16 → 17

Concept: Port scanning

Commands:

* nmap

Learned:

* Discovering open ports and services.

---

## Level 17 → 18

Concept: Comparing files

Commands:

* diff

Learned:

* Identifying differences between files.

---

## Level 18 → 19

Concept: Restricted shells

Commands:

* ssh

Learned:

* Working around restricted environments.

---

## Level 19 → 20

Concept: SUID programs

Commands:

* ls -l

Learned:

* Running programs with another user's privileges.

---

## Level 20 → 21

Concept: Listening services

Commands:

* nc

Learned:

* Client/server communication.

---

## Level 21 → 22

Concept: Cron jobs

Commands:

* cat

Learned:

* How scheduled tasks operate.

---

## Level 22 → 23

Concept: Reading shell scripts

Commands:

* cat

Learned:

* Understanding script logic.

---

## Level 23 → 24

Concept: Temporary files and automation

Commands:

* mkdir
* cat

Learned:

* Working with automated processes and temporary storage.

---

## Level 24 → 25

Concept: Bash scripting and automation

Commands:

* for
* seq
* nc

Learned:

* Automating repetitive tasks.
* Brute-forcing a PIN using a Bash loop.

---

## Level 25 → 26

Concept: Escaping restricted environments

Commands:

* more
* vi

Learned:

* Using program behaviour to gain shell access.

---

## Level 26 → 27

Concept: SUID escalation

Commands:

* whoami

Learned:

* Executing commands as another user.

---

## Level 27 → 28

Concept: Git repositories

Commands:

* git clone

Learned:

* Cloning repositories from a remote server.

---

## Level 28 → 29

Concept: Git history

Commands:

* git log
* git show

Learned:

* Recovering information from previous commits.

---

## Level 29 → 30

Concept: Git branches

Commands:

* git branch
* git checkout

Learned:

* Switching between branches.

---

## Level 30 → 31

Concept: Git tags

Commands:

* git tag
* git show

Learned:

* Inspecting tagged versions of a repository.

---

## Level 31 → 32

Concept: Git workflow

Commands:

* git add
* git commit
* git push

Learned:

* Contributing changes to a repository.

---

## Level 32 → 33

Concept: Shell behaviour

Commands:

* ${0}

Learned:

* Escaping a restricted uppercase shell.

---

## Overall Lessons

Key topics covered:

* Linux navigation
* File permissions
* Networking
* SSH
* Bash scripting
* Cron jobs
* Text processing
* Compression and encoding
* Git fundamentals
* Troubleshooting methodology



























