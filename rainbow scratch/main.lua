display.setStatusBar( display.HiddenStatusBar )

local background = display.newImageRect ("images/rainbow-background.jpg", 1536, 2731 )




local x, y = display.contentCenterX, display.contentCenterY
local tile = {}
local tileH = 2
local tileW = 2

local function remove (event)
	event.target:removeSelf()
	return true
end

local function createTileRow( yPos )
	for i=1, 384 do
	    --tile[i] = display.newImage( "images/tile2.jpg" )
	    tile[i] = display.newRect( 0, 0, tileH, tileW)
	    tile[i].x = 0 + i*tileW
	    tile[i].y = yPos
    	tile[i]:addEventListener( "touch", remove )
   	end
end
 


local function createTile( number )
        tile[number] = display.newImage( "images/tile.jpg" )
        tile[number].x = 0 + number*tileW
        tile[number]:addEventListener( "touch", remove )
end

for i=1, 500 do
	local yPos2 = 0 + i*tileH
	createTileRow( yPos2 )
end






