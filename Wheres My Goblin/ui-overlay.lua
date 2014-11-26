---------------------------------------------------------------------------------
--
-- gameplay.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here


-- -------------------------------------------------------------------------------


-- "scene:create()"
-- Initialize the scene here.

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    -- Randomize function

    local matchBlocks = {}
    matchBlocks[1] = 1
    matchBlocks[2] = 1
    matchBlocks[3] = 1

    local signState = "goblin"
    --local audioTimer

    local goblinText = display.newText( "", display.contentCenterX, 975, native.systemFont, 30 )  
    local activeRibbonsText = display.newText( "activeRibbons: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock, display.contentCenterX, 120, native.systemFont, 30 )
    local matchBlocksText = display.newText( "Head: " .. matchBlocks[1] .. ", Body: " .. matchBlocks[2] .. ", Legs: " .. matchBlocks[3], display.contentCenterX, 30, native.systemFont, 30 )

    -- Audio

    -- temp function for debuggin, sans actual audio
    --[[
    local function stopAudio()
        print "audio stop"
        goblinText.text = "" 
    end

    local function playAudio( audioVar )
        print "audio start"
        if ( audioVar == "wheresMyGoblin" ) then
            goblinText.text = "Where's my goblin?"
        elseif ( audioVar == "myGoblin" ) then
            goblinText.text = "That's my goblin!" 
        elseif ( audioVar == "notMyGoblin" ) then
            goblinText.text = "That's not my goblin." 
        end
        timer.performWithDelay( 1200, stopAudio )
    end
  ]]--

    local shader = display.newRect( display.contentWidth*0.5, display.contentHeight*0.5, display.contentWidth, display.contentHeight )
    -- can't start object with an alpha of 0 or corona will not render it
    -- also, transition values will be relative to intial value, so we start with 1 (100%)
    shader:setFillColor( 0, 0, 0, 1 ) 
    -- transition to alpha 0 to hide shader on page load
    transition.to( shader, { time=1, alpha=0 } )
    
    local bannerUpY = -500
    local bannerDownY = 425
    local matchUpY = -925
    local matchDownY = 0

    local banner = display.newImageRect( "images/banner-512w.png", 569, 1004 ) -- PoT - upscaling smaller 512w to 569w
    banner.x = display.contentWidth*0.5
    banner.y = bannerUpY

    -- Generate Goblins parts for banner

    local mScale = 0.83

    local headMatchCount = _myG.blockCount
    local headMatchSheet = graphics.newImageSheet( "images/head-sheet.png", { width=_myG.blockWidth*mScale, height=_myG.blockHeight1*mScale, numFrames=headMatchCount, sheetContentWidth=_myG.blockWidth*mScale, sheetContentHeight=_myG.blockHeight1*headMatchCount*mScale } )
    local headMatchFrames = { start=1, count=_myG.blockCount }
    local headMatch = display.newSprite( headMatchSheet, headMatchFrames )
    headMatch.x = display.contentCenterX
    headMatch.y = 380*mScale

    local torsoMatchCount = _myG.blockCount
    local torsoMatchSheet = graphics.newImageSheet( "images/torso-sheet.png", { width=_myG.blockWidth*mScale, height=_myG.blockHeight2*mScale, numFrames=torsoMatchCount, sheetContentWidth=_myG.blockWidth*mScale, sheetContentHeight=_myG.blockHeight2*torsoMatchCount*mScale } )
    local torsoMatchFrames = { start=1, count=_myG.blockCount }
    local torsoMatch = display.newSprite( torsoMatchSheet, torsoMatchFrames )
    torsoMatch.x = display.contentCenterX
    torsoMatch.y = 690*mScale

    local legMatchCount = _myG.blockCount
    local legMatchSheet = graphics.newImageSheet( "images/legs-sheet.png", { width=_myG.blockWidth*mScale, height=_myG.blockHeight3*mScale, numFrames=legMatchCount, sheetContentWidth=_myG.blockWidth*mScale, sheetContentHeight=_myG.blockHeight3*legMatchCount*mScale } )
    local legMatchFrames = { start=1, count=_myG.blockCount }
    local legMatch = display.newSprite( legMatchSheet, legMatchFrames )
    legMatch.x = display.contentCenterX
    legMatch.y = 845*mScale

    local matchBlocksGroup = display.newGroup()
    matchBlocksGroup:insert( legMatch )
    matchBlocksGroup:insert( torsoMatch )
    matchBlocksGroup:insert( headMatch )
    matchBlocksGroup.y = matchUpY

    local function randomizeBlocks()  
        print ( "Function start." )
        -- Generate head
        local randomNum = math.random( _myG.blockCount )
        print( randomNum )
        matchBlocks[1] = randomNum
        headMatch:setFrame( randomNum )
        
        -- Generate torso
        randomNum = math.random( _myG.blockCount )
        print( randomNum )
        matchBlocks[2] = randomNum
        torsoMatch:setFrame( randomNum )

        -- Generate legs
        randomNum = math.random( _myG.blockCount )
        print( randomNum )
        matchBlocks[3] = randomNum
        legMatch:setFrame( randomNum )

        matchBlocksText.text = "Head: " .. matchBlocks[1] .. ", Body: " .. matchBlocks[2] .. ", Legs: " .. matchBlocks[3]
    end

    -- Generate missing goblin

    local randomizeBtn = display.newText( "--RANDOMIZE--", display.contentCenterX, 75, native.systemFont, 30 )
    randomizeBtn:addEventListener( "tap", randomizeBlocks )
    sceneGroup:insert( randomizeBtn )
    -- Generate random goblin values on first scene load
    randomizeBlocks()

    -- Load UI and goblin banner

    -- Sprite data

    local sequenceData =
    {
        { name="spinToCheck", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 4, 5, 1, 2, 2, 1 }, time=500, loopCount=1 },
        { name="spinToX", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 15, 16, 12, 13, 13, 12 }, time=500, loopCount=1 },
        { name="spinFromCheck", frames={ 1, 2, 3, 11, 4, 5, 1, 2, 3, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 },
        { name="spinFromX", frames={ 12, 13, 14, 11, 15, 16, 12, 13, 14, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 }
    
    }

    local sheetInfo = require("sign-sheet")
    local myImageSheet = graphics.newImageSheet( "images/sign-sheet.png", sheetInfo:getSheet() )
    local signSprite = display.newSprite( myImageSheet, sequenceData )
    signSprite.x = 654
    signSprite.y = 931
    signSprite:setFrame(1) -- 1 refers to the first frame in the sequence (6), not the frame number
    sceneGroup:insert( signSprite )

    -- Show goblins after first load

    local function showGoblinSlider()
        _myG.ribbon[1].isVisible = true
        _myG.ribbon[2].isVisible = true
        _myG.ribbon[3].isVisible = true
    end

    -- Banner animations

    local function bannerDown()
        _myG.moveAllowed = "false"
        transition.to( banner, { time=500, y=bannerDownY, transition=easing.outSine } )
        transition.to( matchBlocksGroup, { time=500, y=matchDownY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0.5 } )
        --timer.performWithDelay( 4000, playAudio( "wheresMyGoblin" ) )
    end

    local function bannerUp( event )
        _myG.moveAllowed = "true"
        transition.to( banner, { time=500, y=bannerUpY, transition=easing.outSine } )
        transition.to( matchBlocksGroup, { time=500, y=matchUpY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0 } )
        if (signState == "X") then
            signSprite:setSequence( "spinFromX" )
            signSprite:play()
            signState = "goblin"
        end
        showGoblinSlider()
        return true
    end

    local posterDrop = display.newRect( 75, 950, 150, 150 )
    posterDrop:setFillColor( 1, 1, 1, 1 )
    posterDrop:addEventListener( "tap", bannerDown )

    shader:addEventListener( "tap", bannerUp )

    local function compareGoblins( event )
        --_myG.moveAllowed = "false"
        print "Checking goblins"
        activeRibbonsText.text = "activeRibbons: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
        -- if user has a match
        if ( matchBlocks[1] == _myG.ribbon[1].activeBlock ) and ( matchBlocks[2] == _myG.ribbon[2].activeBlock ) and  ( matchBlocks[3] == _myG.ribbon[3].activeBlock ) then
            signSprite:setSequence( "spinToCheck" )
        else
            signState = "X"
            signSprite:setSequence( "spinToX" )
            -- bannerDown commands but with delay. refactor?
            --timer.performWithDelay( 1000, bannerDown )
        end
        signSprite:play()
        return true
    end

    signSprite:addEventListener( "tap", compareGoblins )

    -- Show goblin to be match on first load.

    bannerDown()

--end scene:create
end 

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.

        --TO DO. Why can't I call functions here?
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
