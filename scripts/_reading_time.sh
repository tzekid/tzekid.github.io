#!/usr/bin/env bash

# count words from a file, divide by 205 and add 1

words=$(wc -w $1 | cut -d' ' -f 1)
result=$(printf %.0f `expr $words / 205 + 1`)
html=""



# well, this was easy
