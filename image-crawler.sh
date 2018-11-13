#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# icon sizes to watch in hicolor directory
hicolor='512x512 256x256 96x96 64x64 48x48 32x32'

# icon sizes to generate
#sizelist='32x32 48x48 64x64 96x96 256x256 32x32@2x 48x48@2x 256x256@2x'
sizelist='32x32 48x48 64x64 96x96 256x256 512x512'

# icons and patterns to be excluded
exclude='goa- gcr- gdm- preferences- symbolic ubuntu-logo-icon.png distributor-logo.png'

# correspond sizes and folders from hicolor to Yaru
declare -A redirect=(
    ["32x32"]="32x32"
    ["48x48"]="48x48"
    ["64x64"]="32x32@2x"
    ["96x96"]="48x48@2x"
    ["128x128"]="128x128"
    ["256x256"]="256x256"
    ["512x512"]="256x256@2x"
)

mkdirs() {
    for size in ${sizelist}; do
        path='/home/carlo/.local/share/icons/Yaru/'${redirect[$size]}'/apps'
        if [ ! -f ${path} ]; then
            echo making $path
            mkdir -p ${path}
        fi
    done
}

crawls() {
    for size in ${hicolor}; do
        echo
        echo $size
        echo
        for folder in /usr/share/icons/hicolor/$size/apps; do
            for icon in `ls ${folder}`; do

                extension="${icon##*.}"
                if [[ $extension != "png" ]]; then
                    continue;
                fi

                echo processing $icon
                if [[ $exclude =~ $icon ]]; then
                    # TODO fix regex maching (e.g. 'goa-' does not work)
                    echo "  excluded"
                    continue
                fi

                if [[ -f /usr/share/icons/Yaru/${redirect[$size]}/apps/$icon ]]; then
                    echo "  exists"
                    continue
                fi

                input=$folder/$icon
                color=$(convert $input -geometry 16x16 +dither -colors 5 -unique-colors txt: |\
                    grep -e "^1,0" |\
                    cut -d' ' -f4)
                # cut the alpha value
                color=${color:0:7}

                if [[ $color =~ "#000000" ]]; then
                    echo "  bad color $color"
                    continue
                fi

                # generate all the sizes from the logo at higher resolution
                for ssize in ${sizelist}; do
                    output='/home/carlo/.local/share/icons/Yaru/'${redirect[$ssize]}'/apps/'$icon

                    if [ -f ${output} ]; then
                        echo "  already generated"
                        break
                    fi

                    echo "  generating $icon, size $ssize, color $color"
                    convert \( "tile-"$ssize".png" -fill "$color" -tint 100 -modulate 130,100,100 \) \
                        \( $input[$ssize] -resize 80% \)\
                        -gravity center -composite $output
                done
            done
        done
    done
}

mkdirs
crawls

