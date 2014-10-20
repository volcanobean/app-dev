-- Block and ribbon settings - adjust these settings as needed.

local blockCount = 6
local blockWidth = 600 -- replace with % instead of pixels later (responsive)
local blockMargin = 15

local blockHeight1 = 350
local blockHeight2 = 250
local blockHeight3 = 250
local ribbonY1 = 350
local ribbonY2 = 575
local ribbonY3 = 850

-- Local settings. Don't touch.

local ribbon = {}

local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonStartX = ribbonX -- store starting X value for future reference
local ribbonXText = display.newText( "X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )

local blockRegion = "center"
local activeRibbon = 1
local activeBlockSnap = ribbonX
local activeBlockText = display.newText( "ARibbon: " .. activeRibbon .. ", ABlock: 1, Region: " .. blockRegion, display.contentCenterX, 130, native.systemFont, 30 )

-- duplicate image blocks for the purpose of x pos swapping to simulate loop

local blockGroupA = {}
local blockGroupB = {}

local blockGroupWidth = (blockWidth+blockMargin)*blockCount

-- Get center point of block group, taking into account starting position X offset

local blockGroupCenter = ribbonStartX - ( blockGroupWidth/2 - blockWidth/2 - blockMargin/2 )
local blockGroupText = display.newText( "Start X: " .. ribbonStartX .. ", Width: " .. blockGroupWidth .. ", Center: " .. blockGroupCenter, display.contentCenterX, 90, native.systemFont, 30 )

-- Generate groups to store Block End values

local blockEnd = {}
local blockEndRight = {}
local blockEndLeft = {}

-- Create swipe variables

local touchStartX = 0
local touchEndX = 0
local touchTimer
local touching
local touchCommand = "drag"
local nextBlockSnap = 0

local moveComplete = "true"
-- local moveText = display.newText( moveComplete, display.contentCenterX, 160, native.systemFont, 30 )

-- Generate block end values

-- block 1 requires a different formula than the others because it starts with a positive X value and not at 0
blockEnd[1] = (blockWidth/2 + blockMargin - ribbonStartX) * -1
blockEndRight[1] = blockEnd[1] - blockGroupWidth
blockEndLeft[1] = blockEnd[1] + blockGroupWidth
-- starting with block 2 generate block end values, for use in finding the current active block based on parent group's x position
for i=2, blockCount do
    blockEnd[i] = blockEnd[1] - ((blockWidth + blockMargin) * (i - 1))
    blockEndRight[i] = blockEnd[i] - blockGroupWidth
    blockEndLeft[i] = blockEnd[i] + blockGroupWidth
end 

-- Generate Block Center values

local blockSnap = {}
local blockSnapRight = {}
local blockSnapLeft = {}
for i=1, blockCount do
    blockSnap[i] = blockEnd[i] + (blockWidth/2) + blockMargin;
    blockSnapRight[i] = blockSnap[i] - blockGroupWidth
    blockSnapLeft[i] = blockSnap[i] + blockGroupWidth
end

-- Function to check for a swipe vs a touch and drag

local function swipeTimer()
    -- On completion of timer...
    -- It is a swipe if the user moves their finger left or right and then releases before the countdown ends.
    if ( touchEndX ~= touchStartX ) and ( touching == false ) then
       touchCommand = "swipe"
    -- It is a drag if the user moves their finger left or right and does not release before the timer ends.
    else
       touchCommand = "drag" 
    end
end

-- Active block check, compare current x pos to block end positions to determine active block (left, right or center)

local function getActiveBlock( currentX, ribbonNum )
    -- if we're to the right of the main blocks (negative x pos)
    if( currentX < blockEnd[blockCount] ) then
        for i=1, blockCount do
            -- first block needs unique conditions to be checked
            if ( i == 1 ) and ( currentX > blockEndRight[1] ) then
                ribbon[ribbonNum].activeBlock =  i
                activeBlockSnap = blockSnapRight[i]
            -- all other blocks follow same pattern as each other
            elseif ( i ~= 1 ) and ( currentX < blockEndRight[i-1] ) and ( currentX > blockEndRight[i] ) then
                ribbon[ribbonNum].activeBlock = i
                activeBlockSnap = blockSnapRight[i]
            end
        end
        blockRegion = "right"
        -- debug
        activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
    
    -- if we're to the left of the main blocks (positive x pos)
    elseif( currentX > (ribbonStartX + blockWidth/2)) then
         for i=1, blockCount do
            -- first block needs unique conditions to be checked
            if ( i == 1 ) and ( currentX > blockEndLeft[1] ) then
                ribbon[ribbonNum].activeBlock =  i
                activeBlockSnap = blockSnapLeft[i]
            -- all other blocks follow same pattern
            elseif ( i ~= 1 ) and ( currentX < blockEndLeft[i-1] ) and ( currentX > blockEndLeft[i] ) then
                ribbon[ribbonNum].activeBlock = i
                activeBlockSnap = blockSnapLeft[i]
            end
        end
        blockRegion = "left"
        -- debug
        activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion

    -- if x pos is in the main block area
    else
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
        blockRegion = "center"
        -- debug
        activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
    end
    --print ( blockRegion )
end

-- Shift position of scond group to right or left side of main group depending on X pos

local function groupSwap( target, ribbonNum )
    if ( target.x > blockGroupCenter ) then
        -- invert blockGroup2 to the left
        blockGroupB[ribbonNum].x = -blockGroupWidth
    elseif ( target.x < blockGroupCenter ) then
        -- move blockGroup2 back to the right
        blockGroupB[ribbonNum].x = blockGroupWidth
    end
end

local function moveStart()
    moveComplete = "false"
    -- moveText.text = moveComplete
    -- print ("before: " .. ribbon[activeRibbon].activeBlock .. ", " .. blockRegion)
end

local function moveEnd()
    moveComplete = "true"
    -- moveText.text = moveComplete
    -- print ("after:  " .. ribbon[activeRibbon].activeBlock .. ", " .. blockRegion)
end

-- Move ribbon to center X pos if coming from left or right

local function shiftToCenter( target )
    local shiftX
    if ( blockRegion == "right" ) then
        shiftX = activeBlockSnap + blockGroupWidth
    elseif  ( blockRegion == "left" ) then
        shiftX = activeBlockSnap - blockGroupWidth
    end
    -- move ribbon to relative center X pos
    target.x=shiftX
    -- recheck active block values
    getActiveBlock( target.x, activeRibbon )
    -- swap groups as needed
    groupSwap( target, activeRibbon )
    -- signal shift is complete so other movements can resume
    moveEnd()
end


-- Event function for ribbon drag/scroll interactions

local function scrollMe( event )
    -- ON PRESS:
    if ( event.phase == "began" ) then
        -- if not already in the middle of a previous swipe or drag/snap
        if ( moveComplete == "true" ) then
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
            -- set active ribbon
            activeRibbon = event.target.id
        end

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
            groupSwap( event.target, activeRibbon )
            -- Check for active block
            getActiveBlock( event.target.x, activeRibbon )
            
        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
            -- touch has ended
            touching = false

            -- if not in the middle of a previous swipe/drag
            if ( moveComplete == "true" ) then
                -- if a swip command has been triggered
                if ( touchCommand == "swipe" ) then

                    -- SWIPE LEFT:
                    if ( touchEndX < touchStartX) then
                        -- if at end of center block region
                        if ( ribbon[activeRibbon].activeBlock == blockCount ) then
                            -- transition to first block in right region, then shift to center
                            blockRegion = "right"
                            activeBlockSnap = blockSnapRight[1]
                            transition.to( event.target, { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            -- note: shift to center will get the active block on completion
                            -- debug
                            activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                       -- else, if we're not at the end but still in the center region
                       elseif ( blockRegion == "center" ) then
                            nextBlockSnap = ribbon[activeRibbon].activeBlock + 1
                            transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                        -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                        else
                            -- don't do the full swipe animation, just shift to the next block
                            transition.to( event.target, { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                        end

                    -- SWIPE RIGHT:
                    elseif ( touchEndX > touchStartX) then
                        -- if at start of center block region
                        if( ribbon[activeRibbon].activeBlock == 1) then
                            -- transition to last block in left region, then shift to center
                            blockRegion = "left"
                            activeBlockSnap = blockSnapLeft[blockCount]
                            transition.to( event.target, { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            -- debug
                            activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                         -- else, if we're not at the end but still in the center region
                       elseif ( blockRegion == "center" ) then
                            nextBlockSnap = ribbon[activeRibbon].activeBlock - 1
                            transition.to( event.target, { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                        -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                        else
                            -- don't do the full swipe animation, just shift to the next block
                            transition.to( event.target, { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                        end
                    end

                -- DRAG:
                else
                    -- if the ribbon has been dragged out of the center region into the left or the right regions
                    if( blockRegion ~= "center" ) then
                        -- shift back to center
                        transition.to( event.target, { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                    -- else if we're still in the center
                    else
                        -- just snap to nearest block
                        transition.to( event.target, { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=moveEnd } )
                    end
                end
                -- clear touchCommand so it's not set incorrecty on the next button press
                touchCommand = nil
            end
        end
    end
    -- for event functions, always return true to prevent touch propagation to underlying objects
    return true  
end

-- Create guide for center of screen

--display.newRect( parent, x, y, width, height )
local centerRule = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerRule:setFillColor( 0, 1, 1, 0.25 )

-- Create scrollable ribbon group (last one shows up on top)

ribbon[3] = display.newGroup()
ribbon[3]:addEventListener( "touch", scrollMe )
ribbon[3].x = ribbonX
ribbon[3].y = ribbonY3
ribbon[3].id = 3
ribbon[3].activeBlock = 1

ribbon[2] = display.newGroup()
ribbon[2]:addEventListener( "touch", scrollMe )
ribbon[2].x = ribbonX
ribbon[2].y = ribbonY2
ribbon[2].id = 2
ribbon[2].activeBlock = 1

ribbon[1] = display.newGroup()
ribbon[1]:addEventListener( "touch", scrollMe )
ribbon[1].x = ribbonX
ribbon[1].y = ribbonY1
ribbon[1].id = 1
ribbon[1].activeBlock = 1
--ribbon[1].debug = display.newText( "R1 Active Block: " .. ribbon[1].activeBlock, 560, 50, native.systemFont, 30 )
--sceneGroup:insert( ribbon[1] )
--sceneGroup:insert( ribbon[1].debug )

-- Image sheets for body parts

local headCount = 6
local headSheet = graphics.newImageSheet( "images/head-sheet.png", { width=blockWidth, height=blockHeight1, numFrames=headCount, sheetContentWidth=blockWidth, sheetContentHeight=blockHeight1*headCount } )
local headFrames =  { start=1, count=headCount }

--[[
local torsoCount = 6
local torsoSheet = graphics.newImageSheet( "images/torso-sheet.png", { width=blockWidth, height=blockHeight2, numFrames=torsoCount, sheetContentWidth=blockWidth, sheetContentHeight=blockHeight2*torsoCount } )
local torsoFrames =  { start=1, count=torsoCount }

local legCount = 6
local legSheet = graphics.newImageSheet( "images/leg-sheet.png", { width=blockWidth, height=blockHeight3, numFrames=legCount, sheetContentWidth=blockWidth, sheetContentHeight=blockHeight3*legCount } )
local legFrames =  { start=1, count=legCount }
]]--

-- block groups inside scroll group
blockGroupA[1] = display.newGroup()
ribbon[1]:insert( blockGroupA[1] )
blockGroupA[1].x = 0

blockGroupB[1] = display.newGroup()
ribbon[1]:insert( blockGroupB[1] )
blockGroupB[1].x = -blockGroupWidth

blockGroupA[2] = display.newGroup()
ribbon[2]:insert( blockGroupA[2] )
blockGroupA[2].x = 0

blockGroupB[2] = display.newGroup()
ribbon[2]:insert( blockGroupB[2] )
blockGroupB[2].x = -blockGroupWidth

blockGroupA[3] = display.newGroup()
ribbon[3]:insert( blockGroupA[3] )
blockGroupA[3].x = 0

blockGroupB[3] = display.newGroup()
ribbon[3]:insert( blockGroupB[3] )
blockGroupB[3].x = -blockGroupWidth


local headsA = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    headsA[i] = display.newSprite( headSheet, headFrames )
    -- blocks1[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight1 )
    headsA[i]:setFrame(i)
    headsA[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    --blocks1[i]:setFillColor( 0, 1, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroupA[1]:insert( headsA[i] )
end

local headsB = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    headsB[i] = display.newSprite( headSheet, headFrames )
    headsB[i]:setFrame(i)
    headsB[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    blockGroupB[1]:insert( headsB[i] )
end


local torsoA = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    --torsoA[i] = display.newSprite( torsoSheet, torsoFrames )
    torsoA[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight2 )
    --torsoA[i]:setFrame(i)
    torsoA[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    torsoA[i]:setFillColor( 0, 1, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroupA[2]:insert( torsoA[i] )
end

local torsoB = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    --torsoB[i] = display.newSprite( torsoSheet, torsoFrames )
    torsoB[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight2 )
    torsoB[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    --torsoB[i]:setFrame(i)
    torsoB[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    torsoB[i]:setFillColor( 1, 0, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroupB[2]:insert( torsoB[i] )
end

 
local legsA = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    --legsA[i] = display.newSprite( legSheet, legFrames )
    legsA[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight3 )
    --legsA[i]:setFrame(i)
    legsA[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    legsA[i]:setFillColor( 0, 1, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroupA[3]:insert( legsA[i] )
end

local legsB = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    --legsB[i] = display.newSprite( legSheet, legFrames )
    legsB[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight3 )
    legsB[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    --legsB[i]:setFrame(i)
    legsB[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    legsB[i]:setFillColor( 1, 0, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroupB[3]:insert( legsB[i] )
end
