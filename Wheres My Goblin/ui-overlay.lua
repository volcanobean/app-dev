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
    local arrowState = "down"
    local settingsActive = "true"

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

    -- Sound FX

    local leverFX = audio.loadSound( "audio/lever-pull.wav" )

    local function playLeverFX()
        audio.play( leverFX )
    end

    local bannerFX = audio.loadSound( "audio/banner.wav" )

    local function playBannerFX()
        audio.play( bannerFX )
    end

    -- Voices

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

    -- Settings sprites
    
    local settingsSheetInfo = require("settings-sheet")
    local settingsSheet = graphics.newImageSheet( "images/settings.png", settingsSheetInfo:getSheet() )
    local settingsFrames  = { start=1, count=5 }

    local settingsX = 665*mW

    local homeBtnY = 80*mW
    local replayBtnY = 208*mW
    local audioBtnY = 340*mW

    local arrowBtn = display.newSprite( settingsSheet, settingsFrames )
    arrowBtn:setFrame(2)
    arrowBtn.anchorY = 0 
    arrowBtn.x = settingsX
    arrowBtn.y = -44*mW
    
    local homeBtn = display.newSprite( settingsSheet, settingsFrames )
    homeBtn:setFrame(3)
    homeBtn.anchorY = 0 
    homeBtn.x = settingsX
    homeBtn.y = homeBtnY

    local replayBtn = display.newSprite( settingsSheet, settingsFrames )
    replayBtn:setFrame(4)
    replayBtn.anchorY = 0 
    replayBtn.x = settingsX
    replayBtn.y = replayBtnY

    local audioBtn = display.newSprite( settingsSheet, settingsFrames )
    audioBtn:setFrame(1)
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
        arrowBtn:setFrame(2)
    end

    local function arrowImageUp()
        arrowBtn:setFrame(5)
    end

    local function settingsOpen()
        settingsActiveFalse()
        transition.to( homeBtn, { time=1, time=1, alpha=1 })
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

    local function clickHome( event )
        if( settingsActive == "true" ) then
            composer.gotoScene( "start-screen" )
        end
        return true
    end

    local function clickReplay( event )
        if( settingsActive == "true" ) then
            composer.gotoScene( "replay" )
        end
        return true
    end

    local function clickAudio( event )
        if( settingsActive == "true" ) then
            --show audio settings
        end
        return true
    end

    arrowBtn:addEventListener( "tap", clickArrow )
    homeBtn:addEventListener( "tap", clickHome )
    replayBtn:addEventListener( "tap", clickReplay )
    audioBtn:addEventListener( "tap", clickAudio )

    -- Banner sprites

    local shader = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth+10, display.contentHeight+10 )
    -- can't start object with an alpha of 0 or corona will not render it
    -- also, transition values will be relative to intial value, so we start with 1 (100%)
    shader:setFillColor( 0, 0, 0, 1 ) 
    -- transition to alpha 0 to hide shader on page load
    transition.to( shader, { time=1, alpha=0 } )
    sceneGroup:insert( shader )

    local banner = display.newImageRect( "images/banner.png", 569*mW, 1050*mW) --scale up from 512

    -- Add goblin match pieces to banner

    local headMatch
    local headMatchSheetInfo
    local headMatchSheet
    local headMatchFrames

    local torsoMatch
    local torsoMatchSheetInfo
    local torsoMatchSheet
    local torsoMatchFrames

    local legMatch
    local legMatchSheetInfo
    local legMatchSheet
    local legMatchFrames

    local function getMatchParts()
        -- Generate head
        local matchNumber = math.random( _myG.blockCount )
        matchBlocks[1] = matchNumber
        if ( matchNumber <= 9 ) then
            -- if random number is within range of first sheet...
            headMatchSheetInfo = require("heads-sheet-1")
            headMatchSheet = graphics.newImageSheet( "images/heads-1.png", headMatchSheetInfo:getSheet() )
            headMatchFrames = { start=1, count=9 }
            headMatch = display.newSprite( headMatchSheet, headMatchFrames )
            headMatch:setFrame( matchNumber )
        else
            -- else use the second sheet tp pick up where we left off
            headMatchSheetInfo = require("heads-sheet-2")
            headMatchSheet = graphics.newImageSheet( "images/heads-2.png", headMatchSheetInfo:getSheet() )
            headMatchFrames = { start=1, count=1 }
            headMatch = display.newSprite( headMatchSheet, headMatchFrames )
            headMatch:setFrame( matchNumber-9 )
        end

        -- Generate torso
        matchNumber = math.random( _myG.blockCount )
        matchBlocks[2] = matchNumber
        if ( matchNumber <= 5 ) then
            -- if random number is within range of first sheet...
            torsoMatchSheetInfo = require("torso-sheet-1")
            torsoMatchSheet = graphics.newImageSheet( "images/torso-1.png", torsoMatchSheetInfo:getSheet() )
            torsoMatchFrames = { start=1, count=5 }
            torsoMatch = display.newSprite( torsoMatchSheet, torsoMatchFrames )
            torsoMatch:setFrame( matchNumber )
        else
            -- else use the second sheet tp pick up where we left off
            torsoMatchSheetInfo = require("torso-sheet-2")
            torsoMatchSheet = graphics.newImageSheet( "images/torso-2.png", torsoMatchSheetInfo:getSheet() )
            torsoMatchFrames = { start=1, count=5 }
            torsoMatch = display.newSprite( torsoMatchSheet, torsoMatchFrames )
            torsoMatch:setFrame( matchNumber-5 )
        end

        -- Generate legs
        matchNumber = math.random( _myG.blockCount )
        matchBlocks[3] = matchNumber
        if ( matchNumber <= 6 ) then
            -- if random number is within range of first sheet...
            legMatchSheetInfo = require("legs-sheet-1")
            legMatchSheet = graphics.newImageSheet( "images/legs-1.png", legMatchSheetInfo:getSheet() )
            legMatchFrames = { start=1, count=6 }
            legMatch = display.newSprite( legMatchSheet, legMatchFrames )
            legMatch:setFrame( matchNumber )
        else
            -- else use the second sheet tp pick up where we left off
            legMatchSheetInfo = require("legs-sheet-2")
            legMatchSheet = graphics.newImageSheet( "images/legs-2.png", legMatchSheetInfo:getSheet() )
            legMatchFrames = { start=1, count=4 }
            legMatch = display.newSprite( legMatchSheet, legMatchFrames )
            legMatch:setFrame( matchNumber-6 )
        end
    end

    -- generate intial values

    getMatchParts()

    -- assign Y values now that objects have been created

    headMatch.y = 385*mW
    torsoMatch.y = 695*mW
    legMatch.y = 850*mW

    local mScale = 0.83 

    local matchGroup = display.newGroup()
    matchGroup:insert( legMatch )
    matchGroup:insert( torsoMatch )
    matchGroup:insert( headMatch )
    matchGroup:scale( mScale, mScale )

    local bannerUpY
    local bannerDownY
    local bannerStretchY

    local bannerGroup = display.newGroup()
    bannerGroup:insert( banner )
    bannerGroup:insert( matchGroup )
    sceneGroup:insert( bannerGroup )

    if( screenRatio >= 0.7 ) then
        -- if our device has iPad-eque proportions
        bannerGroup.anchorY = 1
        banner.anchorY = 1
        matchGroup.y = -940*mW
        bannerUpY = 0 --0
        bannerDownY = cH*0.91 --440
        bannerStretchY = 50*mW
    elseif( screenRatio > 0.6 ) and ( screenRatio < 0.7 ) then
        -- if we're on shorter mobile devices
        bannerGroup.anchorY = 1
        banner.anchorY = 1
        matchGroup.y = -940*mW
        bannerUpY = 0 --0
        bannerDownY = cH*0.82 --440
        bannerStretchY = 50*mW
     else
        -- if we're on a taller thinner device
        bannerGroup.anchorY = 0
        banner.anchorY = 0
        matchGroup.y = 120*mW
        bannerUpY = -1050*mW
        bannerDownY = -50*mW
        bannerStretchY = 50*mW
    end

    bannerGroup.y = bannerUpY
    bannerGroup.x = display.contentCenterX
    -- set inital banner values
    transition.to( bannerGroup, { time=1, y=bannerUpY, yScale=0.5 })

    -- animate banner

    local function bannerPlayDown()
        bannerState = "down"
        print( bannerState )
        playBannerFX()
        transition.to( bannerGroup, { time=350, y=bannerDownY+bannerStretchY, yScale=1, transition=easing.outSine })
        transition.to( bannerGroup, { delay=350, time=200, y=bannerDownY, transition=easing.outSine })
        transition.to( shader, { time=300, alpha=0.5 } )
    end

    local function bannerPlayUp()
        bannerState = "up"
        print( bannerState ) 
        transition.to( bannerGroup, { time=400, y=bannerUpY, yScale=0.5, transition=easing.outSine })
        transition.to( shader, { time=300, alpha=0 } )
    end

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
            transition.to( gearHandle, { time=700, rotation=100, transition=easing.outSine } )
            playLeverFX()
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
                timer.performWithDelay( 700, bannerPlayDown )
                timer.performWithDelay( 1400, audioWheresMyGoblin )
            else
                timer.performWithDelay( 700, compareGoblins )
            end
            bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
        end
        return true
    end

    function _myG.startGamePlay()
        _myG.introComplete = "true"
        _myG.uiActive = "true"
        settingsActive = "true"
        _myG.activeRibbonsText.text = "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
    end

    -- event listeners

    gearSprite:addEventListener( "tap", turnCrank )
    gearHandle:addEventListener( "tap", turnCrank )
    shader:addEventListener( "tap", raiseBannerNow )


    -- INTRO ANIMATION:

    uiActiveTrue() -- temporarily true to allow first animation
    crankTimer = timer.performWithDelay( 800, turnCrank )

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
