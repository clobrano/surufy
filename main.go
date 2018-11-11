package main

// convert -modulate to change brightness, saturation and hue

// TODO manage all errors
// TODO support for non PNG images?

import (
	"flag"

	"gopkg.in/gographics/imagick.v2/imagick"
)

func main() {
	input := flag.String("input", "", "path to the input image")
	output := flag.String("output", "", "path to the output image")
	tile := flag.String("tile", "", "path to the tile background")
	hex := flag.String("hex", "", "")
	flag.Parse()

	imagick.Initialize()
	defer imagick.Terminate()

	// colorize background
	color := imagick.NewPixelWand()
	color.SetColor(*hex)

	opacity := imagick.NewPixelWand()
	opacity.SetColor("rgb(100%,100%,100%)")

	bg := imagick.NewMagickWand()
	bg.ReadImage(*tile)

	bg.TintImage(color, opacity)

	// resize images
	perc := uint(80)
	width := (bg.GetImageWidth() * perc) / 100
	height := (bg.GetImageHeight() * perc) / 100

	im := imagick.NewMagickWand()
	im.ReadImage(*input)
	im.ResizeImage(height, width, imagick.FILTER_SINC, 1)

	// composite images
	var x, y int
	x = int(bg.GetImageWidth()/2 - im.GetImageWidth()/2)
	y = int(bg.GetImageHeight()/2 - im.GetImageHeight()/2)
	bg.CompositeImageChannel(imagick.CHANNEL_TRUE_ALPHA, im, imagick.COMPOSITE_OP_ATOP, x, y)

	// Save result
	bg.WriteImage(*output)
}
