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
_myG.adsHeight = 90*mW

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
    local levelsFrames =  { start=1, count=9 }
    
    local levelSequence =
    {
        { name="easy", frames={ 1, 5, 6, 7, 8, 9, 1, }, time=252, loopCount=1 },
        { name="med", frames={ 3, 5, 6, 7, 8, 9, 3 }, time=252, loopCount=1 },
        { name="hard", frames={ 2, 5, 6, 7, 8, 9, 2 }, time=252, loopCount=1 },
    }

    local levelsPost = display.newSprite( levelsSheet, levelsFrames )
    levelsPost:setFrame( 4 )
    levelsPost.x = cX
    levelsPost.y = cH-195*mW

    local easySign = display.newSprite( levelsSheet, levelSequence )
    easySign:setSequence( "easy" )
    easySign:setFrame(1)
    easySign.x = cX+3*mW
    easySign.y = cH-350*mW

    local medSign = display.newSprite( levelsSheet, levelSequence )
    medSign:setSequence( "med" )
    medSign:setFrame(1)
    medSign.x = cX
    medSign.y = cH-250*mW

    local hardSign = display.newSprite( levelsSheet, levelSequence )
    hardSign:setSequence( "hard" )
    hardSign:setFrame(1)
    hardSign.x = cX+7*mW
    hardSign.y = cH-140*mW 

    easyText = display.newText( "easy", display.contentCenterX, display.contentCenterY+(165*mW), "Mathlete-Skinny", 80*mW )
    easyText.x = cX+5*mW
    easyText.y = cH-375*mW 
    easyText:setFillColor( 232/255, 1, 186/255, 1 )

    medText = display.newText( "medium", display.contentCenterX, display.contentCenterY+(255*mW), "Mathlete-Skinny", 80*mW )
    medText.x = cX
    medText.y = cH-275*mW
    medText:setFillColor( 232/255, 1, 186/255, 1 )

    hardText = display.newText( "hard", display.contentCenterX, display.contentCenterY+(345*mW), "Mathlete-Skinny", 80*mW )
    hardText.x = cX+7*mW
    hardText.y = cH-165*mW 
    hardText:setFillColor( 232/255, 1, 186/255, 1 )

    easyTextDark = display.newText( "easy", display.contentCenterX, display.contentCenterY+(165*mW), "Mathlete-Skinny", 80*mW )
    easyTextDark.x = cX+5*mW
    easyTextDark.y = cH-375*mW 
    easyTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    medTextDark = display.newText( "medium", display.contentCenterX, display.contentCenterY+(255*mW), "Mathlete-Skinny", 80*mW )
    medTextDark.x = cX
    medTextDark.y = cH-275*mW
    medTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    hardTextDark = display.newText( "hard", display.contentCenterX, display.contentCenterY+(345*mW), "Mathlete-Skinny", 80*mW )
    hardTextDark.x = cX+7*mW
    hardTextDark.y = cH-165*mW 
    hardTextDark:setFillColor( 123/255, 123/255, 87/255, 1 )

    local shadowDistance = 3*mW
    local easyTextShadow = display.newText( "easy", display.contentCenterX, display.contentCenterY+(165*mW), "Mathlete-Skinny", 80*mW )
    easyTextShadow.x = easyText.x + shadowDistance
    easyTextShadow.y = easyText.y + shadowDistance
    easyTextShadow:setFillColor( 0, 0, 0, 0.8 )

    local medTextShadow = display.newText( "medium", display.contentCenterX, display.contentCenterY+(255*mW), "Mathlete-Skinny", 80*mW )
    medTextShadow.x = medText.x + shadowDistance
    medTextShadow.y = medText.y + shadowDistance
    medTextShadow:setFillColor( 0, 0, 0, 0.8 )

    local hardTextShadow = display.newText( "hard", display.contentCenterX, display.contentCenterY+(345*mW), "Mathlete-Skinny", 80*mW )
    hardTextShadow.x = hardText.x + shadowDistance
    hardTextShadow.y = hardText.y + shadowDistance
    hardTextShadow:setFillColor( 0, 0, 0, 0.8 )

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
            spinTextShadow = easyTextShadow
        elseif( _myG.difficulty == "medium" ) then
            spinText = medText
            spinTextShadow = medTextShadow
        elseif( _myG.difficulty == "hard" ) then
            spinText = hardText
            spinTextShadow = hardTextShadow
        end
        transition.to( spinText, { delay=35, time=0, alpha=0 })
        transition.to( spinTextShadow, { delay=35, time=0, alpha=0 })
        timer.performWithDelay( 216, textToWhite )
        transition.to( spinText, { delay=216, time=0, alpha=1 })
        transition.to( spinTextShadow, { delay=216, time=0, alpha=1 })
    end

    levelsSignGroup = display.newGroup()
    levelsSignGroup:insert( levelsPost )
    levelsSignGroup:insert( easySign )
    levelsSignGroup:insert( medSign )
    levelsSignGroup:insert( hardSign ) 
    levelsSignGroup:insert( easyTextShadow )
    levelsSignGroup:insert( medTextShadow )
    levelsSignGroup:insert( hardTextShadow )
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

    local function clickAbout( event )
        print( "clickAbout" )
        if( settingsActive == "true" ) then
            --show audio settings
        end
        return true
    end

    menuBtn:addEventListener( "tap", clickMenu )
    audioBtn:addEventListener( "tap", clickAudio )
    aboutBtn:addEventListener( "tap", clickAbout )

    -- ad space
    local adBg = display.newRect( cX, cH, display.contentWidth, 90*mW )
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
