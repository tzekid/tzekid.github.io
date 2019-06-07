#!/usr/bin/env sh

# usage: ./compile          compile everything
#        ./compile file     compiles given file
# usage: ./compile file --dev

# if argument given, then only process that
if [ "$1" ]; then
    if [[ "$1" == "--dev" ]]; then
        for file in src/*; do
            if [[ $file != "src/_"* ]] && [[ $file != "src/home"* ]]; then
                scripts/process.sh $file $1
            fi
        done

        echo "Creating writings index..."
        scripts/index_articles.sh src/home.html > src/home_indexed.html
        scripts/process.sh src/home_indexed.html $1

        exit 1
    fi

    scripts/process.sh $1
    
    # update writings section
    if [[ "$1" == *"__"* ]] || [[ "$1" == *'/home.html' ]]; then
        scripts/index_articles.sh src/home.html > src/home_indexed.html
        scripts/process.sh src/home_indexed.html
        # scripts/process.sh src/writings.md
    fi

    # xdotool search --onlyvisible --class Chrome windowfocus key ctrl+r
    exit 1
fi

# dev: #

# generate the writings.md
# scripts/index_articles.sh # outputs articles html

# process all files that are not protected (starting with an `_`)
for file in src/*; do
    if [[ $file != "src/_"* ]] && [[ $file != "src/home"* ]]; then
        scripts/process.sh $1 $file
    fi
done

echo "Creating writings index..."
scripts/index_articles.sh src/home.html > src/home_indexed.html
scripts/process.sh $1 src/home_indexed.html
# refresh chrome
# xdotool search --onlyvisible --class Chrome windowfocus key ctrl+r
