#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR

if [ -z "$1" ]; then
  JS=lib/main.js
else
  JS="$@"
fi

bun x cep -w -c src -o lib -r "$JS"

# cd $1
# shift
# exec dev $@
