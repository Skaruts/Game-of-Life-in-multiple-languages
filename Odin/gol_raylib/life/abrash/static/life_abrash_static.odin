package life_abrash_static

import "core:fmt"
import "core:slice"
import rl "vendor:raylib"

import "../../../data"

print :: fmt.println

/*

	Michael Abrash's algorithm (adapted) (using static arrays)

		- can't do border swapping
		- skips empty space
		- copies the entire board every frame
		- it's potentially faster than the simple algorithm when most cells
		  are dead, and slower when most cells are alive.

		cell bit layout:
			 ------- --- ---------
			| . . . | 0 | 0 0 0 0 |
			 ------- --- ---------
					  ^      ^
					  |     neighbor count
				 cell state

*/

ALIVE :: int(1) << 4   // must cast literals to shift them?
DEAD  :: 0
COUNT :: 0xf
BOARD :: 1
BUFFER  :: 0

cells : [2][data.GH][data.GW]int
// wrap_around        : bool


init :: proc() {
	print("initing ABRASH algorithm (using static memory")
}

destroy :: proc() {}


@private
_inbounds :: proc(x, y:int) -> bool {
	using data
	return x >= 0 && x < GW && y >= 0 && y < GH
}

@private
_update_buffer :: proc() {
	using data
	c := &cells[BOARD]
	p := &cells[BUFFER]

	for j in 0..<GH {
		pj, cj := &p[j], &c[j]
		for i in 0..<GW {
			pj[i] = cj[i]
		}
	}
}


/***************************************************
		Compute Generation
*/
compute_gen :: proc() {
	using data
	_update_buffer()
	c := &cells[BOARD]   // current
	p := &cells[BUFFER]  // previous

	for j in 0..<GH {
		pj, cj := &p[j], &c[j]
		for i in 0..<GW {
			if pj[i] == 0 do continue

			cell := pj[i]
			n := cell & COUNT

			if bool(cell & ALIVE) {
				if n != 2 && n != 3 {
					cj[i] &= ~ALIVE
					_update_neighbors(i, j, -1)
				}
			} else if (n == 3) {
				cj[i] |= ALIVE
				_update_neighbors(i, j, 1)
			}
		}
	}
}


/***************************************************
		Rendering
*/
draw_grid :: proc() {
	using data
	c := &cells[BOARD]

	for j in 0..<GH {
		for i in 0..<GW {
			if bool(c[j][i] & ALIVE) do set_pixel(i, j, alive_color)
		}
	}
}



revive_cell :: proc(x, y:int) {
	if !_inbounds(x, y) do return

	cy := &cells[BOARD][y]
	if cy[x] & ALIVE != 0 do return

	cy[x] |= ALIVE
	_update_neighbors(x, y, 1)
}

kill_cell :: proc(x, y:int) {
	if !_inbounds(x, y) do return

	cy := &cells[BOARD][y]
	if cy[x] & ALIVE == 0 do return

	cy[x] &= ~ALIVE
	_update_neighbors(x, y, -1)
}

@private
_update_neighbors :: proc(x, y, n:int) {
	using data
	l  := (x-1 >= 0   ?  x-1  :  GW-1 )
	r  := (x+1 <  GW  ?  x+1  :  0    )
	u  := (y-1 >= 0   ?  y-1  :  GH-1 )
	d  := (y+1 <  GH  ?  y+1  :  0    )

	cy := &cells[BOARD][y] // Y
	cu := &cells[BOARD][u] // up
	cd := &cells[BOARD][d] // down

	cu[l] = cu[l] + n
	cu[x] = cu[x] + n
	cu[r] = cu[r] + n
	cy[l] = cy[l] + n
	cy[r] = cy[r] + n
	cd[l] = cd[l] + n
	cd[x] = cd[x] + n
	cd[r] = cd[r] + n
}

@private
_update_all_neighbors :: proc() {
	using data
	c := &cells[BOARD]

	for j in 0..<GH {
		cj := &c[j]
		for i in 0..<GW {
			if (cj[i] & ALIVE) != 0 {
				_update_neighbors(i, j, 1)
			}
		}
	}
}

randomize_cells :: proc() {
	using data
	clear_grid()

	c := &cells[BOARD]

	for j in 0..<GH {
		for i in 0..<GW {
			alive := rl.GetRandomValue(0, 100) > 50
			c[j][i] = alive ? ALIVE : DEAD
		}
	}

	_update_all_neighbors()
}

fill_grid :: proc() {
	clear_grid(ALIVE)
}

clear_grid :: proc(val := DEAD) {
	using data
	c := &cells[BOARD]

	for j in 0..<GH {
		for i in 0..<GW {
			c[j][i] = val
		}
	}

	if val == ALIVE {
		_update_all_neighbors()
	}
}




