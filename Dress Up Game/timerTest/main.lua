local myText = display.newText( "Nothing yet.", display.contentCenterX, 50, native.systemFont, 30 )

-- create intial variables


local startX = 0
local startY = 0
local endX = 0
local endY = 0

local touching

local myButton = display.newRect( 560, 250, 200, 200 )
myButton:setFillColor( 1, 1, 1, 1 )

-- functions for icon/closet interaction

local function dragIt()
	myText.text = "Drag and Drop"
    --transition.to( currentTarget, {time=800, x=500} )
end

local function swipeIt()
	if ( endY < startY) then
	   myText.text = "Swipe up"
	elseif ( endY > startY) then
	    myText.text = "Swipe down"
	end
end

local function scrollIt()
	myText.text = "Slow scroll"
end

-- On timer end, choose appropriate function

local function timerCount()
	if ( endX == startX ) and ( endY == startY ) then
        -- if the user keeps their finger in the same spot for the entire timer countdown
		dragIt()
	elseif ( endY ~= startY ) and ( touching == false ) then
        -- if the user moves their finger up or down and then releases before the countdown ends
		swipeIt()		
	else
        -- if the user moves their finger up or down and does not release before the timer ends
		scrollIt()
	end
end

local function buttonPress( event )
    -- on button touch
    if ( event.phase == "began" ) then
        -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true

    	-- set var to current target for use in other fuctions
    	currentTarget = event.target
    	print( "Phase: " .. event.phase )
    	
    	-- touch has started
    	touching = true

    	-- start timer
        touchTimer = timer.performWithDelay( 400, timerCount )
    	myText.text = "Timer start"

    	-- get initial touch positions
        startX = event.xStart
        startY = event.yStart
        endX = event.x
        endY = event.y 
        print( "Touch start: ".. startX .. "," .. startY )

    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then  
  
            -- track x and y movement, store as last positions touched
            endX = event.x
            endY = event.y 
            print( "Touching: ".. endX .. "," .. endY )

            print( "Phase: " .. event.phase )

        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false 

        	-- touch has ended
        	touching = false
            timerComplete = false

            -- print final x, y touch positions
            print( "Touch end: ".. endX .. "," .. endY )
            print( "Phase: " .. event.phase )
        end
    end

    return true  --prevents touch propagation to underlying objects
end

myButton:addEventListener( "touch", buttonPress )

-- Automatically calculate icon layout within parent group based on height and margin values.

local iconGroup = display.newGroup()
iconGroup.y = 160
iconGroup.x = 25

local iconHeight = 140
local iconMargin = 20

local function createIcon( iconName, iconNum )
	local iconName = display.newRect( iconHeight/2, 0, iconHeight, iconHeight )
	iconName.y = ((iconMargin + iconHeight ) * iconNum) - iconHeight/2
	iconName.number = iconNum
	iconName:addEventListener( "touch", buttonPress )
	-- Add to group with a separate function so that x, y values are relative to top, left
	iconGroup:insert( iconName )
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