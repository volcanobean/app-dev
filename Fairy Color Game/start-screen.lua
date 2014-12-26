---------------------------------------------------------------------------------
--
-- gameplay.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
-- Assign shorter variable name to myGlobals table to save on typing.


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

    -- START your game code here:
    
    local function startGame()
        composer.gotoScene( "pick-player", { effect="fade" } )
    end  

   

    local fairyBg = display.newImageRect( "images/fairy-bg.jpg", 1365, 768 )
        fairyBg.x = display.contentCenterX
        fairyBg.y = display.contentCenterY
        --fairyBg:addEventListener( "tap", startGame )
        sceneGroup:insert( fairyBg)



    local startText = display.newText ("Tap to start!", 50, 50, "MountainsofChristmas-Regular", 75 )
    startText.y = display.contentHeight *0.9
    startText.x = display.contentWidth *0.5
    sceneGroup:insert( startText )

    local titleText = display.newText ("Fairy Sisters", 50, 50, "MountainsofChristmas-Regular", 150 )
    titleText.y = display.contentHeight *0.1
    titleText.x = display.contentWidth *0.5
    sceneGroup:insert( titleText )  

    fairyBg:addEventListener( "tap", startGame )   

end -- end "scene:create()"

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
