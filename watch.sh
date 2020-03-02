#!/usr/bin/env bash

# TODO: get rid of the 'entr: unable to stat '.:' warning

if ! (command -v entr >/dev/null 2>&1) ; then
    exit 1
fi

# TODO watch only one file

ls . src/* | entr -p ./compile.sh
