-- Learning about Objects
local myObj01 = display.newRect( 0, 0, 100, 100)
myObj01.x = display.contentCenterX; myObj01.y = 100
myObj01:setFillColor( 1, 1, 1, 0.5)

local myObj02 = display.newRect( 0, 0, 100, 100)
myObj02.x = display.contentCenterX; myObj02.y = 300
myObj02:setFillColor( 1, 1, 1, 1)

local printMe = function( event )
	status = "id = " .. event.target.id .. ", category = " .. event.target.category
	print ( status )
end

myObj01.id = "01"
myObj01.category = "torso"

myObj02.id = "04"
myObj02.category = "legs"

myObj01:addEventListener( "tap", printMe )
myObj02:addEventListener( "tap", printMe )



