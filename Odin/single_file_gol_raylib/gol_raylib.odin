package main

import "core:fmt"
import "core:mem"

import rl "vendor:raylib"


Screen :: struct {
	img    : rl.Image,
	tex    : rl.Texture2D,
	pixels : [^]rl.Color,
}

SW :: 1280
SH :: 800
scale :: 4	// this is basically the size of a cell in pixels
GW :: SW/scale  // grid dimensions
GH :: SH/scale

screen        : Screen

paused        := false
alive_color   := rl.GREEN
dead_color    := rl.Color{16, 10, 6, 255}



main :: proc() {
	tracking_allocator : mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, context.allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)

	reset_tracking_allocator :: proc(a: ^mem.Tracking_Allocator) -> bool {
		leaks := false
		fmt.printf("\n----------------------------------------------\n")
		fmt.printf("  Memory leaks: \n\n")

		for k, v in a.allocation_map {
			leaks = true
			fmt.printf("%v leaked %v bytes\n", v.location, v.size)
		}
		fmt.printf("----------------------------------------------\n\n")

		mem.tracking_allocator_clear(a)
		return leaks
	}


	rl.SetTraceLogLevel(rl.TraceLogLevel.WARNING)

	rl.InitWindow(SW, SH, "odin/raylib test - game of life")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	init_screen()

	life_init()
	randomize_cells()


	main_loop: for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

		if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
			paused = !paused
			fmt.println("paused", paused)
		} else if rl.IsKeyPressed(rl.KeyboardKey.R) {
			randomize_cells()
		}

		if !paused do compute_generation()

		rl.BeginDrawing()
			clear_screen()
			draw_grid()

			rl.UpdateTexture(screen.tex, screen.pixels)
		    rl.DrawTextureEx(screen.tex, rl.Vector2{}, 0, f32(scale), rl.WHITE);  // Draw a Texture2D with extended parameters
		rl.EndDrawing()
	}

	life_destroy()

	if reset_tracking_allocator(&tracking_allocator) {
		// fmt.printf("press space to continue...")
		// for rl.IsKeyPressed(.SPACE) == false {}
	}
	mem.tracking_allocator_destroy(&tracking_allocator)
}


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





/*******************************************************************************

	Life stuff

*/
/*

	Simplest life algorithm

		- iterates the entire array to apply rules
		- swaps borders to avoid checking bounds
		- alternates between two boards to avoid slow copying

*/

cells    : [2][][]int

curr  := 1
prev  := 0
ALIVE :: 1
DEAD  :: 0


life_init :: proc() {
	s1 := make([][]int, GH)
	s2 := make([][]int, GH)
	for j in 0 ..<GH {
		s1[j] = make([]int, GW)
		s2[j] = make([]int, GW)
	}

	cells = [2][][]int{s1, s2}


	// top and bottom rows are the same memory (required for wrapping around)
	cells[0][GH-1] = cells[0][1]
	cells[0][0]    = cells[0][GH-2]

	cells[1][GH-1] = cells[1][1]
	cells[1][0]    = cells[1][GH-2]
}

life_destroy :: proc() {
	for j in 0 ..< GH {
		delete(cells[0][j])
		delete(cells[1][j])
	}
}

inbounds :: proc(x, y:int) -> bool {
	// keep in mind the 1 cell border all around
	return x > 0 && x < GW-1 && y > 0 && y < GH-1
}

compute_generation :: proc() {
	curr, prev = prev, curr

	p := cells[prev]
	c := cells[curr]

	l, r, u, d:int
	n:int // alive neighbor count

	for j in 1..<GH-1 {    // leave the borders out
		u, d = j-1, j+1
		for i in 1..<GW-1 {
			l, r = i-1, i+1

			n = (		// seems parentesis are needed for this ?!
				p[u][l]
			  + p[u][i]
			  + p[u][r]
			  + p[j][l]
			  + p[j][r]
			  + p[d][l]
			  + p[d][i]
			  + p[d][r]
			)

			c[j][i] = (n==3 || (n==2 && p[j][i]==1)) ? ALIVE : DEAD
		}
	}

	swap_borders()
}

draw_grid :: proc() {
	c := cells[curr]

	for j in 1..<GH-1 {
		cj := c[j]
		for i in 1..<GW-1 {
			if bool(cj[i]) do set_pixel(i, j, alive_color)
		}
	}

	// TODO: add a way to turn this off without leaving a blank border
	draw_border_cells()
}

draw_border_cells :: proc() {
	c := cells[curr]

	for j in 0..<GH {
		cj := c[j]
		if bool(cj[0])    do set_pixel(0, j, rl.RED)
		if bool(cj[GW-1]) do set_pixel(GW-1, j, rl.RED)
	}

	for i in 0..<GW {
		if bool(c[0][i])    do set_pixel(i, 0, rl.RED)
		if bool(c[GH-1][i]) do set_pixel(i, GH-1, rl.RED)
	}
}

swap_borders :: proc() {
	c := cells[curr]

	for j in 0..<GH {
		cj := c[j]
		cj[ 0  ] = cj[GW-2]
		cj[GW-1] = cj[ 1  ]
	}

	// no need to swap horizontal borders when using slices
	// c[GH-1] = c[1]
	// c[0]    = c[GH-2]
}

randomize_cells :: proc() {
	c := cells[curr]

	clear_grid()

	for j in 1..<GH-1 {
		for i in 1..<GW-1 {
			alive := rl.GetRandomValue(0, 100) > 50
			c[j][i] = alive ? ALIVE : DEAD
		}
	}
}

clear_grid :: proc() {
	c := cells[curr]

	for j in 1..<GH-1 {
		for i in 1..<GW-1 {
			c[j][i] = DEAD
		}
	}
}


