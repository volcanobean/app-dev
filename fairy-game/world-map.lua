---------------------------------------------------------------------------------
--
-- world-map.lua
--
---------------------------------------------------------------------------------

-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.

print ("start of world-map")
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

    local titleTxt = display.newText( sceneGroup, "World Map", cX, cY-50, native.systemFont, 75 )

    local function gotoLevel1()
        composer.gotoScene( "level-1" )
        return true
    end

    local function gotoLevel2()
        composer.gotoScene( "level-2" )
        return true
    end

    local function gotoLevel3()
        composer.gotoScene( "level-3" )
        return true
    end

    local lvl1Btn = display.newCircle( sceneGroup, 300, 200, 40 )
    local lvl2Btn = display.newCircle( sceneGroup, 500, 500, 40 )
    local lvl3Btn = display.newCircle( sceneGroup, 700, 600, 40 )

    lvl1Btn:addEventListener( "tap", gotoLevel1 )
    lvl2Btn:addEventListener( "tap", gotoLevel2 )
    lvl3Btn:addEventListener( "tap", gotoLevel3 )

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
