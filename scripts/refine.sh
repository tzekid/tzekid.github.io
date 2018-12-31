#!/usr/bin/env bash

## usage: source | refine.sh
# appends the style and navigation components to the file stream

home="  <title>Ilie Ploscaru</title>"
is_home=false
about="  <title>About</title>"
is_about=false
writings="  <title>Writings</title>"
is_writings=false
projects="  <title>Projects</title>"
is_projects=false


output=""

while IFS='' read -r line || [[ -n "$line" ]]; do

    if [[ "$line" == *"$home"* ]]; then
        is_home=true
    elif [[ "$line" == *"$about"* ]]; then
        is_about=true
    elif [[ "$line" == *"$writings"* ]]; then
        is_writings=true
    elif [[ "$line" == *"$projects"* ]]; then
        is_projects=true
    fi

    if [[ "$line" == *'<title>'* ]]; then
        output="$output\n$line\n$(cat src/_style.html)"

    elif [[ "$line" == *'<body>'* ]]; then
        output="$output\n$line\n$(cat src/_navigation.html)"

        if $is_home; then
            continue
        fi
    
        output="$output\n<article><div "
    
    
    # elif [[ "$line" == *'<p class="date">'* ]]; then
    #     output="$output\n$line\n<p class='date'>$(./)"
    
    
    elif [[ "$line" == *'</body>'* ]]; then

        if $is_home; then
            continue
        fi

        # refine w/o appending the <{ up }> arrow at the end 
        # if $is_about || $is_writings; then
        if $is_about || $is_writings || $is_projects; then
            output="$output\n</article>\n$line"
            continue
        fi

        output="$output\n<a class='up-btn' href='#title-block-header'><{ ⇡ }>\
</a>\n</article>\n$line"
    else
        output="$output\n$line"
    fi
done



echo -e "$output"