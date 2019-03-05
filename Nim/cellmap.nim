import csfml, random, sequtils, sksfml

var
    m  :int = 4 #<-- scalar for determining cell and grid sizes
    CS*:int = 16 div m   # cell size
    GW*:int = 80 * m     # grid width
    GH*:int = 50 * m     # grid height
    SW*:int = GW * CS    # screen width
    SH*:int = GH * CS    # screen height
    paused*:bool = false

    pad:int = 1     # spacing around cells
    cell_color_alive = sf_Color("ff8000")
    cell_color_dead = sf_Color("202020")
    quads:VertexArray
    render_states:RenderStates
    cell_texture:Texture
    cellmaps:seq[seq[seq[int8]]]
    curr_buf = 1
    prev_buf = 0


proc toggle_pause*() =
    paused = not paused


proc update_quad(idx:int, color:Color ) =
    quads.getVertex(idx+0)[].color = color
    quads.getVertex(idx+1)[].color = color
    quads.getVertex(idx+2)[].color = color
    quads.getVertex(idx+3)[].color = color


proc init_cells*() =
    quads = sf_VertexArray(PrimitiveType.Quads)
    render_states = sf_RenderStates()

    cellmaps = new_seq[ seq[seq[int8]] ](2)
    cellmaps[curr_buf] = new_seq[ seq[int8] ](GH)

    if CS < 4: pad = 0   # if cells are 2x2 px or smaller, disable padding, or else they'll be 0x0 px

    for j in 0..<GH:
        cellmaps[curr_buf][j] = new_seq[int8](GW)
        for i in 0..<GW:
            cellmaps[curr_buf][j].add(0)
            quads.append( sf_Vertex( sf_Vector2(  i*   CS+pad,   j*   CS+pad ), cell_color_alive ) )
            quads.append( sf_Vertex( sf_Vector2( (i+1)*CS-pad,   j*   CS+pad ), cell_color_alive ) )
            quads.append( sf_Vertex( sf_Vector2( (i+1)*CS-pad,  (j+1)*CS-pad ), cell_color_alive ) )
            quads.append( sf_Vertex( sf_Vector2(  i*   CS+pad,  (j+1)*CS-pad ), cell_color_alive ) )

    cellmaps[prev_buf] = cellmaps[curr_buf] # don't need a deepcopy?


proc randomize_cells*():void =
    for j in 1..<GH-1:
        for i in 1..<GW-1:
            let r = random.rand(100) > 50
            if r:
                cellmaps[curr_buf][j][i] = 1
                update_quad((i+j*GW)*4, cell_color_alive)
            else:
                cellmaps[curr_buf][j][i] = 0
                update_quad((i+j*GW)*4, cell_color_dead)



proc next_generation*(): void =
    curr_buf = 1-curr_buf
    prev_buf = 1-prev_buf

    for j in 0..<GH:
        for i in 0..<GW:
            let l :int = if i-1 >= 0:    i-1 else: GW-1
            let r :int = if i+1 <  GW-1: i+1 else: 0

            let u :int = if j-1 >= 0:    j-1 else: GH-1
            let d :int = if j+1 <  GH:   j+1 else: 0

            let n = cellmaps[prev_buf][ u   ][ l   ] +
                    cellmaps[prev_buf][ u   ][  i  ] +
                    cellmaps[prev_buf][ u   ][   r ] +
                    cellmaps[prev_buf][  j  ][ l   ] +
                    cellmaps[prev_buf][  j  ][   r ] +
                    cellmaps[prev_buf][   d ][ l   ] +
                    cellmaps[prev_buf][   d ][  i  ] +
                    cellmaps[prev_buf][   d ][   r ]

            let alive = n == 3 or (n==2 and cellmaps[prev_buf][j][i] == 1)
            cellmaps[curr_buf][j][i] = int8(alive)
            if alive:  update_quad((i+j*GW)*4, cell_color_alive)
            else:      update_quad((i+j*GW)*4, cell_color_dead)


proc render*(window:RenderWindow) =
    window.draw(quads)


# clean up pointers
proc destroy*() =
    quads.destroy()
    cell_texture.destroy()
