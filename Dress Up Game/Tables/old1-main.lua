-- 
-- Project: Dres Up Game, Tables
--
-- File dependencies: none
---------------------------------------------------------------------------------------

-- ** Tables **

-- In Lua the use of {} always denotes the beginning and end of a table, 
-- even when used as arguments in a function.

-- Create a new blank table for character data.

local character = {}

-- Set default values for character data...

character.name = "Name Here"

-- Create new table and default values for each body area...

character.torso = {}
character.torso.item = 0
character.torso.red = 1
character.torso.green = 1
character.torso.blue = 1
character.torso.alpha = 1

character.legs = {}
character.legs.item = 0
character.legs.red = 1
character.legs.green = 1
character.legs.blue = 1
character.legs.alpha = 1

-- print ( "Red: " .. character.legs.red )
-- End table data


-- ** Buttons and Images **

-- Load our color data from seperate colors.lua file.
-- require( "colors" )

local shirtImage = "images/tshirt01.png"

-- display.newImage( [parent,] filename [,baseDir] [,x,y] [,isFullResolution])
local shirt = display.newImage( shirtImage, display.contentCenterX, 190 )

-- object:setFillColor( red, green, blue, alpha )
shirt:setFillColor( 0, 0, 1, 1)

-- Create new table for storing color values.
local palette = {
	color01 = { 1, 0, 0.5, 1 },
	color02 = { 1, 0, 0, 1 },
	color03 = { 0, 0.5, 1, 1 }
}

-- display.newRect( parent, x, y, width, height )
local colorBtn01 = display.newRect( 100, 400, 40, 40 )
local colorBtn02 = display.newRect( 160, 400, 40, 40 )
local colorBtn03 = display.newRect( 220, 400, 40, 40 )

-- The unpack() function returns the values of a table.
-- print( unpack(palette.color01) )

-- colorBtn01:setFillColor( 1, 0, 0.5, 1 )
colorBtn01:setFillColor( unpack(palette.color01) )
colorBtn02:setFillColor( unpack(palette.color02) )
colorBtn03:setFillColor( unpack(palette.color03) )

local colorBtnTest01 = {
	id = "button1",
	onEvent = chooseColor
}

local function tapColors(event)
    shirt:setFillColor( 1, 0, 0.5, 1 )
    return true -- stops processing of further events
end

colorBtn01:addEventListener("tap", tapColors)

