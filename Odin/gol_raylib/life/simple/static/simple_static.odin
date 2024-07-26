package life_simple_static

import "core:fmt"
import "core:slice"
import rl "vendor:raylib"

import "../../../data"

print :: fmt.println

/*

	Simplest life algorithm (using static arrays)

		- iterates the entire array to apply rules
		- swaps borders to avoid checking bounds
		- alternates between two boards to avoid slow copying


	TODO:
		- add way to turn off border visualization without leaving blank borders

*/

@private ALIVE :: 1
@private DEAD  :: 0


@private cells: [2][data.GH][data.GW]int

@private debug_draw_borders := false
@private wrap_around        := true
@private curr := 1
@private prev := 0


init :: proc() {
	print(">> initing SIMPLE algorithm (using static memory)")
}

destroy :: proc() {}

@private _inbounds :: proc(x, y:int) -> bool {
	using data
	// keep in mind the 1 cell border all around
	return x > 0 && x < GW-1 && y > 0 && y < GH-1
}




/***************************************************
		Compute Generation
*/
compute_gen :: proc() {
	using data

	curr, prev = prev, curr
	p := &cells[prev]
	c := &cells[curr]

	l, r, u, d:int // directions
	n:int // alive neighbor count

	for j in 1..<GH-1 {
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

	if wrap_around do _swap_borders()
}




/***************************************************
		Rendering
*/
draw_grid :: proc() {
	using data
	c := &cells[curr]

	for j in 1..<GH-1 {
		cj := c[j]
		for i in 1..<GW-1 {
			if bool(cj[i]) do set_pixel(i, j, alive_color)
		}
	}

	// TODO: add a way to turn this off without leaving a blank border
	_draw_border_cells()
}


@private _draw_border_cells :: proc() {
	using data
	c := &cells[curr]

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



@private _swap_borders :: proc() {
	using data
	c := &cells[curr]

	for j in 0..<GH {
		cj := &c[j]
		cj[ 0  ] = cj[GW-2]
		cj[GW-1] = cj[ 1  ]
	}

	c[GH-1] = c[1]
	c[0]    = c[GH-2]
}

revive_cell :: proc(x, y:int) {
	using data
	if !_inbounds(x, y) do return

	cy := &cells[curr][y]
	cy[x] = ALIVE

	// update vertical borders
	if x ==  1   do cy[GW-1] = ALIVE
	if x == GW-2 do cy[ 0  ] = ALIVE
}

kill_cell :: proc(x, y:int) {
	using data
	if !_inbounds(x, y) do return

	cy := &cells[curr][y]
	cy[x] = DEAD

	// update vertical borders
	if x ==  1   do cy[GW-1] = DEAD
	if x == GW-2 do cy[ 0  ] = DEAD
}

randomize_cells :: proc() {
	using data
	c := &cells[curr]

	clear_grid(DEAD)

	for j in 1..<GH-1 {
		for i in 1..<GW-1 {
			alive := rl.GetRandomValue(0, 100) > 50
			c[j][i] = alive ? ALIVE : DEAD
		}
	}
}

fill_grid :: proc() {
	clear_grid(ALIVE)
}


clear_grid :: proc(val := DEAD) {
	using data
	c := &cells[curr]

	for j in 1..<GH-1 {
		for i in 1..<GW-1 {
			c[j][i] = val
		}
	}
}
