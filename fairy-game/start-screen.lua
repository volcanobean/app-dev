---------------------------------------------------------------------------------
--
-- start-screen.lua
--
---------------------------------------------------------------------------------

-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.

print ("start of start-screen")
local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

-- Forward declarations



-- -----------------------------------------------------------------------------------------------------------------
-- "scene:create()"
-- -----------------------------------------------------------------------------------------------------------------

-- Initialize the scene here.

function scene:create( event )
    local sceneGroup = self.view

    local function startGame()
    	composer.gotoScene( "world-map" )
    	return true
    end

    local titleTxt = display.newText( sceneGroup, "Fairy Game", cX, cY-50, native.systemFont, 75 )
    titleTxt:addEventListener( "tap", startGame )

    local startBtn = display.newText( sceneGroup, "TAP TO START", cX, cY+100, native.systemFont, 30 )
    startBtn:addEventListener( "tap", startGame )

end

-- -----------------------------------------------------------------------------------------------------------------
-- "scene:show()"
-- -----------------------------------------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    elseif ( event.phase == "did" ) then
        -- Called when the scene is now on screen.

    end
end

-- -----------------------------------------------------------------------------------------------------------------
-- "scene:hide()"
-- -----------------------------------------------------------------------------------------------------------------

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

-- -----------------------------------------------------------------------------------------------------------------
-- "scene:destroy()"
-- -----------------------------------------------------------------------------------------------------------------

function scene:destroy( event )
    local sceneGroup = self.view
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-- -----------------------------------------------------------------------------------------------------------------
-- Listener setup
-- -----------------------------------------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
