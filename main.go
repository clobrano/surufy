package main

// convert -modulate to change brightness, saturation and hue

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
		log.Fatal("cannot open file", *input)
	}

	image.RegisterFormat("png", "png", png.Decode, png.DecodeConfig)
	image, err := png.Decode(f)
	if err != nil {
		log.Fatal("cannot decode image ", err)
	}

	colors, err := prominentcolor.Kmeans(image)
	if err != nil {
		log.Fatal("kmeans failed", err)
	}

	// colorize background
	bg := imagick.NewMagickWand()
	bg.ReadImage(*tile)

	color := imagick.NewPixelWand()
	color.SetColor(fmt.Sprintf("#%s", colors[0].AsString()))

	opacity := imagick.NewPixelWand()
	opacity.SetColor("rgb(60%,60%,60%)")

	bg.ColorizeImage(color, opacity)

	// resize images
	im := imagick.NewMagickWand()
	im.ReadImage(*input)

	bg.ResizeImage(im.GetImageHeight(), im.GetImageWidth(), imagick.FILTER_CUBIC, 1)

	var perc uint
	perc = 80
	width_new := (im.GetImageWidth() * perc) / 100
	height_new := (im.GetImageHeight() * perc) / 100

	im.ResizeImage(height_new, width_new, imagick.FILTER_CUBIC, 1)

	// composite images
	var x, y int
	x = int(bg.GetImageWidth()/2 - im.GetImageWidth()/2)
	y = int(bg.GetImageHeight()/2 - im.GetImageHeight()/2)
	bg.CompositeImageChannel(imagick.CHANNEL_TRUE_ALPHA, im, imagick.COMPOSITE_OP_ATOP, x, y)

	// Save result
	bg.WriteImage(*output)

}
