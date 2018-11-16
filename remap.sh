#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## options:
## -i, --input <file>
## -o, --output <file>
## -p, --palette <file> [default: palette.png]

# GENERATED_CODE: start
# Default values
_palette=palette.png

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--input") set -- "$@" "-i";;
"--output") set -- "$@" "-o";;
"--palette") set -- "$@" "-p";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hi:o:p:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _input=$OPTARG ;;
        o) _output=$OPTARG ;;
        p) _palette=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# GENERATED_CODE: end
convert $_input -alpha on -remap $_palette $_output
