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

local function listener( event )
    print( "listener called" )
end



------

local myButton = display.newRect( 200, 200, 200, 200 )

local startX = 0
local startY = 0
local endX = 0
local endY = 0

local function myTouchListener( event )
    -- set focus to target so corona will track finger even when it leaves the target area
    display.getCurrentStage():setFocus( event.target )
    event.target.isFocus = true
    
    if ( event.phase == "began" ) then
        -- timer.performWithDelay( 1000, listener )
        startX = event.x
        startY = event.y 
        print( "Touch start: ".. startX .. "," .. startY )
        --code executed when the button is touched
        -- print( "object touched = "..tostring(event.target) )  --'event.target' is the touched object
    elseif ( event.phase == "moved" ) then
        --code executed when the touch is moved over the object
        endX = event.x
        endY = event.y 
        print( "Touching: ".. endX .. "," .. endY )
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        --code executed when the touch lifts off the object
        print( "Touch end")
        if ( endY < startY) then
           print ( "Swiped up" )
        elseif ( endY > startY) then
            print ( "Swiped down" )
        end
    end
    return true  --prevents touch propagation to underlying objects
end

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


