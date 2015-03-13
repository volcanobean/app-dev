display.setStatusBar( display.HiddenStatusBar )

local Grid = require ("jumper.grid") -- The grid class
local Pathfinder = require ("jumper.pathfinder") -- The pathfinder lass


local map = {} -- gridmap holder
local function callMap() -- function that creates gridmap
	for x = 1, 25 do -- column
		map[x] = {}
		for y = 1, 17 do --row
			rndSet = math.random(145)
			if rndSet == 1 then
				map[x][y] = 1
			else
				map[x][y] = 0
			end
 
		end
	end
end
callMap()
map[1][1] = 0 -- ensure that actor has a place to start!
map[1][2] = 0 -- ensure that actor has a place to start!


local path
function callNewPath()
	path = myFinder:getPath(startx, starty, endx, endy)
	if path then
	touchStarted = 1
	print(('Path found! Length: %.2f'):format(path:getLength()))
		for node, count in path:nodes() do
		print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
		print(node:getX())
		print(node:getY())
		setX[#setX+1] = node:getX() -- populating coordinate table on each movement
		setY[#setY+1] = node:getY() -- populating coordinate table on each movement
		cellb[node:getY()][node:getX()].alpha = .8 -- see the path you've chosen!
		moveCount = moveCount+1
		end
	end
end