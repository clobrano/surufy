package main

// convert -modulate to change brightness, saturation and hue

import (
	"log"

	"gopkg.in/gographics/imagick.v2/imagick"
)

func main() {
	imagick.Initialize()
	defer imagick.Terminate()

	// Get colors
	im := imagick.NewMagickWand()
	im.ReadImage("firefox.png")

	im.SetImageDepth(8)
	ncolors, palette := im.GetImageHistogram()
	log.Printf("%d colors\n", ncolors)

	// colorize background
	bg := imagick.NewMagickWand()
	bg.ReadImage("squircle2.png")

	//colorize := imagick.NewPixelWand()
	//colorize.SetColor("green")

	opacity := imagick.NewPixelWand()
	opacity.SetColor("rgb(60%,60%,60%)")

	bg.ColorizeImage(palette[1000], opacity)
	bg.WriteImage("result.png")

}
