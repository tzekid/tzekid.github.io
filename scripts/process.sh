#!/usr/bin/env bash

## usage: process_md.sh source.md
#
# process an .md file (or home.html) to a final .html file.
# add_checkboxes.sh and refine.sh

new_file=""

echo "Processing $1..."

# refine index and exit
if [[ $1 == *'home.html' ]]; then
    cat $1 | scripts/refine.sh $1 > index.html
    exit 1

# skip protected files
elif [[ $1 == *'/_'* ]]; then
    exit 1

# omit the article name prefix 
elif [[ $1 == *'__'* ]]; then
    new_file=${1:8:-3}.html

# omit 'src/' prefix
else
    new_file=${1:4:-3}.html
fi

# exclude the TableOfContents
if [[ $1 == *'about.md' ]] || [[ $1 == *'writings.md' ]] \
|| [[ $1 == *'projects.md' ]]; then

    scripts/add_checkboxes.sh $1 | pandoc -s -c style.css --katex |\
scripts/refine.sh > $new_file

# or don't
else
    scripts/add_checkboxes.sh $1 | pandoc -s --toc -c style.css --katex |\
scripts/refine.sh > $new_file
fi
