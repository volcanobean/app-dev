---------------------------------------------------------------------------------
-- goblin-slider.lua
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

if( _myG.difficulty == "easy" ) then
    _myG.blockCount = 10
elseif( _myG.difficulty == "medium" ) then
    _myG.blockCount = 10
elseif( _myG.difficulty == "hard" ) then
    _myG.blockCount = 10
end

_myG.blockWidth = 512*mW
_myG.blockMargin = 120*mW

_myG.blockHeight1 = 312*mW
_myG.blockHeight2 = 540*mW
_myG.blockHeight3 = 396*mW

_myG.ribbonY1 = display.contentCenterY-(287*mW) --225
_myG.ribbonY2 = display.contentCenterY+(8*mW) --520
_myG.ribbonY3 = display.contentCenterY+(178*mW) --690

local randomizeHeads
local randomizeTorso
local randomizeLegs

local matchGroup = display.newGroup()

---------------------------------------------------------------------------------
-- SCENE:CREATE
---------------------------------------------------------------------------------

-- debug

--local adDebug = display.newText( "Create: " .. _myG.adsHeight, display.contentCenterX, 50, native.systemFont, 30 )
--adDebug.text = "Show: " .. _myG.adsHeight

function scene:create( event )
    local sceneGroup = self.view

    -- create ribbon table/array for storage of ribbon pieces/variables later in this file
    -- This table is in my globals so it can be accessed by other scenes

    _myG.ribbon = {}
    _myG.matchBlocks = {}

    local ribbonX = (display.contentWidth - _myG.blockWidth)*0.5 - _myG.blockMargin
    local ribbonStartX = ribbonX -- store starting X value for future reference

    local blockRegion = "center"
    local activeRibbon = 1
    local activeBlockSnap = ribbonX
    --local activeBlockText = display.newText( "ARibbon: " .. activeRibbon .. ", ABlock: 1, Region: " .. blockRegion, display.contentCenterX, 50, native.systemFont, 30 )
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

    local blockTouch
    local blockRelease

    -- Create swipe variables

    local startX = 0
    local endX = 0
    local startTime
    local endTime

    local nextBlockSnap = 0

    local moveAllowed = "true"
    local arrowState = "down"
    local settingsActive = "true"

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
            --activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
        
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
            --activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion

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
            --activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
        end
        --print ( _myG.ribbon[activeRibbon].activeBlock )
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
                groupSwap( activeRibbon )
                getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
                blockTouch = _myG.ribbon[activeRibbon].activeBlock
                print( "blockTouch: " ..blockTouch)

            end

        -- ON MOVE:
        elseif ( event.target.isFocus ) then
            if ( event.phase == "moved" ) then
                endX = event.x
                local difX = endX - startX
                
            -- ON RELEASE: 
            elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                -- remove button focus once finger is lifted from screen
                display.getCurrentStage():setFocus( nil )
                event.target.isFocus = false

                endTime = event.time
                local totalTime = endTime - startTime

                -- if not in the middle of a previous swipe/drag
                if ( _myG.uiActive == "true" )  and ( moveAllowed == "true" ) then

                    nextBlockSnap = blockTouch + 1
                    --getActiveBlock( _myG.ribbon[activeRibbon].x, activeRibbon )
                    blockRelease = _myG.ribbon[activeRibbon].activeBlock
                    print( "blockRelease: " ..blockRelease)

                    -- TAP or SWIPE RIGHT:
                    if ( totalTime < 400 and startX == endX ) or ( totalTime < 200 and endX > startX ) then
                        print("swipe right")
                        nextBlockSnap = blockTouch - 1
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
                            transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- play sound fx
                            playSwipeFX()
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
                        end

                    -- SWIPE LEFT:
                    elseif ( totalTime < 200 ) and ( endX < startX ) then
                    print("swipe left")
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
                            transition.to( _myG.ribbon[activeRibbon], { time=300 ,transition=easing.outSine, x=blockSnap[nextBlockSnap], onStart=moveStart, onComplete=moveEnd } )
                            -- play sound fx
                            playSwipeFX()
                            -- Make sure active block is updated since the scroll is moving without the user touch to track last X position
                            _myG.ribbon[activeRibbon].activeBlock = nextBlockSnap
                            -- debug
                            -- activeBlockText.text = "ARibbon: " .. activeRibbon .. ", ABlock: " .. _myG.ribbon[activeRibbon].activeBlock .. ", Region: " .. blockRegion
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

    local hitRibbonWidth = 325*mW

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

    local signBlock = display.newRect( display.contentWidth, display.contentHeight, 250*mW, 200*mW )
    signBlock.anchorX = 1
    signBlock.anchorY = 1
    if ( _myG.adsLoaded == "true" ) then
        signBlock.y = display.contentHeight-(91*mW)
    end

    sceneGroup:insert( signBlock )

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

    --local waveBtC = display.newText( "YAAAA!!!", display.contentCenterX, 150, native.systemFont, 50 ) 
    --waveBtC:addEventListener( "tap", _myG.yayGoblins )
    
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

-- ----------------------------------------------------------------
-- RIBBONS
-- ----------------------------------------------------------------

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

-- ----------------------------------------------------------------
-- HEADS
-- ----------------------------------------------------------------

    local headsSheetInfo = require("heads-sheet")
    local headsSheet = graphics.newImageSheet( "images/heads.png", headsSheetInfo:getSheet() )
    local headsFrames = { start=1, count=10 }

    local headsArray
    local headsA = {}
    local headsB = {}
    _myG.headsMatch = {}

    -- Array to generate 1-10 digits for randomization
        
    local t1 = {}
    for i = 1, _myG.blockCount do
        t1[i] = i
    end

    function randomizeHeads()

        -- Randomize array for use in shuffling the order of leg sprites as they are generated.
        
        for i = _myG.blockCount, 2, -1 do -- backwards
            local r1 = math.random(i) -- select a random number between 1 and i
            t1[i], t1[r1] = t1[r1], t1[i] -- swap the randomly selected item to position i
        end

        -- Generate leg sprites.
        -- We need to run all this code twice to create duplicate groups for the purpose of allowing our ribbons to loop
            
        for i=1, 3 do
            if i == 1 then
                headsArray = headsA
            elseif i == 2 then
                headsArray = headsB
            elseif i == 3 then
                headsArray = _myG.headsMatch
            end

            -- total part count will vary based on difficulty level, so we determine the array number incrementally

            -- head-cheshire
            local tCount = 1
            local tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(1)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5           
            end
            
            -- head-classic
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(2)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-fool
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(3)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-gentleman
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(4)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-goggles
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(5)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-grump
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(6)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-helmet
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(7)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-hood
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(8)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-skicap
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(9)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- head-tongue
            tCount = tCount+1; tC = t1[tCount]
            headsArray[tC] = display.newSprite( headsSheet, headsFrames )
            headsArray[tC]:setFrame(10)
            if( i ~= 3 ) then
                headsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- include bonus parts based on difficulty level

            --if ( _myG.difficulty ~= "easy" ) then
                -- parts here
            --end

            -- if ( _myG.difficulty == "hard" ) then
                --parts here
            --end

        end

        -- Add shuffled legs to block group

        for i=1, _myG.blockCount do
            blockGroupA[1]:insert( headsA[i] )
            blockGroupB[1]:insert( headsB[i] )
            matchGroup:insert( _myG.headsMatch[i] )
        end



    end -- end randomize function

-- ----------------------------------------------------------------
-- TORSO
-- ----------------------------------------------------------------

    local torsoSheetInfo = require("torso-sheet-1")
    local torsoSheet = graphics.newImageSheet( "images/torso-1.png", torsoSheetInfo:getSheet() )
    local torsoFrames =  { start=1, count=6 }

    local torsoSheetInfo2 = require("torso-sheet-2")
    local torsoSheet2 = graphics.newImageSheet( "images/torso-2.png", torsoSheetInfo2:getSheet() )
    local torsoFrames2 =  { start=1, count=4 }

    local torsoArray
    local torsoA = {}
    local torsoB = {}
    _myG.torsoMatch = {}

    -- Array to generate 1-10 digits for randomization
    
    local t2 = {}
    for i = 1, _myG.blockCount do
        t2[i] = i
    end

    function randomizeTorso()

        -- Randomize array for use in shuffling the order of leg sprites as they are generated.
        
        for i = _myG.blockCount, 2, -1 do -- backwards
            local r2 = math.random(i) -- select a random number between 1 and i
            t2[i], t2[r2] = t2[r2], t2[i] -- swap the randomly selected item to position i
        end

        -- Generate leg sprites.
        -- We need to run all this code twice to create duplicate groups for the purpose of allowing our ribbons to loop
            
        for i=1, 3 do
            if i == 1 then
                torsoArray = torsoA
            elseif i == 2 then
                torsoArray = torsoB
            elseif i == 3 then
                torsoArray = _myG.torsoMatch
            end

            -- total part count will vary based on difficulty level, so we determine the array number incrementally

            -- torso-chef
            local tCount = 1
            local tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(1)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5           
            end

            -- torso-druid
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(2)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- torso-hoodie
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(3)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-loon
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(4)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-suit
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(5)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-traveler
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet, torsoFrames )
            torsoArray[tC]:setFrame(6)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-bomb
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet2, torsoFrames2 )
            torsoArray[tC]:setFrame(1)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-knight
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet2, torsoFrames2 )
            torsoArray[tC]:setFrame(2)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-napolean
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet2, torsoFrames2 )
            torsoArray[tC]:setFrame(3)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

           -- torso-sweater
            tCount = tCount+1; tC = t2[tCount]
            torsoArray[tC] = display.newSprite( torsoSheet2, torsoFrames2 )
            torsoArray[tC]:setFrame(4)
            if( i ~= 3 ) then
                torsoArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- include bonus parts based on difficulty level

            --if ( _myG.difficulty ~= "easy" ) then
                -- parts here
            --end

            -- if ( _myG.difficulty == "hard" ) then
                --parts here
            --end

        end

        -- Add shuffled legs to block group

        for i=1, _myG.blockCount do
            blockGroupA[2]:insert( torsoA[i] )
            blockGroupB[2]:insert( torsoB[i] )
            matchGroup:insert( _myG.torsoMatch[i] )
        end

    end -- end randomize function

-- ----------------------------------------------------------------
-- LEGS
-- ----------------------------------------------------------------

    local legsSheetInfo = require("legs-sheet-1")
    local legsSheet = graphics.newImageSheet( "images/legs-1.png", legsSheetInfo:getSheet() )
    local legsFrames =  { start=1, count=7 }

    local legsSheetInfo2 = require("legs-sheet-2")
    local legsSheet2 = graphics.newImageSheet( "images/legs-2.png", legsSheetInfo2:getSheet() )
    local legsFrames2 =  { start=1, count=4 }

    local legsArray
    local legsA = {}
    local legsB = {}
    _myG.legsMatch = {}

    -- Array to generate 1-10 digits for randomization
    
    local t3 = {}
    for i = 1, _myG.blockCount do
        t3[i] = i
    end

    function randomizeLegs()

        -- Randomize array for use in shuffling the order of leg sprites as they are generated.
        
        for i = _myG.blockCount, 2, -1 do -- backwards
            local r3 = math.random(i) -- select a random number between 1 and i
            t3[i], t3[r3] = t3[r3], t3[i] -- swap the randomly selected item to position i
        end

        -- Generate leg sprites.
        -- We need to run all this code twice to create duplicate groups for the purpose of allowing our ribbons to loop
            
        for i=1, 3 do
            if i == 1 then
                legsArray = legsA
            elseif i == 2 then
                legsArray = legsB
            elseif i == 3 then
                legsArray = _myG.legsMatch
            end

            -- total part count will vary based on difficulty level, so we determine the array number incrementally

            -- legs-bermuda
            local tCount = 1
            local tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet, legsFrames )
            legsArray[tC]:setFrame(1)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5           
            end

            -- legs-buccaneer
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet, legsFrames )
            legsArray[tC]:setFrame(2)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-dancer
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet, legsFrames )
            legsArray[tC]:setFrame(3)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-prisoner
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet, legsFrames )
            legsArray[tC]:setFrame(4)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-wizard - original (blue)
            local legsWizardBase = display.newSprite( legsSheet, legsFrames )
            legsWizardBase:setFrame(6)

            local legsWizardColor = display.newSprite( legsSheet, legsFrames )
            legsWizardColor:setFrame(5)

            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newGroup()
            legsArray[tC]:insert( legsWizardColor )
            legsArray[tC]:insert( legsWizardBase )
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-yeehaw
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet, legsFrames )
            legsArray[tC]:setFrame(7)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-bigfoot
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet2, legsFrames2 )
            legsArray[tC]:setFrame(1)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-kilt
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet2, legsFrames2 )
            legsArray[tC]:setFrame(2)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-knight
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet2, legsFrames2 )
            legsArray[tC]:setFrame(3)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- legs-traveler
            tCount = tCount+1; tC = t3[tCount]
            legsArray[tC] = display.newSprite( legsSheet2, legsFrames2 )
            legsArray[tC]:setFrame(4)
            if( i ~= 3 ) then
                legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
            end

            -- include bonus parts based on difficulty level

            --[[
            if ( _myG.difficulty ~= "easy" ) then
                
                -- legs-wizard - green
                local legsWizardBase2 = display.newSprite( legsSheet, legsFrames )
                legsWizardBase2:setFrame(6)

                local legsWizardColor2 = display.newSprite( legsSheet, legsFrames )
                legsWizardColor2:setFrame(5)
                legsWizardColor2:setFillColor( 0, 1, 0, 1 ) -- green

                tCount = tCount+1; tC = t3[tCount]
                legsArray[tC] = display.newGroup()
                legsArray[tC]:insert( legsWizardColor2 )
                legsArray[tC]:insert( legsWizardBase2 )
                if( i ~= 3 ) then
                    legsArray[tC].x = (( _myG.blockMargin + _myG.blockWidth ) * tC ) - _myG.blockWidth*0.5
                end

            end
            ]]--

            -- if ( _myG.difficulty == "hard" ) then
                --parts here
            --end

        end

        -- Add shuffled legs to block group

        for i=1, _myG.blockCount do
            blockGroupA[3]:insert( legsA[i] )
            blockGroupB[3]:insert( legsB[i] )
            matchGroup:insert( _myG.legsMatch[i] )
        end  

        sceneGroup:insert( matchGroup )      

    end -- end randomize function

    -- slider setup for first load

    function _myG.loadSlider()
        transition.to( _myG.ribbon[1], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[2], { time=600, alpha=1 } )
        transition.to( _myG.ribbon[3], { time=600, alpha=1 } )
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

-- ----------------------------------------------------------------
-- SETTINGS
-- ----------------------------------------------------------------   

    -- Settings sprites
    
    local settingsSheetInfo = require("settings-sheet")
    local settingsSheet = graphics.newImageSheet( "images/settings.png", settingsSheetInfo:getSheet() )
    local settingsFrames  = { start=1, count=7 }

    local settingsX = 665*mW

    local homeBtnY = 40*mW
    local replayBtnY = 168*mW
    local audioBtnY = 300*mW

    local arrowBtn = display.newSprite( settingsSheet, settingsFrames )
    arrowBtn:setFrame(3)
    arrowBtn.anchorY = 0 
    arrowBtn.x = settingsX
    arrowBtn.y = -44*mW
    
    local homeBtn = display.newSprite( settingsSheet, settingsFrames )
    homeBtn:setFrame(4)
    homeBtn.anchorY = 0 
    homeBtn.x = settingsX
    homeBtn.y = homeBtnY

    local replayBtn = display.newSprite( settingsSheet, settingsFrames )
    replayBtn:setFrame(6)
    replayBtn.anchorY = 0 
    replayBtn.x = settingsX
    replayBtn.y = replayBtnY

    local audioBtn = display.newSprite( settingsSheet, settingsFrames )
    audioBtn:setFrame(2)
    audioBtn.anchorY = 0 
    audioBtn.x = settingsX
    audioBtn.y = audioBtnY

    audioBtn.yScale=0.25
    audioBtn.alpha=0
    replayBtn.yScale=0.5
    replayBtn.alpha=0
    homeBtn.yScale=0.5
    homeBtn.alpha=0

    sceneGroup:insert( audioBtn )
    sceneGroup:insert( replayBtn )
    sceneGroup:insert( homeBtn  )
    sceneGroup:insert( arrowBtn )

    -- settings-related functions
    
    local function settingsActiveTrue()
        settingsActive = "true"
        print ("settingsActive: " .. settingsActive)
    end 

    local function settingsActiveFalse()
        settingsActive = "false"
        print ("settingsActive: " .. settingsActive)
    end 

    local function arrowImageDown()
        arrowBtn:setFrame(3)
    end

    local function arrowImageUp()
        arrowBtn:setFrame(7)
    end

    local function settingsOpen()
        settingsActiveFalse()
        transition.to( homeBtn, { time=1, alpha=1 })
        transition.to( homeBtn, { delay=1, time=150, y=homeBtnY+48*mW, yScale=1, transition=easing.outSine })
        transition.to( homeBtn, { delay=150, time=150, y=homeBtnY, transition=easing.outSine })
        transition.to( replayBtn, { delay=250, time=1, alpha=1 })
        transition.to( replayBtn, { delay=250, time=150, y=replayBtnY+50*mW, yScale=1, transition=easing.outSine })
        transition.to( replayBtn, { delay=400, time=150, y=replayBtnY, transition=easing.outSine })
        transition.to( audioBtn, { delay=500, time=1, alpha=1 })
        transition.to( audioBtn, { delay=500, time=150, y=audioBtnY+50*mW, yScale=1, transition=easing.outSine })
        transition.to( audioBtn, { delay=650, time=150, y=audioBtnY, transition=easing.outSine })
        timer.performWithDelay( 700, arrowImageUp )
        timer.performWithDelay( 700, settingsActiveTrue )
    end

    local function settingsClose()
        settingsActiveFalse()
        transition.to( audioBtn, { time=100, yScale=0.25, transition=easing.outSine })
        transition.to( audioBtn, { delay=100, time=1, alpha=0 })
        transition.to( replayBtn, { delay=100, time=75, yScale=0.5, transition=easing.outSine  })
        transition.to( replayBtn, { delay=175, time=1, alpha=0 })
        transition.to( homeBtn, { delay=175, time=60, yScale=0.5, transition=easing.outSine  })
        transition.to( homeBtn, { delay=235, time=1, alpha=0 })
        timer.performWithDelay( 235, arrowImageDown )
        timer.performWithDelay( 235, settingsActiveTrue )
    end

    local function clickArrow( event )
        if( settingsActive == "true" ) then
            if( arrowState == "up" ) then
                arrowState = "down"
                settingsClose()
            elseif( arrowState == "down") then
                arrowState = "up"
                settingsOpen()
            end
        end
        return true
    end

        -- scene outro

    local function gotoHome( event )
        composer.removeScene( "goblin-slider" )
        composer.gotoScene( "start-screen" )
        return true
    end

    local function gotoReplay( event )
        composer.removeScene( "goblin-slider" )
        composer.gotoScene( "goblin-slider" )
        return true
    end

    function _myG.clickHome( event )
        if( settingsActive == "true" ) then
            transition.to( _myG.blackFader, { time=400, alpha=1 })
            timer.performWithDelay( 600, gotoHome )
        end
        return true
    end

    function _myG.clickReplay( event )
        if( settingsActive == "true" ) then
            _myG.fromReplay = "true"
            print( "Replay: " .. _myG.fromReplay)
            transition.to( _myG.blackFader, { time=400, alpha=1 })
            timer.performWithDelay( 600, gotoReplay )
        end
        return true
    end

    local function clickAudio( event )
        if( settingsActive == "true" ) then
            --show audio settings
            if( _myG.audioOn == "true" ) then
                audioBtn:setFrame(5)
                _myG.audioOn = "false"
                audio.stop()
            elseif( _myG.audioOn == "false" ) then
                audioBtn:setFrame(2)
                _myG.audioOn = "true"
            end
        end
        return true
    end

    arrowBtn:addEventListener( "touch", clickArrow )
    homeBtn:addEventListener( "tap", _myG.clickHome )
    replayBtn:addEventListener( "tap", _myG.clickReplay )
    audioBtn:addEventListener( "tap", clickAudio )

    -- ad space
    local adBg = display.newRect( cX, cH, display.contentWidth, 90*mW )
    adBg:setFillColor( 0, 0, 0, 1 )
    adBg.anchorY = 1
    sceneGroup:insert( adBg ) 


end --end scene:create

---------------------------------------------------------------------------------
-- SCENE:SHOW
---------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view
    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- Hide the goblin slider on initial game load.
        _myG.ribbon[1].alpha=0
        _myG.ribbon[2].alpha=0
        _myG.ribbon[3].alpha=0

        matchGroup.alpha=0

        randomizeHeads()
        randomizeTorso()
        randomizeLegs()

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen

        -- Load Goblin banner and UI 
        composer.showOverlay( "ui-overlay" )
        print( "calling overlay" )

        -- activeBlock always starts at 1

        _myG.ribbon[1].activeBlock = 1
        _myG.ribbon[2].activeBlock = 1
        _myG.ribbon[3].activeBlock = 1

    end
end

---------------------------------------------------------------------------------
-- SCENE:HIDE
---------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------
-- SCENE:DESTROY
---------------------------------------------------------------------------------

function scene:destroy( event )
    local sceneGroup = self.view
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------
-- Listener setup
---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
