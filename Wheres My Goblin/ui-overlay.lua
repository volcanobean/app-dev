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

    -- Create table to hold data for goblin match

    local matchBlocks = {}
    matchBlocks[1] = 1
    matchBlocks[2] = 1
    matchBlocks[3] = 1

    local introComplete = "false"
    local bannerTimer

    --local debug

    local goblinText = display.newText( "", display.contentCenterX, 985, native.systemFont, 30 )  
    local activeText = display.newText( "UI Active: " .. _myG.uiActive, display.contentCenterX, 950, native.systemFont, 30 ) 

    local matchBlocksText = display.newText( "Match these: " .. matchBlocks[1] .. ", " .. matchBlocks[2] .. ", " .. matchBlocks[3], display.contentCenterX, 20, native.systemFont, 30 )
    local activeRibbonsText = display.newText( "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock, display.contentCenterX, 60, native.systemFont, 30 )

    -- UI on/off functions

    local function uiActiveFalse()
        _myG.uiActive = "false"
        activeText.text = "UI Active: " .. _myG.uiActive
    end

    local function uiActiveTrue()
        _myG.uiActive = "true"
        activeText.text = "UI Active: " .. _myG.uiActive
    end

    -- Audio

    -- temp function for debuggin, sans actual audio

    local mySound = media.newEventSound( "audio/wmg-mason-01.wav" )

    local function stopAudio()
        goblinText.text = ""
    end

    local function audioWheresMyGoblin()
        goblinText.text = "Where's my goblin?" 
        -- Play sound
        media.playEventSound( mySound )
        timer.performWithDelay( 2000, stopAudio )
    end

    local function audioThatsMyGoblin()
        goblinText.text = "That's my goblin!" 
        timer.performWithDelay( 2000, stopAudio )
    end

    local function audioNotMyGoblin()
        goblinText.text = "That's not my goblin." 
        timer.performWithDelay( 2000, stopAudio )
    end

    -- Banner sprites

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

    local banner = display.newImageRect( "images/banner-512w.png", 569, 1004 ) -- PoT - upscaling smaller 512w image to 569w
    banner.x = display.contentWidth*0.5
    banner.y = bannerUpY

    -- Add goblin match pieces to banner

    local mScale = 0.83 -- single variable to scale all goblin banner parts larger or smaller

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

    -- animate banner

    local function uiActiveCheck()
        --[[if introComplete == "true" then
            _myG.uiActive = "true"
        else
            -- cue up next part of intro
            --timer.performWithDelay( 600, sliderIntro )
        end]]--
        uiActiveTrue()
    end

    local function bannerPlayDown()
        transition.to( banner, { time=500, y=bannerDownY, transition=easing.outSine } )
        transition.to( matchBlocksGroup, { time=500, y=matchDownY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0.5 } )
    end

    local function bannerPlayUp()
        transition.to( banner, { time=500, y=bannerUpY, transition=easing.outSine } )
        transition.to( matchBlocksGroup, { time=500, y=matchUpY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0, onComplete=uiActiveCheck } )
    end

    -- Randomize functions

    local function randomizeMatch()  
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

        matchBlocksText.text = "Match these: " .. matchBlocks[1] .. ", " .. matchBlocks[2] .. ", " .. matchBlocks[3]
    end

    local randomizeBtn = display.newText( "--RANDOMIZE--", display.contentCenterX, 100, native.systemFont, 30 )
    randomizeBtn:addEventListener( "tap", randomizeMatch )
    sceneGroup:insert( randomizeBtn )

    -- gear sprite

    local gearSequence =
    {
        { name="forward", frames={ 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 3, 4, 4, 1 }, time=600, loopCount=1 },
        { name="backward", frames={ 1, 4, 3, 2, 1, 4, 3, 2, 1, 4, 3, 3, 2, 2, 1 }, time=600, loopCount=1 }
    }

    local gearSheetInfo = require("gear-sheet")
    local gearSheet = graphics.newImageSheet( "images/gear-sheet.png", gearSheetInfo:getSheet() )
    
    local gearHandle = display.newImage( gearSheet, 5 )
    gearHandle.x = 70
    gearHandle.y = 933
    gearHandle.anchorY = 1
    sceneGroup:insert( gearHandle )

    local function handlePlay( seqVar )
        if seqVar == "down" then
            transition.to( gearHandle, { time=400, rotation=90, transition=easing.outSine } )
        elseif seqVar == "up" then
            transition.to( gearHandle, { time=400, rotation=0, transition=easing.outSine } )
        end
    end

    local gearSprite = display.newSprite( gearSheet, gearSequence )
    gearSprite.x = 85
    gearSprite.y = 940
    gearSprite:setFrame(1) -- 1 refers to the first frame in the sequence (6), not the frame number
    sceneGroup:insert( gearSprite )

    local function gearPlay( seqVar )
        gearSprite:setSequence( seqVar )
        gearSprite:play()
    end

    -- sign sprite

    local signSequence =
    {
        { name="spinToCheck", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 4, 5, 1, 2, 2, 1 }, time=500, loopCount=1 },
        { name="spinToX", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 15, 16, 12, 13, 13, 12 }, time=500, loopCount=1 },
        { name="spinFromCheck", frames={ 1, 2, 3, 11, 4, 5, 1, 2, 3, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 },
        { name="spinFromX", frames={ 12, 13, 14, 11, 15, 16, 12, 13, 14, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 }
    }

    local signSheetInfo = require("sign-sheet")
    local signSheet = graphics.newImageSheet( "images/sign-sheet.png", signSheetInfo:getSheet() )
    local signSprite = display.newSprite( signSheet, signSequence )
    signSprite.x = 654
    signSprite.y = 931
    signSprite:setFrame(1) -- 1 refers to the first frame in the sequence, not the frame number
    sceneGroup:insert( signSprite )

    local function signSpinToCheck()
        signSprite:setSequence( "spinToCheck" )
        signSprite:play()
    end

    local function signSpinFromCheck()
        signSprite:setSequence( "spinFromCheck" )
        signSprite:play()
    end

    local function signSpinToX()
        signSprite:setSequence( "spinToX" )
        signSprite:play()
    end

    local function signSpinFromX()
        signSprite:setSequence( "spinFromX" )
        signSprite:play()
    end

    -- make slider visible, for use after intro compeletes

    local function showGoblinSlider()
        _myG.ribbon[1].isVisible = true
        _myG.ribbon[2].isVisible = true
        _myG.ribbon[3].isVisible = true
        _myG.randomizeBlocks()
        introComplete = "true"
    end

    -- animation functions

    local function raiseBanner()
        handlePlay( "up" )
        gearPlay( "backward" )
        bannerPlayUp()
        print ("raiseBanner uiActive: " .. _myG.uiActive )
        if ( introComplete == "false") then
            timer.performWithDelay( 600, showGoblinSlider )
        end
    end

    local function lowerBanner( event )
        if _myG.uiActive == "true" then
            uiActiveFalse()
            handlePlay( "down" )
            gearPlay( "forward" )
            timer.performWithDelay( 600, bannerPlayDown )
            timer.performWithDelay( 1400, audioWheresMyGoblin ) 
            bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
        end
        return true
    end

    local function raiseBannerNow( event )
        timer.cancel( bannerStayTimer )
        raiseBanner()
        print ("raiseBannerNow uiActive: " .. _myG.uiActive )
        return true
    end

    -- Sign animation and match checking

    local function compareGoblins( event )
        if( _myG.uiActive == "true" ) then
            uiActiveFalse()
            print "Checking goblins"
            activeRibbonsText.text = "activeRibbons: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
            -- if user successfully has a match
            if ( matchBlocks[1] == _myG.ribbon[1].activeBlock ) and ( matchBlocks[2] == _myG.ribbon[2].activeBlock ) and  ( matchBlocks[3] == _myG.ribbon[3].activeBlock ) then
                signSpinToCheck()
                timer.performWithDelay( 700, audioThatsMyGoblin )
                -- replace below with victory animation
                timer.performWithDelay( 3000, signSpinFromCheck )
                timer.performWithDelay( 3500, uiActiveTrue )
            else
                signSpinToX()
                timer.performWithDelay( 700, audioNotMyGoblin )
                timer.performWithDelay( 3000, signSpinFromX )
                timer.performWithDelay( 3500, uiActiveTrue )
            end
        end
        return true
    end

    -- event listeners

    gearSprite:addEventListener( "tap", lowerBanner )
    gearHandle:addEventListener( "tap", lowerBanner )
    shader:addEventListener( "tap", raiseBannerNow )
    signSprite:addEventListener( "tap", compareGoblins )

    -- on first scene load, play banner animation
    -- temporarily true to allow first animation

    uiActiveTrue() 

    -- Generate random goblin values on first scene load

    randomizeMatch()

    timer.performWithDelay( 400, lowerBanner )

--end scene:create
end 

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.
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
