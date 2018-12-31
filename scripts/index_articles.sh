#!/usr/bin/env zsh

## usage index_articles.sh
# → it will go through the local 'src/' directory
#
# !IMPORTANT! This uses zsh, because bash drops newlines in the output
#

# original .md file
WRITINGS=$(<src/_writings.md)

for file in src/*.md; do
    # file is an article
    if [[ "$file" == *__*  ]]; then

        # skip protected files
        if [[ "$file" == "src/_"* ]]; then
            continue
        fi

        # go through file and extract title and date
        title=""
        date=""

        # extract title and date strings
        while IFS='' read -r line || [[ -n "$line" ]]; do
            if [[ $line == 'title: '* ]]; then
                title="${line:7}"
            elif [[ $line == 'date: '* ]]; then
                date="${line:6}"
                break
            fi
        done < "$file"

        # append the entry to the original .md file
        WRITINGS="$WRITINGS\n\n<div class='article'><span class='a-date'>\
$date</span><a class='a-title' href='/${file:8:-3}'>$title</a></div>\n"

    fi
done

echo -e $WRITINGS
