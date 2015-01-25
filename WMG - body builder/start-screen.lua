---------------------------------------------------------------------------------
--
-- start-screen.lua
--
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

local blackMask 
local tapGroup
local playGoblinTheme
local stopGoblinTheme

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
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

    -- create start function

    local function startGame( event ) 
        composer.gotoScene( "goblin-slider" )
        --_myG.background.isVisible = false
        return true
    end

    -- load 'secret button' first to hide it behind background image

    local startHitArea =  display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    startHitArea:setFillColor( 0, 1, 1, 0.25 )
    startHitArea:addEventListener( "tap", startGame )
    sceneGroup:insert( startHitArea )

    _myG.background = display.newImageRect( "images/forest-bg.jpg", display.contentWidth, 1366*mW)
    _myG.background.x = display.contentCenterX
    _myG.background.y = display.contentCenterY
    sceneGroup:insert( _myG.background )

    -- game title
    local titleText1 = display.newText( "where's my", display.contentCenterX, display.contentCenterY-(180*mW), "Mathlete-Skinny", 135*mW )
    local titleText1b = display.newText( "where's my", display.contentCenterX+3*mW, display.contentCenterY-(177*mW), "Mathlete-Skinny", 135*mW )
    titleText1b:setFillColor( 0, 0, 0, 0.8 )
    local titleText2 = display.newText( "goblin?", display.contentCenterX, display.contentCenterY-(60*mW), "Mathlete-Skinny", 235*mW)
    local titleText2b = display.newText( "goblin?", display.contentCenterX+5*mW, display.contentCenterY-(55*mW), "Mathlete-Skinny", 235*mW)
    titleText2b:setFillColor( 0, 0, 0, 0.8 )

    sceneGroup:insert( titleText1b )
    sceneGroup:insert( titleText1 )
    sceneGroup:insert( titleText2b )
    sceneGroup:insert( titleText2 )

    local startBtn = display.newText( "tap to start", display.contentCenterX, display.contentCenterY+(200*mW), "Mathlete-SkinnySlant", 80*mW )
    startBtn:setFillColor( 0.8, 0.97, 0.63, 1 )
    local startBtn2 = display.newText( "tap to start", display.contentCenterX+3, display.contentCenterY+(203*mW), "Mathlete-SkinnySlant", 80*mW )
    startBtn2:setFillColor( 0, 0, 0, 0.8 )
    startBtn:addEventListener( "tap", startGame )

    tapGroup = display.newGroup()
    tapGroup:insert( startBtn2 )
    tapGroup:insert( startBtn )

    sceneGroup:insert( tapGroup )
    

    -- Settings sprites
    
    local settingsSheetInfo = require("settings-sheet")
    local settingsSheet = graphics.newImageSheet( "images/settings.png", settingsSheetInfo:getSheet() )
    local settingsFrames  = { start=1, count=6 }

    local settingsX = 665*mW

    local audioBtnY = 42*mW

    local arrowBtn = display.newSprite( settingsSheet, settingsFrames )
    arrowBtn:setFrame(2)
    arrowBtn.anchorY = 0 
    arrowBtn.x = settingsX
    arrowBtn.y = -44*mW

    local audioBtn = display.newSprite( settingsSheet, settingsFrames )
    audioBtn:setFrame(1)
    audioBtn.anchorY = 0 
    audioBtn.x = settingsX
    audioBtn.y = audioBtnY

    audioBtn.yScale=0.25
    audioBtn.alpha=0

    sceneGroup:insert( audioBtn )
    sceneGroup:insert( arrowBtn )

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

    local function arrowImageDown()
        arrowBtn:setFrame(2)
    end

    local function arrowImageUp()
        arrowBtn:setFrame(6)
    end

    local function settingsOpen()
        settingsActiveFalse()
        transition.to( audioBtn, { time=1, alpha=1 })
        transition.to( audioBtn, { delay=1, time=150, y=audioBtnY+48*mW, yScale=1, transition=easing.outSine })
        transition.to( audioBtn, { delay=150, time=150, y=audioBtnY, transition=easing.outSine })
        timer.performWithDelay( 500, arrowImageUp )
        timer.performWithDelay( 500, settingsActiveTrue )
    end

    local function settingsClose()
        settingsActiveFalse()
        transition.to( audioBtn, { delay=175, time=60, yScale=0.5, transition=easing.outSine  })
        transition.to( audioBtn, { delay=235, time=1, alpha=0 })
        timer.performWithDelay( 235, arrowImageDown )
        timer.performWithDelay( 235, settingsActiveTrue )
    end

    local function clickArrow( event )
        print( "clickArrow" )
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
                audioBtn:setFrame(4)
                _myG.audioOn = "false"
                audio.stop()
            elseif( _myG.audioOn == "false" ) then
                audioBtn:setFrame(1)
                _myG.audioOn = "true"
                -- restart the music
                playGoblinTheme()
            end
        end
        return true
    end

    arrowBtn:addEventListener( "tap", clickArrow )
    audioBtn:addEventListener( "tap", clickAudio )

    blackMask = display.newRect( cX, cY, cW, cH )
    blackMask:setFillColor( 0, 0, 0, 1 )
    sceneGroup:insert( blackMask )

    -- fake ad, ad space
    local adSpace = display.newRect( cX, cH, display.contentWidth, 90*mW )
    adSpace:setFillColor( 0, 0, 0, 1 )
    adSpace.anchorY = 1
    sceneGroup:insert( adSpace ) 

end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- Show banner ad
        ads.show( "banner", { x=0, y=100000, appId=bannerAppID } )
 
        -- Set pre-animated object positions
        transition.to( tapGroup, { time=0, y=50, alpha=0 } )

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.

        -- pre-load next scene
        print ( "loading goblin-slider" )
        composer.loadScene( "goblin-slider" )

        -- play goblin theme
        timer.performWithDelay( 600, playGoblinTheme )
        transition.to( blackMask, { delay=600, time=400, alpha=0 } )
        transition.to( tapGroup, { delay=1200, time=800, y=0, alpha=1, transition=easing.outSine } )
    end
end


-- "scene:hide()"
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
