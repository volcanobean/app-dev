---------------------------------------------------------------------------------
-- gameplay.lua
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY
local mW = 0.0013022*cW
local screenRatio = cW/cH
print ("screenRatio " .. screenRatio)

local bannerStayTimer
local crankTimer
local signTimer
local uiActiveTrue
local turnCrank
local uiShader2

local signSprite
local signIsUp
local replayShader
local replaySign
local replayYesBtn
local replayNoBtn
local bannerGroup
local replayShade2

local bannerUpY
local bannerDownY
local bannerStretchY
local getMatchParts

local notGobPlayed = "false"

---------------------------------------------------------------------------------
-- SCENE:CREATE - Initialize the scene here.
---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    local startX
    local endX
    local startY
    local endY
    local startTime
    local endTime
    local totalTime = 0

    local gameStartTime = 0
    local gameEndTime = 0
    local gameTimeDif = 0
    local totalPeeks = 0
    local peeksPar
    local timePar

    if( _myG.difficulty == "medium" ) then
        peeksPar = 2
        timePar = 2400
    elseif( _myG.difficulty == "hard" ) then
        peeksPar = 1
        timePar = 1900
    end

    -- Create table to hold data for goblin match

    local matchBlocks = {}
    matchBlocks[1] = 1
    matchBlocks[2] = 1
    matchBlocks[3] = 1
    _myG.headsMatch.activeBlock = 1
    _myG.torsoMatch.activeBlock = 1
    _myG.legsMatch.activeBlock = 1

    _myG.introComplete = "false"
    local bannerState = "up"
    local handleState = "up"
    local signState = "goblin"
    local arrowState = "down"
    local settingsActive = "true"

    --local debug

    local goblinText = display.newText( "", display.contentCenterX, 985, native.systemFont, 30 )  
    local activeText = display.newText( "UI Active: " .. _myG.uiActive, display.contentCenterX, 950, native.systemFont, 30 ) 

    local matchBlocksText = display.newText( "Match these: " .. _myG.headsMatch.activeBlock .. ", " .. _myG.torsoMatch.activeBlock .. ", " .. _myG.legsMatch.activeBlock, display.contentCenterX, 20, native.systemFont, 30 )
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

    function uiActiveTrue()
        _myG.uiActive = "true"
        activeText.text = "UI Active: " .. _myG.uiActive
    end

    -- Audio

    -- Sound FX

    local leverFX = audio.loadSound( "audio/lever-pull.wav" )

    local function playLeverFX()
        if ( _myG.audioOn == "true" ) then
            audio.play( leverFX )
        end
    end

    local leverShortFX = audio.loadSound( "audio/lever-short.wav" )

    local function playLeverShortFX()
        if( _myG.audioOn == "true" ) then
            audio.play( leverShortFX )
        end
    end

    local bannerFX = audio.loadSound( "audio/banner-short.wav" )

    local function playBannerFX()
        if( _myG.audioOn == "true" ) then
            audio.play( bannerFX )
        end
    end

    local wrongFX = audio.loadSound( "audio/wrong-answer.wav" )

    local function playWrongAnswerFX()
        if( _myG.audioOn == "true" ) then
            audio.play( wrongFX )
        end
    end

    -- Voices

    local whereGoblin = audio.loadSound( "audio/mason-where-goblin.wav" )
    local notGoblin = audio.loadSound( "audio/mason-not-my-goblin.wav" )
    local thatGoblin = audio.loadSound( "audio/mason-thats-my-goblin.wav" )
    local yayGoblin = audio.loadSound( "audio/yays.wav" )

    local function stopAudio()
        goblinText.text = ""
    end

    local function audioWheresMyGoblin()
        goblinText.text = "Where's my goblin?" 
        -- Play sound
        if( _myG.audioOn == "true" ) then
            audio.play( whereGoblin )
        end
        --timer.performWithDelay( 2000, stopAudio )
    end

    local function audioThatsMyGoblin()
        goblinText.text = "That's my goblin!" 
        if( _myG.audioOn == "true" ) then
            audio.play( thatGoblin )
        end
        --timer.performWithDelay( 2000, stopAudio )
    end

    local function audioNotMyGoblin()
        goblinText.text = "That's not my goblin." 
        if( _myG.audioOn == "true" ) and ( notGobPlayed == "false") then
            audio.play( notGoblin )
            notGobPlayed = "true"
        end
        --timer.performWithDelay( 2000, stopAudio )
    end

    local function audioYay()
        goblinText.text = "Yay!" 
        if( _myG.audioOn == "true" ) then
            audio.play( yayGoblin )
        end
        --timer.performWithDelay( 2000, stopAudio )
    end

    local uiShader1 = display.newImageRect( "images/ui-shader-1.png", 385*mW, 399*mW )
    uiShader1.anchorX = 0
    uiShader1.anchorY = 1
    uiShader1.x = 0
    uiShader1.y = cH
    sceneGroup:insert( uiShader1 )

    uiShader2 = display.newImageRect( "images/ui-shader-2.png", 384*mW, 295*mW )
    uiShader2.anchorX = 1
    uiShader2.anchorY = 1
    uiShader2.x = cW
    uiShader2.y = cH
    sceneGroup:insert( uiShader2 )

    -- Settings sprites
    
    local settingsSheetInfo = require("settings-sheet")
    local settingsSheet = graphics.newImageSheet( "images/settings.png", settingsSheetInfo:getSheet() )
    local settingsFrames  = { start=1, count=6 }

    local settingsX = 665*mW

    local homeBtnY = 40*mW
    local replayBtnY = 168*mW
    local audioBtnY = 300*mW

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
    replayBtn:setFrame(5)
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
        arrowBtn:setFrame(6)
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

    local function clickHome( event )
        if( settingsActive == "true" ) then
            composer.removeScene( "goblin-slider" )
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
            if( _myG.audioOn == "true" ) then
                audioBtn:setFrame(4)
                _myG.audioOn = "false"
                audio.stop()
            elseif( _myG.audioOn == "false" ) then
                audioBtn:setFrame(1)
                _myG.audioOn = "true"
            end
        end
        return true
    end

    arrowBtn:addEventListener( "touch", clickArrow )
    homeBtn:addEventListener( "tap", clickHome )
    replayBtn:addEventListener( "tap", clickReplay )
    audioBtn:addEventListener( "tap", clickAudio )

    -- handle block

    local gearBlock = display.newRect( 0, display.contentHeight, 125*mW, 400*mW )
    gearBlock.anchorX = 0
    gearBlock.anchorY = 1
    if ( _myG.adsLoaded == "true" ) then
        gearBlock.y = display.contentHeight-(91*mW)
    end

    gearBlock.isVisible = false
    gearBlock.isHitTestable = true

    sceneGroup:insert( gearBlock ) 

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

    local matchGroup = display.newGroup()

    function getMatchParts()

        -- LEGS
        local r1 = math.random( _myG.blockCount )
        _myG.legsMatch.activeBlock = r1
        for i=1, _myG.blockCount do
            _myG.legsMatch[i].isVisible = false
        end
        _myG.legsMatch[r1].isVisible = true
        matchGroup:insert( _myG.legsMatch[r1] )

        -- TORSO
        local r2 = math.random( _myG.blockCount )
        _myG.torsoMatch.activeBlock = r2
        for i=1, _myG.blockCount do
            _myG.torsoMatch[i].isVisible = false
        end
        _myG.torsoMatch[r2].isVisible = true
        matchGroup:insert( _myG.torsoMatch[r2] )

        -- HEAD
        local r3 = math.random( _myG.blockCount )
        _myG.headsMatch.activeBlock = r3
        for i=1, _myG.blockCount do
            _myG.headsMatch[i].isVisible = false
        end
        _myG.headsMatch[r3].isVisible = true
        matchGroup:insert( _myG.headsMatch[r3] )

        -- assign Y values now that objects have been created

        _myG.headsMatch[r3].y = 385*mW
        _myG.torsoMatch[r2].y = 675*mW
        _myG.legsMatch[r1].y = 850*mW

        -- debug
        matchBlocksText.text = "Match these: " .. _myG.headsMatch.activeBlock .. ", " .. _myG.torsoMatch.activeBlock .. ", " .. _myG.legsMatch.activeBlock
    end

    -- generate intial values

    --getMatchParts()

    local mScale = 0.83 
    matchGroup:scale( mScale, mScale )

    bannerGroup = display.newGroup()
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
        print( "more than 0.7")
    elseif( screenRatio > 0.6 ) and ( screenRatio < 0.7 ) then
        -- if we're on shorter mobile devices
        bannerGroup.anchorY = 1
        banner.anchorY = 1
        matchGroup.y = -940*mW
        bannerUpY = 0 --0
        bannerDownY = cH*0.82 --440
        bannerStretchY = 50*mW
        print( "between 0.6 and 0.7")
        print( bannerDownY )
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

    -- animate banner

    local function bannerStateDown()
        bannerState = "down"
        print( "bannerState down")
    end

    local function bannerStateUp()
        bannerState = "up"
        print( "bannerState up")
    end

    local function bannerPlayDown()
        if ( bannerState == "up" ) then
            print( bannerState )
            --bannerStateDown()
            playBannerFX()
            transition.to( bannerGroup, { time=350, y=bannerDownY+bannerStretchY, yScale=1, transition=easing.outSine })
            transition.to( bannerGroup, { delay=350, time=200, y=bannerDownY, transition=easing.outSine })
            transition.to( shader, { time=300, alpha=0.5 } )
            timer.performWithDelay( 300, bannerStateDown )
        end
    end

    local function bannerPlayUp()
        if ( bannerState == "down" ) then
            print( bannerState )
            playBannerFX()
            transition.to( bannerGroup, { time=400, y=bannerUpY, yScale=0.5, transition=easing.outSine })
            transition.to( shader, { time=300, alpha=0 } )
            timer.performWithDelay( 400, bannerStateUp )
        end
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
    local gearHandleY = display.contentHeight-(91*mW)
    gearHandle.y = gearHandleY
    gearHandle.anchorY = 1
    sceneGroup:insert( gearHandle )

    local function handleStateDown()
        handleState = "down"
        print( "handleState down")
    end

    local function handleStateUp()
        handleState = "up"
        print( "handleState up")
    end

    local function handlePlay( seqVar )
        if seqVar == "down" then
            transition.to( gearHandle, { time=700, rotation=100, transition=easing.outSine } )
            timer.performWithDelay( 700, handleStateDown )
            playLeverFX()
        elseif seqVar == "up" then
            transition.to( gearHandle, { time=400, rotation=0, transition=easing.outSine } )
            playLeverShortFX()
            timer.performWithDelay( 500, handleStateUp )
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
    signSprite = display.newSprite( signSheet, signSequence )
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
        signState = "check"
    end

    local function signSpinFromCheck()
        signSprite:setSequence( "spinFromCheck" )
        signSprite:play()
        signState = "goblin"
    end

    local function signSpinToX()
        signSprite:setSequence( "spinToX" )
        signSprite:play()
        signState = "x"
    end

    local function signSpinFromX()
        signSprite:setSequence( "spinFromX" )
        signSprite:play()
        signState = "goblin"
    end

    -- replay sign sprites

    replayShader = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth+10, display.contentHeight+10 )
    replayShader:setFillColor( 0, 0, 0, 1 ) 
    sceneGroup:insert( replayShader )

    replayShade2 = display.newImageRect( sceneGroup, "images/replay-shader.png", cW, 510*mW )
    replayShade2.x = cX
    replayShade2.y = cY+130*mW

    local replaySheetInfo = require("replay-sheet")
    local replaySheet = graphics.newImageSheet( "images/replay-sheet.png", replaySheetInfo:getSheet() )
    local replayFrames  = { start=1, count=3 }

    replayYesBtn = display.newSprite( replaySheet, replayFrames )
    replayYesBtn:setFrame(3)
    replayYesBtn.anchorY = 0 
    replayYesBtn.x = 285*mW
    
    replayNoBtn = display.newSprite( replaySheet, replayFrames )
    replayNoBtn:setFrame(1)
    replayNoBtn.anchorY = 0 
    replayNoBtn.x = 490*mW

    replayYesBtn:addEventListener( "tap", clickReplay )
    replayNoBtn:addEventListener( "tap", clickHome )

    local replayPaper = display.newSprite( replaySheet, replayFrames )
    replayPaper:setFrame(2)
    replayPaper.height = 303*mW
    replayPaper.width =  568*mW
    replayPaper.anchorY = 0 
    replayPaper.x = cX
    replayPaper.y = cY-275*mW

    -- rope sprites

    local ropeSheetInfo = require("ropes-sheet")
    local ropeSheet = graphics.newImageSheet( "images/ropes.png", ropeSheetInfo:getSheet() )
    local ropeFrames  = { start=1, count=2 }

    local ropeL = display.newSprite( ropeSheet, ropeFrames )
    ropeL:setFrame(1)
    ropeL.anchorY = 1 
    ropeL.x = 255*mW
    ropeL.y = cY-233*mW
    
    local ropeR = display.newSprite( ropeSheet, ropeFrames )
    ropeR:setFrame(2)
    ropeR.anchorY = 1
    ropeR.x = 512*mW
    ropeR.y = cY-229*mW

    local replayText = display.newText( "play again?", display.contentCenterX+15*mW, cY-180*mW, "Mathlete-Skinny", 120*mW )
    replayText:setFillColor( 74/255, 54/255, 22/255, 1)

    local statsTextY = cY-80*mW
    local statsTextSize = 70*mW

    local peeksLabel = display.newText( "peeks:", display.contentCenterX-55*mW, statsTextY, "Mathlete-Skinny", statsTextSize )
    peeksLabel:setFillColor( 74/255, 54/255, 22/255, 1)
    peeksLabel.anchorX = 1

    local timeLabel = display.newText( "time:", display.contentCenterX+95*mW, statsTextY, "Mathlete-Skinny", statsTextSize )
    timeLabel:setFillColor( 74/255, 54/255, 22/255, 1)
    timeLabel.anchorX = 1

    local peeksNumber = display.newText( " 0", display.contentCenterX-65*mW, statsTextY, "Mathlete-Skinny", statsTextSize )
    peeksNumber.anchorX = 0
    peeksNumber:setFillColor( 37/255, 108/255, 0, 1)

    local timeNumber = display.newText( " 0:00", display.contentCenterX+85*mW, statsTextY, "Mathlete-Skinny", statsTextSize )
    timeNumber.anchorX = 0
    timeNumber:setFillColor( 37/255, 108/255, 0, 1)

    -- sign group

    replaySign = display.newGroup()
    replaySign:insert( replayPaper )
    replaySign:insert( replayText )
    replaySign:insert( peeksLabel )
    replaySign:insert( timeLabel )
    replaySign:insert( peeksNumber )
    replaySign:insert( timeNumber )
    replaySign:insert( ropeL )
    replaySign:insert( ropeR )

    sceneGroup:insert( replayShader )
    sceneGroup:insert( replayYesBtn )
    sceneGroup:insert( replayNoBtn )
    sceneGroup:insert( replaySign )

    -- change sign for Easy level
    
    if( _myG.difficulty == "easy" ) then
        replayText.y = cY-145*mW
        peeksLabel.isVisible = false
        timeLabel.isVisible = false
        peeksNumber.isVisible = false
        timeNumber.isVisible = false
    end

    -- animate replay sign

    local function replayBtnsOpen()
        transition.to( replayYesBtn, { time=1, alpha=1 })
        transition.to( replayYesBtn, { delay=1, time=200, y=cY+25*mW, yScale=1, transition=easing.outSine })
        transition.to( replayYesBtn, { delay=200, time=200, y=cY-45*mW, transition=easing.outSine })
        transition.to( replayNoBtn, { time=101, alpha=1 })
        transition.to( replayNoBtn, { delay=101, time=200, y=cY+25*mW, yScale=1, transition=easing.outSine })
        transition.to( replayNoBtn, { delay=300, time=200, y=cY-45*mW, transition=easing.outSine })
    end

    --[[
    local function replayBtnsClose()
        transition.to( audioBtn, { time=100, yScale=0.25, transition=easing.outSine })
        transition.to( audioBtn, { delay=100, time=1, alpha=0 })
        transition.to( replayBtn, { delay=100, time=75, yScale=0.5, transition=easing.outSine  })
        transition.to( replayBtn, { delay=175, time=1, alpha=0 })
        transition.to( homeBtn, { delay=175, time=60, yScale=0.5, transition=easing.outSine  })
        transition.to( homeBtn, { delay=235, time=1, alpha=0 })
    end
    ]]--

    local function replaySignDown()
        playBannerFX()
        transition.to( replaySign, { time=1, alpha=1 })
        transition.to( replaySign, { time=350, y=50*mW, yScale=1, transition=easing.outSine })
        transition.to( replaySign, { delay=350, time=200, y=0, transition=easing.outSine })
        transition.to( replayShader, { time=300, alpha=0.5 } )
        transition.to( replayShade2, { time=600, alpha=1 } )
        timer.performWithDelay( 200, replayBtnsOpen )
    end

    --[[
    local function replaySignUp()
        playBannerFX()
        transition.to( bannerGroup, { time=400, y=bannerUpY, yScale=0.5, transition=easing.outSine })
        transition.to( shader, { time=300, alpha=0 } )
    end
    ]]--

    -- victory animation

    local function playVictoryScene()
        uiActiveFalse()
        _myG.yayGoblins()
        if( _myG.audioOn == "true" ) then
            audio.play( yayGoblin )
        end
        timer.performWithDelay( 3000, replaySignDown )
        print ( "Victory!" )
    end

    -- change UI placement if ad is present

    if ( _myG.adsLoaded == "true" ) then
        -- alter banner position on devices that are not taller/thinner 
        if( screenRatio > 0.6 ) then
            bannerDownY = cH-_myG.adsHeight-(80*mW)
        end
        --alter banner size on iPad
        if( screenRatio >= 0.7 ) then
            banner.height = 960*mW
            matchGroup.y = -850*mW
            mScale = 0.90
            matchGroup:scale( mScale, mScale )
        end

        --move UI above banner ad
        gearSprite.y = cH-_myG.adsHeight
        gearHandle.y = gearHandleY-_myG.adsHeight
        signSprite.y = cH-_myG.adsHeight
        uiShader1.y = cH-_myG.adsHeight
        uiShader2.y = cH-_myG.adsHeight

        -- fake ad, ad space
        local adSpace = display.newRect( cX, cH, display.contentWidth, 90*mW )
        adSpace:setFillColor( 0, 0, 0, 1 )
        adSpace.anchorY = 1
        sceneGroup:insert( adSpace ) 
    end

    local function secsToMins( secs )
        local myTime 
        local myMinutes
        local mySeconds

        if secs > 59 then
            myMinutes = math.floor(secs/60)
            mySeconds = secs-(math.floor(secs/60)*60)
            if mySeconds < 10 then
                mySeconds = "0"..mySeconds
            end
            myTime = myMinutes..":"..mySeconds
        else
            if secs < 60 then
                mySeconds = secs
            end
            if secs < 10 then
                mySeconds = "0"..mySeconds
            end
            myTime = "0:"..mySeconds
        end
        timeNumber.text = " " .. myTime
        print ( "myTime: ", myTime )
    end

    local function getGameStats()
        gameEndTime = system.getTimer()
        print( "end: ", gameEndTime )
        gameTimeDif = math.floor((gameEndTime - gameStartTime)*0.001)
        print( "time: ", gameTimeDif .. " seconds" )
        secsToMins( gameTimeDif )
        peeksNumber.text = " " .. totalPeeks
        if( _myG.difficulty ~= "easy" ) then
            if (totalPeeks > peeksPar ) then
                peeksNumber:setFillColor( 150/255, 50/255, 0, 1 )
            end
            if (gameTimeDif > timePar ) then
                timeNumber:setFillColor( 150/255, 50/255, 0, 1 )
            end
        end
        print( "peeks: " .. totalPeeks )
    end

    -- Sign animation and match checking

    local function signCompare( event )
        if ( _myG.uiActive == "true" ) and ( _myG.introComplete == "true" ) then
            uiActiveFalse()
            if _myG.headsMatch.activeBlock == _myG.ribbon[1].activeBlock and _myG.torsoMatch.activeBlock == _myG.ribbon[2].activeBlock and _myG.legsMatch.activeBlock == _myG.ribbon[3].activeBlock then
                -- if we have a match, don't lower the banner. Play victory animation.
                getGameStats()
                signSpinToCheck()
                timer.performWithDelay( 700, audioThatsMyGoblin )
                -- you win!
                timer.performWithDelay( 1200, playVictoryScene )
            else
                -- if we don't have a match, lower the banner, etc
                signSpinToX()
                timer.performWithDelay( 600, playWrongAnswerFX )
                --timer.performWithDelay( 700, audioNotMyGoblin )
                signTimer = timer.performWithDelay( 2000, signSpinFromX )
                timer.performWithDelay( 2500, uiActiveTrue )
            end
        end
        return true
    end

    local function compareGoblins()
        if ( _myG.introComplete == "false" ) then
            -- if this is the intro, skip the comparison and just lower the banner
            timer.performWithDelay( 700, bannerPlayDown )
            timer.performWithDelay( 1400, audioWheresMyGoblin )
            --bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
        elseif ( _myG.introComplete == "true" ) then
            -- raise sign if needed
            if( signIsUp == "false" ) then
                transition.to( signSprite, { time=400, y=cH-_myG.adsHeight, transition=easing.outSine })
                transition.to( uiShader2, { time=800, alpha=1 })
                signIsUp = true
            end
            -- else do our comparison
            if _myG.headsMatch.activeBlock == _myG.ribbon[1].activeBlock and _myG.torsoMatch.activeBlock == _myG.ribbon[2].activeBlock and _myG.legsMatch.activeBlock == _myG.ribbon[3].activeBlock then
                -- if we have a match, don't lower the banner. Play victory animation.
                getGameStats()
                timer.performWithDelay( 400, signSpinToCheck )
                timer.performWithDelay( 1100, audioThatsMyGoblin )
                -- you win!
                timer.performWithDelay( 1600, playVictoryScene )
            else
                -- if we don't have a match, lower the banner, etc
                timer.performWithDelay( 400, signSpinToX )
                --timer.performWithDelay( 600, playWrongAnswerFX )
                timer.performWithDelay( 1100, bannerPlayDown )
                timer.performWithDelay( 1800, audioNotMyGoblin )
                signTimer = timer.performWithDelay( 4400, signSpinFromX )
                --bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
            end
        end
    end

    -- animation functions

    local function raiseBanner()
        if( bannerState == "down" ) then
            print ( "raiseBanner" )
            handlePlay( "up" )
            gearBackward()
            bannerPlayUp()
            print( "raiseBanner uiActive: " .. _myG.uiActive )
            if ( _myG.introComplete == "false" ) then
                _myG.loadSlider()
            elseif ( signState ~= "check" ) then
                timer.performWithDelay( 500, uiActiveTrue )
            end
        end
    end

    local function raiseBannerNow( event )
        if( bannerState == "down" ) then
            print( "raiseBannerNow" )
            timer.cancel( bannerStayTimer )
            raiseBanner()
            if (signState == "x") then
                timer.cancel( signTimer )
                signSpinFromX()
            end
            print( "raiseBannerNow uiActive: " .. _myG.uiActive )
        end
        return true
    end

    function turnCrank( event )
        print ( "turnCrank" )
        if ( bannerState == "down" ) then
            raiseBannerNow()
        end
        if ( _myG.uiActive == "true" ) then
            uiActiveFalse()
            handlePlay( "down" )
            gearForward()
            compareGoblins()
            if ( _myG.introComplete == "false" ) then
                if( _myG.difficulty == "easy" ) then
                    bannerStayTimer = timer.performWithDelay( 6000, raiseBanner )
                elseif( _myG.difficulty == "medium" ) then
                    bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
                elseif( _myG.difficulty == "hard" ) then
                    bannerStayTimer = timer.performWithDelay( 2000, raiseBanner )
                end
            else
                local peekVar = totalPeeks
                totalPeeks = peekVar+1
                if( _myG.difficulty == "easy" ) then
                    bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
                elseif( _myG.difficulty == "medium" ) then
                    bannerStayTimer = timer.performWithDelay( 4000, raiseBanner )
                elseif( _myG.difficulty == "hard" ) then
                    bannerStayTimer = timer.performWithDelay( 2500, raiseBanner )
                end
            end
        end
        return true
    end

    local function handleDrag( event )
        if ( handleState == "up" ) then
            if ( event.phase == "began" ) then
                display.getCurrentStage():setFocus( gearHandle )
                gearHandle.isFocus = true
                startX = event.x
                startTime = event.time
                endX = event.x
            elseif ( gearHandle.isFocus ) then
                if( event.phase == "moved") then
                    endX = event.x
                    local difX = endX - startX
                    if( gearHandle.rotation > -1 and gearHandle.rotation < 101 ) then
                        gearHandle.rotation = difX*0.25
                        if( gearHandle.rotation > 29) then
                            turnCrank()
                        end
                    end 
                elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                    endX = event.x
                    endTime = event.time
                    local totalTime = endTime - startTime
                    if ( totalTime < 400 ) and ( startX == endX ) then
                        -- this is a tap
                        turnCrank()
                    elseif( gearHandle.rotation < 30 )then
                        transition.to( gearHandle, { time=200, rotation=0, transition=easing.outSine } )
                        timer.performWithDelay( 200, handleStateUp )
                    end
                    display.getCurrentStage():setFocus( nil )
                    gearHandle.isFocus = false
                end
            end
        end
        return true
    end

    function _myG.startGamePlay()
        _myG.introComplete = "true"
        _myG.uiActive = "true"
        settingsActive = "true"
        --_myG.activeRibbonsText.text = "You picked: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
        -- capture current time for game start
        gameStartTime = system.getTimer()
        print( "start: ", gameStartTime)
    end

    -- event listeners

    signSprite:addEventListener( "tap", signCompare )
    gearSprite:addEventListener( "tap", turnCrank )
    --gearHandle:addEventListener( "tap", turnCrank )
    gearHandle:addEventListener( "touch", handleDrag )
    gearBlock:addEventListener( "touch", handleDrag )
    shader:addEventListener( "tap", raiseBannerNow )


--end scene:create
end 

---------------------------------------------------------------------------------
-- SCENE:SHOW
---------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        getMatchParts()

        signIsUp = "false"
        transition.to( signSprite, { time=0, y=cH+100*mW })
        transition.to( uiShader2, { time=0, alpha=0 })

        transition.to( replayShader, { time=0, alpha=0 })
        transition.to( replayShade2, { time=0, alpha=0 } )

        -- set inital banner values
        transition.to( bannerGroup, { time=0, y=bannerUpY, yScale=0.5 })

        -- set inital sign position
        transition.to( replaySign, { time=0, y=-300, yScale=0.5 })
        transition.to( replaySign, { time=1, alpha=0 }) 
        transition.to( replayYesBtn, { time=0, y=cY-40*mW, yScale=0.25, alpha=0 })
        transition.to( replayNoBtn, { time=0, y=cY-40*mW, yScale=0.25, alpha=0 })
        
    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.

        -- INTRO ANIMATION:

        uiActiveTrue() -- temporarily true to allow first animation
        crankTimer = timer.performWithDelay( 800, turnCrank )

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

        timer.cancel( bannerStayTimer )
        timer.cancel( crankTimer )

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
