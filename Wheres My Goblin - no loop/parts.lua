local myText = display.newText( "Nothing yet.", display.contentCenterX, 50, native.systemFont, 30 )

-- create intial variables

local startX = 0
local startY = 0
local endX = 0
local endY = 0

-- debug
local startXText = display.newText( "startX: " .. startX, display.contentCenterX, 100, native.systemFont, 30 )
local startYText = display.newText( "startY: " .. startY, display.contentCenterX, 150, native.systemFont, 30 )
local endXText = display.newText( "endX: " .. endX, display.contentCenterX, 200, native.systemFont, 30 )
local endYText = display.newText( "endY: " .. endY, display.contentCenterX, 250, native.systemFont, 30 )

local touchTimer
local touching
local touchCommand
local currentIcon

local iconHeight = 140
local iconWidth
local iconMargin = 20

local scrollMask = display.newRect( 0, 0, 190, 840 )
scrollMask.anchorX = 0
scrollMask.anchorY = 0
scrollMask.x = 0
scrollMask.y = 180
scrollMask:setFillColor( 1, 1, 1, 0.25 )

local iconGroup = display.newGroup()
iconGroup.origX = 25
iconGroup.origY = 160
iconGroup.x = iconGroup.origX
iconGroup.y = iconGroup.origY

-- Create hit area for center of screen

--display.newRect( parent, x, y, width, height )
local centerHitArea = display.newRect( display.contentCenterX, 500, 20, 1000 )
centerHitArea:setFillColor( 0, 1, 1, 0.25 )

-- Function to set the appropriate touchCommand value

local function timerCount()
    --print ( "Timer Complete" )
    -- On completion of timer...
    -- It is a swipe if the user moves their finger up or down and then releases before the countdown ends.
    if ( endY ~= startY ) and ( touching == false ) then
       touchCommand = "swipeGroup"
    -- It is a drag if the user moves their finger up or down and does not release before the timer ends.
    elseif ( touching == true ) then 
        touchCommand = "dragGroup"
    end
end

--rectangle-based collision detection

local function hasCollided( obj1, obj2 )
   if ( obj1 == nil ) or ( obj2 == nil ) then  -- make sure the objects exists
      return false
   end
   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
   return (left or right) and (up or down)
end

-- Event function for icon button interaction

local function buttonPress( event )
    
    -- ON PRESS:

    if ( event.phase == "began" ) then

        -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true

        -- touch has started
        touching = true
        currentIcon = event.target

        -- debug
        myText.text = ""

        -- if this icon is still part of the slider/group, start timer
    	-- after 400 milliseconds trigger timerCount() function to determine touch command
        if ( event.target.group == iconGroup ) then
            touchTimer = timer.performWithDelay( 300, timerCount )
    	end
        --print ( "Timer start" )

    	-- get initial touch positions
        startX = event.xStart
        startY = event.yStart
        endX = event.x
        endY = event.y

        -- debug
        startXText.text = "startX: " .. startX
        startYText.text = "startY: " .. startY
        endXText.text = "endX: " .. endX
        endYText.text = "endY: " .. endY 
        --print( "Touch start: ".. startX .. "," .. startY )

    -- ON MOVE:

    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then  
  
            -- track x and y movement, store as last positions touched
            endX = event.x
            endY = event.y

            -- debug
            endXText.text = "endX: " .. endX
            endYText.text = "endY: " .. endY 

            myText.text = "Slow scroll"
            
            -- START GROUP DRAG:

            -- if there are enough icons for scrolling
            if ( iconGroup.height > scrollMask.height ) then
                iconGroup.y = event.y - event.target.y
                endYText.text = "Group Y: " .. iconGroup.y 
                -- Group scroll constraints:
                -- Snap to top
                if ( iconGroup.y > iconGroup.origY ) then
                    transition.to( iconGroup, { time=0, y=iconGroup.origY } )  
                end
                -- Snap to bottom
                if ( iconGroup.y < iconGroup.floor ) then
                    transition.to( iconGroup, { time=0, y=iconGroup.floor } ) 
                end
            end

        -- ON RELEASE: 

        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            
            -- touch has ended
            touching = false

            -- if releasing a swipe:
            if ( event.target.group == iconGroup ) and ( touchCommand == "swipeGroup" ) then
                 if ( endY < startY) then
                    myText.text = "Swipe up"
                    --transition.to( iconGroup, { time=300 ,transition=easing.outSine, y=0 } )
                elseif ( endY > startY) then
                    myText.text = "Swipe down"
                    --transition.to( iconGroup, { time=300 ,transition=easing.outSine, y=400 } )
                end

            -- if releasing a drag:
            elseif ( event.target.group == display.currentStage ) then
                if ( hasCollided( event.target, centerHitArea )) then
                    transition.to( event.target, { time=50, x=centerHitArea.x, y=centerHitArea.y } )
                else
                    iconGroup:insert( event.target )
                    event.target.group = iconGroup
                    event.target:setFillColor( 1, 1, 1, 1 )
                    transition.to( event.target, { time=50, x=event.target.origX, y=event.target.origY } )
                end
            end
            
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false 
            -- clear touchCommand so it's not inherited by the next button pressed
            touchCommand = nil

            -- print final x, y touch positions
            --print( "Touch end: ".. endX .. "," .. endY )
        end
    end
    -- on event functions, always return true to prevent touch propagation to underlying objects
    return true  
end

-- Automatically calculate icon layout within parent group based on height, width and margin values.

local function createIcon( iconName, iconNum )
	local iconName = display.newRect( iconHeight/2, 0, iconHeight, iconHeight )
	iconName.y = ((iconMargin + iconHeight ) * iconNum) - iconHeight/2
    iconName.origY = iconName.y
    iconName.origX = iconHeight/2
	iconName.number = iconNum
	iconName:addEventListener( "touch", buttonPress )
	-- Add to group with a separate function so that x, y values are relative to top, left
	iconName.group = iconGroup
    iconName.group:insert( iconName )
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

-- Get lowest possible Y position for group
iconGroup.floor = iconGroup.origY - (iconGroup.height - scrollMask.height + iconMargin)
print ( "floor: " .. iconGroup.floor)