-- local variables
-- Block settings - adjust these settings as needed

local blockCount = 5
local blockWidth = 500
local blockHeight = blockWidth/2
local blockMargin = 15

-- Adjust y position of ribbons

local ribbonY1 = 320
local ribbonY2 = 585
local ribbonY3 = 850

-- more local variables, don't touch

local ribbon = {}

local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonStartX = ribbonX -- store starting X value for future reference
local activeBlock = 1
local activeBlockSnap = ribbonX
local activeRibbon = 1

-- Create swipe variables

local touchStartX = 0
local touchEndX = 0
local touchTimer
local touching
local touchCommand
local nextBlockSnap

-- DEBUG

local blockCountText = display.newText( "Block Count: " .. blockCount, 200, 50, native.systemFont, 30 )
local activeRibbonText = display.newText( "Active Ribbon: " .. activeRibbon, 200, 90, native.systemFont, 30 )

--local ribbonXText = display.newText( "Ribbon X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )
--local ribbonStartXText = display.newText( "Ribbon Start X: " .. ribbonStartX, display.contentCenterX, 90, native.systemFont, 30 )
--local activeBlockSnapText = display.newText( "Active Block Snap: " .. activeBlockSnap, display.contentCenterX, 170, native.systemFont, 30 )
--local touchStartXText = display.newText( "touchStartX: " .. touchStartX, display.contentCenterX, 950, native.systemFont, 30 )
--local touchEndXText = display.newText( "touchEndX: " .. touchEndX, display.contentCenterX, 990, native.systemFont, 30 )


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


-- Active block check, compare current ribbon's current x pos to block end positions to determine active block

local function getActiveBlock( currentX, ribbonNum )
    for i=1, blockCount do
        -- first block needs unique conditions to be checked
        if ( i == 1 ) and ( currentX > blockEnd[1] ) then
            ribbon[ribbonNum].activeBlock =  i
            activeBlockSnap = blockSnap[i]
        -- all other blocks follow same pattern
        elseif ( i ~= 1 ) and ( currentX < blockEnd[i-1] ) and ( currentX > blockEnd[i] ) then
            ribbon[ribbonNum].activeBlock = i
            activeBlockSnap = blockSnap[i]
        end
    end
    -- debug
    activeRibbonText.text = "Active Ribbon: " .. ribbonNum
    ribbon[ribbonNum].debug.text = "R" .. ribbonNum .. " Active Block: " .. ribbon[ribbonNum].activeBlock
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
        -- set active ribbon
        activeRibbon = event.target.id

        -- debug
        activeRibbonText.text = "Active Ribbon: " .. activeRibbon
        
        --touchStartXText.text = "touchStartX: " .. touchStartX
        --touchEndXText.text = "touchEndX: " .. touchEndX

    -- ON MOVE:
    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then
            -- START DRAG:
            event.target.x = event.x - event.target.offset
            -- track x and y movement, store as last positions touched
            touchEndX = event.x

            -- Check for active block
            getActiveBlock( event.target.x, activeRibbon )
            -- debug
            --ribbonXText.text = "Ribbon X: " .. event.target.x
            --touchEndXText.text = "touchEndX: " .. touchEndX

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
                    if(ribbon[activeRibbon].activeBlock ~= blockCount) then
                        nextBlockSnap = ribbon[activeRibbon].activeBlock + 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )
                        -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                        ribbon[activeRibbon].activeBlock = nextBlockSnap
                        -- debug
                        ribbon[activeRibbon].debug.text = "R" .. activeRibbon .. " Active Block: " .. ribbon[activeRibbon].activeBlock
                    else
                        -- snap to nearest block
                        transition.to( event.target, { time=150, x=activeBlockSnap } )     
                    end
                elseif ( touchEndX > touchStartX) then
                    -- swipe right
                    if(ribbon[activeRibbon].activeBlock ~= 1) then
                        nextBlockSnap = ribbon[activeRibbon].activeBlock - 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )     
                        ribbon[activeRibbon].activeBlock = nextBlockSnap
                        --debug
                        ribbon[activeRibbon].debug.text = "R" .. activeRibbon .. " Active Block: " .. ribbon[activeRibbon].activeBlock
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

ribbon[1] = display.newGroup()
ribbon[1]:addEventListener( "touch", ribbonScroll )
ribbon[1].x = ribbonX -- use variables from top
ribbon[1].y = ribbonY1
ribbon[1].id = 1
ribbon[1].activeBlock = 1
ribbon[1].debug = display.newText( "R1 Active Block: " .. ribbon[1].activeBlock, 560, 50, native.systemFont, 30 )

ribbon[2] = display.newGroup()
ribbon[2]:addEventListener( "touch", ribbonScroll )
ribbon[2].x = ribbonX
ribbon[2].y = ribbonY2
ribbon[2].id = 2
ribbon[2].activeBlock = 1
ribbon[2].debug = display.newText( "R2 Active Block: " .. ribbon[2].activeBlock, 560, 90, native.systemFont, 30 )

ribbon[3] = display.newGroup()
ribbon[3]:addEventListener( "touch", ribbonScroll )
ribbon[3].x = ribbonX
ribbon[3].y = ribbonY3
ribbon[3].id = 3
ribbon[3].activeBlock = 1
ribbon[3].debug = display.newText( "R3 Active Block: " .. ribbon[3].activeBlock, 560, 130, native.systemFont, 30 )


-- Create blocks - Generate blocks based on block count
-- populate blocks with images at a later date

local block = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    block[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    block[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    ribbon[1]:insert( block[i] )
end

local block2 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    block2[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    block2[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    ribbon[2]:insert( block2[i] )
end

local block3 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    block3[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    block3[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    ribbon[3]:insert( block3[i] )
end
