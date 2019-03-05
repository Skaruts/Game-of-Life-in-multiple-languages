#!/usr/local/bin/python
# -*- coding:latin-1 -*-
# python 2.7

import sfml as sf
from cellmap import Cellmap

paused = False

# scalar for cell size, bigger means smaller cells
m = 1           # 1, 2, 4, 8 or 16 (2 or more is very slow)

CS = 16/m       # cell size
GW = 80*m       # grid width
GH = 50*m       # grid height

cm = Cellmap(GW, GH, CS)
window = sf.RenderWindow(sf.VideoMode(GW*CS, GH*CS), "Game of Life (pySFML)")

while window.is_open:
    for event in window.events:
        if type(event) is sf.CloseEvent or type(event) is sf.KeyEvent \
        and (event.code in (sf.Keyboard.ESCAPE, sf.Keyboard.Q)):
            window.close()
        if type(event) is sf.KeyEvent:
            if event.pressed:
                if event.code is sf.Keyboard.SPACE:
                    paused = not paused

    window.clear()

    if not paused:
        cm.pass_generation()
    cm.draw(window)

    window.display()


