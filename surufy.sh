## options
## -i, --input <file>
## -f, --format <wxh>
## -c, --color <hex>
## -s, --shadow <hex>
## -o, --output <file>
# GENERATED_CODE: start

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--input") set -- "$@" "-i";;
"--format") set -- "$@" "-f";;
"--color") set -- "$@" "-c";;
"--shadow") set -- "$@" "-s";;
"--output") set -- "$@" "-o";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hi:f:c:s:o:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        i) _input=$OPTARG ;;
        f) _format=$OPTARG ;;
        c) _color=$OPTARG ;;
        s) _shadow=$OPTARG ;;
        o) _output=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done
# GENERATED_CODE: end


# compose tile, logo outline and actual logo
convert \( "tile-"$_format".png" -fill "$_color" -tint 100 -modulate 130,100,100 \) \
        \( $_input[$_format] -resize 81%  -background $_shadow -shadow 60x1 \) -gravity center -composite \
        \( $_input[$_format] -resize 80% \)\
        -gravity center -composite $_output
