---------------------------------------------------------------------------------
--
-- start-screen.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

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
        return true
    end

    -- load 'secret button' first to hide it behind background image
    local startHitArea =  display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    startHitArea:setFillColor( 0, 1, 1, 0.25 )
    startHitArea:addEventListener( "tap", startGame )
    sceneGroup:insert( startHitArea )

    _myG.background = display.newImage( "images/forest_bg.jpg" )
    _myG.background.x = display.contentWidth*0.5
    _myG.background.y = display.contentHeight*0.5
    sceneGroup:insert( _myG.background )

    -- game title
    local titleText1 = display.newText( "where's", display.contentCenterX, 400, "Mathlete-Skinny", 125 )
    local titleText2 = display.newText( "my", display.contentCenterX, 525, "Mathlete-Skinny", 125 )
    local titleText3 = display.newText( "goblin?", display.contentCenterX, 650, "Mathlete-Skinny", 125 )
    sceneGroup:insert( titleText1 )
    sceneGroup:insert( titleText2 )
    sceneGroup:insert( titleText3 )

    local startBtn = display.newText( "start", display.contentCenterX, 875, "Mathlete-Skinny", 80 )
    -- startBtn:addEventListener( "tap", startGame )
    sceneGroup:insert( startBtn )
    
    print( "Scene created: start-screen")
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
