#!/usr/bin/env bash

# TODO: get rid of the 'entr: unable to stat '.:' warning
ls . src/* | entr -p ./compile.sh
