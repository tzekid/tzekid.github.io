#!/usr/bin/env sh

# if argument given, then only process that
if [ "$1" ]; then
    scripts/process.sh $1
    
    # update writings section
    if [[ "$1" == *"__"* ]]; then
        scripts/index_articles.sh > src/writings.md
        scripts/process.sh src/writings.md
    fi

    xdotool search --onlyvisible --class Chrome windowfocus key ctrl+r
    exit 1
fi

# generate the writings.md
echo "Creating writings index..."
scripts/index_articles.sh > src/writings.md

# process all files that are not protected (starting with an `_`)
for file in src/*; do
    if [[ $file != "src/_"* ]]; then
        scripts/process.sh $file
    fi
done

# refresh chrome
xdotool search --onlyvisible --class Chrome windowfocus key ctrl+r
