---------------------------------------------------------------------------------
--
-- gameplay.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY
local mW = 0.0013020833*cW
local screenRatio = cW/cH
print ("screenRatio " .. screenRatio)

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
-- any reference created in scene:create will not be available in scene:hide, show, etc
-- unless it is first defined as a forward reference here

local bannerStayTimer
local crankTimer

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

    _myG.introComplete = "false"
    local bannerState = "up"
    local signState = "goblin"

    --local debug

    local goblinText = display.newText( "", display.contentCenterX, 985, native.systemFont, 30 )  
    local activeText = display.newText( "UI Active: " .. _myG.uiActive, display.contentCenterX, 950, native.systemFont, 30 ) 

    local matchBlocksText = display.newText( "Match these: " .. matchBlocks[1] .. ", " .. matchBlocks[2] .. ", " .. matchBlocks[3], display.contentCenterX, 20, native.systemFont, 30 )
    _myG.activeRibbonsText = display.newText( "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock, display.contentCenterX, 60, native.systemFont, 30 )

    sceneGroup:insert( goblinText )
    sceneGroup:insert( activeText )
    sceneGroup:insert( matchBlocksText )
    sceneGroup:insert( _myG.activeRibbonsText )

    goblinText.isVisible = false
    activeText.isVisible = false
    matchBlocksText.isVisible = false
    _myG.activeRibbonsText.isVisible = false

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

    local mySound = audio.loadSound( "audio/wmg-mason-01.wav" )

    local function stopAudio()
        goblinText.text = ""
    end

    local function audioWheresMyGoblin()
        goblinText.text = "Where's my goblin?" 
        -- Play sound
        audio.play( mySound )
        timer.performWithDelay( 2000, stopAudio )
    end

    local function audioThatsMyGoblin()
        goblinText.text = "That's my goblin!" 
        --audio.play( mySound )
        timer.performWithDelay( 2000, stopAudio )
    end

    local function audioNotMyGoblin()
        goblinText.text = "That's not my goblin." 
        --audio.play( mySound )
        timer.performWithDelay( 2000, stopAudio )
    end

    -- Banner sprites

    local shader = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth+10, display.contentHeight+10 )
    -- can't start object with an alpha of 0 or corona will not render it
    -- also, transition values will be relative to intial value, so we start with 1 (100%)
    shader:setFillColor( 0, 0, 0, 1 ) 
    -- transition to alpha 0 to hide shader on page load
    transition.to( shader, { time=1, alpha=0 } )
    sceneGroup:insert( shader )
    
    local bannerUpY
    local bannerDownY

    local banner = display.newImageRect( "images/banner.png", 569*mW, 1050*mW) --scale up from 512
    
    if( screenRatio >= 0.7 ) then 
        banner.anchorY = 1
        -- if our device has iPad-eque proportions
        bannerUpY = 0
        bannerDownY = cH*0.92 --440
    else
        banner.anchorY = 0
        -- if we're on a taller thinner device
        bannerUpY = -1050*mW
        bannerDownY = 0
    end

    banner.x = display.contentCenterX
    banner.y = bannerUpY
    sceneGroup:insert( banner )

    -- Add goblin match pieces to banner

    local mScale = 0.83 -- single variable to scale all goblin banner parts larger or smaller

    local headMatchCount = 5
    -- instead of loading the original heads-sheet.lua file, load a duplicate with scaled values
    local headMatchSheetInfo = require("heads-sheet-1") 
    local headMatchSheet = graphics.newImageSheet( "images/heads-1.png", headMatchSheetInfo:getSheet() )
    local headMatchFrames = { start=1, count=_myG.blockCount }
    local headMatch = display.newSprite( headMatchSheet, headMatchFrames )
    --headMatch = display.newImageRect( headMatchSheet, 1, _myG.blockWidth*mScale, _myG.blockHeight2*mScale )
    headMatch.x = display.contentCenterX
    headMatch.y = 0 --380

    local torsoMatchCount = 5
    local torsoMatchSheet = graphics.newImageSheet( "images/torso-sheet.png", { width=_myG.blockWidth*mScale, height=_myG.blockHeight2*mScale, numFrames=torsoMatchCount, sheetContentWidth=_myG.blockWidth*mScale, sheetContentHeight=_myG.blockHeight2*torsoMatchCount*mScale } )
    local torsoMatchFrames = { start=1, count=_myG.blockCount }
    local torsoMatch = display.newSprite( torsoMatchSheet, torsoMatchFrames )
    torsoMatch.x = display.contentCenterX
    torsoMatch.y = 0 --690

    local legMatchCount = 5
    local legMatchSheet = graphics.newImageSheet( "images/legs-sheet.png", { width=_myG.blockWidth*mScale, height=_myG.blockHeight3*mScale, numFrames=legMatchCount, sheetContentWidth=_myG.blockWidth*mScale, sheetContentHeight=_myG.blockHeight3*legMatchCount*mScale } )
    local legMatchFrames = { start=1, count=_myG.blockCount }
    local legMatch = display.newSprite( legMatchSheet, legMatchFrames )
    legMatch.x = display.contentCenterX
    legMatch.y = 0 --845

    local matchGroup = display.newGroup()
    matchGroup:insert( legMatch )
    matchGroup:insert( torsoMatch )
    matchGroup:insert( headMatch )
    matchGroup.y = 0
    matchGroup:scale( mScale, mScale )
    sceneGroup:insert( matchGroup )

    -- animate banner

    local function bannerPlayDown()
        bannerState = "down"
        print( bannerState ) 
        transition.to( banner, { time=500, y=bannerDownY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0.5 } )
    end

    local function bannerPlayUp()
        bannerState = "up"
        print( bannerState ) 
        transition.to( banner, { time=500, y=bannerUpY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0 } )
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

    -- back to home

    local function returnHome( event )
        composer.gotoScene( "start-screen" )
        return true
    end

    local homeButton = display.newText( "<- HOME", 100, 50, native.systemFont, 30 )
    homeButton:addEventListener( "tap", returnHome )
    sceneGroup:insert( homeButton )

    -- gear sprite

    local gearSequence =
    {
        { name="forward", frames={ 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 3, 4, 4, 1 }, time=700, loopCount=1 },
        { name="backward", frames={ 1, 4, 3, 2, 1, 4, 3, 2, 1, 4, 3, 3, 2, 2, 1 }, time=700, loopCount=1 }
    }

    local gearSheetInfo = require("gear-sheet")
    local gearSheet = graphics.newImageSheet( "images/gear-sheet.png", gearSheetInfo:getSheet() )
    
    local gearHandle = display.newImage( gearSheet, 5 )
    gearHandle.x = 70*mW
    gearHandle.y = display.contentHeight-(91*mW)
    gearHandle.anchorY = 1
    sceneGroup:insert( gearHandle )

    local function handlePlay( seqVar )
        if seqVar == "down" then
            transition.to( gearHandle, { time=400, rotation=100, transition=easing.outSine } )
        elseif seqVar == "up" then
            transition.to( gearHandle, { time=400, rotation=0, transition=easing.outSine } )
        end
    end

    local gearSprite = display.newSprite( gearSheet, gearSequence )
    gearSprite.anchorX = 0
    gearSprite.anchorY = 1
    gearSprite.x = 0
    gearSprite.y = cH
    gearSprite:setFrame(1) -- 1 refers to the first frame in the sequence (6), not the frame number
    sceneGroup:insert( gearSprite )

    local function gearForward()
        gearSprite:setSequence( "forward" )
        gearSprite:play()
    end

    local function gearBackward()
        gearSprite:setSequence( "backward" )
        gearSprite:play()
    end

    -- sign sprite

    local signSequence =
    {
        { name="spin", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 },
        { name="spinToCheck", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 4, 5, 1, 2, 2, 1 }, time=500, loopCount=1 },
        { name="spinToX", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 15, 16, 12, 13, 13, 12 }, time=500, loopCount=1 },
        { name="spinFromCheck", frames={ 1, 2, 3, 11, 4, 5, 1, 2, 3, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 },
        { name="spinFromX", frames={ 12, 13, 14, 11, 15, 16, 12, 13, 14, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 }
    }

    local signSheetInfo = require("sign-sheet")
    local signSheet = graphics.newImageSheet( "images/sign-sheet.png", signSheetInfo:getSheet() )
    local signSprite = display.newSprite( signSheet, signSequence )
    signSprite.anchorY = 1
    signSprite.x = 654*mW
    signSprite.y = cH 
    signSprite:setFrame(1) -- 1 refers to the first frame in the sequence (6), not the frame number
    sceneGroup:insert( signSprite )

    local function signSpin()
        signSprite:setSequence( "spin" )
        signSprite:play()
    end

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

    -- vicotry animation

    local function playVictoryScene()
        print ( "Victory!" )
    end

    -- Sign animation and match checking

    local function compareGoblins()
        print "compareGoblins"
        --_myG.activeRibbonsText.text = "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
        -- if user successfully has a match
        if matchBlocks[1] == _myG.ribbon[1].activeBlock and matchBlocks[2] == _myG.ribbon[2].activeBlock and matchBlocks[3] == _myG.ribbon[3].activeBlock then
            signSpinToCheck()
            signState = "check"
            timer.performWithDelay( 700, audioThatsMyGoblin )
            -- replace below with victory animation
            --timer.performWithDelay( 3000, signSpinFromCheck )
            --timer.performWithDelay( 3500, uiActiveTrue )
            playVictoryScene()
        else
            signSpinToX()
            signState = "x"
            bannerPlayDown()
            timer.performWithDelay( 700, audioNotMyGoblin )
        end
    end

    -- animation functions

    local function raiseBanner()
        print ( "raiseBanner" )
        handlePlay( "up" )
        gearBackward()
        bannerPlayUp()
        print( "raiseBanner uiActive: " .. _myG.uiActive )
        if ( _myG.introComplete == "false" ) then
            _myG.loadSlider()
        elseif ( signState == "x" ) then
            signSpinFromX()
            timer.performWithDelay( 500, uiActiveTrue )
        end
    end

    local function raiseBannerNow( event )
        print( "raiseBannerNow" )
        timer.cancel( bannerStayTimer )
        raiseBanner()
        print( "raiseBannerNow uiActive: " .. _myG.uiActive )
        return true
    end

    local function turnCrank( event )
        print ( "turnCrank" )
        if ( bannerState == "down" ) then
            raiseBannerNow()
        end
        if ( _myG.uiActive == "true" ) then
            uiActiveFalse()
            handlePlay( "down" )
            gearForward()
            if ( _myG.introComplete == "false" ) then
                timer.performWithDelay( 600, bannerPlayDown )
                timer.performWithDelay( 1400, audioWheresMyGoblin )
            else
                timer.performWithDelay( 300, compareGoblins )
            end
            bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
        end
        return true
    end

    function _myG.startGamePlay()
        _myG.introComplete = "true"
        _myG.uiActive = "true"
        _myG.activeRibbonsText.text = "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
    end

    -- event listeners

    gearSprite:addEventListener( "tap", turnCrank )
    gearHandle:addEventListener( "tap", turnCrank )
    shader:addEventListener( "tap", raiseBannerNow )


    -- INTRO ANIMATION:

    uiActiveTrue() -- temporarily true to allow first animation
    randomizeMatch()
    crankTimer = timer.performWithDelay( 600, turnCrank )

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

        timer.cancel( bannerStayTimer )
        timer.cancel( crankTimer )

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
