-- title: Tiny Life
-- author: MetalDudeBro
-- desc: A toy Game of Life
-- script: lua
-- input: mouse, keyboard

-- version 1.0
-- MIT Licence (c) 2019 MetalDudeBro
---------------------------------------
---------------------------------------
-- TICuare - A UI library for TIC-80
--
-- Copyright (c) 2017 Crutiatix
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
tc={name="tc",elements={},z=1,hz=nil}tc.__index=tc tc.me={nothing=0,click=1,noclick=2,none=3}local e={__index=tc}local function u(r,e,n,t,o,i)return r>n and r<n+o and e>t and e<t+i end local function R(e,o,t)for n,r in pairs(o)do if type(r)=="table"then if type(e[n]or false)=="table"then R(e[n]or{},o[n]or{},t)else if not e[n]or t then e[n]=r end end else if not e[n]or t then e[n]=r end end end return e end local function i(e,n)if(e==nil and n==nil)then for e=0,15 do poke4(16368*2+e,e)end else poke4(16368*2+e,n)end end function tc.lerp(e,n,t)if e==n then return e else if math.abs(e-n)<.005 then return n else return e*(1-t)+n*t end end end local function F(o)local t={}local function r(e)if type(e)~="table"then return e elseif t[e]then return t[e]end local n={}t[e]=n for t,e in pairs(e)do n[r(t)]=r(e)end return setmetatable(n,getmetatable(e))end return r(o)end local function f(o,r,t,n,e)if o then return t elseif r then return n else return e end end function tc.print(t,i,a,o,n,e)n=n or false e=e or 1 local d,r=t:gsub("\n","")local w,h if o then w,h=print(t,i,a,o,n,e),(6+r)*e*(r+1)end return w,h end function tc.font(c,s,f,r,e,a,n,o,t)e=e or-1 a=a or 8 n=n or 8 o=o or false t=t or 1 local d,l=c:gsub("\n","")if type(e)=="table"and type(e[1])=="table"then for t,n in ipairs(e[1])do if type(r)=="table"then i(n,r[t])else i(n,r)end end e=e[2]end local d if r then d=font(c,s,f,e,a,n,o,t)end i()return d,(n+l)*t*(1+l)end function tc.element(t,n)if not n then n=t t="element"end local e=n setmetatable(e,tc)e.hover,e.click=false,false e.activity=n.activity or true e.drag=n.drag or{activity=false}e.align=n.align or{x=0,y=0}e.visibility=n.visibility or true if e.content then if not e.content.scroll then e.content.scroll={x=0,y=0}end e.content.w,e.content.h=e.content.w or e.w,e.content.h or e.h end e.type,e.z=t,tc.z tc.z=tc.z+1 tc.hz=tc.z table.insert(tc.elements,e)return e end function tc.Element(e)return tc.element("element",e)end function tc.Style(e)return e end function tc.Group()local e={type="group",elements={}}setmetatable(e,tc)return e end function tc:updateSelf(e)if e.mouse_x and e.mouse_y and e.event then mouse_x=e.mouse_x mouse_y=e.mouse_y mouse_press=e.press mouse_event=e.event local a,d,n,t,r,e,e local e,i,o=tc.me,self.x-(self.align.x==1 and self.w*.5 or(self.align.x==2 and self.w or 0)),self.y-(self.align.y==1 and self.h*.5-1 or(self.align.y==2 and self.h-1 or 0))a=mouse_event~=e.none and mouse_press or false d=u(mouse_x,mouse_y,i,o,self.w,self.h)n=mouse_event~=e.none and d or false t,r=self.hover,self.hold self.hover=n or(self.drag.active and tc.draging_obj and tc.draging_obj.obj==self)self.hold=((mouse_event==e.click and n)and true)or(a and self.hold)or((n and mouse_event~=e.noclick and self.hold))if mouse_event==e.click and n and self.onClick then self.onClick(self)elseif(mouse_event==e.noclick and n and r)and self.onCleanRelease then self.onCleanRelease(self)elseif((mouse_event==e.noclick and n and r)or(self.hold and not n))and self.onRelease then self.onRelease(self)elseif self.hold and self.onPress then self.onPress(self)elseif not t and self.hover and self.onStartHover then self.onStartHover(self)elseif self.hover and self.onHover then self.onHover(self)elseif t and not self.hover and self.onEndHover then self.onEndHover(self)end if self.hold and(not n or self.drag.active)and not tc.draging_obj then self.hold=self.drag.active tc.draging_obj={obj=self,d={x=i-mouse_x,y=o-mouse_y}}elseif not self.hold and n and(tc.draging_obj and tc.draging_obj.obj==self)then self.hold=true tc.draging_obj=nil end if tc.draging_obj and tc.draging_obj.obj==self and self.drag.active then self.x=(not self.drag.fixed or not self.drag.fixed.x)and mouse_x+tc.draging_obj.d.x or self.x self.y=(not self.drag.fixed or not self.drag.fixed.y)and mouse_y+tc.draging_obj.d.y or self.y local e=self.drag.bounds if e then if e.x then self.x=(e.x[1]and self.x<e.x[1])and e.x[1]or self.x self.x=(e.x[2]and self.x>e.x[2])and e.x[2]or self.x end if e.y then self.y=(e.y[1]and self.y<e.y[1])and e.y[1]or self.y self.y=(e.y[2]and self.y>e.y[2])and e.y[2]or self.y end end if self.track then self:anchor(self.track.ref)end end return n elseif e.focused_element and e.event then local t,i,a,n,r,o=tc.me i=e.event~=t.none and e.press or false a=self==e.focused_element n=e.event~=t.none and a or false r,o=self.hover,self.hold self.hover=n self.hold=((e.event==t.click and n)and true)or(i and self.hold)or((n and e.event~=t.noclick and self.hold))if e.event==t.click and n and self.onClick then self.onClick(self)elseif(e.event==t.noclick and n and o)and self.onCleanRelease then self.onCleanRelease(self)elseif((e.event==t.noclick and n and o)or(self.hold and not n))and self.onRelease then self.onRelease(self)elseif self.hold and self.onPress then self.onPress(self)elseif not r and self.hover and self.onStartHover then self.onStartHover(self)elseif self.hover and self.onHover then self.onHover(self)elseif r and not self.hover and self.onEndHover then self.onEndHover(self)end return n else error("updateSelf error in arguments!")end end function tc:updateTrack()local n,e=self.drag.bounds,self.track if e then self.x,self.y=e.ref.x+e.d.x,e.ref.y+e.d.y if n and n.relative then if n.x then n.x[1]=e.ref.x+e.b.x[1]or nil n.x[2]=e.ref.x+e.b.x[2]or nil end if n.y then n.y[1]=e.ref.y+e.b.y[1]or nil n.y[2]=e.ref.y+e.b.y[2]or nil end end end end function tc:drawSelf()if self.visibility then local S,C,R,h,j,v,u,P,o,r,m,_,p,b,k,z,s,x,e,i,l,d,H,y,g local c,a,e,t,n,w=self.shadow,self.border,self.text,self.icon,self.tiled,self.colors o=self.x-(self.align.x==1 and self.w*.5-1 or(self.align.x==2 and self.w-1 or 0))r=self.y-(self.align.y==1 and self.h*.5-1 or(self.align.y==2 and self.h-1 or 0))if c and c.colors then c.offset=c.offset or{x=1,y=1}C=f(self.hold,self.hover,c.colors[3],c.colors[2],c.colors[1])if C then rect(o+c.offset.x,r+c.offset.y,self.w,self.h,C)end end if w then S=f(self.hold,self.hover,w[3],w[2],w[1])if S then rect(o,r,self.w,self.h,S)end end i=a and(a.width)or 0 y=2*i if n then n.scale=n.scale or 1 n.key=n.key or-1 n.flip=n.flip or 0 n.rotate=n.rotate or 0 n.w=n.w or 1 n.h=n.h or 1 H=f(self.hold,self.hover,n.sprites[3],n.sprites[2],n.sprites[1])if H then clip(o+i,r+i,self.w-y,self.h-y)for e=0,self.w+(8*n.w)*n.scale,(8*n.w)*n.scale do for t=0,self.h+(8*n.h)*n.scale,(8*n.h)*n.scale do spr(H,o+e+i,r+t+i,n.key,n.scale,n.flip,n.rotate,n.w,n.h)end end clip()end end if self.content and self.drawContent then if self.content.wrap and clip then clip(o+i,r+i,self.w-y,self.h-y)end self:renderContent()if self.content.wrap and clip then clip()end end if a and a.colors then k=a.colors R=f(self.hold,self.hover,k[3],k[2],k[1])if R then for e=0,a.width-1 do rectb(o+e,r+e,self.w-2*e,self.h-2*e,R)end end end if a and a.sprites then l=a.key or-1 d=f(self.hold,self.hover,a.sprites[3],a.sprites[2],a.sprites[1])if d then clip(o+8,r,self.w-16+1,self.h)for e=8,self.w-9,8 do spr(d[2],o+e,r,l,1,0,0)spr(d[2],o+e,r+self.h-8,l,1,0,2)end clip()spr(d[1],o,r,l,1,0,0)spr(d[1],o+self.w-8,r,l,1,0,1)clip(o,r+8,self.w,self.h-16+1)for e=8,self.h-9,8 do spr(d[2],o,r+e,l,1,0,3)spr(d[2],o+self.w-8,r+e,l,1,2,1)end clip()spr(d[1],o+self.w-8,r+self.h-8,l,1,0,2)spr(d[1],o,r+self.h-8,l,1,0,3)end end if t and t.sprites and#t.sprites>0 then P=((self.hold and t.sprites[3])and t.sprites[3])or((self.hover and t.sprites[2])and t.sprites[2])or t.sprites[1]z=t.offset or{x=0,y=0}t.align=t.align or{x=0,y=0}spr(P,(o+(t.align.x==1 and self.w*.5-((t.scale*8)/2)or(t.align.x==2 and self.w-(t.scale*8)or 0))+z.x),(r+(t.align.y==1 and self.h*.5-((t.scale*8)/2)or(t.align.y==2 and self.h-(t.scale*8)or 0))+z.y),t.key,t.scale,t.flip,t.rotate,t.w,t.h)end if e and e.print then u=e.colors or{15,15,15}u[1]=u[1]or 15 j=f(self.hold,self.hover,u[3],u[2],u[1])if e.shadow then v=e.shadow h=f(self.hold,self.hover,v.colors[3],v.colors[2],v.colors[1])x=v.offset or{x=1,y=1}end s=e.offset or{x=0,y=0}if e.font then e.space=e.space or{w=8,h=8}m,_=tc.font(e.print,0,200,-1,e.key,e.space.w,e.space.h,e.fixed,e.scale)else m,_=tc.print(e.print,0,200,-1,e.fixed,e.scale)end g=e.align or{x=0,y=0}p=(g.x==1 and o+((self.w*.5)-(m*.5))+s.x or(g.x==2 and o+((self.w)-(m))+s.x-i or o+s.x+i))b=(g.y==1 and r+((self.h*.5)-(_*.5))+s.y or(g.y==2 and r+((self.h)-(_))+s.y-i or r+s.y+i))if e.font then if type(h)=="table"then tc.font(e.print,p+x.x,b+x.y,h,e.key,e.space.w,e.space.h,e.fixed,e.scale)end tc.font(e.print,p,b,j,e.key,e.space.w,e.space.h,e.fixed,e.scale)else if h then tc.print(e.print,p+x.x,b+x.y,h,e.fixed,e.scale)end tc.print(e.print,p,b,j,e.fixed,e.scale)end end end end function tc:renderContent()local i,o,n,t,r,e e=self.align i=self.x-(e.x==1 and self.w*.5 or(e.x==2 and self.w or 0))o=self.y-(e.y==1 and self.h*.5-1 or(e.y==2 and self.h-1 or 0))n=self.border and self.border.width or 1 t=i-(self.content.scroll.x or 0)*(self.content.w-self.w)+n r=o-(self.content.scroll.y or 0)*(self.content.h-self.h)+n self.drawContent(self,t,r)end function tc:Content(e)self.drawContent=e return self end function tc:scroll(e)if e~=nil then e.x=e.x or 0 e.y=e.y or 0 if self.content then e.x=(e.x<0 and 0)or(e.x>1 and 1)or e.x e.y=(e.y<0 and 0)or(e.y>1 and 1)or e.y self.content.scroll.x,self.content.scroll.y=e.x or self.content.scroll.x,e.y or self.content.scroll.y end return self else if self.content then return self.content.scroll end end end function tc.update(e,l,o)local t,r=tc.me,tc.elements local d,i,a,n=t.nothing,false,{},nil if type(e)=="table"then o=l end if e then if tc.click and not o then tc.click=false d=t.noclick tc.draging_obj=nil elseif not tc.click and o then tc.click=true d=t.click tc.draging_obj=nil end for e=1,#r do table.insert(a,r[e])end table.sort(a,function(n,e)return n.z>e.z end)for r=1,#a do n=a[r]if n then if type(e)=="table"then if n:updateSelf{focused_element=e,press=o,event=(i or not n.activity)and t.none or d}then i=true end elseif e and l and type(e)~="table"then if n:updateSelf{mouse_x=e,mouse_y=l,press=o,event=((i or(tc.draging_obj and tc.draging_obj.obj~=n))or not n.activity)and t.none or d}then i=true end else error("Wrong arguments for update()")end end end for e=#r,1,-1 do if r[e]then r[e]:updateTrack()end end end end function tc.draw()local e={}for n=1,#tc.elements do if tc.elements[n].draw then table.insert(e,tc.elements[n])end end table.sort(e,function(n,e)return n.z<e.z end)for n=1,#e do e[n]:drawSelf()end end function tc:style(e)if self.type=="group"then for t,n in pairs(self.elements)do R(n,F(e),false)end else R(self,F(e),false)end return self end function tc:anchor(n)if self.type=="group"then for t,e in pairs(self.elements)do e:anchor(n)end else local e,t,r,o,i=self.drag.bounds,nil,nil,nil,nil if e and e.x then t=e.x[1]-n.x r=e.x[2]-n.x elseif e and e.y then o=e.y[1]-n.y i=e.y[2]-n.y end self.track={ref=n,d={x=self.x-n.x,y=self.y-n.y},b={x={t,r},y={o,i}}}end return self end function tc:group(n,e)if e then n.elements[e]=self else table.insert(n.elements,self)end return self end function tc:active(e)if e~=nil then if self.type=="group"then for t,n in pairs(self.elements)do n:active(e)end else self.activity=e end return self else if self.type=="group"then local e={}for n,t in pairs(self.elements)do e[n]=t:active()end return e else if self.activity~=nil then return self.activity end end end end function tc:visible(e)if e~=nil then if self.type=="group"then for t,n in pairs(self.elements)do n:visible(e)end else self.visibility=e end return self else if self.type=="group"then local e={}for n,t in pairs(self.elements)do e[n]=t:visible()end return e else if self.activity~=nil then return self.visibility end end end end function tc:dragBounds(e)if e~=nil then self.drag.bounds=e else return self.drag.bounds end end function tc:horizontalRange(n)local e=self.drag.bounds if n~=nil then self.x=e.x[1]+(e.x[2]-e.x[1])*n else assert(e and e.x and#e.x==2,"X bounds error!")return(self.x-e.x[1])/(e.x[2]-e.x[1])end end function tc:verticalRange(n)local e=self.drag.bounds if n~=nil then self.y=e.y[1]+(e.y[2]-e.y[1])*n else assert(e and e.y and#e.y==2,"Y bounds error!")return(self.y-e.y[1])/(e.y[2]-e.y[1])end end function tc:index(e)if e~=nil then if self.type=="group"then local n for t,e in pairs(self.elements)do if not n or e.z<n then n=e.z end end for r,t in pairs(self.elements)do local e=t.z-n+e t:index(e)end else self.z=e if e>tc.hz then tc.hz=e end end else return self.z end return end function tc:toFront()if self.z<tc.hz or self.type=="group"then return self:index(tc.hz+1)end end function tc:remove()for e=#tc.elements,1,-1 do if tc.elements[e]==self then table.remove(tc.elements,e)self=nil end end end function tc.empty()for e=1,#tc.elements do tc.elements[e]=nil end end
---------------------------------------
---------------------------------------

local	-- some shortenings
fls,   tru,  floor,      ceil,      max,      min,      abs,      str =
false, true, math.floor, math.ceil, math.max, math.min, math.abs, tostring



-- some options you may want to
-- change permanently
local draw_dead_cells = fls
local wrap_around = tru
local use_padding = tru

-- default zoom scalar
-- (higher = smaller cells)
-- use 1, 2, 4 or 8
-- (drawing tools get a bit buggy
-- with '8' or low fps, unless you
-- pause before drawing)
local zoom = 4




local	-- keys
PGUP, PGDN, CTRL, SHIFT, ALT, SPC, ENT, BSLASH, GRAVE, TAB =
54,   55,   63,   64,    65 , 48,  50,  41,     44,    49
local
A,B,C,D,E,F,G,H,I,J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z =
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
local	-- number keys
N0, N1, N2, N3, N4, N5, N6, N7, N8, N9 =
27, 28, 29, 30, 31, 32, 33, 34, 35, 36
local
ct_mod, sh_mod, al_mod, m1_pressed, m1_released, mouse_on_ui =
fls,    fls,    fls,    fls,        tru,         fls

local -- mouse, real pos / grid pos / mouse btns
rmx, rmy, mx, my, lmb, mmb, rmb =
0,   0,   0,  0,  fls, fls, fls

local m1, m2, m3 = -- mouse btn states
{clicked=fls, held=fls},
{clicked=fls, held=fls},
{clicked=fls, held=fls}

local	-- colors
col_bg, col_ui_bg, col_text, col_header, col_dead, col_alive, col_selected =
0,      1,         5,        9,          2,        8,         11
local
col_erasing, col_ui_lines, col_dim_text, col_paused =
7,           13,           14,           7

-- prev/curr/selection cellmaps
local pre, cur, sel = 1, 2, 3
local cells = {}  -- actual cellmaps

local SS = 8 -- sprite size
local CS, GW, GH = SS//zoom, 30*zoom, 17*zoom -- cell size, grid width/height
local pad = 0 -- padding for cell rects (will always be 0 if cells are too small - see 'set_padding()')

local
anim, help_scr, ui_vis =
nil,  fls,      tru
local
paused, stopped, eraser, rand_at_start, t_old =
tru,    tru,     fls,    tru,           0

local -- UI
ui_gr, tlbar_anchor, ui_bg, tlbar, ibar, topbar, paused_text =
nil,   nil,          nil,   nil,   nil,  nil,    nil

local -- tiles
bar_outline, bar_bg =
132,		 255

local 	-- starting state is inverted for these
use_topbar, use_ibar =
fls,        fls

local 	-- living cells / generations
l_cells, gens =
0,       0

local 	-- game screens
GAME_SCR, HELP_SCR1, HELP_SCR2, HELP_SCR3, OPTS_SCR1, OPTS_SCR2 =
0,        1,         2,         3,         10,        11

local
num_help_scrs, num_options_screens, cur_scr =
3,			          1,	              				GAME_SCR

-- tools
--------------------------
local
tool,    tl_origin, tl_w, tl_h =
"brush", nil,       0,    0

local -- filled/square/centered on mouse
tl_alt_mode_1, tl_alt_mode_2, tl_alt_mode_3 =
fls,		   fls,			  fls

local
tl_is_drawing, tl_brush_size, tl_bbox =
fls,           0,             nil

local 	-- pattern tool
tl_cats, tl_cur_pats, tl_patt_pid, tl_cur_cat, tl_cur_pat =
{}, 	 {}, 		  0, 		   1,		   1


function set_padding(enable)
	use_padding = enable
	pad = use_padding == true and (CS == 1 and 0 or 1) or 0
end

function set_zoom(dir)
	local z = zoom
	if dir == 1 then 	z = clamp(z * 2, 1, 8)
	else				z = clamp(z // 2, 1, 8)
	end

	if z ~= zoom then
		zoom = z
		CS = SS//zoom
		GW = 30*zoom
		GH = 17*zoom
		set_padding(use_padding)
		gens = 0
		l_cells = 0
		create_cells()
		-- fill_grid(true)
		if not paused then pause() end
	end
end

---------------------------------------
--              GAME                 --
---------------------------------------

function init()
	set_padding(use_padding)
	tl_origin = Point.nu()
	tl_bbox = Rect.nu()
	tl_init_pats()
	create_cells()
	if rand_at_start then rand_cells() end

	anim = Animator.nu()

	build_tlbar()
	build_ibar()
	build_topbar()

	toggle_topbar()

	tlbar.btns["brush"]:toggle_state()
end

function build_tlbar()
	ui_gr = tc.Group()

	ui_bg = tc.element({
		x=0,y=0,w=240,h=136,
		onStartHover = function(self) mouse_on_ui = fls end,
		onEndHover = function(self) mouse_on_ui = tru end
	})

	tlbar_gr = tc.Group():group(ui_gr, "tlbar_group")
	tlbar_anchor = nu_anchor_btn( 128, 0, 0, "Drag me! (U/2xLMB to reset)" ):group(tlbar_gr, "tlbar_anchor")
	tlbar = new_tlbar(bar_outline, 0, 0, SS*2, SS*9):anchor(tlbar_anchor):group(tlbar_gr, "tlbar")

	tlbar.mode = nu_togl_btn(144, 0, SS*1, "Toggle draw/eraser mode (E)", nil, "toggle", toggle_eraser ):anchor(tlbar_anchor):group(tlbar_gr, "tl_eraser_mode")

	tlbar.btns["brush"]   = nu_togl_btn(160, SS*0, SS*3, "Brush Tool (V/1)", tlbar, "on", switch_tool, {"brush" } ):anchor(tlbar_anchor):group(tlbar_gr, "brush")
	tlbar.btns["line"]    = nu_togl_btn(208, SS*1, SS*3, "Line Tool (L)", tlbar, "on", switch_tool, {"line"   } ):anchor(tlbar_anchor):group(tlbar_gr, "line")
	tlbar.btns["rect"]    = nu_togl_btn(176, SS*0, SS*4, "Rectangle Tool (R)", tlbar, "on", switch_tool, {"rect"   } ):anchor(tlbar_anchor):group(tlbar_gr, "rect")
	tlbar.btns["circle"]  = nu_togl_btn(192, SS*1, SS*4, "Circle Tool (C)", tlbar, "on", switch_tool, {"circle" } ):anchor(tlbar_anchor):group(tlbar_gr, "circle")
	tlbar.btns["fill"]    = nu_togl_btn(224, SS*0, SS*5, "Fill Tool (F)", tlbar, "on", switch_tool, {"fill"   } ):anchor(tlbar_anchor):group(tlbar_gr, "fill")
	tlbar.btns["pattern"] = nu_togl_btn(240, SS*1, SS*5, "Pattern Tool (2-6)", tlbar, "on", switch_tool, {"pattern"} ):anchor(tlbar_anchor):group(tlbar_gr, "pattern")

	rect_gr = tc.Group():group(tlbar_gr, "rect_gr")
	tlbar.r_gr = nu_btn_list(SS*2, 0, 0, 0):anchor( tlbar_anchor )
	tlbar.r_gr.btns[1] = nu_togl_icn(150, SS*0, SS*7, "Square (shift)" ):anchor( tlbar_anchor ):group(rect_gr, "propor_r")
	tlbar.r_gr.btns[2] = nu_togl_icn(166, SS*1, SS*7, "Filled (ctrl)" ):anchor( tlbar_anchor ):group(rect_gr, "fill_r")
	tlbar.r_gr.btns[3] = nu_togl_icn(182, SS*0, SS*8, "Centered (alt)" ):anchor( tlbar_anchor ):group(rect_gr, "center_r")

	circ_gr = tc.Group():group(tlbar_gr, "circle_group")
	tlbar.c_gr = nu_btn_list(SS*2, 0, 0, 0):anchor( tlbar_anchor )
	tlbar.c_gr.btns[1] = nu_togl_icn(198, SS*0, SS*7, "Circle (shift)" ):anchor( tlbar_anchor ):group(circ_gr, "propor_c")
	tlbar.c_gr.btns[2] = nu_togl_icn(214, SS*1, SS*7, "Filled (ctrl)" ):anchor( tlbar_anchor ):group(circ_gr, "fill_c")
	tlbar.c_gr.btns[3] = nu_togl_icn(230, SS*0, SS*8, "Centered (alt)" ):anchor( tlbar_anchor ):group(circ_gr, "center_c")

	nu_icon(130, 0, SS*2, 2, 1):anchor(tlbar_anchor):group(tlbar_gr, "sep1")
	nu_icon(130, 0, SS*6, 2, 1):anchor(tlbar_anchor):group(tlbar_gr, "sep1")

	rect_gr:visible(fls)
	rect_gr:active(fls)
	circ_gr:visible(fls)
	circ_gr:active(fls)

	tlbar_anchor.set_origin(tlbar_anchor, 0, 26)
	tlbar_anchor:toFront()

	anim:add_anim("tlbar_hide", tlbar_anchor, tlbar_anchor.x-SS*2-1, tlbar_anchor.y)
	anim:add_anim("tlbar_show", tlbar_anchor, tlbar_anchor.x, tlbar_anchor.y)
end

function build_ibar()
	ui_ibar_group = tc.Group():group(ui_gr, "ibar_group")
	ibar = nu_ibar(bar_bg, bar_outline, 0, 0, SS*30+2, SS*1+2):group(ui_ibar_group, "ibar")

	ibar:add_label("nfo", new_label("",  SS*7, 2, col_text, {x=0, y=0}, fls):group(ui_ibar_group, "nfo") )
	ibar:add_label("help", new_label("(H)", SS*30, 2, col_header, {x=2, y=0}, fls):group(ui_ibar_group, "help") )
	ibar:add_label("mouse", new_label("", 2, 2, col_dim_text, {x=0, y=0}, fls):group(ui_ibar_group, "lb1") )
	ibar:set_pos(-1, SS*16-1)

	anim:add_anim("ibar_hide", ibar, ibar.x, ibar.y+SS+1)
	anim:add_anim("ibar_show", ibar, ibar.x, ibar.y)

	toggle_ibar()
end

function build_topbar()
	ui_topbar_group = tc.Group():group(ui_gr, "topbar_group")
	topbar = nu_ibar(bar_bg, bar_outline, 0, 0, SS*30+2, SS*1+2):group(ui_topbar_group, "topbar")

	play_btn_gr = tc.Group()
	pause_btn_gr = tc.Group()

	rand_btn = nu_simp_btn(136, SS*7, 1, "Randomize cells", rand_cells):anchor(topbar)

	decel_btn = nu_simp_btn(200, SS*8, 1, "Speed -- (N/A yet)" --[[, callback, args]]):anchor(topbar)
	stop_button  = nu_togl_btn(152, SS*9, 1, "Stop/clear", nil, "sticky", stop):anchor(topbar)
	play_button  = nu_togl_btn(168, SS*10, 1, "Play/Pause/Unpause", nil, "toggle", pause):anchor(topbar):group(play_btn_gr, "b1")
	pause_button = nu_togl_btn(184, SS*10, 1, "Play/Pause/Unpause", nil, "toggle", pause):anchor(topbar):group(pause_btn_gr, "b2")
	accel_btn   = nu_simp_btn(203, SS*11,  1, "Speed ++ (N/A yet)" --[[, callback, args]]):anchor(topbar)

	stop_button:turn_on()

	pause_btn_gr:visible(fls)
	pause_btn_gr:active(fls)

	topbar:add_label("gens", new_label("G: ", 2, 2, col_text, {x=0, y=0}, fls):group(ui_topbar_group, "lb1") )
	topbar:add_label("cells1", new_label("C:         |         /", SS*15-1, 2, col_text, {x=0, y=0}, fls):group(ui_topbar_group, "lb2") )
	topbar:add_label("cells2", new_label("", SS*20, 2, col_text, {x=2, y=0}, fls):group(ui_topbar_group, "lb3") )
	topbar:add_label("cells3", new_label("", SS*25, 2, col_text, {x=2, y=0}, fls):group(ui_topbar_group, "lb4") )
	topbar:add_label("cells4", new_label("", SS*30, 2, col_text, {x=2, y=0}, fls):group(ui_topbar_group, "lb5") )

	topbar:set_pos(-1, -1)


	anim:add_anim("topbar_hide", topbar, topbar.x, topbar.y-SS-1)
	anim:add_anim("topbar_show", topbar, topbar.x, topbar.y)
end

function TIC()
	local t_now = time()/1000
	local dt = t_now-t_old
	t_old = t_now

	update(dt)
	draw()
end

function update(dt)
	update_mouse()
	handle_keys()

	if tl_type == "rect" then
		tlbar.r_gr.btns[1]:set_state(sh_mod)
		tlbar.r_gr.btns[2]:set_state(ct_mod)
		tlbar.r_gr.btns[3]:set_state(al_mod)
	elseif tl_type == "circle" then
		tlbar.c_gr.btns[1]:set_state(sh_mod)
		tlbar.c_gr.btns[2]:set_state(ct_mod)
		tlbar.c_gr.btns[3]:set_state(al_mod)
	end

	if cur_scr == GAME_SCR then
		if use_ibar then ibar:set_text("nfo", "") end

		if not mouse_on_ui then
			clear_selects()
			tl_draw_points( mx, my )
			ibar:set_text("mouse", zoom.." | "..mx..", "..my)
		end

		if not paused then next_gen() end

		topbar:set_text("gens", "G: "..gens)
		topbar:set_text("cells2", str(l_cells))
		topbar:set_text("cells3", str((GW*GH)-l_cells))
		topbar:set_text("cells4", str(GW*GH))

		anim:update()
		tc.update(rmx, rmy, lmb, mmb, rmb)

	elseif cur_scr == OPTS_SCR then
		-- TODO?
	end
end

function draw()
	cls(col_bg)
	if cur_scr == GAME_SCR then
		if CS > 1 then draw_cells()
		else           draw_pix() end
		tc.draw()
	elseif cur_scr == HELP_SCR1 then	draw_help1()
	elseif cur_scr == HELP_SCR2 then	draw_help2()
	elseif cur_scr == HELP_SCR3 then	draw_help3()
	elseif cur_scr == OPTS_SCR then
		--draw_options()
	end
end

function draw_cells()
	for j=1, GH do
		for i=1, GW do
			local x, y, w, h =
				(i-1) * CS + pad,
			 (j-1) * CS + pad,
			 CS - pad, -- ( CS > 2 and pad or 0) ,
			 CS - pad  -- ( CS > 2 and pad or 0)

			if ( (mx == i and my == j and not tl_is_drawing) or (cells[sel][j][i] == 1) )
			and not mouse_on_ui then
				rect(x, y, w, h, eraser and col_erasing or col_selected)
			elseif cells[cur][j][i] == 1 then
				rect(x, y, w, h, col_alive)
			elseif draw_dead_cells then
				rect(x, y, w, h, col_dead)
			end
		end
	end
end

function draw_pix()
	for j=1, GH do
		for i=1, GW do
			local x, y = i-1, j-1

			if ( (mx == i and my == j and not tl_is_drawing) or (cells[sel][j][i] == 1) )
			and not mouse_on_ui then
				pix(x, y, eraser and col_erasing or col_selected)
			elseif cells[cur][j][i] == 1 then
				pix(x, y, col_alive)
			elseif draw_dead_cells then
				pix(x, y, col_dead)
			end
		end
	end
end

function build_options_screen()
	-- TODO?
end


function draw_help_stuff()
	writec("Help ".. cur_scr .."/"..num_help_scrs, 'x', 0, 0 , col_header)
	writec("H >>  ", 'x', nil, 16, col_header, fls)
end

function draw_help1()
	draw_help_stuff()
	write("Controls ", 1, 1, col_header)
	str1 = [[
				H         Cycle help screens
				SPACE     Pause/play
				SHIFT-R   Reset (stop)
				SHIFT-C/F Revive/kill all cells
				ENTER     Randomize cells
				K         Draw dead cells
				G         Next Generation (if paused)
				I         Toggle information bar
				TAB/U     Toggle/Reset UI
				PG-UP/DN  Zoom in/out (resets cells)
				P         Toggle padding (if zoom<8)
			]]
	write(str1:gsub('\t', ''), 2, 2, col_text, tru)

	write("Mouse editing ", 1, 12, col_header)
	str4 = [[
				LMB       Draw
				RMB       Erase(brush tool)/cancel
				MMB       Erase(non-brush tools)
			]]
	write(str4:gsub('\t', ''), 2, 13, col_text, tru)
end

function draw_help2()
	draw_help_stuff()
	write("Tools ", 1, 1, col_header)
	str2 = [[
				V/1       Brush tool
				2-6       Pattern tool/categories
				L         Line tool
				R/C       Rectangle/circle tools
				F         Fill tool
			]]
	write(str2:gsub('\t', ''), 2, 2, col_text, tru)

	write("Tool modes ", 1, 7, col_header)
	str3 = [[
				E         Toggle eraser mode
				CTRL      Filled rect/circle
				SHIFT     Proportional rect/circle
				ALT       Centered rect/circle
				W         Expand brush/next pattern
				S         Shrink brush/prev pattern
			]]
	write(str3:gsub('\t', ''), 2, 8, col_text, tru)
end

function draw_help3()
	draw_help_stuff()
	write("Pattern Categories ", 1, 2, col_header)
	str2 = [[
				2 - Static
				3 - Blinkers
				4 - Amusing/Explosive
				5 - Gliders
				6 - Glider Gun!









				Lol Note: The Glider Gun doesn't fit
				  on the screen with zoom level 1
			]]
	write(str2:gsub('\t', ''), 2, 3, col_text, tru)
end

function handle_keys()
	ct_mod = key(CTRL)
	sh_mod = key(SHIFT)
	al_mod = key(ALT)

	-- if tl_type ~= "brush" then
		tl_alt_mode_1 = ct_mod
		tl_alt_mode_2 = sh_mod
		tl_alt_mode_3 = al_mod
	-- end

	if keyp(SPC) then
		if sh_mod then stop_button:toggle_state()
		else toggle_pause() end
	elseif keyp(P)					then set_padding(not use_padding)
	elseif keyp(TAB)			then toggle_ui()
	elseif keyp(G, 10, 5)			then
		if paused then next_gen()end
		if stopped then toggle_pause() toggle_pause() end

	elseif keyp(ENT)				then rand_cells()
	elseif keyp(E)					then tlbar.mode:toggle_state()

	elseif keyp(H)					then toggle_help()
	elseif keyp(I)					then toggle_ibar()
	elseif keyp(V)
	or     keyp(N1)					then if tl_type ~= "brush" then tlbar.btns["brush"]:toggle_state() end
	elseif keyp(U)					then tlbar_anchor:reset()
	elseif keyp(L)					then if tl_type ~= "line" then tlbar.btns["line"]:toggle_state() end
	elseif keyp(K)					then toggle_d_cells()
	elseif keyp(O)					then toggle_topbar()

	elseif keyp(PGUP)				then	set_zoom(-1)
	elseif keyp(PGDN)				then	set_zoom(1)

	elseif keyp(R) 					then if tl_type ~= "rect" then tlbar.btns["rect"]:toggle_state() end

	elseif keyp(C) and     sh_mod 	then fill_grid(fls)
	elseif keyp(C) and not sh_mod 	then if tl_type ~= "circle" then tlbar.btns["circle"]:toggle_state() end
	elseif keyp(F) and     sh_mod 	then fill_grid(tru)
	elseif keyp(F) and not sh_mod 	then if tl_type ~= "fill" then tlbar.btns["fill"]:toggle_state() end

	elseif keyp(W, 10, 5) then
		if tl_type == "brush" 		then tl_expand()
		elseif tl_type == "pattern" then tl_next_pattern() end
	elseif keyp(S, 10, 5) then
		if tl_type == "brush" 		then tl_contract()
		elseif tl_type == "pattern" then tl_prev_pattern() end

	elseif keyp(N2) then
		if tl_type ~= "pattern" 	then tlbar.btns["pattern"]:toggle_state() end
		tl_set_category(1)
	elseif keyp(N3) then
		if tl_type ~= "pattern" 	then tlbar.btns["pattern"]:toggle_state() end
		tl_set_category(2)
	elseif keyp(N4) then
		if tl_type ~= "pattern" 	then tlbar.btns["pattern"]:toggle_state() end
		tl_set_category(3)
	elseif keyp(N5) then
		if tl_type ~= "pattern" 	then tlbar.btns["pattern"]:toggle_state() end
		tl_set_category(4)
	elseif keyp(N6) then
		if tl_type ~= "pattern" 	then tlbar.btns["pattern"]:toggle_state() end
		tl_set_category(5)
	end
end

function update_mouse()
	-- wish I could make this simpler...
	rmx, rmy, lmb, mmb, rmb = mouse()
	if CS > 1 then mx, my = (rmx-1)//CS+1, (rmy-1)//CS+1
	else mx, my = rmx//CS+1, rmy//CS+1 end
	mx = clamp(mx, 1, GW)
	my = clamp(my, 1, GH)

	if not lmb and m1.held then                        		m1.held = fls
	elseif lmb and not m1.clicked and not m1.held then 		m1.clicked = tru
	elseif lmb and m1.clicked and not m1.held then
		m1.held = tru
		m1.clicked = fls
	end

	if not rmb and m2.held then                        m2.held = fls
	elseif rmb and not m2.clicked and not m2.held then m2.clicked = tru
	elseif rmb and m2.clicked and not m2.held then
		m2.held = tru
		m2.clicked = fls
	end

	if not mmb and m3.held then                        m3.held = fls
	elseif mmb and not m3.clicked and not m3.held then m3.clicked = tru
	elseif mmb and m3.clicked and not m3.held then
		m3.held = tru
		m3.clicked = fls
	end

	if m1.clicked or m2.clicked or m3.clicked then
		mouse_clicked(m1.clicked, m2.clicked, m3.clicked) end

	mouse_held(m1.held, m2.held, m3.held)
end

function mouse_held(mb1, mb2, mb3)
	if not mouse_on_ui then
		if mb1 then
			if tl_type == "brush" then commit_selects(not eraser)
			elseif tl_type == "line" then tl_start_drawing(mx, my) end
		elseif mb2 then
			if tl_type == "brush" then commit_selects(fls) end
end	end end

function mouse_clicked(mb1, mb2, mb3)
	if not mouse_on_ui and tl_type ~= "brush" then
		if mb2 then cancel_tool()
		else
			if (tl_type == "fill"
			or tl_type == "pattern")
			or tl_is_drawing then
				if mb1 then			commit_selects(not eraser)
				elseif mb3 then		commit_selects(fls) end
				tl_toggle_drawing()
			else
				tl_toggle_drawing(mx, my)
end	end	end end

function toggle_ui()
	if ui_vis then
		if not anim:is_playing() then
			anim:add_anim("tlbar_show", tlbar_anchor, tlbar_anchor.x, tlbar_anchor.y)
			anim:play("tlbar_hide")
			anim:play("ibar_hide")
			anim:play("topbar_hide")
			ui_vis = fls
		end
	else
		if not anim:is_playing() then
			anim:play("tlbar_show")
			anim:play("ibar_show")
			anim:play("topbar_show")
			ui_vis = tru
end	end end

function toggle_help()
	if cur_scr == GAME_SCR then	cur_scr = HELP_SCR1
	else                        cur_scr = (cur_scr+1)%(num_help_scrs+1) end
end

function toggle_pause()
	if stopped then
		play_button:toggle_state()
		pause_button:toggle_state() -- a bit of a hack here
		pause_button:toggle_state() -- to function properly
	else
		pause_button:toggle_state()	end
end

function pause()
	if stopped then
		stopped = fls
		paused = fls

		play_btn_gr:visible(fls)
		play_btn_gr:active(fls)

		pause_btn_gr:visible(tru)
		pause_btn_gr:active(tru)

		stop_button:turn_off()
	elseif not paused then
		paused = tru

		pause_btn_gr:visible(tru)
		pause_btn_gr:active(tru)
	elseif paused then
		paused = fls
	end
end

function stop()
	gens = 0
	fill_grid(fls)

	paused = tru
	stopped = tru

	play_btn_gr:visible(tru)
	play_btn_gr:active(tru)
	play_button:turn_off()

	pause_button:turn_off()
	pause_btn_gr:visible(fls)
	pause_btn_gr:active(fls)
end

function set_tooltip(tip) ibar:set_text("nfo", tip) end
function toggle_eraser() eraser = not eraser end
function toggle_d_cells() draw_dead_cells = not draw_dead_cells end
function toggle_topbar()
	use_topbar = not use_topbar

	ui_topbar_group:visible(use_topbar)
	ui_topbar_group:active(use_topbar)
end

function toggle_ibar()
	use_ibar = not use_ibar
	ui_ibar_group:visible(use_ibar)
	ui_ibar_group:active(use_ibar)
end

function next_gen()
	if wrap_around then next_gen_wrap()
	else 				next_gen_nowrap()
	end
	gens = gens +1
end

function next_gen_wrap()
	cur, pre = pre, cur

	for j=1, GH do
		for i=1, GW do
			local j_, _j, i_, _i =
				j-1 <  1 and GH or j-1,
				j+1 > GH and  1 or j+1,
				i-1 <  1 and GW or i-1,
				i+1 > GW and  1 or i+1

			local n =
							cells[pre][ j_    ][ i_    ]	-- this is the slow part
					+ cells[pre][ j_    ][   i   ]
					+ cells[pre][ j_    ][    _i ]
					+ cells[pre][   j   ][ i_    ]
					+ cells[pre][   j   ][    _i ]
					+ cells[pre][    _j ][ i_    ]
					+ cells[pre][    _j ][   i   ]
					+ cells[pre][    _j ][    _i ]

			local oc = cells[pre][j][i] == 1 -- old cell
			local alive = n==3 or (n==2 and oc)
			cells[cur][j][i] = num(alive)

			if alive then	l_cells = l_cells + (oc and 0 or 1)
			else			l_cells = l_cells + (oc and -1 or 0)
			end
end end end

function next_gen_nowrap()
	cur, pre = pre, cur

	for j=1, GH do
		for i=1, GW do
			-- this is considerably slower than the wrapping function
			local j_, _j, i_, _i =
				j-1 >=  1,
				j+1 <= GH,
				i-1 >=  1,
				i+1 <= GW

			local n =
					  ( (j_ and i_) and cells[pre][ j-1   ][ i-1   ] or 0 )
					+ ( (j_       ) and cells[pre][ j-1   ][   i   ] or 0 )
					+ ( (j_ and _i) and cells[pre][ j-1   ][   i+1 ] or 0 )
					+ ( (       i_) and cells[pre][   j   ][ i-1   ] or 0 )
					+ ( (       _i) and cells[pre][   j   ][   i+1 ] or 0 )
					+ ( (_j and i_) and cells[pre][   j+1 ][ i-1   ] or 0 )
					+ ( (_j       ) and cells[pre][   j+1 ][   i   ] or 0 )
					+ ( (_j and _i) and cells[pre][   j+1 ][   i+1 ] or 0 )

			local oc = cells[pre][j][i] == 1 -- old cell
			local alive = n==3 or (n==2 and oc)
			cells[cur][j][i] = num(alive)

			if alive then	l_cells = l_cells + (oc and 0 or 1)
			else			l_cells = l_cells + (oc and -1 or 0)
			end
end end end

function rand_cells()
	l_cells = 0
	gens = 0
	-- if not stopped then stop_button:toggle_state() end
	for j=1, GH do
		for i=1, GW do
			local alive = num( math.random() > 0.5 )
			cells[cur][j][i] = alive
			l_cells = l_cells + alive
		end
	end
end

function create_cells()
	for g=1, 3 do cells[g] = {} end

	for j=1, GH do
		for g=1, 3 do cells[g][j] = {} end
		for i=1, GW do
			for g=1, 2 do cells[g][j][i] = 0 end end end
end

function fill_grid(fill)
	for j=1, GH do
		for i=1, GW do
			cells[cur][j][i] = num(fill)
		end end
	l_cells = (fill and GW*GH or 0)
end

function commit_selects(draw)
	for j=1, GH do
		for i=1, GW do
			if cells[sel][j][i] == 1 then
				if draw then
					if cells[cur][j][i] ~= 1 then l_cells = l_cells + 1 end
					cells[cur][j][i] = 1
				else
					if cells[cur][j][i] ~= 0 then l_cells = l_cells -1 end
					cells[cur][j][i] = 0
end	end	end end end

function clear_selects()
	for j=1, GH do
		for i=1, GW do
			cells[sel][j][i] = 0 end end
end

---------------------------------------
--    HELPERS    ----------------------
---------------------------------------
-- print text w/ drop shadow
function write(txt, x, y, col, fix, ofsx, ofsy)
	local ofsx, ofsy = ofsx or 0, ofsy or 0
	print(txt, x*SS+ofsx+1, y*SS+ofsy+1, 3, fix, 1) -- shadow
	print(txt, x*SS+ofsx,   y*SS+ofsy, col, fix, 1) end

-- print centered w/ drop shadow
function writec(t, axis, x, y, c, fix)
	local c = c or 15
	if axis == 'x' then
		print(t, 0+(240-print(t, 0, -6))//2, 2+y*SS, 3, fix) -- x
		print(t, (240-print(t, 0, -6))//2, 1+y*SS, c, fix) -- x
	elseif axis == 'y' then
		print(t, 3+x*SS, 1+(136-SS)//2, 3, fix) -- y
		print(t, 2+x*SS, (136-SS)//2, c, fix) -- y
	else
		print(t, 1+(240-print(t, 0, -6))//2, 1+(136-SS)//2, 3, fix) -- xy
		print(t, (240-print(t, 0, -6))//2, (136-SS)//2, c, fix) -- xy
	end
end

function num(v, base)
	if     type(v) == 'boolean' then return v and 1 or 0
	elseif type(v) == 'string' then return base == nil and tonumber(v) or tonumber(v, base)
	else return v == nil and 0 or v end end

function clamp(v, l, h)
	return max(l, min(h, v)) end

function round(a)
	local fl = floor(a)
	return a-fl >= 0.5 and fl+1 or fl end


---------------------------------------
--    TOOLS    ------------------------
---------------------------------------
function cancel_tool()
	if tl_type ~= nil then
		tl_stop_drawing() end end

function switch_tool(t)
	cancel_tool()
	tl_type = t

	rect_gr:visible( t == "rect" and ui_vis )
	rect_gr:active( t == "rect" and ui_vis )

	circ_gr:visible( t == "circle" and ui_vis )
	circ_gr:active( t == "circle" and ui_vis )
end

---------------------
-- Point           --
---------------------
Point = {}
Point.__index = Point
function Point.nu(x, y)
	local t = {}
	setmetatable(t, Point)
	t.x, t.y  =  (x == nil and 0 or x), (y == nil and 0 or y)
	return t end

function Point.equals(p1, p2) return p1.x == p2.x and p1.y == p2.y end
function Point:swap() return Point.nu(self.y, self.x) end
---------------------
-- Rect            --
---------------------
Rect = {}
Rect.__index = Rect
function Rect.nu(x1, y1, x2, y2, square)
	local t = {}
	setmetatable(t, Rect)
	t.x1 = x1 == nil and 0 or min(x1, x2)
	t.y1 = y1 == nil and 0 or min(y1, y2)
	t.x2 = x2 == nil and 0 or max(x1, x2)
	t.y2 = y2 == nil and 0 or max(y1, y2)
	t.w, t.h = t.x2-t.x1, t.y2-t.y1

	if square then
		if t.w > t.h then
			t.w = t.h
			t.x2 = t.x1 + t.w
		elseif t.h > t.w then
			t.h = t.w
			t.y2 = t.y1 + t.h
	end end

	t.tl, t.tr = Point.nu(t.x1, t.y1), Point.nu(t.x2, t.y1)
	t.bl, t.br = Point.nu(t.x1, t.y2), Point.nu(t.x2, t.y2)
	t.left, t.right, t.top, t.bottom = t.x1, t.x2, t.y1, t.y2
	t.c = Point.nu(abs(t.x2-t.x1)//2, abs(t.y2-t.y1)//2)
	return t end

function Rect.equals(r1, r2)
	return r1.tl:equals(r2.tl) and r1.br:equals(r2.br) end

function Rect.shrink(r, v)
	return Rect.nu(r.x1+v, r.y1+v, r.x2-v, r.y2-v)
end

-- function Rect.intersects(r1, r2)
-- 	return r1.x1 <= r2.x2 and r1.x2 >= r2.x1 and r1.y1 <= r2.y2 and r1.y2 >= r2.y1 end

-- function Rect.has_point(r, p)
-- 	return p.x >= r.x1 and p.x <= r.x2 and p.y >= r.y1 and p.y <= r.y2 end

---------------------
--     TOOLS       --
function tl_set_size()
	-- trace( table.concat( { tl_cur_cat, tl_cur_pat }, ", " ) )
	tl_w = tl_cats[tl_cur_cat][tl_cur_pat].w
	tl_h = tl_cats[tl_cur_cat][tl_cur_pat].h
	end

function tl_toggle_drawing(x, y)
	if not tl_is_drawing then tl_start_drawing(x, y)
	else                        tl_stop_drawing() end end

function tl_stop_drawing()
	-- if tl_type ~= "pattern" then
		tl_is_drawing = fls
	-- end
end

function tl_start_drawing(x, y)
	tl_origin = Point.nu(x, y)
	tl_is_drawing = tru end

function tl_expand()   tl_set_brush_size(tl_brush_size + 1) end
function tl_contract() tl_set_brush_size(tl_brush_size - 1) end
function tl_set_brush_size(size) tl_brush_size = clamp(size, 0, 5) end

function tl_draw_points(x, y)
	if     tl_type == "brush"   then tl_brush_points(x, y)
	elseif tl_type == "rect"    then tl_rect_points(x, y)
	elseif tl_type == "circle"  then tl_circle_points(x, y)
	elseif tl_type == "line"    then tl_line_points(x, y)
	elseif tl_type == "fill"    then tl_fill_points(x, y)
	elseif tl_type == "pattern" then tl_pattern_points(x, y)
	end end

function tl_brush_points(x, y)
	-- TODO: improve this crappy brush
	local r = tl_brush_size -- radius
	for j=y-r, y+r do
		for i=x-r, x+r do
			if j > 0 and i > 0 and j <= GH and i <= GW then
				cells[sel][j][i] = 1
	end end end end

function tl_rect_points(x, y)
	if tl_is_drawing then
		if tl_alt_mode_3 then
			local r = Rect.nu( tl_origin.x, tl_origin.y, x, y, tl_alt_mode_2 )
			tl_bbox = Rect.nu( clamp(tl_origin.x-r.c.x, 1, GW), clamp(tl_origin.y-r.c.y, 1, GH), clamp(x-r.c.x, 1, GW), clamp(y-r.c.y, 1, GH), tl_alt_mode_2 )
		else
			tl_bbox = Rect.nu( tl_origin.x, tl_origin.y, x, y, tl_alt_mode_2 )
		end

		if tl_alt_mode_1 then rect_filled( tl_bbox )
		else                  rect_hollow( tl_bbox )
	end end end

function tl_circle_points(x, y)
	if tl_is_drawing then
		tl_bbox = Rect.nu( tl_origin.x, tl_origin.y, x, y, tl_alt_mode_2 )
		-- a little hack that doesn't do anything to fix ellipses...
		if tl_bbox.w < 2 or tl_bbox.h < 2 then tl_rect_points(x, y)
		else draw_ellipse( tl_bbox, tl_alt_mode_3, tl_alt_mode_1 )
end end end

function tl_line_points(x, y)
	if tl_is_drawing then
		if tl_alt_mode_1 then line_points(tl_origin, Point.nu(x, y))
		else                  line_points(tl_origin, Point.nu(x, y))
	end end end

function tl_fill_points(x, y)
	flood_fill(x, y)
	end

function tl_pattern_points(x, y)
	local pat = tl_cats[tl_cur_cat][tl_cur_pat].layout
	for j=1, tl_h do
		for i=1, tl_w do
			local gy, gx = j+(y-1)-tl_h, i+(x-1)-tl_w
			if gy > 0 and gx > 0 and gy <= GH and gx <= GW then
				cells[sel][gy][gx] = pat[j][i]
	end end end end

function tl_nu_pattern(id, name, layout)
	return {
		id = id,
		name = name,
		layout = layout,
		w = #layout[1],
		h = #layout
	} end

function tl_next_id()
	tl_patt_pid = tl_patt_pid +1
	return tl_patt_pid end

function tl_set_category(c)
	tl_cur_cat = c
	tl_cur_pat = tl_cur_pats[tl_cur_cat]
	tl_set_size() end

function tl_next_pattern()
	local old_pat, new_pat =
		tl_cur_pat,
		clamp(tl_cur_pats[tl_cur_cat]+1, 1, #tl_cats[tl_cur_cat])

	if new_pat ~= old_pat then
		tl_cur_pat = new_pat
		tl_cur_pats[tl_cur_cat] = new_pat
		tl_set_size()
	end end

function tl_prev_pattern()
	local old_pat, new_pat =
		tl_cur_pat,
		clamp(tl_cur_pats[tl_cur_cat]-1, 1, #tl_cats[tl_cur_cat])

	if new_pat ~= old_pat then
		tl_cur_pat = new_pat
		tl_cur_pats[tl_cur_cat] = new_pat
		tl_set_size()
	end end

function tl_init_pats()
	tl_cats = {
		{
			tl_nu_pattern( tl_next_id(), "1-1 Unnamed", {{0,1,0},{1,0,1},{1,0,1},{0,1,0}} ),
			tl_nu_pattern( tl_next_id(), "1-2 Loaf", {{0,1,1,0},{1,0,0,1},{0,1,0,1},{0,0,1,0}} )
		}, {
			tl_nu_pattern( tl_next_id(), "2-1 Toad", {{0,1,1,1},{1,1,1,0}} ),
			tl_nu_pattern( tl_next_id(), "2-2 Unnamed", {{0,1,0},{0,1,0},{1,0,1},{0,1,0},{0,1,0},{0,1,0},{0,1,0},{1,0,1},{0,1,0},{0,1,0}} ),
			tl_nu_pattern( tl_next_id(), "2-3 Unnamed", {{1,1,0,0},{1,0,0,0},{0,0,0,1},{0,0,1,1}} ),
			tl_nu_pattern( tl_next_id(), "2-4 Pulsar", {{0,0,1,1,1,0,0,0,1,1,1,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0},{1,0,0,0,0,1,0,1,0,0,0,0,1},{1,0,0,0,0,1,0,1,0,0,0,0,1},{1,0,0,0,0,1,0,1,0,0,0,0,1},{0,0,1,1,1,0,0,0,1,1,1,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,1,1,1,0,0,0,1,1,1,0,0},{1,0,0,0,0,1,0,1,0,0,0,0,1},{1,0,0,0,0,1,0,1,0,0,0,0,1},{1,0,0,0,0,1,0,1,0,0,0,0,1},{0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,1,1,1,0,0,0,1,1,1,0,0}} ),
			tl_nu_pattern( tl_next_id(), "2-5 Unnamed", {{0,0,0,0,0,0,0,0,1,1,0,0,1,1,0},{0,0,0,0,0,0,0,0,1,0,0,0,0,1,0},{0,0,0,0,0,0,0,0,0,1,1,1,1,0,0},{0,0,0,0,0,0,1,1,1,0,0,0,1,0,1},{0,0,1,0,0,0,1,0,0,1,0,0,0,1,1},{0,1,0,1,0,0,0,1,0,1,0,0,0,0,0},{1,0,1,0,0,1,0,1,0,1,1,0,0,0,0},{1,0,0,1,1,0,1,0,0,0,1,0,0,0,0},{0,1,0,1,0,0,1,0,1,1,0,0,0,0,0},{1,1,0,1,0,1,0,1,0,0,1,0,0,0,0},{1,0,0,1,0,1,0,1,0,1,1,0,0,0,0},{0,1,1,0,0,0,0,0,0,1,0,0,0,0,0},{0,0,0,1,1,1,1,1,0,1,0,0,0,0,0},{0,0,0,1,0,0,0,0,1,0,0,0,0,0,0},{0,0,0,0,1,1,1,1,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,1,1,0,0,0,0,0,0,0,0,0},{0,0,0,0,1,1,0,0,0,0,0,0,0,0,0}} ),
		}, {
			tl_nu_pattern( tl_next_id(), "3-1 R Pentomino", {{0,1,1},{1,1,0},{0,1,0}} ),
			tl_nu_pattern( tl_next_id(), "3-2 Unnamed", {{1,1,0,0,0,0,1,0},{0,1,0,0,0,1,1,1}} ),
			tl_nu_pattern( tl_next_id(), "3-3 Unnamed", {{1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1},{1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1},{0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,1,0,1,0,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},{0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1},{0,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1},{0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}} ),
			tl_nu_pattern( tl_next_id(), "3-4 Unnamed", {{1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1}} ),
			tl_nu_pattern( tl_next_id(), "3-5 Unnamed", {{0,1,0,0,0,0,0},{0,0,0,1,0,0,0},{1,1,0,0,1,1,1}} ),
			tl_nu_pattern( tl_next_id(), "3-6 Unnamed", {{1,1,1,0,1},{1,0,0,0,0},{0,0,0,1,1},{0,1,1,0,1},{1,0,1,0,1}} ),
			tl_nu_pattern( tl_next_id(), "3-6 Unnamed", {{0,0,0,0,0,0,1,0},{0,0,0,0,1,0,1,1},{0,0,0,0,1,0,1,0},{0,0,0,0,1,0,0,0},{0,0,1,0,0,0,0,0},{1,0,1,0,0,0,0,0}} ),
		}, {
			tl_nu_pattern( tl_next_id(), "4-1 Glider", {{0,0,1},{1,0,1},{0,1,1}} ),
			tl_nu_pattern( tl_next_id(), "4-2 Light-Weight Spaceship", {{1,0,0,1,0},{0,0,0,0,1},{1,0,0,0,1},{0,1,1,1,1}} ),
		}, {
			tl_nu_pattern( tl_next_id(), "5-1 Gosper's Glider Gun", {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1},{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1},{1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}} ),
		}
	}

	for i=1, #tl_cats do
		tl_cur_pats[i] = 1 end

	tl_set_size()
	end

---------------------------------------
--       GEOMETRY FUNCTIONS          --
---------------------------------------
-- Rect functions
function rect_hollow(r)
	local p1, p2 = r.tl, r.br

	for j=r.y1, r.y2 do
		if j == p1.y or j == p2.y then
			for i=r.x1, r.x2 do cells[sel][j][i] = 1 end
		else
			cells[sel][j][r.x1] = 1
			cells[sel][j][r.x2] = 1	end end end

function rect_filled(r)
	for j=r.y1, r.y2 do
		for i=r.x1, r.x2 do
			cells[sel][j][i] = 1 end end end

----------------------------------
-- Bresenham's line algorithm
----------------------------------
-- Adapted from Luke M.'s python implementation:
-- https://gist.github.com/flags/1132363
----------------------------------
function bresenham(p0, p1)
	local points = {}

	local steep = abs(p1.y-p0.y) > abs(p1.x-p0.x)
	if steep then
		p0 = p0.swap()
		p1 = p1.swap()
	end

	if p0.x > p1.x then
		-- 'flippin and floppin'
		local _x0, _x1 = p0.x, p1.x
		p0.x = _x1
		p1.x = _x0

		local _y0, _y1 = p0.y, p1.y
		p0.y = _y1
		p1.y = _y0
	end

	local dx, dy = p1.x-p0.x, abs(p1.y-p0.y)
	local err, derr = 0, dy/float(dx)
	local ystep, y = 0, p0.y

	if p0.y < p1.y then ystep = 1
	else                ystep = -1 end

	for x=p0.x, p1.x+1 do
		if steep then points.insert( Point.nu(y, x) )
		else          points.insert( Point.nu(x, y) ) end

		err = err + derr

		if err >= 0.5 then
			y = y + ystep
			err = err - 1.0
		end
	end
	return points end

----------------------------------
-- RedBlobGames Line algorithm
----------------------------------
function line_points(p0, p1)
	local points, N = {}, diag_dist(p0, p1)

	for step=0, N do
		local t = N == 0 and 0.0 or step/N
		points[ step+1 ] = round_point( lerp_pt(p0, p1, t) ) end

	for _, p in pairs(points) do
		cells[sel][p.y][p.x] = 1 end end

function diag_dist(p0, p1)
	return max( abs(p1.x-p0.x), abs(p1.y-p0.y) ) end

function round_point(p)
	return Point.nu( round(p.x), round(p.y) ) end

-- Helpers
--------------------------------------------
function lerp(l, h, t)
	return l + t * (h-l) end

function lerp_pt(p0, p1, t)
	return Point.nu( lerp( p0.x, p1.x, t), lerp(p0.y, p1.y, t) ) end

----------------------------------
-- Ellipse function
----------------------------------
function draw_ellipse(r, center, filled)
	local p1 = r.tl
	local p2 = r.br
	local Rx, Ry =  (p2.x-p1.x)//2, (p2.y-p1.y)//2

	if not center then bres_ellipse(p1.x+Rx, p1.y+Ry, Rx, Ry)
	else               bres_ellipse(p1.x, p1.y, Rx, Ry) end

	if filled then
		if center then flood_fill(p1.x, p1.y, true)
		else flood_fill(r.c.x+p1.x, r.c.y+p1.y, true) end end end

-- not working properly
function bres_ellipse(xc, yc, width, height)
	if width <= 0 or height <= 0 then return end

	local a2, b2 = width*width, height*height
	local fa2, fb2 = 4*a2, 4*b2
	local x, y, sigma = 0, 0, 0

	-- /* first half */
	x = 0
	y = height
	sigma = 2*b2 + a2*(1-2*height)
	while b2*x <= a2*y do
		draw_on_grid(xc, yc, x, y)
		if sigma >= 0 then
			sigma = sigma + fa2*(1-y)
			y = y-1
		end
		sigma = sigma + b2*((4*x)+6)
		x = x+1
	end
	-- /* second half */
	x = width
	y = 0
	sigma = 2*a2 + b2*(1-2*width)
	while a2*y <= b2*x do
		draw_on_grid(xc, yc, x, y)
		if sigma >= 0 then
			sigma = sigma + fb2 * (1 - x)
			x = x -1
		end
		sigma = sigma + a2 * ((4 * y) + 6)
		y = y+1
	end
end

function draw_on_grid(CX, CY, X, Y)
	cells[sel][ clamp( CY+Y, 1, GH ) ][ clamp( CX+X , 1, GW ) ] = 1
	cells[sel][ clamp( CY+Y, 1, GH ) ][ clamp( CX-X , 1, GW ) ] = 1
	cells[sel][ clamp( CY-Y, 1, GH ) ][ clamp( CX+X , 1, GW ) ] = 1
	cells[sel][ clamp( CY-Y, 1, GH ) ][ clamp( CX-X , 1, GW ) ] = 1 end

---------------------------------------
--      FLOOD FILL FUNCTIONS         --
---------------------------------------
function flood_fill(x, y, ellipse)
	elipse = elipse or false
	scanline_ft_fill(x, y, ellipse) end

function set_pixel(x, y)
	cells[sel][y][x] = 1
end

function has_pixel(x, y, elipse)
	if elipse then
		return x < 1 or y < 1 or x > GW or y > GH
		or cells[sel][y][x] == 1
	else
		return x < 1 or y < 1 or x > GW or y > GH
		or cells[sel][y][x] == 1 or cells[cur][y][x] == 1
	end
end


-------------------------------------
--   Scanline FT
function scanline_ft_fill(x, y, ellipse)
	local points = {}
	table.insert(points, #points+1, Point.nu(x, y) ) -- add the initial point

	repeat
		local pt = table.remove(points)
		local setAbove = tru
		local setBelow = tru

		x = pt.x
		while not has_pixel(x, pt.y, ellipse) do
			cells[sel][pt.y][x] = 1 -- set_pixel(x, pt.y)

			if (has_pixel(x, pt.y-1, ellipse) ~= setAbove)  then
				setAbove = not setAbove
				if not setAbove then table.insert(points, Point.nu(x, pt.y-1) ) end end

			if (has_pixel(x, pt.y+1, ellipse) ~= setBelow) then
				setBelow = not setBelow
				if not setBelow then table.insert(points, Point.nu(x, pt.y+1) ) end end
			x = x +1
		end

		setAbove = pt.y > 0 and has_pixel(pt.x, pt.y-1, ellipse)
		setBelow = pt.y < GH-1 and has_pixel(pt.x, pt.y+1, ellipse)

		x = pt.x-1
		while not has_pixel(x, pt.y, ellipse) do
			cells[sel][pt.y][x] = 1 -- set_pixel(x, pt.y)

			if (has_pixel(x, pt.y-1, ellipse) ~= setAbove) then
				setAbove = not setAbove

				if not setAbove then table.insert(points, Point.nu(x, pt.y-1) ) end end

			if (has_pixel(x, pt.y+1, ellipse) ~= setBelow) then
				setBelow = not setBelow
				if not setBelow then table.insert(points, Point.nu(x, pt.y+1) ) end end
			x = x-1
		end
	until #points == 0 end


-- ============================================================================
--               UI
-- ============================================================================
function new_label(txt, x, y, color, align, fix)
	local fix = fix or fls
	return tc.element({
		x=x, y=y, w=0, h=0,
		text={ print=txt, align=align, colors={color,color,color}, shadow={ colors={3,3,3} }, fixed=fix },
		set_text = function(self, txt) self.text.print=txt end,
		set_pos = function(self, x, y) self.x, self.y = x, y end,
	})
end

function nu_btn_list(x, y, w, h)
	return tc.element({
		x=x, y=y, w=SS, h=SS,
		btns = {},
	})
end

function nu_anchor_btn(idx, x, y, nfo)
	return tc.element({
		x=x, y=y, w=SS*2, h=SS, ox=x, oy=y,
		icon = { sprites={idx,idx,idx}, key=0, scale=1, w=2, h=1 },
		drag = { active=fls, bounds={ x={0,240-8}, y={0, 136-8} } },
		nfo=nfo, cooldown=0.5, t_click=0, counting_t=fls,

		onHover = function(self) set_tooltip(self.nfo) end,
		onPress = function(self) self.drag.active=tru end,
		onCleanRelease = function(self) self.drag.active=fls end,
		onClick = function(self)
			if not self.counting_t then
				self:start_t()
			else
				local t_now = time()/1000
				local diff = abs(self.t_click - t_now)
				if diff < self.cooldown then self:reset()
				else                            self:start_t() end
			end
		end,
		start_t = function(self) self.t_click, self.counting_t = time()/1000, tru end,
		reset_t = function(self) self.counting_t, self.t_click = fls, 0 end,
		set_pos = function(self, x, y) self.x, self.y = x, y end,
		set_origin = function(self, x, y)
			self.ox, self.oy = x, y
			self:set_pos(x, y)
		end,
		reset = function(self)
			self:set_pos(self.ox, self.oy)
			self:reset_t()
		end
	})
end

function nu_togl_icn(idx, x, y, nfo)
	return tc.element({
		x=x, y=y, w=SS, h=SS,
		icon = { sprites={idx,idx,idx}, key=0, scale=1, w=1, h=1 },
		nfo=nfo,
		onHover = function(self) set_tooltip(self.nfo) end,

		icon1 = { sprites={idx,idx,idx}, key=0, scale=1, w=1, h=1 },
		icon2 = { sprites={idx+1,idx+1,idx+1}, key=0, scale=1, w=1, h=1 },
		is_on = fls,
		set_state = function(self, enable)
			self.is_on = enable
			if self.is_on then self.icon = self.icon2
			else               self.icon = self.icon1 end
		end,
	})
end

function nu_icon(idx, x, y, w, h)
	return tc.element({
		x=x, y=y, w=0, h=0,
		icon = { sprites={idx,idx+1,idx+2}, key=0, scale=1, w=w, h=h }
	})
end

function nu_btn(idx, x, y, nfo)
	return tc.element({
		x=x, y=y, w=SS, h=SS,
		icon = { sprites={idx,idx+1,idx+2}, key=0, scale=1, w=1, h=1 },
		nfo=nfo,
		onHover = function(self) set_tooltip(self.nfo) end,
	})
end

function nu_simp_btn(idx, x, y, nfo, callback, args)
	local p = nu_btn(idx, x, y, nfo)
	p.callback=callback
	p.args=args
	p.onCleanRelease = function(self) self:toggle_state() end
	p.toggle_state = function(self) self:hit() end
	p.hit = function(self)
		if self.callback then
			if self.args then self.callback(table.unpack(self.args))
			else         self.callback() end
		end
	end
	return p
end

function nu_togl_btn(idx, x, y, nfo, parent, act_on, callback, args)
	local p = nu_simp_btn(idx, x, y, nfo, callback, args)
	p.icon1 = { sprites={idx  ,idx+1,idx+2}, key=0, scale=1, w=1, h=1 }
	p.icon2 = { sprites={idx+3,idx+4,idx+5}, key=0, scale=1, w=1, h=1 }
	p.is_on = fls
	p.act_on=act_on
	p.parent=parent

	p.toggle_state = function(self)
		if self.act_on == "sticky" then
			if not self.is_on then
				self.is_on = tru
				if self.parent then self.parent:reset_btns() end
				self.icon = self.icon2
			end
			self:hit()
		else
			self.is_on = not self.is_on
			if self.is_on then
				if self.parent then self.parent:reset_btns() end
				self.icon = self.icon2
				if self.act_on == "on" or self.act_on == "toggle" then self:hit() end
			else
				if self.parent then self.parent:reset_btns() end
				self.icon = self.icon1
				if self.act_on == "off" or self.act_on == "toggle" then self:hit() end
			end
		end
	end
	p.turn_off = function(self) self.icon, self.is_on = self.icon1, fls end
	p.turn_on = function(self) self.icon, self.is_on = self.icon2, tru end
	return p
end

function new_tlbar(idx, x, y, w, h)
	return tc.element({
		x=x-1, y=y-1, w=w+2, h=h+2,
		tiled  = { sprites={idx+2,idx+2,idx+2}, scale=1, flip=0 },
		border = { sprites={{idx,idx+1},{idx,idx+1},{idx,idx+1}}, key=0, width=1 },
		btns = {},
		set_pos = function(self, x, y) self.x, self.y = x-1, y-1 end,
		reset_btns = function(self) for _,btn in pairs(self.btns) do btn:turn_off() end end
	})
end

function new_ui_element(x, y, w, h)
	return tc.element({
		x=x, y=y, w=w, h=h,
		set_pos = function(self, x, y) self.x, self.y = x, y end,
		set_size = function(self, w, h) self.w, self.h = w, h end
	})
end

function new_ui_panel(bg_idx, brd_idx, x, y, w, h, draggable, bounds)
	local draggable = draggable or fls

	local p = new_ui_element(x, y, w, h)
	if bg_idx    then p.tiled  = { sprites={bg_idx,bg_idx,bg_idx}, scale=1, key=0 } end
	if brd_idx   then p.border = { sprites={ {brd_idx,brd_idx+1},{brd_idx,brd_idx+1},{brd_idx,brd_idx+1} }, key=0, width=1 } end
	if draggable then p.drag   = { active=tru, bounds=(bounds or { x={-500,500}, y={-500, 500} }) } end
	return p
end

function nu_ibar(bg_idx, brd_idx, x, y, w, h) -- nfo panel
	local p = new_ui_panel(bg_idx, brd_idx, x, y, w, h)
	p.labels = {}
	p.add_label = function(self, name, label)
		label:anchor(self)
		self.labels[name] = label
	end
	p.set_text = function(self, label, txt) self.labels[label]:set_text(txt) end
	return p
end

---------------------------------------
--        ANIMATION PLAYER           --
---------------------------------------
-- Simplest animation player ever
-- Probably the most naive too
-- Only animates positions
---------------------------------------
Animator = {}
Animator.__index = Animator
function Animator:nu()
	local t = {}
	setmetatable(t, Animator)
	t.anims = {}
	return t end

function Animator:update(dt)
	for _, an in pairs(self.anims) do
		if an.playing == tru then an:update() end end end

function Animator:play(name)
	self.anims[name]:play() end

function Animator:is_playing(name)
	if not name then for _, an in pairs(self.anims) do if an.playing then return tru end end
	else return self.anims[name].playing end end

function Animator:add_anim(name, obj, dx, dy)
	self.anims[name] = Animation:nu(name, obj, dx, dy) end

---------------------------------------
--            ANIMATION              --
---------------------------------------
Animation = {}
Animation.__index = Animation
function Animation:nu(name, obj, dx, dy)
	local t = {}
	setmetatable(t, Animation)
	t.name = name
	t.obj = obj
	t.dx, t.dy = dx, dy
	t.playing = fls
	return t end

function Animation:play() self.playing = tru end
function Animation:update()
	local scalar = 0.70
	local obj, dx, dy = self.obj, self.dx, self.dy

	obj:set_pos( lerp(obj.x, dx, scalar), lerp(obj.y, dy, scalar) )

	if abs(obj.x-dx) < 0.1 then obj.x = dx end
	if abs(obj.y-dy) < 0.1 then obj.y = dy end

	if obj.x == dx and obj.y == dy then
		obj:set_pos(dx, dy)
		self.playing = fls
		return tru end
	return fls end



-- trace(debug.traceback())
init()