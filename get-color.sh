#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## -i, --input <file>
## -n, --number <number> [default: 1]
# GENERATED_CODE: start
# Default values
_number=1

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--input") set -- "$@" "-i";;
"--number") set -- "$@" "-n";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hi:n:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _input=$OPTARG ;;
        n) _number=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# GENERATED_CODE: end


palette=$(convert $_input -geometry 16x16 +dither -colors 5 -unique-colors txt:)
color=$(echo "$palette" | grep -e "^$_number,0" | cut -d' ' -f4)
shadow=$(echo "$palette" | grep -e "^0,0" | cut -d' ' -f4)

# cut the alpha value
color=${color:0:7}

# Basic color quality filter
if [[ $color =~ "#000000" ]]; then
    echo "  bad color $color"
    continue
fi

echo color:$color
echo shadow:$shadow
