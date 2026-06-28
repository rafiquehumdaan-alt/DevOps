# OverTheWire Bandit - Command Reference

## Navigation

### Show current directory

```bash
pwd
```

### List files

```bash
ls
ls -la
```

### Change directory

```bash
cd directory_name
cd ..
cd ~
```

---

## Reading Files

### Display file contents

```bash
cat filename
```

### Display beginning of file

```bash
head filename
```

### Display end of file

```bash
tail filename
```

### Determine file type

```bash
file filename
```

---

## Finding Files

### Find files by name

```bash
find . -name filename
```

### Find files by size

```bash
find . -size 1033c
```

### Find files by owner

```bash
find / -user bandit7
```

### Find files by permissions

```bash
find . -perm 600
```

---

## Text Searching

### Search for text

```bash
grep "password" file.txt
```

### Search recursively

```bash
grep -r "password" .
```

### Sort output

```bash
sort file.txt
```

### Show unique lines

```bash
uniq
uniq -u
```

---

## Permissions

### View permissions

```bash
ls -l
```

### Change permissions

```bash
chmod 600 file.txt
chmod 700 script.sh
```

### Make file executable

```bash
chmod +x script.sh
```

---

## File Management

### Copy files

```bash
cp source destination
```

### Move or rename files

```bash
mv oldfile newfile
```

### Delete files

```bash
rm filename
```

### Create directories

```bash
mkdir directory
```

### Remove empty directories

```bash
rmdir directory
```

---

## Archives and Compression

### Extract gzip

```bash
gunzip file.gz
```

### Extract bzip2

```bash
bunzip2 file.bz2
```

### Extract tar archive

```bash
tar -xf archive.tar
```

### Create tar archive

```bash
tar -cf archive.tar folder
```

---

## Encodings

### Decode Base64

```bash
base64 -d file.txt
```

### Reverse Hex Dump

```bash
xxd -r file.hex
```

### ROT13

```bash
tr 'A-Za-z' 'N-ZA-Mn-za-m'
```

---

## Strings

### Extract readable strings

```bash
strings filename
```

### Search extracted strings

```bash
strings filename | grep "="
```

---

## Networking

### SSH Login

```bash
ssh user@host -p 2220
```

### SSH Using Private Key

```bash
ssh -i sshkey user@host -p 2220
```

### Connect Using Netcat

```bash
nc localhost 30002
```

### Send Data To Service

```bash
echo "message" | nc localhost 30002
```

---

## Environment Variables

### Show Environment Variables

```bash
env
```

### Create Variable

```bash
export NAME=value
```

### Display Variable

```bash
echo $NAME
```

---

## Shell Scripting

### For Loop

```bash
for i in {1..10}
do
    echo $i
done
```

### Sequence Loop

```bash
for i in $(seq -w 0000 9999)
do
    echo $i
done
```

### Create Temporary Directory

```bash
mktemp -d
```

---

## Cron Jobs

### View Cron Configuration

```bash
cat /etc/cron.d/cronjob_bandit24
```

### Read Cron Script

```bash
cat /usr/bin/cronjob_bandit24.sh
```

---

## Git

### Clone Repository

```bash
git clone <repository>
```

### Check Status

```bash
git status
```

### View Commit History

```bash
git log
```

### View Commit Details

```bash
git show
```

### View Branches

```bash
git branch
git branch -a
```

### Switch Branch

```bash
git checkout branch-name
```

### View Tags

```bash
git tag
```

### Show Tag Contents

```bash
git show tag-name
```

### Add Files

```bash
git add file
git add -f file
```

### Commit Changes

```bash
git commit -m "message"
```

### Push Changes

```bash
git push origin main
```

---

## Troubleshooting Commands

### Current User

```bash
whoami
```

### User Information

```bash
id
```

### Print Shell

```bash
echo $0
```

### Display Command Path

```bash
which command
```

### Show Running Process

```bash
ps
```

---

## Key Lessons Learned

* Investigate before acting.
* Read scripts before executing them.
* Understand permissions and ownership.
* Use pipelines to combine commands.
* Git stores history, branches, and tags.
* Troubleshooting is often more important than memorising commands.
