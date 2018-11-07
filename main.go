package main

// convert -modulate to change brightness, saturation and hue

import (
	"flag"
	"fmt"
	"image"
	"image/png"
	"log"
	"os"
	"strconv"

	"github.com/EdlinOrg/prominentcolor"
	"gopkg.in/gographics/imagick.v2/imagick"
)

func get_colors(k int, img image.Image) ([]prominentcolor.ColorItem, error) {
	mask := prominentcolor.GetDefaultMasks()
	resizeSize := uint(126)

	conf := prominentcolor.ArgumentNoCropping

	res, err := prominentcolor.KmeansWithAll(k, img, conf, resizeSize, mask)
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
	color_id := flag.String("color-id", "1", "color id to use from the palette (zero based)")
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
	bg := imagick.NewMagickWand()
	bg.ReadImage(*tile)

	id, err := strconv.Atoi(*color_id)
	if err != nil {
		log.Fatal("could not convert color_id %s\n", *color_id)
	}

	color := imagick.NewPixelWand()
	if len(colors) < id+1 {
		log.Fatal("no colors")
	}

	color.SetColor(fmt.Sprintf("#%s", colors[id].AsString()))
	opacity := imagick.NewPixelWand()

	opacity.SetColor("rgb(90%,90%,90%)")

	bg.ColorizeImage(color, opacity)

	// resize images
	im := imagick.NewMagickWand()
	im.ReadImage(*input)

	//bg.ResizeImage(im.GetImageHeight(), im.GetImageWidth(), imagick.FILTER_SINC, 1)
	im.ResizeImage(bg.GetImageHeight(), bg.GetImageWidth(), imagick.FILTER_SINC, 1)

	perc := uint(80)
	width_new := (im.GetImageWidth() * perc) / 100
	height_new := (im.GetImageHeight() * perc) / 100

	im.ResizeImage(height_new, width_new, imagick.FILTER_SINC, 1)

	// composite images
	var x, y int
	x = int(bg.GetImageWidth()/2 - im.GetImageWidth()/2)
	y = int(bg.GetImageHeight()/2 - im.GetImageHeight()/2)
	bg.CompositeImageChannel(imagick.CHANNEL_TRUE_ALPHA, im, imagick.COMPOSITE_OP_ATOP, x, y)

	// Save result
	bg.WriteImage(*output)
}
