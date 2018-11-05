#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# icon sizes to watch in hicolor directory
hicolor='32x32 48x48 64x64 96x96 256x256 512x512'

# icon sizes to generate
sizelist='32x32 48x48 256x256 32x32@2x 48x48@2x 256x256@2x'

# icons and patterns to be excluded
exclude='goa- gcr- gdm- preferences- symbolic ubuntu-logo-icon.png distributor-logo.png'

# correspond sizes and folders from hicolor to Yaru
declare -A redirect=(
    ["32x32"]="32x32"
    ["48x48"]="48x48"
    ["64x64"]="32x32@2x"
    ["96x96"]="48x48@2x"
    ["256x256"]="256x256"
    ["512x512"]="256x256@2x"
)

mkdirs() {
    for size in ${sizelist}; do
        path='/home/carlo/.local/share/icons/Yaru/'$size'/apps'
        if [ ! -f ${path} ]; then
            echo making $path
            mkdir -p ${path}
        fi
    done
}

crawls() {
    for size in ${hicolor}; do
        for folder in /usr/share/icons/hicolor/$size/apps; do
            echo $folder, ${redirect[$size]}
            for icon in `ls ${folder}`; do
                if [[ ! $exclude =~ $icon ]] && [[ ! -f /usr/share/icons/Yaru/${redirect[$size]}/apps/$icon ]]; then
                    input=$folder/$icon
                    output='/home/carlo/.local/share/icons/Yaru/'${redirect[$size]}'/apps/'$icon
                    #echo $input in $output
                    go-tile -tile "squircle2.png" -input $input -output $output
                else
                    echo skipping $icon
                fi
            done
        done
    done
}

mkdirs
crawls

