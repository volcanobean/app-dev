-- Block and ribbon settings - adjust these settings as needed.

local blockCount = 6
local blockWidth = 600 -- replace with % instead of pixels later (responsive)
local blockHeight = 350
local blockMargin = 15

local ribbonY1 = 400
local ribbonY2 = 585
local ribbonY3 = 850

-- Local settings. Don't touch.

local ribbon = {}

local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonStartX = ribbonX -- store starting X value for future reference
local ribbonXText = display.newText( "X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )

local blockGroup1 
local blockGroup2

local blockRegion = "center"
local activeRibbon = 1
local activeBlock = 1
local activeBlockSnap = ribbonX
local activeBlockText = display.newText( "Active Block: " .. activeBlock .. ", Region: " .. blockRegion, display.contentCenterX, 130, native.systemFont, 30 )

local blockGroupWidth = (blockWidth+blockMargin)*blockCount
-- Get center point of block group, taking into account starting position X offset
local blockGroupCenter = ribbonStartX - ( blockGroupWidth/2 - blockWidth/2 - blockMargin/2 )
local blockGroupText = display.newText( "Start X: " .. ribbonStartX .. ", Width: " .. blockGroupWidth .. ", Center: " .. blockGroupCenter, display.contentCenterX, 90, native.systemFont, 30 )

-- Generate Block End values for center, left and right group positions
local blockEnd = {}
local blockEndRight = {}
local blockEndLeft = {}

-- Create swipe variables
local touchStartX = 0
local touchEndX = 0
local touchTimer
local touching
local touchCommand
local nextBlockSnap
    

-- block 1 requires a different formula than the others because it starts with a positive X value and not at 0
blockEnd[1] = (blockWidth/2 + blockMargin - ribbonStartX) * -1
blockEndRight[1] = blockEnd[1] - blockGroupWidth
blockEndLeft[1] = blockEnd[1] + blockGroupWidth
--debug
print( "b1end: " .. blockEnd[1] .. ", b1R: " .. blockEndRight[1] .. ", b1L: " .. blockEndLeft[1] )
-- starting with block 2 generate block end values, for use in finding the current active block based on parent group's x position
for i=2, blockCount do
    blockEnd[i] = blockEnd[1] - ((blockWidth + blockMargin) * (i - 1))
    blockEndRight[i] = blockEnd[i] - blockGroupWidth
    blockEndLeft[i] = blockEnd[i] + blockGroupWidth
    --debug
    print( "b" .. i .. "end: " .. blockEnd[i] .. ", b" .. i .. "R: " .. blockEndRight[i] .. ", b" .. i .. "L: " .. blockEndLeft[i] )
end 


-- Generate Block Center values

local blockSnap = {}
local blockSnapRight = {}
local blockSnapLeft = {}
for i=1, blockCount do
    blockSnap[i] = blockEnd[i] + (blockWidth/2) + blockMargin;
    blockSnapRight[i] = blockSnap[i] - blockGroupWidth
    blockSnapLeft[i] = blockSnap[i] + blockGroupWidth
    print( "Snap: " .. blockSnap[i] )
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


-- Active block check, compare current x pos to block end positions to determine active block (left, right or center)

local function getActiveBlock( currentX )
    -- if we're to the right of the main blocks (negative x pos)
    if( currentX < blockEnd[blockCount] ) then
        for i=1, blockCount do
            -- first block needs unique conditions to be checked
            if ( i == 1 ) and ( currentX > blockEndRight[1] ) then
                activeBlock =  i
                activeBlockSnap = blockSnapRight[i]
            -- all other blocks follow same pattern
            elseif ( i ~= 1 ) and ( currentX < blockEndRight[i-1] ) and ( currentX > blockEndRight[i] ) then
                activeBlock = i
                activeBlockSnap = blockSnapRight[i]
            end
        end
        blockRegion = "right"
        -- debug
        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
    
    -- if we're to the left of the main blocks (positive x pos)
    elseif( currentX > (ribbonStartX + blockWidth/2)) then
         for i=1, blockCount do
            -- first block needs unique conditions to be checked
            if ( i == 1 ) and ( currentX > blockEndLeft[1] ) then
                activeBlock =  i
                activeBlockSnap = blockSnapLeft[i]
            -- all other blocks follow same pattern
            elseif ( i ~= 1 ) and ( currentX < blockEndLeft[i-1] ) and ( currentX > blockEndLeft[i] ) then
                activeBlock = i
                activeBlockSnap = blockSnapLeft[i]
            end
        end
        blockRegion = "left"
        -- debug
        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion

    -- if x pos is in the main block area
    else
        for i=1, blockCount do
            -- first block needs unique conditions to be checked
            if ( i == 1 ) and ( currentX > blockEnd[1] ) then
                activeBlock =  i
                activeBlockSnap = blockSnap[i]
            -- all other blocks follow same pattern
            elseif ( i ~= 1 ) and ( currentX < blockEnd[i-1] ) and ( currentX > blockEnd[i] ) then
                activeBlock = i
                activeBlockSnap = blockSnap[i]
            end
        end
        blockRegion = "center"
        -- debug
        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
    end
    --print ( blockRegion )
end

-- Shift position of scond group to right or left side of main group depending on X pos

local function groupSwap( target )
    if ( target.x > blockGroupCenter ) then
        -- invert blockGroup2 to the left
        blockGroup2.x = -blockGroupWidth
    elseif ( target.x < blockGroupCenter ) then
        -- move blockGroup2 back to the right
        blockGroup2.x = blockGroupWidth
    end
end

-- Move ribbon to center X pos if coming from left or right

local function shiftToCenter( target )
    local shiftX
    print( blockRegion )
    if ( blockRegion == "right" ) then
        shiftX = activeBlockSnap + blockGroupWidth
    elseif  ( blockRegion == "left" ) then
        shiftX = activeBlockSnap - blockGroupWidth
    end
    -- move ribbon to relative center X pos
    target.x=shiftX
    -- recheck active block values
    getActiveBlock( target.x )
    -- swap groups as needed
    groupSwap( target )
    --activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion 
     print("R after: " .. blockRegion)
end


-- Event function for ribbon drag/scroll interactions

local function scrollMe( event )
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
        ribbonXText.text = "X: " .. event.target.x

        -- get initial touch positions to measure swipe
        touchStartX = event.xStart
        touchEndX = event.x

    -- ON MOVE:
    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then
            -- START DRAG:
            event.target.x = event.x - event.target.offset
            -- debug
            ribbonXText.text = "X: " .. event.target.x

            -- track x and y movement, store as last positions touched
            touchEndX = event.x

            -- Swap groups as needed
            groupSwap( event.target )

            -- Check for active block
            getActiveBlock( event.target.x )

        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false

            -- check for swipe vs drag
            if ( touchCommand == "swipe" ) then
                -- if releasing a swipe:
                if  ( touchEndX < touchStartX) then
                    -- swipe left
                    -- if at end of block region
                    if(activeBlock == blockCount) then
                        blockRegion = "right"
                        activeBlockSnap = blockSnapRight[1]
                        transition.to( event.target, { time=300, transition=easing.outSine, x=activeBlockSnap, onComplete=shiftToCenter } )
                        -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                        activeBlock = 1
                         print("Active a: " .. activeBlockSnap )
                        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
                    else
                        -- standard swipe
                        nextBlockSnap = activeBlock + 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )
                        -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                        activeBlock = nextBlockSnap
                        -- debug
                        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
                    end
                elseif ( touchEndX > touchStartX) then
                    -- swipe right
                    -- if at start of block region
                    if( activeBlock == 1) then
                        blockRegion = "left"
                        activeBlockSnap = blockSnapLeft[blockCount]
                        transition.to( event.target, { time=300, transition=easing.outSine, x=activeBlockSnap, onComplete=shiftToCenter } )
                        -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                        activeBlock = blockCount
                        print("Active a: " .. activeBlockSnap )
                        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
                    else
                        -- standard swipe
                        nextBlockSnap = activeBlock - 1
                        transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap] } )     
                        activeBlock = nextBlockSnap
                        --debug
                        activeBlockText.text = "Active Block: " .. activeBlock .. ", Region: " .. blockRegion
                    end
                end
            else
                -- Standard drag 
                if( blockRegion ~= "center" ) then
                    -- if we have stopped on a block in the right or left area, shift back to center
                    transition.to( event.target, { time=150, x=activeBlockSnap, onComplete=shiftToCenter } )
                else
                    --  snap to nearest block
                    transition.to( event.target, { time=150, x=activeBlockSnap } )
                end
            end
            -- touch has ended
            touching = false
            -- clear touchCommand so it's not set incorrecty on the next button press
            touchCommand = nil
        end
    end
    -- for event functions, always return true to prevent touch propagation to underlying objects
    return true  
end

-- Create guide for center of screen

--display.newRect( parent, x, y, width, height )
local centerRule = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerRule:setFillColor( 0, 1, 1, 0.25 )

-- Create scrollable ribbon group

ribbon[1] = display.newGroup()
ribbon[1]:addEventListener( "touch", scrollMe )
ribbon[1].x = ribbonX
ribbon[1].y = ribbonY1
ribbon[1].id = 1
ribbon[1].activeBlock = 1
--ribbon[1].debug = display.newText( "R1 Active Block: " .. ribbon[1].activeBlock, 560, 50, native.systemFont, 30 )
--sceneGroup:insert( ribbon[1] )
--sceneGroup:insert( ribbon[1].debug )

-- add ribbon[2] and [3] here later


-- Image sheets for body parts

local headCount = 6
local headSheet = graphics.newImageSheet( "images/head-sheet.png", { width=blockWidth, height=blockHeight, numFrames=headCount, sheetContentWidth=blockWidth, sheetContentHeight=blockHeight*headCount } )
local headFrames =  { start=1, count=headCount }



-- block groups inside scroll group
blockGroup1 = display.newGroup()
ribbon[1]:insert( blockGroup1 )
blockGroup1.x = 0

blockGroup2 = display.newGroup()
ribbon[1]:insert( blockGroup2 )
blockGroup2.x = -blockGroupWidth

local blocks1 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    blocks1[i] = display.newSprite( headSheet, headFrames )
    blocks1[i]:setFrame(i)
    -- blocks1[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    blocks1[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    --blocks1[i]:setFillColor( 0, 1, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroup1:insert( blocks1[i] )
end

local blocks2 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    blocks2[i] = display.newSprite( headSheet, headFrames )
    blocks2[i]:setFrame(i)
    blocks2[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    blockGroup2:insert( blocks2[i] )
end
