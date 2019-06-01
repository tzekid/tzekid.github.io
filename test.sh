#!/usr/bin/env bash

# GOTO for bash, based upon https://stackoverflow.com/a/31269848/5353461
function goto
{
 local label=$1
 cmd=$(sed -En "/^[[:space:]]*#[[:space:]]*$label:[[:space:]]*#/{:a;n;p;ba};" "$0")
 eval "$cmd"
 exit
}

# if argument given, then only process that
if [ "$1" ]; then
    if [[ "$1" == "--dev" ]]; then
        goto end
    fi
    echo "Suck a cock"
    exit 1
fi

# end: #

echo "Hello my good sir."