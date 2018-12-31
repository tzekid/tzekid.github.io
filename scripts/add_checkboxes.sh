#!/usr/bin/env bash

## usage: source | add_checkboxes.sh
# transforms custom md sytanx to HTML checkboxes

# TODO: upgrade the script to use sed|awk for text manipulation
# Prefix: `_  ` for checkbox
#         `_o ` for fixed unchecked
#         `_x ` for fixed checked

output=""

# the file contains at least one prefix
if grep -q '_  '* $1 || grep -q '_o '* $1 || grep -q '_x '* $1; then
    
    # go through file line by line
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == '_  '* ]] || [[ "$line" == '_o '* ]]\
    || [[ "$line" == '_x '* ]]; then

            random_id=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 8 | head -n 1)

            # convert the inner html to md → html
            proc_markdown=$(echo ${line:3} | pandoc --from markdown --to html)

            proc_markdown=${proc_markdown//"<p>"/}
            proc_markdown=${proc_markdown//"</p>"/}

            checkbox="<input id='$random_id' type='checkbox' class='cbi'"

            # fix (and/or check) special checkboxes
            if [[ "$line" == '_o '* ]]; then
                checkbox=$checkbox" disabled "
            elif [[ "$line" == '_x '* ]]; then
                checkbox=$checkbox" checked disabled "
            fi

            # automatically strikethrough the checked checkboxes
            if [[ "$line" == '_x '* ]]; then
                checkbox="<del>$checkbox><label class='cbl' for='$random_id'>\
$proc_markdown</label></del>"

            else
                checkbox=$checkbox"><label class='cbl' for='$random_id'>\
$proc_markdown</label>"
            fi

            output="$output\n$checkbox"
        else
            output="$output\n$line"
        fi
    done < "$1"

    echo -e "$output"

# the file doesn't contain any of the prefixes
else
    cat $1
fi
