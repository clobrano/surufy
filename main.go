package main

// convert -modulate to change brightness, saturation and hue

import (
	"gopkg.in/gographics/imagick.v2/imagick"
)

func main() {
	imagick.Initialize()
	defer imagick.Terminate()

	mw := imagick.NewMagickWand()
	mw.ReadImage("squircle2.png")

	colorize := imagick.NewPixelWand()
	colorize.SetColor("green")

	opacity := imagick.NewPixelWand()
	opacity.SetColor("rgb(60%,60%,60%)")

	mw.ColorizeImage(colorize, opacity)
	mw.WriteImage("result.png")
}
