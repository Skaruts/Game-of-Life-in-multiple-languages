require "cellmap"

-- scalar for cell and grid sizes
local m = 8		-- use 1, 2, 4, 8 or 16 (4 or more will be slow)

local CS = 16/m
local GW = 80*m
local GH = 50*m
local paused = false

function love.load(args)
	cm = Cellmap(GW, GH, CS)
	cm.init()
	bg_clear_color = {0,0,0}

	love._openConsole()
	-- love.graphics.setBlendMode("screen")
	love.graphics.setBackgroundColor(bg_clear_color)
	love.window.setMode( CS*GW, CS*GH )
end

function love.update(dt)
	if not paused then cm.update() end
end

function love.draw()
	cm.draw()
end

function love.keypressed(k)
	if k == 'q' or k == 'escape' then
		love.event.quit()
	elseif k == 'space' then
		toggle_pause()
	end
end

function toggle_pause()
	paused = not paused
end
