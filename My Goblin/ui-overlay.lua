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
local gearGroup
local gearShade
local signShade
local shader

local signSprite
local signIsUp
local replayShader
local replaySign
local replayYesBtn
local replayNoBtn
local bannerGroup
local replayBtnShade

local bannerUpY
local bannerDownY
local bannerStretchY = 0
local getMatchParts
local notGobPlayed = "false"
local playIntro

---------------------------------------------------------------------------------
-- SCENE:CREATE - Initialize the scene here.
---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    print( "creating overlay" )

    --local thing = display.newRect( sceneGroup, cX, cY, 50, 50 )

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

    _myG.headsMatch.activeBlock = 1
    _myG.torsoMatch.activeBlock = 1
    _myG.legsMatch.activeBlock = 1

    _myG.introComplete = "false"
    local bannerState = "up"
    local handleState = "up"
    local signState = "goblin"

        -- UI on/off functions

    local function uiActiveFalse()
        _myG.uiActive = "false"
        --activeText.text = "UI Active: " .. _myG.uiActive
    end

    function uiActiveTrue()
        _myG.uiActive = "true"
        --activeText.text = "UI Active: " .. _myG.uiActive
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

    local function audioWheresMyGoblin()
        -- Play sound
        if( _myG.audioOn == "true" ) then
            audio.play( whereGoblin )
        end
    end

    local function audioThatsMyGoblin()
        if( _myG.audioOn == "true" ) then
            audio.play( thatGoblin )
        end
    end

    local function audioNotMyGoblin()
        if( _myG.audioOn == "true" ) and ( notGobPlayed == "false") then
            audio.play( notGoblin )
            notGobPlayed = "true"
        end
    end

    local function audioYay()
        if( _myG.audioOn == "true" ) then
            audio.play( yayGoblin )
        end
    end

    -- UI bg shade

    gearShade = display.newImageRect( "images/ui-shader-1.png", 385*mW, 399*mW )
    gearShade.anchorX = 0
    gearShade.anchorY = 1
    gearShade.x = 0
    gearShade.y = cH
    sceneGroup:insert( gearShade )

    signShade = display.newImageRect( "images/ui-shader-2.png", 384*mW, 295*mW )
    signShade.anchorX = 1
    signShade.anchorY = 1
    signShade.x = cW
    signShade.y = cH
    sceneGroup:insert( signShade )

    -- expanded handle hit area

    local handleHit = display.newRect( 0, display.contentHeight, 125*mW, 400*mW )
    handleHit.anchorX = 0
    handleHit.anchorY = 1
    if ( _myG.adsLoaded == "true" ) then
        handleHit.y = display.contentHeight-(91*mW)
    end

    handleHit.isVisible = false
    handleHit.isHitTestable = true

    sceneGroup:insert( handleHit )

---------------------------------------------------------------------------------
-- Match parts
---------------------------------------------------------------------------------

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

        _myG.headsMatch[r3].y = 0*mW
        _myG.torsoMatch[r2].y = 290*mW
        _myG.legsMatch[r1].y = 465*mW

        -- debug
        --matchBlocksText.text = "Match these: " .. _myG.headsMatch.activeBlock .. ", " .. _myG.torsoMatch.activeBlock .. ", " .. _myG.legsMatch.activeBlock
    end

---------------------------------------------------------------------------------
-- Banner
---------------------------------------------------------------------------------

    shader = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth+10, display.contentHeight+10 )
    shader:setFillColor( 0, 0, 0, 1 )
    sceneGroup:insert( shader )

    -- rope sprites

    local ropeSheetInfo = require("ropes-sheet")
    local ropeSheet = graphics.newImageSheet( "images/ropes.png", ropeSheetInfo:getSheet() )
    local ropeFrames  = { start=1, count=2 }

    local matchRopeL = display.newSprite( ropeSheet, ropeFrames )
    matchRopeL:setFrame(1)
    matchRopeL.anchorY = 1 
    matchRopeL.x = 275*mW
    matchRopeL.y = cY-420*mW
    
    local matchRopeR = display.newSprite( ropeSheet, ropeFrames )
    matchRopeR:setFrame(2)
    matchRopeR.anchorY = 1
    matchRopeR.x = 510*mW
    matchRopeR.y = cY-420*mW

    local banner = display.newImageRect( "images/banner.png", 512*mW, 795*mW)
    banner.x = cX+10*mW
    banner.y = cY-60*mW

    local matchGoblinText = display.newText( "match this goblin", cX+14*mW, cY-366*mW, "Mathlete-Skinny", 85*mW )
    matchGoblinText:setFillColor( 74/255, 54/255, 22/255, 1)

    -- Add goblin match pieces to banner

    local mScale = 0.77 
    matchGroup:scale( mScale, mScale )
    matchGroup.x = cX
    matchGroup.y = cY-220*mW

    bannerGroup = display.newGroup()
    bannerGroup:insert( banner )
    bannerGroup:insert( matchRopeL )
    bannerGroup:insert( matchRopeR )
    bannerGroup:insert( matchGoblinText )
    bannerGroup:insert( matchGroup )

    sceneGroup:insert( bannerGroup )

    bannerUpY = -800*mW
    bannerDownY = 0
    bannerStretchY = 50*mW

    bannerGroup.y = bannerUpY

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
            playBannerFX()
            transition.to( bannerGroup, { time=400, y=bannerDownY+bannerStretchY, yScale=1, transition=easing.outSine })
            transition.to( bannerGroup, { delay=400, time=200, y=bannerDownY, transition=easing.outSine })
            transition.to( shader, { time=350, alpha=0.5 } )
            timer.performWithDelay( 350, bannerStateDown )
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

---------------------------------------------------------------------------------
-- Gear
---------------------------------------------------------------------------------

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

    gearGroup = display.newGroup()
    gearGroup:insert( gearHandle )
    gearGroup:insert( gearSprite )

    sceneGroup:insert( gearGroup )

    local function gearForward()
        gearSprite:setSequence( "forward" )
        gearSprite:play()
    end

    local function gearBackward()
        gearSprite:setSequence( "backward" )
        gearSprite:play()
    end

---------------------------------------------------------------------------------
-- Sign
---------------------------------------------------------------------------------

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
    signSprite:setSequence( "spin" )
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

---------------------------------------------------------------------------------
-- Reply banner
---------------------------------------------------------------------------------

    replayShader = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth+10, display.contentHeight+10 )
    replayShader:setFillColor( 0, 0, 0, 1 ) 
    sceneGroup:insert( replayShader )

    replayBtnShade = display.newImageRect( sceneGroup, "images/replay-shader.png", cW, 510*mW )
    replayBtnShade.x = cX
    replayBtnShade.y = cY+130*mW

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

    local replayPaper = display.newSprite( replaySheet, replayFrames )
    replayPaper:setFrame(2)
    replayPaper.height = 303*mW
    replayPaper.width =  568*mW
    replayPaper.anchorY = 0 
    replayPaper.x = cX
    replayPaper.y = cY-275*mW

    replayYesBtn:addEventListener( "tap", _myG.clickReplay )
    replayNoBtn:addEventListener( "tap", _myG.clickHome )

    -- rope sprites

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

    local function replaySignDown()
        playBannerFX()
        transition.to( replaySign, { time=1, alpha=1 })
        transition.to( replaySign, { time=350, y=50*mW, yScale=1, transition=easing.outSine })
        transition.to( replaySign, { delay=350, time=200, y=0, transition=easing.outSine })
        transition.to( replayShader, { time=300, alpha=0.5 } )
        transition.to( replayBtnShade, { time=600, alpha=1 } )
        timer.performWithDelay( 200, replayBtnsOpen )
    end

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
            --bannerDownY = cH-_myG.adsHeight-(80*mW)
        end
        --alter banner size on iPad
        if( screenRatio >= 0.7 ) then
            --banner.height = 960*mW
            --matchGroup.y = -850*mW
            --mScale = 0.90
            --matchGroup:scale( mScale, mScale )
        end

        --[[
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
        ]]--


        --move UI above banner ad
        gearSprite.y = cH-_myG.adsHeight
        gearHandle.y = gearHandleY-_myG.adsHeight
        signSprite.y = cH-_myG.adsHeight
        gearShade.y = cH-_myG.adsHeight
        signShade.y = cH-_myG.adsHeight

        -- ad space
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
        elseif ( _myG.introComplete == "true" ) then
            -- raise sign if needed
            if( signIsUp == "false" ) then
                transition.to( signSprite, { time=400, y=cH-_myG.adsHeight, transition=easing.outSine })
                transition.to( signShade, { time=800, alpha=1 })
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
                timer.performWithDelay( 1100, bannerPlayDown )
                timer.performWithDelay( 1800, audioNotMyGoblin )
                signTimer = timer.performWithDelay( 4400, signSpinFromX )
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
                    if ( totalTime < 400 ) and ( startX < endX+10 and startX > endX-10 ) then
                        -- this is a tap
                        turnCrank()
                        print("tapped on handle")
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
        -- capture current time for game start
        gameStartTime = system.getTimer()
        print( "start: ", gameStartTime)
    end

    -- event listeners

    signSprite:addEventListener( "tap", signCompare )
    gearSprite:addEventListener( "tap", turnCrank )
    gearHandle:addEventListener( "touch", handleDrag )
    handleHit:addEventListener( "touch", handleDrag )
    shader:addEventListener( "tap", raiseBannerNow )

    -- INTRO ANIMATION:

    function playIntro()
        uiActiveTrue() -- temporarily true to allow first animation
        transition.to( gearGroup, { time=800, y=0, transition=easing.outSine })
        crankTimer = timer.performWithDelay( 1200, turnCrank )
        transition.to( gearShade, { delay=2000, time=800, alpha=1 })
    end

--end scene:create
end 

---------------------------------------------------------------------------------
-- SCENE:SHOW
---------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        print( "WILL show scene" )
        -- Called when the scene is still off screen (but is about to come on screen).

        _myG.blackFader.alpha=0

        getMatchParts()

        signIsUp = "false"
        signSprite.y=cH+100*mW
        gearShade.alpha=0
        signShade.alpha=0
        shader.alpha=0
        replayShader.alpha=0
        replayBtnShade.alpha=0

        -- set inital banner values
        bannerGroup.y=bannerUpY
        bannerGroup.yScale=0.5

        -- set inital sign position
        replaySign.y=-300*mW
        replaySign.yScale=0.5
        replaySign.alpha=0
        replayYesBtn.y=cY-40*mW
        replayYesBtn.yScale=0.25
        replayYesBtn.alpha=0
        replayNoBtn.y=cY-40*mW
        replayNoBtn.yScale=0.25
        replayNoBtn.alpha=0

        gearGroup.y=cH-100*mW

        if( _myG.fromReplay == "true" ) then
            _myG.blackFader.alpha=1
        end

    elseif ( event.phase == "did" ) then
        print( "DID show scene" )
        -- Called when the scene is now on screen.

        if( _myG.fromReplay == "true" ) then
            transition.to( _myG.blackFader, { delay=200, time=400, alpha=0 } )
            timer.performWithDelay( 600, playIntro )
            _myG.fromReplay = "false"
        else
            playIntro()
        end
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
