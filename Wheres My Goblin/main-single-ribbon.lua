-- local variables
-- adjust these settings as needed

local blockCount = 15
local blockWidth = 500
local blockHeight = blockWidth/1.5
local blockMargin = 15

-- more local variables, don't touch

local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonY = 380
local ribbonStartX = ribbonX -- store starting X value for future reference
local activeBlock = 1
local activeBlockSnap = ribbonX

-- Create swipe variables

local touchStartX = 0
local touchEndX = 0
local touchTimer
local touching
local touchCommand
local nextBlockSnap

-- DEBUG

local ribbonXText = display.newText( "Ribbon X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )
local ribbonStartXText = display.newText( "Ribbon Start X: " .. ribbonStartX, display.contentCenterX, 90, native.systemFont, 30 )
local activeBlockText = display.newText( "Active Block: " .. activeBlock, display.contentCenterX, 130, native.systemFont, 30 )
local activeBlockSnapText = display.newText( "Active Block Snap: " .. activeBlockSnap, display.contentCenterX, 170, native.systemFont, 30 )
local touchStartXText = display.newText( "touchStartX: " .. touchStartX, display.contentCenterX, 950, native.systemFont, 30 )
local touchEndXText = display.newText( "touchEndX: " .. touchEndX, display.contentCenterX, 990, native.systemFont, 30 )


-- Generate Block End values

-- Since we can't dynamically generate variable names, we create a table/array to store and retrieve values
local blockEnd = {}
-- our first block end requires a different formula than the others because it starts with a positive X value and not at 0
blockEnd[1] = (blockWidth/2 + blockMargin - ribbonStartX) * -1
print( blockEnd[1] )
-- starting with block 2 generate block end values, for use in finding the current active block based on parent group's x position
for i=2, blockCount do
    blockEnd[i] = blockEnd[1] - ((blockWidth + blockMargin) * (i - 1))
    print( blockEnd[i] )
end


-- Generate Block Center values

local blockSnap = {}
for i=1, blockCount do
    blockSnap[i] = blockEnd[i] + (blockWidth/2) + blockMargin;
    print( blockSnap[i] )
end


-- Function to check for a swipe vs a touch and drag

local function swipeTimer()
    -- On completion of timer...
    -- It is a swipe if the user moves their finger left or right and then releases before the countdown ends.
    if ( touchEndX ~= touchStartX ) and ( touching == false ) then
       touchCommand = "swipe"
    -- It is a drag if the user moves their finger up or down and does not release before the timer ends.
    elseif ( touching == true ) then
       touchCommand = "drag" 
    end
end


-- Active block check, compare ribbon's current x pos to block end positions to determine active block

local function getActiveBlock( currentX )
    for i=1, blockCount do
        -- first block needs conditions to be checked
        if ( i == 1 ) and ( currentX > blockEnd[1] ) then
            activeBlock =  i
            activeBlockSnap = blockSnap[i]
        -- all other blocks follow same pattern
        elseif ( i ~= 1 ) and ( currentX < blockEnd[i-1] ) and ( currentX > blockEnd[i] ) then
            activeBlock = i
            activeBlockSnap = blockSnap[i]
        end
    end
    -- debug
    activeBlockText.text = "Active Block: " .. activeBlock
    activeBlockSnapText.text = "Active Block Snap: " .. activeBlockSnap
end


-- Event function for ribbon drag/scroll interactions

local function ribbonScroll( event )
    -- ON PRESS:
    if ( event.phase == "began" ) then
        -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        -- touch has started. start timer
        touching = true
        touchTimer = timer.performWithDelay( 300, swipeTimer )
        -- get touch position offset to prevent awkward snapping of ribbon to user's finger
        event.target.offset = event.x - event.target.x
        -- get initial touch positions to measure swipe
        touchStartX = event.xStart
        touchEndX = event.x
        -- debug
        touchStartXText.text = "touchStartX: " .. touchStartX
        touchEndXText.text = "touchEndX: " .. touchEndX

    -- ON MOVE:
    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then
            -- START DRAG:
            event.target.x = event.x - event.target.offset
            -- track x and y movement, store as last positions touched
            touchEndX = event.x
            -- Check for active block
            getActiveBlock( event.target.x )
            -- debug
            ribbonXText.text = "Ribbon X: " .. event.target.x
            touchEndXText.text = "touchEndX: " .. touchEndX

        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false 
            -- touch has ended
            touching = false
            -- check for swipe vs drag
            if ( touchCommand == "swipe" ) then
                -- if releasing a swipe:
                if  ( touchEndX < touchStartX) then
                    -- swipe left
                    if(activeBlock ~= blockCount) then
                        nextBlockSnap = activeBlock + 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )
                    else
                        -- snap to nearest block
                        transition.to( event.target, { time=150, x=activeBlockSnap } )     
                    end
                elseif ( touchEndX > touchStartX) then
                    -- swipe right
                    if(activeBlock ~= 1) then
                        nextBlockSnap = activeBlock - 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )     
                    else
                        -- snap to nearest block
                        transition.to( event.target, { time=150, x=activeBlockSnap } ) 
                    end
                end
            else
                -- Default drag and release behavior, snap to nearest block
                transition.to( event.target, { time=150, x=activeBlockSnap } ) 
            end
            -- clear touchCommand so it's not set incorrecty on the next button press
            touchCommand = nil
        end
    end
    -- for event functions, always return true to prevent touch propagation to underlying objects
    return true  
end


-- Create guide for center of screen

--display.newRect( parent, x, y, width, height )
local centerArea = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerArea:setFillColor( 0, 1, 1, 0.25 )


-- Create scrollable ribbon group

local ribbon = display.newGroup()
ribbon:addEventListener( "touch", ribbonScroll )
ribbon.x = ribbonX -- use variables from top
ribbon.y = ribbonY


-- Create blocks - Generate blocks based on block count

local block = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    block[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    block[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    ribbon:insert( block[i] )
end