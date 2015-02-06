---------------------------------------------------------------------------------
-- start-screen.lua
---------------------------------------------------------------------------------

print ("start of start-screen")
local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY
local mW = 0.0013022*cW

--temp
_myG.blackFader = display.newRect( cX, cY, cW, cH )
_myG.blackFader:setFillColor( 0, 0, 0, 1 )
_myG.blackFader.alpha=0

-- Ad code

local ads = require( "ads" )
local bannerAppID = "ca-app-pub-7094148843149156/7291607302"  -- admob, iOS banner
local adProvider = "admob"
if ( system.getInfo( "platformName" ) == "Android" ) then
    bannerAppID = "ca-app-pub-7094148843149156/5814874106"  -- admob, Android banner
end

_myG.adsLoaded = "true"
_myG.adsHeight = 100*mW

local function adListener( event )
    local msg = event.response
    -- Quick debug message regarding the response from the library
    print( "Message from the ads library: ", msg )

    if ( event.isError ) then
        print( "Error, no ad received", msg )
    else
        print( "Ah ha! Got one!" )
    end
end

ads.init( adProvider, bannerAppID, adListener )


-- Forward declarations

_myG.difficulty = "easy"

local tapGroup
local playGoblinTheme
local stopGoblinTheme

local easyText
local medText
local hardText
local easyTextDark
local medTextDark
local hardTextDark

local titleGroup
local levelsSignGroup
local settingsGroup

local bannerGroup
local bannerUpY
local bannerDownY
local bannerStretchY = 0
local shader
local bannerState = "up"

--[[
local screenRatio = cW/cH
print ("screenRatio " .. screenRatio)

if( screenRatio >= 0.7 ) then
    -- if our device has iPad-eque proportions
    print( "ipad")
elseif( screenRatio > 0.6 ) and ( screenRatio < 0.7 ) then
    -- if we're on shorter mobile devices
    print( "short mobile")
else
    -- if we're on a taller thinner device
    print( "tall mobile")
end
]]--

---------------------------------------------------------------------------------
-- SCENE:CREATE - Initialize the scene here.
---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    -- audio

    local goblinTheme = audio.loadSound( "audio/goblin-theme-loop.wav" )

    function playGoblinTheme()
        if ( _myG.audioOn == "true" ) then
            audio.play( goblinTheme, { loops=-1 } )
        end
    end

    function stopGoblinTheme()
        audio.stop()
    end

    local bannerFX = audio.loadSound( "audio/banner-short.wav" )

    local function playBannerFX()
        if( _myG.audioOn == "true" ) then
            audio.play( bannerFX )
        end
    end

    local swipeFX = audio.loadSound( "audio/swipe.wav" )

    local function playSwipeFX()
        if( _myG.audioOn == "true" ) then
            audio.play( swipeFX )
        end
    end

    _myG.background = display.newImageRect( "images/forest-bg.jpg", display.contentWidth, 1366*mW)
    _myG.background.x = display.contentCenterX
    _myG.background.y = display.contentCenterY
    sceneGroup:insert( _myG.background )

    -- game title
    local titleText1 = display.newText( "where's my", display.contentCenterX, display.contentCenterY-(220*mW), "Mathlete-Skinny", 135*mW )
    local titleText1b = display.newText( "where's my", display.contentCenterX+3*mW, display.contentCenterY-(217*mW), "Mathlete-Skinny", 135*mW )
    titleText1b:setFillColor( 0, 0, 0, 0.8 )
    local titleText2 = display.newText( "goblin?", display.contentCenterX, display.contentCenterY-(100*mW), "Mathlete-Skinny", 235*mW)
    local titleText2b = display.newText( "goblin?", display.contentCenterX+5*mW, display.contentCenterY-(95*mW), "Mathlete-Skinny", 235*mW)
    titleText2b:setFillColor( 0, 0, 0, 0.8 )

    titleGroup = display.newGroup()
    titleGroup:insert( titleText1b )
    titleGroup:insert( titleText1 )
    titleGroup:insert( titleText2b )
    titleGroup:insert( titleText2 )

    sceneGroup:insert( titleGroup )

    -- levels sprites

    local levelsSheetInfo = require("levels-sheet")
    local levelsSheet = graphics.newImageSheet( "images/levels-sheet.png", levelsSheetInfo:getSheet() )
    local levelsFrames =  { start=1, count=12 }
    
    local levelSequence =
    {
        { name="easy", frames={ 3, 7, 8, 9, 10, 11, 3 }, time=252, loopCount=1 },
        { name="med", frames={ 5, 7, 8, 9, 10, 11, 5 }, time=252, loopCount=1 },
        { name="hard", frames={ 4, 7, 8, 9, 10, 11, 4 }, time=252, loopCount=1 },
    }

    local levelsPost = display.newSprite( levelsSheet, levelsFrames )
    levelsPost:setFrame(6)
    levelsPost.x = cX
    levelsPost.y = cH-205*mW

    local easySign = display.newSprite( levelsSheet, levelSequence )
    easySign:setSequence( "easy" )
    easySign:setFrame(1)
    easySign.x = cX+3*mW
    easySign.y = cH-360*mW

    local medSign = display.newSprite( levelsSheet, levelSequence )
    medSign:setSequence( "med" )
    medSign:setFrame(1)
    medSign.x = cX
    medSign.y = cH-260*mW

    local hardSign = display.newSprite( levelsSheet, levelSequence )
    hardSign:setSequence( "hard" )
    hardSign:setFrame(1)
    hardSign.x = cX+7*mW
    hardSign.y = cH-150*mW 

    easyText = display.newSprite( levelsSheet, levelsFrames )
    easyText:setFrame(1)
    easyText.x = cX+5*mW
    easyText.y = cH-370*mW
    easyText:setFillColor( 232/255, 1, 186/255, 1 )

    medText = display.newSprite( levelsSheet, levelsFrames )
    medText:setFrame(12)
    medText.x = cX
    medText.y = cH-270*mW
    medText:setFillColor( 232/255, 1, 186/255, 1 )

    hardText = display.newSprite( levelsSheet, levelsFrames )
    hardText:setFrame(2)
    hardText.x = cX+7*mW
    hardText.y = cH-160*mW 
    hardText:setFillColor( 232/255, 1, 186/255, 1 )

    easyTextDark = display.newSprite( levelsSheet, levelsFrames )
    easyTextDark:setFrame(1)
    easyTextDark.x = cX+5*mW
    easyTextDark.y = cH-370*mW 
    easyTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    medTextDark = display.newSprite( levelsSheet, levelsFrames )
    medTextDark:setFrame(12)
    medTextDark.x = cX
    medTextDark.y = cH-270*mW
    medTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    hardTextDark = display.newSprite( levelsSheet, levelsFrames )
    hardTextDark:setFrame(2)
    hardTextDark.x = cX+7*mW
    hardTextDark.y = cH-160*mW 
    hardTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    local function textToWhite()
        if( _myG.difficulty == "easy" ) then
            easyText:setFillColor( 1, 1, 1, 1 )
        elseif( _myG.difficulty == "medium" ) then
            medText:setFillColor( 1, 1, 1, 1 )
        elseif( _myG.difficulty == "hard" ) then
            hardText:setFillColor( 1, 1, 1, 1 )
        end
    end

    local function textSpin()
        local spinText
        local spinTextShadow
        if( _myG.difficulty == "easy" ) then
            spinText = easyText
        elseif( _myG.difficulty == "medium" ) then
            spinText = medText
        elseif( _myG.difficulty == "hard" ) then
            spinText = hardText
        end
        transition.to( spinText, { delay=35, time=0, alpha=0 })
        timer.performWithDelay( 216, textToWhite )
        transition.to( spinText, { delay=216, time=0, alpha=1 })
    end

    levelsSignGroup = display.newGroup()
    levelsSignGroup:insert( levelsPost )
    levelsSignGroup:insert( easySign )
    levelsSignGroup:insert( medSign )
    levelsSignGroup:insert( hardSign ) 
    levelsSignGroup:insert( easyText )
    levelsSignGroup:insert( medText )
    levelsSignGroup:insert( hardText )
    levelsSignGroup:insert( easyTextDark )
    levelsSignGroup:insert( medTextDark )
    levelsSignGroup:insert( hardTextDark )

    sceneGroup:insert( levelsSignGroup ) 

    -- Settings sprites
    
    local settingsSheetInfo = require("settings-sheet")
    local settingsSheet = graphics.newImageSheet( "images/settings.png", settingsSheetInfo:getSheet() )
    local settingsFrames  = { start=1, count=6 }

    local settingsX = 668*mW
    
    local menuBtnY = -35*mW
    local audioBtnY = 30*mW
    local aboutBtnY = 155*mW

    local audioBtn = display.newSprite( settingsSheet, settingsFrames )
    audioBtn:setFrame(2)
    audioBtn.anchorY = 0 
    audioBtn.x = settingsX
    audioBtn.y = audioBtnY

    local aboutBtn = display.newSprite( settingsSheet, settingsFrames )
    aboutBtn:setFrame(1)
    aboutBtn.anchorY = 0 
    aboutBtn.x = settingsX
    aboutBtn.y = aboutBtnY

    local menuBtn = display.newSprite( settingsSheet, settingsFrames )
    menuBtn:setFrame(4)
    menuBtn.anchorY = 0 
    menuBtn.x = settingsX
    menuBtn.y = menuBtnY

    aboutBtn.yScale=0.5
    aboutBtn.alpha=0
    audioBtn.yScale=0.5
    audioBtn.alpha=0

    sceneGroup:insert( aboutBtn )
    sceneGroup:insert( audioBtn )
    sceneGroup:insert( menuBtn )
    
       -- settings-related functions

    local settingsActive = "true"
    local arrowState = "down"
    
    local function settingsActiveTrue()
        settingsActive = "true"
        print ("settingsActive: " .. settingsActive)
    end 

    local function settingsActiveFalse()
        settingsActive = "false"
        print ("settingsActive: " .. settingsActive)
    end 

    local function settingsOpen()
        settingsActiveFalse()
        transition.to( audioBtn, { time=1, alpha=1 })
        transition.to( audioBtn, { delay=1, time=150, y=audioBtnY+48*mW, yScale=1, transition=easing.outSine })
        transition.to( audioBtn, { delay=150, time=150, y=audioBtnY, transition=easing.outSine })
        transition.to( aboutBtn, { delay=250, time=1, alpha=1 })
        transition.to( aboutBtn, { delay=250, time=150, y=aboutBtnY+50*mW, yScale=1, transition=easing.outSine })
        transition.to( aboutBtn, { delay=400, time=150, y=aboutBtnY, transition=easing.outSine })
        timer.performWithDelay( 650, settingsActiveTrue )
    end

    local function settingsClose()
        settingsActiveFalse()
        transition.to( aboutBtn, { time=75, yScale=0.5, transition=easing.outSine  })
        transition.to( aboutBtn, { delay=75, time=1, alpha=0 })
        transition.to( audioBtn, { delay=75, time=60, yScale=0.5, transition=easing.outSine  })
        transition.to( audioBtn, { delay=135, time=1, alpha=0 })
        timer.performWithDelay( 135, settingsActiveTrue )
    end

    local function clickMenu( event )
        print( "clickMenu" )
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

    local function clickAudio( event )
        print( "clickAudio" )
        if( settingsActive == "true" ) then
            --show audio settings
            if( _myG.audioOn == "true" ) then
                audioBtn:setFrame(5)
                _myG.audioOn = "false"
                audio.stop()
            elseif( _myG.audioOn == "false" ) then
                audioBtn:setFrame(2)
                _myG.audioOn = "true"
                -- restart the music
                playGoblinTheme()
            end
        end
        return true
    end

    menuBtn:addEventListener( "tap", clickMenu )
    audioBtn:addEventListener( "tap", clickAudio )
    --aboutBtn:addEventListener( "tap", clickAbout )

    -- ad space
    local adBg = display.newRect( cX, cH, display.contentWidth, 100*mW )
    adBg:setFillColor( 0, 0, 0, 1 )
    adBg.anchorY = 1
    sceneGroup:insert( adBg ) 


    -- create start function

    local function startGame() 
        composer.gotoScene( "goblin-slider" )
    end

    local function goToStart()
        if( arrowState == "up" ) then
            settingsClose()
        end
        transition.to( levelsSignGroup, { delay=100, time=100, y=-50*mW, transition=easing.outSine })
        transition.to( levelsSignGroup, { delay=200, time=200, y=400*mW, transition=easing.inSine })
        timer.performWithDelay( 300, playSwipeFX )
        transition.to ( titleGroup, { delay=100, time=500, alpha=0 })
        timer.performWithDelay( 800, startGame )
    end

       local function setToEasy( event )
        _myG.difficulty = "easy"
        print( _myG.difficulty )
        easySign:setSequence( "easy" )
        easySign:play()
        textSpin()
        easyText:setFillColor( 1, 1, 1, 1 )
        transition.to( medTextDark, { time=216, alpha=1 })
        transition.to( hardTextDark, { time=216, alpha=1 })
        transition.to( medText, { time=216, alpha=0 })
        transition.to( hardText, { time=216, alpha=0 })
        timer.performWithDelay( 300, goToStart )
        return true
    end

    local function setToMed( event )
        _myG.difficulty = "medium"
        print( _myG.difficulty )
        medSign:setSequence( "med" )
        medSign:play()
        textSpin()
        transition.to( easyTextDark, { time=216, alpha=1 })
        transition.to( hardTextDark, { time=216, alpha=1 })
        transition.to( easyText, { time=216, alpha=0 })
        transition.to( hardText, { time=216, alpha=0 })
        timer.performWithDelay( 300, goToStart )
        return true
    end

    local function setToHard( event )
        _myG.difficulty = "hard"
        print( _myG.difficulty )
        hardSign:setSequence( "hard" )
        hardSign:play()
        textSpin()
        transition.to( easyTextDark, { time=216, alpha=1 })
        transition.to( medTextDark, { time=216, alpha=1 })
        transition.to( easyText, { time=216, alpha=0 })
        transition.to( medText, { time=216, alpha=0 })
        timer.performWithDelay( 300, goToStart )
        return true
    end

    easySign:addEventListener( "tap", setToEasy )
    medSign:addEventListener( "tap", setToMed )
    hardSign:addEventListener( "tap", setToHard )


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

    local infoText1 = display.newText( "where's my goblin?", cX+14*mW, cY-360*mW, "Mathlete-Skinny", 75*mW )
    local infoText2 = display.newText( "© Volcano Bean, LLC", cX+14*mW, cY-300*mW, "Mathlete-Skinny", 75*mW )
    local infoText3 = display.newText( "artists:", cX+14*mW, cY-210*mW, "Mathlete-Skinny", 75*mW )
    local infoText4 = display.newText( "matt seniour", cX+14*mW, cY-150*mW, "Mathlete-Skinny", 75*mW )
    local infoText5 = display.newText( "gene kelly", cX+14*mW, cY-90*mW, "Mathlete-Skinny", 75*mW )
    local infoText6 = display.newText( "producer:", cX+14*mW, cY, "Mathlete-Skinny", 75*mW )
    local infoText7 = display.newText( "mary mckenzie", cX+14*mW, cY+60*mW, "Mathlete-Skinny", 75*mW )
    local infoText8 = display.newText( "programmer:", cX+14*mW, cY+150*mW, "Mathlete-Skinny", 75*mW )
    local infoText9 = display.newText( "gene kelly", cX+14*mW, cY+210*mW, "Mathlete-Skinny", 75*mW )
   
    infoText1:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText2:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText3:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText4:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText5:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText6:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText7:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText8:setFillColor( 74/255, 54/255, 22/255, 1)
    infoText9:setFillColor( 74/255, 54/255, 22/255, 1)

    bannerGroup = display.newGroup()
    bannerGroup:insert( banner )
    bannerGroup:insert( matchRopeL )
    bannerGroup:insert( matchRopeR )
    bannerGroup:insert( infoText1 )
    bannerGroup:insert( infoText2 )
    bannerGroup:insert( infoText3 )
    bannerGroup:insert( infoText4 )
    bannerGroup:insert( infoText5 )
    bannerGroup:insert( infoText6 )
    bannerGroup:insert( infoText7 )
    bannerGroup:insert( infoText8 )
    bannerGroup:insert( infoText9 )

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

    local function raiseBanner()
        if( bannerState == "down" ) then
            bannerPlayUp()
        end
    end

    local function clickAbout( event )
        print( "clickAbout" )
        if( settingsActive == "true" ) then
            bannerPlayDown()
        end
        return true
    end


    -- event listeners

    shader:addEventListener( "tap", raiseBanner )
    aboutBtn:addEventListener( "tap", clickAbout )

end

---------------------------------------------------------------------------------
-- SCENE:SHOW
---------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- Show banner ad
        ads.show( "banner", { x=0, y=100000, appId=bannerAppID } )

        -- Set pre-animated object positions

        _myG.blackFader.alpha=1
        titleGroup.alpha=1
        levelsSignGroup.y=0

        easyText.alpha=1
        medText.alpha=1
        hardText.alpha=1
        easyText:setFillColor( 232/255, 1, 186/255, 1 )
        medText:setFillColor( 232/255, 1, 186/255, 1 )
        hardText:setFillColor( 232/255, 1, 186/255, 1 )

        easyTextDark.alpha=0
        medTextDark.alpha=0
        hardTextDark.alpha=0

        shader.alpha=0
        bannerGroup.y=bannerUpY
        bannerGroup.yScale=0.5

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.

        -- pre-load next scene
        -- can't preload anymore because goblin-slider needs to be built based on level selection on this screen
        --print ( "loading goblin-slider" )
        --composer.loadScene( "goblin-slider" )

        -- play goblin theme
        timer.performWithDelay( 700, playGoblinTheme )
        transition.to( _myG.blackFader, { delay=200, time=400, alpha=0 } )
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

        -- stop audio
        stopGoblinTheme()

    elseif ( event.phase == "did" ) then
        -- Called immediately after scene goes off screen.

        -- remove the current ad
        --ads.hide()
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
