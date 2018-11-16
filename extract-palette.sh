#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## options:
## -i, --input <file>
## -o, --output <file> [default: palette.png]
## -n, --number <num> [default: 32]
# GENERATED_CODE: start
# Default values
_output=palette.png
_number=32

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--input") set -- "$@" "-i";;
"--output") set -- "$@" "-o";;
"--number") set -- "$@" "-n";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hi:o:n:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _input=$OPTARG ;;
        o) _output=$OPTARG ;;
        n) _number=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# GENERATED_CODE: end

convert $_input -geometry 16x16 +dither -colors $_number -unique-colors -type Palette $_output

