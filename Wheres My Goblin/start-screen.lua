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
local mW = 0.0013020833*cW

-- Ad code

local ads = require( "ads" )
local bannerAppID = "ca-app-pub-7094148843149156/1832646501"  -- admob, iOS banner
--local interstitialAppID = "ca-app-pub-7094148843149156/3309379704" -- admob, iOS interstitial
local adProvider = "admob"

local function adListener( event )
    -- The 'event' table includes:
    -- event.name: string value of "adsRequest"
    -- event.response: message from the ad provider about the status of this request
    -- event.phase: string value of "loaded", "shown", or "refresh"
    -- event.type: string value of "banner" or "interstitial"
    -- event.isError: boolean true or false

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
--ads.show( "banner", { x=0, y=100000, appId=bannerAppID } )

-- audio

local goblinTheme = audio.loadSound( "audio/goblin-theme-loop.wav" )

local function playGoblinTheme()
    audio.play( goblinTheme, { loops=-1 } )
end

local function stopGoblinTheme()
    audio.stop()
end

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

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
    local titleText1 = display.newText( "where's", display.contentCenterX, display.contentCenterY-(322*mW), "Mathlete-Skinny", 125*mW ) --300,125
    local titleText2 = display.newText( "my", display.contentCenterX, display.contentCenterY-(212*mW), "Mathlete-Skinny", 125*mW ) --410,125
    local titleText3 = display.newText( "goblin?", display.contentCenterX, display.contentCenterY-(112*mW), "Mathlete-Skinny", 125*mW) --510,125
    sceneGroup:insert( titleText1 )
    sceneGroup:insert( titleText2 )
    sceneGroup:insert( titleText3 )

    local startBtn = display.newText( "start", display.contentCenterX, display.contentCenterY+(200*mW), "Mathlete-SkinnySlant", 80*mW ) --875,80
    startBtn:addEventListener( "tap", startGame )
    sceneGroup:insert( startBtn )

end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- Show banner ad
        ads.show( "banner", { x=0, y=100000, appId=bannerAppID } )

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

        -- pre-load next scene
        print ( "loading goblin-slider" )
        composer.loadScene( "goblin-slider" )

        -- play goblin theme
        timer.performWithDelay( 600, playGoblinTheme )
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
        ads.hide()
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
