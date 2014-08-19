-- widget.newScrollView( options )

local widget = require( "widget" )

-- Create the widget
local scrollView = widget.newScrollView
{
	-- The left and top position where the widget will be created. If specified, these values override the x and y parameters.
    top = 200,
    left = 10,
    -- The visible (on screen) width and height of the scroll view.
    width = 150,
    height = 800,
    -- The width and height of the total scrollable content area.
    scrollWidth = 150,
    scrollHeight = 1400,
	backgroundColor = { 1, 1, 1, 0.5 },
	horizontalScrollDisabled = true
}

------

local function myTouchListener( event )

    if ( event.phase == "began" ) then
        --code executed when the button is touched
        print( "object touched = "..tostring(event.target) )  --'event.target' is the touched object
    elseif ( event.phase == "moved" ) then
        --code executed when the touch is moved over the object
        print( "touch location in content coordinates = "..event.x..","..event.y )
    elseif ( event.phase == "ended" ) then
        --code executed when the touch lifts off the object
        print( "touch ended on object "..tostring(event.target) )
    end
    return true  --prevents touch propagation to underlying objects
end

local myButton = display.newRect( 100, 100, 200, 50 )
myButton:addEventListener( "touch", myTouchListener )  --add a "touch" listener to the object

-----
local function iconTouch( event )
	if ( event.phase == "began" ) then
        --code executed when the button is touched
        print( "object touched = "..tostring(event.target) )  --'event.target' is the touched object
    elseif ( event.phase == "moved" ) then
        --code executed when the touch is moved over the object
        print( "touch location in content coordinates = "..event.x..","..event.y )
    elseif ( event.phase == "ended" ) then
        --code executed when the touch lifts off the object
        print( "touch ended on object "..tostring(event.target) )
    end
    		
	--print ( "I clicked on icon" .. event.target.number )

	
	-- not returning true because this eliminates the parent group's ability to scroll
	return true
end


-- Automatically calculate icon layout within parent group based on height and margin values.

local iconHeight = 140
local iconMargin = 20

local function createIcon( iconName, iconNum )
	local iconName = display.newRect( iconHeight/2, 0, iconHeight, iconHeight )
	iconName.y = ((iconMargin + iconHeight ) * iconNum) - iconHeight/2
	iconName.number = iconNum
	-- "touch" instead of "tap" because you can't drag and drop on a tap
	iconName:addEventListener( "touch", iconTouch )
	-- Add to group with a separate function so that x, y values are relative to top, left
	scrollView:insert( iconName )
end

--display.newRect( parent, x, y, width, height )
createIcon ( "icon1", 1)
createIcon ( "icon2", 2)
createIcon ( "icon3", 3)
createIcon ( "icon4", 4)
createIcon ( "icon5", 5)
createIcon ( "icon6", 6)
createIcon ( "icon7", 7)
createIcon ( "icon8", 8)
createIcon ( "icon9", 9)
createIcon ( "icon10", 10)


