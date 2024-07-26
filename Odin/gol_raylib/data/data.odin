package data

import "core:fmt"
import rl "vendor:raylib"

Screen :: struct {
	img    : rl.Image,
	tex    : rl.Texture2D,
	pixels : [^]rl.Color,
}


SW :: 1280
SH :: 800

// this is basically the size of a cell in pixels
// best to keep this to multiples, 1, 2, 4, 8, etc (bit shifting ensures it)
scale :: int(1) << 2

GW :: SW/scale
GH :: SH/scale



paused := false
dt            : f32
ellapsed_time : f64
screen        : Screen
last_gm :[2]int		// last mouse position, in grid coords


alive_color := rl.GREEN
dead_color  := rl.Color{16, 10, 6, 255}

init_screen :: proc() {
	// this must be initialized only after 'rl.InitWindow()' is called
	img   : rl.Image = rl.GenImageColor(i32(GW), i32(GH), rl.GREEN)

	screen = {
		img    = img,
		tex    = rl.LoadTextureFromImage(img),
		pixels = rl.LoadImageColors(img),
	}
}

set_pixel :: proc(x, y:int, color:rl.Color) {
	screen.pixels[x+y*GW] = color
}

clear_screen :: proc() {
	for j in 0..<GH {
		for i in 0..<GW {
			screen.pixels[i+j*GW] = dead_color
		}
	}
}
