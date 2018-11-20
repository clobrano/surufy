#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Place the input logo PNG into a tile/squircle in Suru icon set style
## usage:
##      surufy.sh --input <logo.png> --format <WxH> --color <hex-color> --shadow <hex-color> -output <result.png>
## options:
##     -i, --input <file>   The input logo image in PNG format
##     -f, --format <wxh>   The size of the resulting PNG [default: 512x512]
##     -o, --output <file>  The name of the resulting image in PNG format
# GENERATED_CODE: start
# Default values
_format=512x512

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--input") set -- "$@" "-i";;
"--format") set -- "$@" "-f";;
"--output") set -- "$@" "-o";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hi:f:o:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _input=$OPTARG ;;
        f) _format=$OPTARG ;;
        o) _output=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# GENERATED_CODE: end

set -ue
source ./surufy

_palette=$(get_palette $_input)
_background=$(get_color_from_palette "$_palette" 1)
_shadow=$(get_color_from_palette "$_palette" 0)

surufy $_input $_format $_background $_shadow $_output
