print( "Width: " .. display.contentWidth )
print( "Height: " .. display.contentHeight )


-- display.newRect( parent, x, y, width, height )
local top = display.newRect( display.contentCenterX, 200, display.contentWidth, 300 )
top:setFillColor( 0, 1, 1, 0.5 )

local middle = display.newRect( display.contentCenterX, 550, display.contentWidth, 500 )
middle:setFillColor( 1, 0, 1, 0.5 )

local bottom = display.newRect( display.contentCenterX, 800, display.contentWidth, 350 )
bottom:setFillColor( 1, 1, 0, 0.5 )