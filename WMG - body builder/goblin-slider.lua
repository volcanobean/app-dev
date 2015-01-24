---------------------------------------------------------------------------------
--
-- goblin-slider.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY
local mW = 0.0013022*cW

-- Begin global settings
-- Block and ribbon values. Adjust as needed

_myG.blockCount = 10
_myG.blockWidth = 512*mW
_myG.blockMargin = 120*mW

_myG.blockHeight1 = 312*mW
_myG.blockHeight2 = 540*mW
_myG.blockHeight3 = 396*mW

_myG.ribbonY1 = display.contentCenterY-(287*mW) --225
_myG.ribbonY2 = display.contentCenterY+(8*mW) --520
_myG.ribbonY3 = display.contentCenterY+(178*mW) --690


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.

-- debug

--local adDebug = display.newText( "Create: " .. _myG.adsHeight, display.contentCenterX, 50, native.systemFont, 30 )
--adDebug.text = "Show: " .. _myG.adsHeight

function scene:create( event )
    local sceneGroup = self.view

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

    local startX = 0
    local endX = 0
    local startTime
    local endTime

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

    -- Audio

    -- Sound FX

    local swipeFX = audio.loadSound( "audio/swipe.wav" )

    local function playSwipeFX()
        if( _myG.audioOn == "true" ) then
            audio.play( swipeFX )
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
        --print ("shift to center")
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
                
                -- get touch position offset to prevent awkward snapping of ribbon to user's finger
                event.target.offset = event.x - _myG.ribbon[activeRibbon].x
                --ribbonXText.text = "X: " .. _myG.ribbon[activeRibbon].x
                -- get initial touch positions to measure swipe
                startX = event.x
                startTime = event.time
                endX = event.x

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
                endX = event.x
                local difX = endX - startX
                -- Swap groups as needed
                groupSwap( activeRibbon )
                 -- Check for active block
                getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
                
            -- ON RELEASE: 
            elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                -- remove button focus once finger is lifted from screen
                display.getCurrentStage():setFocus( nil )
                event.target.isFocus = false

                endTime = event.time
                local totalTime = endTime - startTime

                -- if not in the middle of a previous swipe/drag
                if ( _myG.uiActive == "true" )  and ( moveAllowed == "true" ) then
                    -- if a swip command has been triggered

                    -- SWIPE LEFT:
                    if ( totalTime < 200 ) and ( endX < startX ) then
                        -- if at end of center block region
                        if ( _myG.ribbon[activeRibbon].activeBlock == _myG.blockCount ) then
                            -- transition to first block in right region, then shift to center
                            blockRegion = "right"
                            activeBlockSnap = blockSnapRight[1]
                            transition.to( _myG.ribbon[activeRibbon], { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            -- note: shift to center will get the active block on completion
                            -- play sound fx
                            playSwipeFX()
                            
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                       -- else, if we're not at the end but still in the center region
                       elseif ( blockRegion == "center" ) then
                            nextBlockSnap = _myG.ribbon[activeRibbon].activeBlock + 1
                            transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- play sound fx
                            playSwipeFX()
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                        -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                        else
                            -- don't do the full swipe animation, just shift to the next block
                            -- play sound fx
                            playSwipeFX()
                            transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                        end

                    -- SWIPE RIGHT:
                    elseif ( totalTime < 200 ) and ( endX > startX ) then
                        -- if at start of center block region
                        if( _myG.ribbon[activeRibbon].activeBlock == 1) then
                            -- transition to last block in left region, then shift to center
                            blockRegion = "left"
                            activeBlockSnap = blockSnapLeft[_myG.blockCount]
                            transition.to( _myG.ribbon[activeRibbon], { time=300, transition=easing.outSine, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            -- play sound fx
                            playSwipeFX()
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                         -- else, if we're not at the end but still in the center region
                       elseif ( blockRegion == "center" ) then
                            nextBlockSnap = _myG.ribbon[activeRibbon].activeBlock - 1
                            transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- play sound fx
                            playSwipeFX()
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                        -- else if we are not in the center region (because of a very fast/long swipe going into the right region before code trigger)
                        else
                            -- don't do the full swipe animation, just shift to the next block
                            transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=shiftToCenter } )
                            -- play sound fx
                            playSwipeFX()
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
                            --print ("abs: " .. activeBlockSnap)
                            transition.to( _myG.ribbon[activeRibbon], { time=150, x=activeBlockSnap, onStart=moveStart, onComplete=moveEnd } )
                        end
                    end
                end
            end
        end
        -- for event functions, always return true to prevent touch propagation to underlying objects
        return true  
    end

    -- Create guide for center of screen

    --[[
    local centerRule = display.newRect( display.contentCenterX, 500, 10, 1000 )
    centerRule:setFillColor( 0, 1, 1, 0.25 )
    sceneGroup:insert( centerRule )
    ]]--

    -- Create hit areas to control ribbon scroll

    local hitRibbonWidth = 500*mW

    local hitRibbon1 = display.newRect( display.contentCenterX, display.contentCenterY-(272*mW), hitRibbonWidth, 215*mW ) --260,215
    hitRibbon1:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon1.id = 1
    hitRibbon1:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon1 )

    local hitRibbon2 = display.newRect( display.contentCenterX, display.contentCenterY-(32*mW), hitRibbonWidth, 262*mW ) --500,262
    hitRibbon2:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon2.id = 2
    hitRibbon2:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon2 )

    local hitRibbon3 = display.newRect( display.contentCenterX, display.contentCenterY+(238*mW), hitRibbonWidth, 275*mW ) --770,275
    hitRibbon3:setFillColor( 0, 1, 1, 0.25 )
    hitRibbon3.id = 3
    hitRibbon3:addEventListener( "touch", scrollMe )
    sceneGroup:insert( hitRibbon3 )

    --[[
    hitRibbon1.isVisible = false
    hitRibbon2.isVisible = false
    hitRibbon3.isVisible = false
    hitRibbon1.isHitTestable = true
    hitRibbon2.isHitTestable = true
    hitRibbon3.isHitTestable = true
    ]]--

    -- hit ribbon blockers
    -- sometimes trying to use the lever or sign trigger a leg swipe, so we need to fake a larger no-swipe area.

    local function blockHits( event )
        -- no code, just prevent stuff under it from being triggered.
        return true
    end

    --[[
    local gearBlock = display.newRect( 0, display.contentHeight, 125*mW, 400*mW )
    gearBlock.anchorX = 0
    gearBlock.anchorY = 1
    if ( _myG.adsLoaded == "true" ) then
        gearBlock.y = display.contentHeight-(91*mW)
    end
    ]]--

    local signBlock = display.newRect( display.contentWidth, display.contentHeight, 250*mW, 200*mW )
    signBlock.anchorX = 1
    signBlock.anchorY = 1
    if ( _myG.adsLoaded == "true" ) then
        signBlock.y = display.contentHeight-(91*mW)
    end

    --sceneGroup:insert( gearBlock )
    sceneGroup:insert( signBlock )

    --gearBlock:addEventListener( "touch", blockHits )
    signBlock:addEventListener( "touch", blockHits )


    -- We render the background image after the hit area so it is stacked on top, hiding the hit area.
    
    _myG.background = display.newImageRect( "images/forest-bg.jpg", display.contentWidth, 1366*mW)
    _myG.background.x = display.contentCenterX
    _myG.background.y = display.contentCenterY
    sceneGroup:insert( _myG.background )

    --_myG.background.isVisible = false

    -- Cheering goblins

    local yayGoblin = {}

    local yaySheetInfo = require("yay-goblin-sheet")
    local yaySheet = graphics.newImageSheet( "images/yay-goblin-sheet.png", yaySheetInfo:getSheet() )
    local yayFrames = { start=1, count=5 }

    local yayHeadSequence =
    {
        { name="headShake", frames={ 3, 5, 3, 4 }, time=600, loopCount=0 }
    }

    local yayHead = display.newSprite( yaySheet, yayHeadSequence )
    yayHead.x = 0
    yayHead.y = 0

    local yayHead2 = display.newSprite( yaySheet, yayHeadSequence )
    yayHead2.x = 0
    yayHead2.y = 0

    local yayHead3 = display.newSprite( yaySheet, yayHeadSequence )
    yayHead3.x = 0
    yayHead3.y = 0

    local yayBody = display.newImage( yaySheet, 2 )
    yayBody.x = 10*mW
    yayBody.y = 150*mW

    local yayBody2 = display.newImage( yaySheet, 2 )
    yayBody2.x = 10*mW
    yayBody2.y = 150*mW

    local yayBody3 = display.newImage( yaySheet, 2 )
    yayBody3.x = 10*mW
    yayBody3.y = 150*mW

    local yayArmL  = display.newImage( yaySheet, 1 )
    yayArmL.anchorX = 1
    yayArmL.anchorY = 0
    -- middle
    yayArmL.rotation = 90
    yayArmL.x = -4*mW
    yayArmL.y = 116*mW
    -- up
    --yayArmL.rotation = 135
    --yayArmL.x = -40*mW
    --yayArmL.y = 116*mW
    -- down
    --yayArmL.rotation = 50
    --yayArmL.x = 20*mW
    --yayArmL.y = 110*mW

    local yayArmL2  = display.newImage( yaySheet, 1 )
    yayArmL2.rotation = 90
    yayArmL2.anchorX = 1
    yayArmL2.anchorY = 0
    yayArmL2.x = -4*mW
    yayArmL2.y = 116*mW

    local yayArmL3  = display.newImage( yaySheet, 1 )
    yayArmL3.rotation = 90
    yayArmL3.anchorX = 1
    yayArmL3.anchorY = 0
    yayArmL3.x = -4*mW
    yayArmL3.y = 116*mW

    local yayArmR  = display.newImage( yaySheet, 1 )
    yayArmR.xScale = -1 
    yayArmR.anchorX = 0
    yayArmR.anchorY = 0
    -- middle
    --yayArmR.rotation = -90
    --yayArmR.x = 10*mW
    --yayArmR.y = 50*mW
    -- up
    --yayArmR.rotation = -150
    --yayArmR.x = 10*mW
    --yayArmR.y = 70*mW
    -- down
    yayArmR.rotation = -45
    yayArmR.x = 30*mW
    yayArmR.y = 40*mW


    local yayArmR2  = display.newImage( yaySheet, 1 )
    yayArmR2.xScale = -1 
    yayArmR2.rotation = -90
    yayArmR2.anchorX = 0
    yayArmR2.anchorY = 0
    yayArmR2.x = 10*mW
    yayArmR2.y = 50*mW

    local yayArmR3  = display.newImage( yaySheet, 1 )
    yayArmR3.xScale = -1 
    yayArmR3.rotation = -90
    yayArmR3.anchorX = 0
    yayArmR3.anchorY = 0
    yayArmR3.x = 10*mW
    yayArmR3.y = 50*mW

    local yayGob1 = display.newGroup()
    yayGob1:insert( yayArmL )
    yayGob1:insert( yayArmR )
    yayGob1:insert( yayBody )
    yayGob1:insert( yayHead )
    yayGob1.x = 110*mW
    local yayGob1Y = cY-130*mW
    yayGob1.y = yayGob1Y
    yayGob1:scale( 0.65, 0.65 )
    yayGob1.rotation = 25

    local yayGob2 = display.newGroup()
    yayGob2:insert( yayArmL2 )
    yayGob2:insert( yayArmR2 )
    yayGob2:insert( yayBody2 )
    yayGob2:insert( yayHead2 )
    yayGob2.x = 600*mW
    local yayGob2Y = cY-120*mW
    yayGob2.y = yayGob2Y
    yayGob2.xScale = -1
    yayGob2:scale( 0.45, 0.45 )
    yayGob2.rotation = -30

    local yayGob3 = display.newGroup()
    yayGob3:insert( yayArmL3 )
    yayGob3:insert( yayArmR3 )
    yayGob3:insert( yayBody3 )
    yayGob3:insert( yayHead3 )
    yayGob3.x = 685*mW
    local yayGob3Y = cY-230*mW
    yayGob3.y = yayGob3Y
    yayGob3:scale( 0.65, 0.65 )
    yayGob3.rotation = -20

    sceneGroup:insert( yayGob1 )
    sceneGroup:insert( yayGob2 )
    sceneGroup:insert( yayGob3 )

    -- yay goblin animations

    local function armWave()
        -- left arm animations

        transition.to( yayArmL, { time=100, x=-40*mW, y=116*mW, rotation=135 })
        transition.to( yayArmL, { delay=100, time=100, x=-4*mW, y=116*mW, rotation=90 })
        transition.to( yayArmL, { delay=200, time=100, x=20*mW, y=110*mW, rotation=50 })
        transition.to( yayArmL, { delay=300, time=100, x=-4*mW, y=116*mW, rotation=90 })

        transition.to( yayArmL2, { time=100, x=-40*mW, y=116*mW, rotation=135 })
        transition.to( yayArmL2, { delay=100, time=100, x=-4*mW, y=116*mW, rotation=90 })
        transition.to( yayArmL2, { delay=200, time=100, x=20*mW, y=110*mW, rotation=50 })
        transition.to( yayArmL2, { delay=300, time=100, x=-4*mW, y=116*mW, rotation=90 })

        transition.to( yayArmL3, { time=100, x=-40*mW, y=116*mW, rotation=135 })
        transition.to( yayArmL3, { delay=100, time=100, x=-4*mW, y=116*mW, rotation=90 })
        transition.to( yayArmL3, { delay=200, time=100, x=20*mW, y=110*mW, rotation=50 })
        transition.to( yayArmL3, { delay=300, time=100, x=-4*mW, y=116*mW, rotation=90 })

        -- right arm animations

        transition.to( yayArmR, { time=100, x=30*mW, y=40*mW, rotation=-45 })
        transition.to( yayArmR, { delay=100, time=100, x=10*mW, y=50*mW, rotation=-90 })
        transition.to( yayArmR, { delay=200, time=100, x=10*mW, y=70*mW, rotation=-150 })
        transition.to( yayArmR, { delay=300, time=100, x=10*mW, y=50*mW, rotation=-90 })

        transition.to( yayArmR2, { time=100, x=30*mW, y=40*mW, rotation=-45 })
        transition.to( yayArmR2, { delay=100, time=100, x=10*mW, y=50*mW, rotation=-90 })
        transition.to( yayArmR2, { delay=200, time=100, x=10*mW, y=70*mW, rotation=-150 })
        transition.to( yayArmR2, { delay=300, time=100, x=10*mW, y=50*mW, rotation=-90 })

        transition.to( yayArmR3, { time=100, x=30*mW, y=40*mW, rotation=-45 })
        transition.to( yayArmR3, { delay=100, time=100, x=10*mW, y=50*mW, rotation=-90 })
        transition.to( yayArmR3, { delay=200, time=100, x=10*mW, y=70*mW, rotation=-150 })
        transition.to( yayArmR3, { delay=300, time=100, x=10*mW, y=50*mW, rotation=-90, onComplete=armWave })
    end

    -- set default hidden positions

    transition.to( yayGob1, { time=1, y=yayGob1Y+100*mW, alpha=0 })
    transition.to( yayGob2, { time=1, y=yayGob2Y+100*mW, alpha=0 })
    transition.to( yayGob3, { time=1, y=yayGob3Y+100*mW, alpha=0 })


    function _myG.yayGoblins( event )
        -- start loops

        yayHead:play()
        yayHead2:play()
        yayHead3:play()
        armWave()
        
        --pop up
        
        transition.to( yayGob1, { time=1, alpha=1 })
        transition.to( yayGob1, { delay=1, time=200, y=yayGob1Y-15*mW, transition=easing.outSine })
        transition.to( yayGob1, { delay=200, time=200, y=yayGob1Y, transition=easing.outSine })
        
        transition.to( yayGob2, { delay=50, time=1, alpha=1 })
        transition.to( yayGob2, { delay=51, time=200, y=yayGob2Y-15*mW, transition=easing.outSine })
        transition.to( yayGob2, { delay=250, time=200, y=yayGob2Y, transition=easing.outSine })
        
        transition.to( yayGob3, { time=1, alpha=1 })
        transition.to( yayGob3, { delay=1, time=200, y=yayGob3Y-15*mW, transition=easing.outSine })
        transition.to( yayGob3, { delay=200, time=200, y=yayGob3Y, transition=easing.outSine })
        
        -- back down
        
        local downDelay = 2000

        transition.to( yayGob1, { delay=downDelay, time=200, y=yayGob1Y-15*mW })
        transition.to( yayGob1, { delay=downDelay+200, time=200, y=yayGob1Y+100*mW })
        transition.to( yayGob1, { delay=downDelay+401, time=1, alpha=0 })
        
        transition.to( yayGob2, { delay=downDelay+50, time=200, y=yayGob2Y-15*mW })
        transition.to( yayGob2, { delay=downDelay+250, time=200, y=yayGob2Y+100*mW })
        transition.to( yayGob2, { delay=downDelay+451, time=1, alpha=0 })
    
        transition.to( yayGob3, { delay=downDelay, time=200, y=yayGob3Y-15*mW })
        transition.to( yayGob3, { delay=downDelay+200, time=200, y=yayGob3Y+100*mW })
        transition.to( yayGob3, { delay=downDelay+401, time=1, alpha=0 })

        return true
    end

    --local waveBtn = display.newText( "YAAAA!!!", display.contentCenterX, 150, native.systemFont, 50 ) 
    --waveBtn:addEventListener( "tap", _myG.yayGoblins )
    
    -- Extra bushes to hide cheering goblins at game end. 

    local bushLeft = display.newImageRect( "images/bush-left.png", 115*mW, 352*mW )
    bushLeft.anchorX = 0
    bushLeft.x = 0
    bushLeft.y = cY+38*mW

    local bushRight = display.newImageRect( "images/bush-right.png", 337*mW, 489*mW )
    bushRight.anchorX = 1
    bushRight.x = cW
    bushRight.y = cY+63*mW

    sceneGroup:insert( bushLeft )
    sceneGroup:insert( bushRight )
    
    --bushLeft.isVisible = false
    --bushRight.isVisible = false


    local uiShader = display.newImageRect( "images/ui-shader.png", display.contentWidth, 403*mW )
    uiShader.anchorY = 1
    uiShader.x = display.contentCenterX
    uiShader.y = cH
    sceneGroup:insert( uiShader )

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

    local headCount = 10
    local headSheetInfo = require("heads-sheet")
    local headSheet = graphics.newImageSheet( "images/heads.png", headSheetInfo:getSheet() )
    local headFrames = { start=1, count=headCount }

    local torsoCount = 6
    local torsoSheetInfo = require("torso-sheet-1")
    local torsoSheet = graphics.newImageSheet( "images/torso-1.png", torsoSheetInfo:getSheet() )
    local torsoFrames =  { start=1, count=torsoCount }

    local torso2Count = 4
    local torso2SheetInfo = require("torso-sheet-2")
    local torso2Sheet = graphics.newImageSheet( "images/torso-2.png", torso2SheetInfo:getSheet() )
    local torso2Frames =  { start=1, count=torso2Count }

    --[[
    local legCount = 6
    local legSheetInfo = require("legs-sheet-1")
    local legSheet = graphics.newImageSheet( "images/legs-1.png", legSheetInfo:getSheet() )
    local legFrames =  { start=1, count=legCount }

    local leg2Count = 4
    local leg2SheetInfo = require("legs-sheet-2")
    local leg2Sheet = graphics.newImageSheet( "images/legs-2.png", leg2SheetInfo:getSheet() )
    local leg2Frames =  { start=1, count=leg2Count }
    ]]--

    local legsSheetInfo = require("legs-sheet-1")
    local legsSheet = graphics.newImageSheet( "images/legs-1.png", legsSheetInfo:getSheet() )
    local legsFrames =  { start=1, count=7 }

    local legsSheetInfo2 = require("legs-sheet-2")
    local legsSheet2 = graphics.newImageSheet( "images/legs-2.png", legsSheetInfo2:getSheet() )
    local legsFrames2 =  { start=1, count=4 }

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
        headsA[i] = display.newSprite( headSheet, headFrames )
        headsA[i]:setFrame(i)
        headsA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5 
        blockGroupA[1]:insert( headsA[i] )
    end

    local headsB = {}
    for i=1, _myG.blockCount do
        --if ( i <= headCount ) then
            -- use the first head sprite sheet
            headsB[i] = display.newSprite( headSheet, headFrames )
            headsB[i]:setFrame(i)
            --[[
        else
            -- use the second head sprite sheet
            headsB[i] = display.newSprite( head2Sheet, head2Frames )
            headsB[i]:setFrame(i-headCount)
        end
        ]]--
        headsB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupB[1]:insert( headsB[i] )
    end

    local torsoA = {}
    for i=1, _myG.blockCount do
        if ( i <= torsoCount ) then
            torsoA[i] = display.newSprite( torsoSheet, torsoFrames )
            torsoA[i]:setFrame(i)
        else
            torsoA[i] = display.newSprite( torso2Sheet, torso2Frames )
            torsoA[i]:setFrame(i-torsoCount)
        end
        torsoA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupA[2]:insert( torsoA[i] )
    end

    local torsoB = {}
    for i=1, _myG.blockCount do
        if ( i <= torsoCount ) then
            torsoB[i] = display.newSprite( torsoSheet, torsoFrames )
            torsoB[i]:setFrame(i)
        else
            torsoB[i] = display.newSprite( torso2Sheet, torso2Frames )
            torsoB[i]:setFrame(i-torsoCount)
        end
        torsoB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupB[2]:insert( torsoB[i] )
    end

    --[[
    local legsA = {}
    for i=1, _myG.blockCount do
        if ( i <= legCount ) then
            legsA[i] = display.newSprite( legSheet, legFrames )
            legsA[i]:setFrame(i)
        else
            legsA[i] = display.newSprite( leg2Sheet, leg2Frames )
            legsA[i]:setFrame(i-legCount)
        end
        legsA[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupA[3]:insert( legsA[i] )
    end

    local legsB = {}
    for i=1, _myG.blockCount do
        if ( i <= legCount ) then
            legsB[i] = display.newSprite( legSheet, legFrames )
            legsB[i]:setFrame(i)
        else
            legsB[i] = display.newSprite( leg2Sheet, leg2Frames )
            legsB[i]:setFrame(i-legCount)
        end
        legsB[i].x = (( _myG.blockMargin + _myG.blockWidth ) * i) - _myG.blockWidth*0.5
        blockGroupB[3]:insert( legsB[i] )
    end
    ]]--

    local legsA = {}
    local legsB = {}
    local legCount = 10
    local legsI
    local blocksI

    -- Create our sprites and populate our tables

    local t = {}
    for i = 1, legCount do
        t[i] = i
    end

    for i = legCount, 2, -1 do -- backwards
        local r = math.random(i) -- select a random number between 1 and i
        t[i], t[r] = t[r], t[i] -- swap the randomly selected item to position i
    end

    for i=1, 2 do
        -- We need to run all this code twice to create duplicate groups for the purpose of allowing our ribbons to loop
        if i == 1 then
            legsI = legsA
        elseif i == 2 then
            legsI = legsB
        end

        -- total leg count will vary based on other game data like skill level, so we determine the array number incrementally
        -- if a leg is not included in a certain level, the incrementing will still allow the array to build out correctly

        -- legs-bermuda
        local tV = 1
        local tN = t[tV]

        legsI[tN] = display.newSprite( legsSheet, legsFrames )
        legsI[tN]:setFrame(1)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5           

        -- legs-buccaneer
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet, legsFrames )
        legsI[tN]:setFrame(2)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-dancer
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet, legsFrames )
        legsI[tN]:setFrame(3)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-prisoner
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet, legsFrames )
        legsI[tN]:setFrame(4)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-wizard - original (blue)
        local legsWizardBase = display.newSprite( legsSheet, legsFrames )
        legsWizardBase:setFrame(6)

        local legsWizardColor = display.newSprite( legsSheet, legsFrames )
        legsWizardColor:setFrame(5)

        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newGroup()
        legsI[tN]:insert( legsWizardColor )
        legsI[tN]:insert( legsWizardBase )
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-wizard - green
        local legsWizardBase2 = display.newSprite( legsSheet, legsFrames )
        legsWizardBase2:setFrame(6)

        local legsWizardColor2 = display.newSprite( legsSheet, legsFrames )
        legsWizardColor2:setFrame(5)
        legsWizardColor2:setFillColor( 0, 1, 0, 1 ) -- green

        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newGroup()
        legsI[tN]:insert( legsWizardColor2 )
        legsI[tN]:insert( legsWizardBase2 )
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-yeehaw
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet, legsFrames )
        legsI[tN]:setFrame(7)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-bigfoot
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet2, legsFrames2 )
        legsI[tN]:setFrame(1)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-kilt
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet2, legsFrames2 )
        legsI[tN]:setFrame(2)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        -- legs-knight
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet2, legsFrames2 )
        legsI[tN]:setFrame(3)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5

        --[[
        -- legs-traveler
        tV = tV+1; tN = t[tV]
        legsI[tN] = display.newSprite( legsSheet2, legsFrames2 )
        legsI[tN]:setFrame(4)
        legsI[tN].x = (( _myG.blockMargin + _myG.blockWidth ) * tN ) - _myG.blockWidth*0.5
        ]]--
    end

    -- Add shuffled legs to block group

    for i=1, legCount do
        blockGroupA[3]:insert( legsA[i] )
        blockGroupB[3]:insert( legsB[i] )
    end

    -- slider setup for first load

    function _myG.loadSlider()
        -- get random values for start position
        local random1 = math.random( 1, _myG.blockCount )
        local random2 = math.random( 1, _myG.blockCount )
        local random3 = math.random( 2, _myG.blockCount )
        -- set inital positions
        transition.to( _myG.ribbon[1], { time=0, x=blockEnd[random1] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[2], { time=0, x=blockEnd[random2] + _myG.blockWidth/2 + _myG.blockMargin } )
        transition.to( _myG.ribbon[3], { time=0, x=blockEnd[random3] + _myG.blockWidth/2 + _myG.blockMargin } )
        --fade in
        transition.to( _myG.ribbon[1], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[2], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[3], { time=600, alpha=1 } )
        -- set active block values based on post-animation start position
        _myG.ribbon[1].activeBlock = random1
        _myG.ribbon[2].activeBlock = random2
        _myG.ribbon[3].activeBlock = random3
        timer.performWithDelay( 700, _myG.startGamePlay )
    end


    -- COLOR EXPERIMENTS
    
    --[[
    headsA[1]:setFillColor( 1, 1, 0, 1 )
    headsB[1]:setFillColor( 1, 1, 0, 1 )

    headsA[2]:setFillColor( 1, 0, 1, 1 )
    headsB[2]:setFillColor( 1, 0, 1, 1 )

    legsA[5]:setFillColor( 1, 0, 1, 1 )
    legsB[5]:setFillColor( 1, 0, 1, 1 )
    ]]--

    --require( "body-builder" )

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
