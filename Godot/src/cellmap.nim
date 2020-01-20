import random
import gdw
import godot, godotapi/node_2d

gdobj Cellmap of Node2D:
    var cellmaps: seq[seq[seq[int8]]]
    var spawn_rate:int
    var cell_rects: seq[Rect2]
    var curr_buf:int = 1
    var prev_buf:int = 0
    var cell_color_on:Color = col(1, 0.66, 0.01)
    var cell_color_off:Color = col(0.25, 0.25, 0.25, 1)
    var pad:int
    var paused = false
    var CS:int
    var GW:int
    var GH:int
    var draw_dead_cells:bool

    # this is not gdscript's _init()
    proc init*(w, h, cell_size:int, spawn_rate = 50, draw_dead_cells = false) {.gdExport.} =
        self.spawn_rate = spawn_rate
        self.draw_dead_cells = draw_dead_cells

        self.CS = cell_size
        self.GW = w
        self.GH = h
        self.pad = if self.CS > 2: 1 else: 0

        randomize()
        self.init_cellmaps()
        self.randomize_cells()

    method draw*() =
        for j in 0..<self.GH:
            for i in 0..<self.GW:
                if self.cellmaps[self.curr_buf][j][i] == 1:
                    self.draw_rect( self.cell_rects[i+j*self.GW], self.cell_color_on )
                elif self.draw_dead_cells:
                    self.draw_rect( self.cell_rects[i+j*self.GW], self.cell_color_off )

    method process*(delta:float) =
        if not self.paused:
            self.next_generation()

    proc toggle_pause*():bool {.gdExport.} =
        self.paused = not self.paused

    proc init_cellmaps() =
        self.cellmaps = newSeq[ seq[seq[int8]] ](2)
        self.cellmaps[self.curr_buf] = newSeq[ seq[int8] ](self.GH)
        self.cellmaps[self.prev_buf] = newSeq[ seq[int8] ](self.GH)
        for j in 0..<self.GH:
            self.cellmaps[self.curr_buf][j] = newSeq[int8](self.GW)
            self.cellmaps[self.prev_buf][j] = newSeq[int8](self.GW)
            for i in 0..<self.GW:
                let p:int = self.pad
                let x:int = i*self.CS+p
                let y:int = j*self.CS+p
                let w:int = self.CS-p*2
                let h:int = self.CS-p*2
                self.cell_rects.add( rect2( x, y, w, h ) )

    proc randomize_cells*() =
        for j in 0..<self.GH:
            for i in 0..<self.GW:
                let r = rand(100)
                self.cellmaps[self.curr_buf][j][i] = int8(r > self.spawn_rate)

    proc next_generation*() =
        self.curr_buf = 1-self.curr_buf   # switch buffers
        self.prev_buf = 1-self.prev_buf

        for j in 0..<self.GH:
            for i in 0..<self.GW:
                # wrap around
                let u :int = if j-1 >= 0:      j-1 else: self.GH-1     # up
                let d :int = if j+1 < self.GH: j+1 else: 0             # down
                let l :int = if i-1 >= 0:      i-1 else: self.GW-1     # left
                let r :int = if i+1 < self.GW: i+1 else: 0             # right

                # count neighbors
                let n = self.cellmaps[self.prev_buf][ u   ][ l   ] +
                        self.cellmaps[self.prev_buf][ u   ][  i  ] +
                        self.cellmaps[self.prev_buf][ u   ][   r ] +
                        self.cellmaps[self.prev_buf][  j  ][ l   ] +
                        self.cellmaps[self.prev_buf][  j  ][   r ] +
                        self.cellmaps[self.prev_buf][   d ][ l   ] +
                        self.cellmaps[self.prev_buf][   d ][  i  ] +
                        self.cellmaps[self.prev_buf][   d ][   r ]

                # apply rules
                let alive = int8( n == 3 or (n==2 and self.cellmaps[self.prev_buf][j][i] == 1) )
                self.cellmaps[self.curr_buf][j][i] = alive

        # redraw
        self.update()

