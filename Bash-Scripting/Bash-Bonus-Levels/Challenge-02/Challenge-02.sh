#!/bin/bash

mkdir bash_demo
cd bash_demo

touch demo.txt

echo "This file was created by a Bash script on $(date)" > demo.txt

cat demo.txt