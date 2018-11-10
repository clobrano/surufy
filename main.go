package main

// convert -modulate to change brightness, saturation and hue

// TODO manage all errors
// TODO support for non PNG images?

import (
	"flag"
	"fmt"
	"image"
	"image/png"
	"log"
	"os"

	"github.com/EdlinOrg/prominentcolor"
	"gopkg.in/gographics/imagick.v2/imagick"
)

func get_colors(k int, img image.Image) ([]prominentcolor.ColorItem, error) {
	mask := prominentcolor.GetDefaultMasks()
	conf := prominentcolor.ArgumentNoCropping
	size := uint(126)

	res, err := prominentcolor.KmeansWithAll(k, img, conf, size, mask)
	if err != nil {
		log.Fatal("can't get prominent color", err)
		return nil, err
	}

	return res, nil
}

func main() {
	input := flag.String("input", "", "path to the input image")
	output := flag.String("output", "", "path to the output image")
	tile := flag.String("tile", "", "path to the tile background")
	flag.Parse()

	imagick.Initialize()
	defer imagick.Terminate()

	f, err := os.Open(*input)
	defer f.Close()
	if err != nil {
		log.Fatal(*input, " :cannot open file")
	}

	image.RegisterFormat("png", "png", png.Decode, png.DecodeConfig)
	img, err := png.Decode(f)
	if err != nil {
		log.Fatal(*input, " :cannot decode img ", err)
	}

	colors, err := get_colors(5, img)
	if err != nil {
		log.Fatal(*input, " failed")
	}

	// colorize background
	var id int
	if len(colors) > 2 {
		id = 2
	} else if len(colors) > 1 {
		id = 1
	} else {
		id = 0
	}
	color := imagick.NewPixelWand()
	color.SetColor(fmt.Sprintf("#%s", colors[id].AsString()))

	opacity := imagick.NewPixelWand()
	opacity.SetColor("rgb(70%,70%,70%)")

	bg := imagick.NewMagickWand()
	bg.ReadImage(*tile)
	bg.ColorizeImage(color, opacity)

	// resize images
	perc := uint(80)
	width_new := (bg.GetImageWidth() * perc) / 100
	height_new := (bg.GetImageHeight() * perc) / 100

	im := imagick.NewMagickWand()
	im.ReadImage(*input)
	im.ResizeImage(height_new, width_new, imagick.FILTER_SINC, 1)

	// composite images
	var x, y int
	x = int(bg.GetImageWidth()/2 - im.GetImageWidth()/2)
	y = int(bg.GetImageHeight()/2 - im.GetImageHeight()/2)
	bg.CompositeImageChannel(imagick.CHANNEL_TRUE_ALPHA, im, imagick.COMPOSITE_OP_ATOP, x, y)

	// Save result
	bg.WriteImage(*output)
}
