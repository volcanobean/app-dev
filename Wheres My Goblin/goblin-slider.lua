---------------------------------------------------------------------------------
--
-- goblin-slider.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    -- My global variables (_myG.) - The following variables are all assigned in the main.lua file for this project:
    -- blockCount, blockWidth, blockMargin, blockHeight1, blockHeight2, blockHeight3, ribbonY1, ribbonY2, ribbonY3

    -- create ribbon table/array for storage of ribbon pieces/variables later in this file
    -- This table is in my globals so it can be accessed by other scenes

    _myG.ribbon = {}

    local ribbonX = (display.contentWidth - _myG.blockWidth)*0.5 - _myG.blockMargin
    local ribbonStartX = ribbonX -- store starting X value for future reference
    --local ribbonXText = display.newText( "X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )

    local blockRegion = "center"
    local activeRibbon = 1
    local activeBlockSnap = ribbonX
    -- local activeBlockText = display.newText( "ARibbon: " .. activeRibbon .. ", ABlock: 1, Region: " .. blockRegion, display.contentCenterX, 50, native.systemFont, 30 )
    -- sceneGroup:insert( activeBlockText )

    -- duplicate image blocks for the purpose of x pos swapping to simulate loop

    local blockGroupA = {}
    local blockGroupB = {}

    local blockGroupWidth = (_myG.blockWidth+_myG.blockMargin)*_myG.blockCount

    -- Get center point of block group, taking into account starting position X offset

    local blockGroupCenter = ribbonStartX - ( blockGroupWidth*0.5 - _myG.blockWidth*0.5 - _myG.blockMargin*0.5 )
    --local blockGroupText = display.newText( "Start X: " .. ribbonStartX .. ", Width: " .. blockGroupWidth .. ", Center: " .. blockGroupCenter, display.contentCenterX, 90, native.systemFont, 30 )

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

    local moveAllowed = "true"

    -- on first load, UI is not active until after intro animations complete

    _myG.uiActive = "false"

    -- Generate block end values

    -- block 1 requires a different formula than the others because it starts with a positive X value and not at 0
    blockEnd[1] = (_myG.blockWidth*0.5 + _myG.blockMargin - ribbonStartX) * -1
    blockEndRight[1] = blockEnd[1] - blockGroupWidth
    blockEndLeft[1] = blockEnd[1] + blockGroupWidth
    -- starting with block 2 generate block end values, for use in finding the current active block based on parent group's x position
    for i=2, _myG.blockCount do
        blockEnd[i] = blockEnd[1] - ((_myG.blockWidth + _myG.blockMargin) * (i - 1))
        blockEndRight[i] = blockEnd[i] - blockGroupWidth
        blockEndLeft[i] = blockEnd[i] + blockGroupWidth
    end 

    -- Generate Block Center values

    local blockSnap = {}
    local blockSnapRight = {}
    local blockSnapLeft = {}
    for i=1, _myG.blockCount do
        blockSnap[i] = blockEnd[i] + (_myG.blockWidth*0.5) + _myG.blockMargin;
        blockSnapRight[i] = blockSnap[i] - blockGroupWidth
        blockSnapLeft[i] = blockSnap[i] + blockGroupWidth
    end

    -- Function to check for a swipe vs a touch and drag

    local function swipeTimer()
        -- On completion of timer...
        -- It is a swipe if the user moves their finger left or right and then releases before the countdown ends.
        if ( touchEndX ~= touchStartX ) and ( touching == false ) then
           touchCommand = "swipe"
           print( "swipe" )
        -- It is a drag if the user moves their finger left or right and does not release before the timer ends.
        else
           touchCommand = "drag"
           print( "drag" )
        end
    end

    -- Active block check, compare current x pos to block end positions to determine active block (left, right or center)

    local function getActiveBlock( currentX, ribbonNum )
        -- if we're to the right of the main blocks (negative x pos)
        if( currentX < blockEnd[_myG.blockCount] ) then
            for i=1, _myG.blockCount do
                -- first block needs unique conditions to be checked
                if ( i == 1 ) and ( currentX > blockEndRight[1] ) then
                    _myG.ribbon[ribbonNum].activeBlock =  i
                    activeBlockSnap = blockSnapRight[i]
                -- all other blocks follow same pattern as each other
                elseif ( i ~= 1 ) and ( currentX < blockEndRight[i-1] ) and ( currentX > blockEndRight[i] ) then
                    _myG.ribbon[ribbonNum].activeBlock = i
                    activeBlockSnap = blockSnapRight[i]
                end
            end
            blockRegion = "right"
            -- debug
            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
        
        -- if we're to the left of the main blocks (positive x pos)
        elseif( currentX > (ribbonStartX + _myG.blockWidth*0.5)) then
             for i=1, _myG.blockCount do
                -- first block needs unique conditions to be checked
                if ( i == 1 ) and ( currentX > blockEndLeft[1] ) then
                    _myG.ribbon[ribbonNum].activeBlock =  i
                    activeBlockSnap = blockSnapLeft[i]
                -- all other blocks follow same pattern
                elseif ( i ~= 1 ) and ( currentX < blockEndLeft[i-1] ) and ( currentX > blockEndLeft[i] ) then
                    _myG.ribbon[ribbonNum].activeBlock = i
                    activeBlockSnap = blockSnapLeft[i]
                end
            end
            blockRegion = "left"
            -- debug
            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion

        -- if x pos is in the main block area
        else
            for i=1, _myG.blockCount do
                -- first block needs unique conditions to be checked
                if ( i == 1 ) and ( currentX > blockEnd[1] ) then
                    _myG.ribbon[ribbonNum].activeBlock =  i
                    activeBlockSnap = blockSnap[i]
                -- all other blocks follow same pattern
                elseif ( i ~= 1 ) and ( currentX < blockEnd[i-1] ) and ( currentX > blockEnd[i] ) then
                    _myG.ribbon[ribbonNum].activeBlock = i
                    activeBlockSnap = blockSnap[i]
                end
            end
            blockRegion = "center"
            -- debug
            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
        end
        --print ( blockRegion )
    end

    -- Shift position of scond group to right or left side of main group depending on X pos

    local function groupSwap( ribbonNum )
        if ( _myG.ribbon[activeRibbon].x > blockGroupCenter ) then
            -- invert blockGroup2 to the left
            blockGroupB[ribbonNum].x = -blockGroupWidth
        elseif ( _myG.ribbon[activeRibbon].x < blockGroupCenter ) then
            -- move blockGroup2 back to the right
            blockGroupB[ribbonNum].x = blockGroupWidth
        end
    end

    -- Functions for use in only allowing movement after a previous movement is complete

    local function moveStart()
        moveAllowed = "false"
        -- moveText.text = moveAllowed
        -- print ("before: " .. _myG.ribbon[activeRibbon].activeBlock .. ", " .. blockRegion)
    end

    local function moveEnd()
        moveAllowed = "true"
        -- moveText.text = moveAllowed
        -- print ("after:  " .. _myG.ribbon[activeRibbon].activeBlock .. ", " .. blockRegion)
    end

    -- Move ribbon to center X pos if coming from left or right

    local function shiftToCenter()
        print ("shift to center")
        local shiftX
        if ( blockRegion == "right" ) then
            shiftX = activeBlockSnap + blockGroupWidth
        elseif  ( blockRegion == "left" ) then
            shiftX = activeBlockSnap - blockGroupWidth
        end
        -- move ribbon to relative center X pos
        _myG.ribbon[activeRibbon].x=shiftX
        -- recheck active block values
        getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
        -- swap groups as needed
        groupSwap( activeRibbon )
        -- signal shift is complete so other movements can resume
        moveEnd()
    end


    -- Event function for ribbon drag/scroll interactions

    local function scrollMe( event )
        -- ON PRESS:
        if ( event.phase == "began" ) then
            -- if not already in the middle of a previous swipe or drag/snap
            if ( _myG.uiActive == "true" ) and ( moveAllowed == "true" ) then
                -- set active ribbon
                activeRibbon = event.target.id
                -- debug
                -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: 1, Region: " .. blockRegion

                -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
                display.getCurrentStage():setFocus( event.target )
                event.target.isFocus = true
                
                -- touch has started. start timer
                touching = true
                touchTimer = timer.performWithDelay( 300, swipeTimer )
                -- get touch position offset to prevent awkward snapping of ribbon to user's finger
                event.target.offset = event.x - _myG.ribbon[activeRibbon].x
                --ribbonXText.text = "X: " .. _myG.ribbon[activeRibbon].x
                -- get initial touch positions to measure swipe
                touchStartX = event.xStart
                touchEndX = event.x

                -- Check for active block, this is to make sure a new tap doesn't use the old active block information
                getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
            end

        -- ON MOVE:
        elseif ( event.target.isFocus ) then
            if ( event.phase == "moved" ) then
                -- START DRAG:
                _myG.ribbon[activeRibbon].x = event.x - event.target.offset
                -- debug
                --ribbonXText.text = "X: " .. _myG.ribbon[activeRibbon].x
                -- track x and y movement, store as last positions touched
                touchEndX = event.x
                -- Swap groups as needed
                groupSwap( activeRibbon )
                 -- Check for active block
                getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
                
            -- ON RELEASE: 
            elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                -- remove button focus once finger is lifted from screen
                display.getCurrentStage():setFocus( nil )
                event.target.isFocus = false
                -- touch has ended
                touching = false

                -- if not in the middle of a previous swipe/drag
                if ( _myG.uiActive == "true" )  and ( moveAllowed == "true" ) then
                    -- if a swip command has been triggered
                    if ( touchCommand == "swipe" ) then

                        -- SWIPE LEFT:
                        if ( touchEndX < touchStartX ) then
                            -- if at end of center block region
                            if ( _myG.ribbon[activeRibbon].activeBlock == _myG.blockCount ) then
                                -- transition to first block in right region, then shift to center
                                blockRegion = "right"
                                activeBlockSnap = blockSnapRight[1]
                                transition.to( _myG.ribbon[activeRibbon], { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                                -- note: shift to center will get the active block on completion
                                -- debug
                                -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                           -- else, if we're not at the end but still in the center region
                           elseif ( blockRegion == "center" ) then
                                nextBlockSnap = _myG.ribbon[activeRibbon].activeBlock + 1
                                transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                                -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                                _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                                -- debug
                                -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                            -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                            else
                                -- don't do the full swipe animation, just shift to the next block
                                transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            end

                        -- SWIPE RIGHT:
                        elseif ( touchEndX > touchStartX) then
                            -- if at start of center block region
                            if( _myG.ribbon[activeRibbon].activeBlock == 1) then
                                -- transition to last block in left region, then shift to center
                                blockRegion = "left"
                                activeBlockSnap = blockSnapLeft[_myG.blockCount]
                                transition.to( _myG.ribbon[activeRibbon], { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                                -- debug
                                -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                             -- else, if we're not at the end but still in the center region
                           elseif ( blockRegion == "center" ) then
                                nextBlockSnap = _myG.ribbon[activeRibbon].activeBlock - 1
                                transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                                -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                                _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                                -- debug
                                -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                            -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                            else
                                -- don't do the full swipe animation, just shift to the next block
                                transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            end
                        end

                    -- DRAG:
                    else
                        -- if the ribbon has been dragged out of the center region into the left or the right regions
                        if( blockRegion ~= "center" ) then
                            -- shift back to center
                            transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                        -- else if we're still in the center
                        else
                            -- just snap to nearest block
                            print ("abs: " .. activeBlockSnap)
                            transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=moveEnd } )
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
    sceneGroup:insert( centerRule )

    -- Create hit areas to control ribbon scroll

    local hitRibbon1 = display.newRect( display.contentCenterX, 260, display.contentWidth, 215 )
    hitRibbon1:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon1.id = 1
    hitRibbon1:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon1 )

    local hitRibbon2 = display.newRect( display.contentCenterX, 500, display.contentWidth, 262 )
    hitRibbon2:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon2.id = 2
    hitRibbon2:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon2 )

    local hitRibbon3 = display.newRect( display.contentCenterX, 770, display.contentWidth, 275 )
    hitRibbon3:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon3.id = 3
    hitRibbon3:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon3 )

    -- We render the background image after the hit area so it is stacked on top, hiding the hit area.
    
    _myG.background = display.newImageRect( "images/forest-bg.jpg", 768, 1366 )
    _myG.background.x = display.contentCenterX
    _myG.background.y = display.contentCenterY
    sceneGroup:insert( _myG.background )

    -- Create scrollable ribbon group (last one shows up on top, so we display legs, then body, the head)

    _myG.ribbon[3] = display.newGroup()
    _myG.ribbon[3].x = ribbonX
    _myG.ribbon[3].y = _myG.ribbonY3
    _myG.ribbon[3].id = 3
    _myG.ribbon[3].activeBlock = 1
    sceneGroup:insert( _myG.ribbon[3] )

    _myG.ribbon[2] = display.newGroup()
    _myG.ribbon[2].x = ribbonX
    _myG.ribbon[2].y = _myG.ribbonY2
    _myG.ribbon[2].id = 2
    _myG.ribbon[2].activeBlock = 1
    sceneGroup:insert( _myG.ribbon[2] )

    _myG.ribbon[1] = display.newGroup()
    _myG.ribbon[1].x = ribbonX
    _myG.ribbon[1].y = _myG.ribbonY1
    _myG.ribbon[1].id = 1
    _myG.ribbon[1].activeBlock = 1
    sceneGroup:insert( _myG.ribbon[1] )

    -- Image sheets for body parts

    local headCount = _myG.blockCount
    local headSheetInfo = require("heads-sheet")
    local headSheet = graphics.newImageSheet( "images/heads-sheet.png", headSheetInfo:getSheet() )
    local headFrames = { start=1, count=headCount }

    local torsoCount = _myG.blockCount
    local torsoSheet = graphics.newImageSheet( "images/torso-sheet.png", { width=_myG.blockWidth, height=_myG.blockHeight2, numFrames=torsoCount, sheetContentWidth=_myG.blockWidth, sheetContentHeight=_myG.blockHeight2*torsoCount } )
    local torsoFrames =  { start=1, count=torsoCount }

    local legCount = _myG.blockCount
    local legSheet = graphics.newImageSheet( "images/legs-sheet.png", { width=_myG.blockWidth, height=_myG.blockHeight3, numFrames=legCount, sheetContentWidth=_myG.blockWidth, sheetContentHeight=_myG.blockHeight3*legCount } )
    local legFrames =  { start=1, count=legCount }

    -- block groups inside scroll group

    blockGroupA[1] = display.newGroup()
    _myG.ribbon[1]:insert( blockGroupA[1] )
    blockGroupA[1].x = 0

    blockGroupB[1] = display.newGroup()
    _myG.ribbon[1]:insert( blockGroupB[1] )
    blockGroupB[1].x = -blockGroupWidth

    blockGroupA[2] = display.newGroup()
    _myG.ribbon[2]:insert( blockGroupA[2] )
    blockGroupA[2].x = 0

    blockGroupB[2] = display.newGroup()
    _myG.ribbon[2]:insert( blockGroupB[2] )
    blockGroupB[2].x = -blockGroupWidth

    blockGroupA[3] = display.newGroup()
    _myG.ribbon[3]:insert( blockGroupA[3] )
    blockGroupA[3].x = 0

    blockGroupB[3] = display.newGroup()
    _myG.ribbon[3]:insert( blockGroupB[3] )
    blockGroupB[3].x = -blockGroupWidth


    local headsA = {}
    for i=1, _myG.blockCount do
        -- Automatically calculate block layout within parent group based on height, width and margin values.
        headsA[i] = display.newSprite( headSheet, headFrames )
        headsA[i]:setFrame(i)
        headsA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5 
        -- Note on *0.5 vs /2 to get half of _myG.blockWidth: in corona multiplication is faster than division
        -- Add to group, x, y values are relative to top, left
        blockGroupA[1]:insert( headsA[i] )
    end

    local headsB = {}
    for i=1, _myG.blockCount do
        headsB[i] = display.newSprite( headSheet, headFrames )
        headsB[i]:setFrame(i)
        headsB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupB[1]:insert( headsB[i] )
    end

    local torsoA = {}
    for i=1, _myG.blockCount do
        torsoA[i] = display.newSprite( torsoSheet, torsoFrames )
        torsoA[i]:setFrame(i)
        torsoA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupA[2]:insert( torsoA[i] )
    end

    local torsoB = {}
    for i=1, _myG.blockCount do
        torsoB[i] = display.newSprite( torsoSheet, torsoFrames )
        torsoB[i]:setFrame(i)
        torsoB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupB[2]:insert( torsoB[i] )
    end

    local legsA = {}
    for i=1, _myG.blockCount do
        -- Automatically calculate block layout within parent group based on height, width and margin values.
        legsA[i] = display.newSprite( legSheet, legFrames )
        legsA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        legsA[i]:setFrame(i)
        blockGroupA[3]:insert( legsA[i] )
    end

    local legsB = {}
    for i=1, _myG.blockCount do
        legsB[i] = display.newSprite( legSheet, legFrames )
        legsB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        legsB[i]:setFrame(i)
        blockGroupB[3]:insert( legsB[i] )
    end

    -- slider setup for first load

    function _myG.loadSlider()
        -- get random values for start position
        local random1 = math.random( 1, _myG.blockCount-2 )
        local random2 = math.random( 1, _myG.blockCount-1 )
        local random3 = math.random( 2, _myG.blockCount )
        -- get offset values
        local end1 = random1+1
        local end2 = random1+2
        local end3 = random2+1
        local end4 = random3-1
        if( end2 > _myG.blockCount ) then
            end2 = _myG.blockCount
        end
        if( end3 > _myG.blockCount ) then
            end3 = _myG.blockCount
        end
        print( random1,random2,random3 )
        print( end2,end3,end4 )
        -- set inital positions
        transition.to( _myG.ribbon[1], { time=0, x=blockEnd[random1] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[2], { time=0, x=blockEnd[random2] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[3], { time=0, x=blockEnd[random3] + _myG.blockWidth/2 + _myG.blockMargin } )
        --fade in
        transition.to( _myG.ribbon[1], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[2], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[3], { time=600, alpha=1 } )
        -- begin animation
        transition.to( _myG.ribbon[1], { delay=700, time=275, x=blockEnd[end1] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[1], { delay=1400, time=275, x=blockEnd[end2] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[2], { delay=2100, time=275, x=blockEnd[end3] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[3], { delay=2800, time=275, x=blockEnd[end4] + _myG.blockWidth/2 + _myG.blockMargin } )
        -- set ative block values based on post-animation start position
        _myG.ribbon[1].activeBlock = end2
        _myG.ribbon[2].activeBlock = end3
        _myG.ribbon[3].activeBlock = end4
        timer.performWithDelay( 3100, _myG.startGamePlay )
    end

--end scene:create
end 

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- Hide the goblin slider on initial game load.
        _myG.ribbon[1].alpha=0
        _myG.ribbon[2].alpha=0
        _myG.ribbon[3].alpha=0

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen

        -- Load Goblin banner and UI 
        composer.showOverlay( "ui-overlay", { effect="fade" }  )

    end
end


-- "scene:hide()"
function scene:hide( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( event.phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )
    local sceneGroup = self.view
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
