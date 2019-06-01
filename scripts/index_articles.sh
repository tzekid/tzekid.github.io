#!/usr/bin/env zsh

## usage index_articles.sh
# → it will go through the local 'src/' directory
# → outputs articles in the ```.article span.a-date a.a-title``` format
#
# !IMPORTANT! This uses zsh, because bash drops newlines in the output
#

# original .md file
# ARTICLES=$(<src/home.html)
ARTICLES=""

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
                break #? where does break break from ? if or while statement
            fi
        done < "$file"

        # append article to articles
        ARTICLES="$ARTICLES\n\n\t\t<div class='article'><span class='a-date'>\
$date</span><a class='a-title' href='/${file:8:-3}'>$title</a></div>\n"

    fi
done

output=""
if [ "$1" ]; then
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $line == *'<article>'* ]]; then
            output="$output$line$ARTICLES"
        else
            output="$output$line\n"
        fi
    done < "$1"
    
    echo -e "$output"
    exit 1
fi

echo -e $ARTICLES
