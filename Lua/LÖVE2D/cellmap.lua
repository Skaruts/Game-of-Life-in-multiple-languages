
function Cellmap(w, h, cs)
	local t = {
		CS = cs,
		GW = w,
		GH = h,
		pad = cs > 2 and 1 or 0, -- otherwise if cells are 2x2 px, padding will make them 0x0 px
		old_buf = 0,
		curr_buf = 1,
		cells = {},
		cell_color_alive = {1, 0.5, 0, 1},
		cell_color_dead = {0.1, 0.1, 0.1, 1},
	}

	function t.init()
		t.init_cells()
		t.randomize_cells()
	end

	function t.init_cells()
		for bufs=0, 1 do
			t.cells[bufs] = {}
			for j=0, t.GH-1 do
				t.cells[bufs][j] = {}
				for i=0, t.GW-1 do
					t.cells[bufs][j][i] = 0
				end
			end
		end
	end

	function t.randomize_cells()
		for j=0, t.GH-1 do
			for i=0, t.GW-1 do
				local alive = love.math.random()*100 < 50
				if alive == true then	t.cells[t.curr_buf][j][i] = 1
				else 					t.cells[t.curr_buf][j][i] = 0
				end
			end
		end
	end

	function t.draw()
		local size = t.CS-t.pad*2
		for j=0, t.GH-1 do
			for i=0, t.GW-1 do
				local x = i*t.CS + t.pad
				local y = j*t.CS + t.pad
				if t.cells[t.curr_buf][j][i] == 1 then
					love.graphics.setColor(t.cell_color_alive)
				else
					love.graphics.setColor(t.cell_color_dead)
				end
				love.graphics.rectangle('fill', x, y, size, size)
			end
		end
	end

	function t.update(dt)
		t.next_gen()
	end

	function t.next_gen()
		t.curr_buf = 1 - t.curr_buf
		t.old_buf = 1 - t.old_buf

		for j=0, t.GH-1 do
			for i=0, t.GW-1 do
				local j_, _j, i_, _i =
				j-1 <      0 and t.GH-1 or j-1,
				j+1 > t.GH-1 and      0 or j+1,
				i-1 <      0 and t.GW-1 or i-1,
				i+1 > t.GW-1 and      0 or i+1

				local n = t.cells[t.old_buf][ j_    ][ i_    ]	-- this is the slow part
						+ t.cells[t.old_buf][ j_    ][   i   ]
						+ t.cells[t.old_buf][ j_    ][    _i ]
						+ t.cells[t.old_buf][   j   ][ i_    ]
						+ t.cells[t.old_buf][   j   ][    _i ]
						+ t.cells[t.old_buf][    _j ][ i_    ]
						+ t.cells[t.old_buf][    _j ][   i   ]
						+ t.cells[t.old_buf][    _j ][    _i ]

				t.cells[t.curr_buf][j][i] = (n==3 or (n==2 and t.cells[t.old_buf][j][i] == 1)) and 1 or 0
			end
		end
	end

	return t
end