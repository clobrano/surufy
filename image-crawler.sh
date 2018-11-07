#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# icon sizes to watch in hicolor directory
hicolor='32x32 48x48 64x64 96x96 128x128 256x256 512x512'

# icon sizes to generate
sizelist='32x32 48x48 64x64 96x96 128x128 256x256 32x32@2x 48x48@2x 256x256@2x'

# icons and patterns to be excluded
exclude='goa- gcr- gdm- preferences- symbolic ubuntu-logo-icon.png distributor-logo.png'

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
        echo
        echo $size
        echo
        for folder in /usr/share/icons/hicolor/$size/apps; do
            for icon in `ls ${folder}`; do
                if [[ $exclude =~ $icon ]]; then
                    echo $icon excluded
                else if [[ -f /usr/share/icons/Yaru/$size/apps/$icon ]]; then
                        echo $icon exists
                    else
                        input=$folder/$icon
                        output='/home/carlo/.local/share/icons/Yaru/'$size'/apps/'$icon
                        echo $icon converting $output
                        go-tile -tile "tile-"$size".png" -input $input -output $output
                    fi
                fi
            done
        done
    done
}

mkdirs
crawls

