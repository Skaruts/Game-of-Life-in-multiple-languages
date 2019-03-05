#!/usr/local/bin/python
# -*- coding:latin-1 -*-

import sfml as sf
import random

class Cellmap(object):
	def __init__(self, w, h, cs):
		self.GW = w
		self.GH = h
		self.CS = cs
		self.prev_idx = 1
		self.curr_idx = 0
		self.pad = 1 if cs > 2 else 0 # if cells are 2x2 px or smaller, disable padding

		self.ALIVE_COLOR = sf.Color(255, 128, 0)
		self.DEAD_COLOR	= sf.Color(32, 32, 32)

		self.quads = sf.VertexArray( sf.PrimitiveType.QUADS )
		self.cells = []

		self.init_cells()
		self.randomize_cells()


	def draw(self, window):
		window.draw(self.quads)


	def init_cells(self):
		self.cells = [[[ 0 for i in range(self.GW) ]
									for j in range(self.GH) ]
										for k in range(2) ]

		self.quads.resize( self.GW * self.GH *4)

		for j in xrange(self.GH):
			for i in xrange(self.GW):
				INDEX = (i+j*self.GW) * 4

				self.quads[INDEX + 0].position = sf.Vector2(  i    * self.CS + self.pad   ,   j    * self.CS + self.pad ) # top left
				self.quads[INDEX + 1].position = sf.Vector2( (i+1) * self.CS - self.pad   ,   j    * self.CS + self.pad ) # top right
				self.quads[INDEX + 2].position = sf.Vector2( (i+1) * self.CS - self.pad   ,  (j+1) * self.CS - self.pad ) # bot right
				self.quads[INDEX + 3].position = sf.Vector2(  i    * self.CS + self.pad   ,  (j+1) * self.CS - self.pad ) # bot left

				self.quads[INDEX + 0].color = self.DEAD_COLOR
				self.quads[INDEX + 1].color = self.DEAD_COLOR
				self.quads[INDEX + 2].color = self.DEAD_COLOR
				self.quads[INDEX + 3].color = self.DEAD_COLOR
				# self.set_vertices_color(INDEX, self.DEAD_COLOR)


	def update_quad(self, index, c):
		self.quads[index + 0].color = c
		self.quads[index + 1].color = c
		self.quads[index + 2].color = c
		self.quads[index + 3].color = c


	def randomize_cells(self):
		self.alive_cells = 0
		for j in range(self.GH):
			for i in range(self.GW):
				r = random.uniform(0, 100) > 50
				if r:
					self.cells[self.curr_idx][j][i] = 1
					self.update_quad((i+j*self.GW)*4, self.ALIVE_COLOR)
				else:
					self.cells[self.curr_idx][j][i] = 0
					self.update_quad((i+j*self.GW)*4, self.DEAD_COLOR)


	def pass_generation(self):
		self.curr_idx = 1 - self.curr_idx
		self.prev_idx = 1 - self.prev_idx

		for j in range(self.GH):
			for i in range(self.GW):
				j_ = j-1 if j-1 >=       0 else self.GH-1
				_j = j+1 if j+1 <  self.GH else         0
				i_ = i-1 if i-1 >=       0 else self.GW-1
				_i = i+1 if i+1 <  self.GW else         0

				n =   self.cells[self.prev_idx][ j_    ][ i_    ]    \
					+ self.cells[self.prev_idx][ j_    ][   i   ]    \
					+ self.cells[self.prev_idx][ j_    ][    _i ]    \
					+ self.cells[self.prev_idx][   j   ][ i_    ]    \
					+ self.cells[self.prev_idx][   j   ][    _i ]    \
					+ self.cells[self.prev_idx][    _j ][ i_    ]    \
					+ self.cells[self.prev_idx][    _j ][   i   ]    \
					+ self.cells[self.prev_idx][    _j ][    _i ]

				alive = n == 3 or (self.cells[self.prev_idx][j][i] and n == 2)
				self.cells[self.curr_idx][j][i] = int(alive)

				if alive:	self.update_quad((i+j*self.GW)*4, self.ALIVE_COLOR)
				else:		self.update_quad((i+j*self.GW)*4, self.DEAD_COLOR)


