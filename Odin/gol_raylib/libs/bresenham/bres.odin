package bresenham
// import rl "vendor:raylib"


// Bresenham's line (returns a list of points that make up the line)
line :: proc(x1, y1, x2, y2:int, exclude_start:=false) -> [dynamic][2]int {
	x1, y1, x2, y2 := x1, y1, x2, y2

	points := make([dynamic][2]int, context.temp_allocator)

	err :int = 0
	dtx :int = x2 - x1
	dty :int = y2 - y1
	ix  :int = dtx > 0 ? 1 : -1
	iy  :int = dty > 0 ? 1 : -1
	dtx = 2 * abs(dtx)
	dty = 2 * abs(dty)

	if !exclude_start do append(&points, [2]int{x1, y1})

	if dtx >= dty {
		err = dty - dtx / 2
		for x1 != x2 {
			if err > 0 || (err == 0 && ix > 0) {
				err -= dtx
				y1 += iy
			}
			err += dty
			x1  += ix
			append(&points, [2]int{x1, y1})
		}
	} else {
		err = dtx - dty / 2
		for y1 != y2 {
			if err > 0 || (err == 0 && iy > 0) {
				err -= dty
				x1 += ix
			}
			err += dtx
			y1 += iy
			append(&points, [2]int{x1, y1})
		}
	}
	return points
}


// linev :: proc(x1, y1, x2, y2:f32, exclude_start:=false) -> [dynamic]rl.Vector2 {
// 	x1, y1, x2, y2 := x1, y1, x2, y2

// 	points := make([dynamic]rl.Vector2, context.temp_allocator)

// 	err :f32 = 0
// 	dtx :f32 = x2 - x1
// 	dty :f32 = y2 - y1
// 	ix  :f32 = dtx > 0 ? 1 : -1
// 	iy  :f32 = dty > 0 ? 1 : -1
// 	dtx = 2 * abs(dtx)
// 	dty = 2 * abs(dty)

// 	if !exclude_start do append(&points, rl.Vector2{x1, y1})

// 	if dtx >= dty {
// 		err = dty - dtx / 2
// 		for x1 != x2 {
// 			if err > 0 || (err == 0 && ix > 0) {
// 				err -= dtx
// 				y1 += iy
// 			}
// 			err += dty
// 			x1  += ix
// 			append(&points, rl.Vector2{x1, y1})
// 		}
// 	} else {
// 		err = dtx - dty / 2
// 		for y1 != y2 {
// 			if err > 0 || (err == 0 && iy > 0) {
// 				err -= dty
// 				x1 += ix
// 			}
// 			err += dtx
// 			y1 += iy
// 			append(&points, rl.Vector2{x1, y1})
// 		}
// 	}
// 	return points
// }
