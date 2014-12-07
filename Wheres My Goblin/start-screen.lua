---------------------------------------------------------------------------------
--
-- start-screen.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

-- local ads = require( "ads" )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

    -- Ad code

    --[[

    local bannerAppID = "ca-app-pub-7094148843149156/1832646501"  -- admob, iOS banner

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

    ads.init( adProvider, appID, adListener )
    ]]--

    -- create start function

    local function startGame( event ) 
        composer.gotoScene( "goblin-slider" )
        return true
    end

    -- load 'secret button' first to hide it behind background image

    local startHitArea =  display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    startHitArea:setFillColor( 0, 1, 1, 0.25 )
    startHitArea:addEventListener( "tap", startGame )
    sceneGroup:insert( startHitArea )

    _myG.background = display.newImageRect( "images/forest-bg.jpg", 768, 1366 )
    _myG.background.x = display.contentWidth*0.5
    _myG.background.y = display.contentHeight*0.5
    sceneGroup:insert( _myG.background )

    -- game title
    local titleText1 = display.newText( "where's", display.contentCenterX, 300, "Mathlete-Skinny", 125 )
    local titleText2 = display.newText( "my", display.contentCenterX, 410, "Mathlete-Skinny", 125 )
    local titleText3 = display.newText( "goblin?", display.contentCenterX, 510, "Mathlete-Skinny", 125 )
    sceneGroup:insert( titleText1 )
    sceneGroup:insert( titleText2 )
    sceneGroup:insert( titleText3 )

    local startBtn = display.newText( "start", display.contentCenterX, 875, "Mathlete-Skinny", 80 )
    -- startBtn:addEventListener( "tap", startGame )
    sceneGroup:insert( startBtn )
    
    -- ads.show( "banner", { x=0, y=100000, appId=bannerAppID } )
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
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
