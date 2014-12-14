---------------------------------------------------------------------------------
--
-- gameplay.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
-- Assign shorter variable name to myGlobals table to save on typing.
local _myG = composer.myGlobals

_myG.player = "p1"

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

    -- START your game code here:
    
    local function startGame()
        composer.gotoScene( "gameplay", { effect="fade" } )
    end  

    local function chooseP1( event )
        _myG.player = "p1"
        print ( "start p: " .. _myG.player)
        startGame () 
        return true
    end    

    local function chooseP2( event )
        _myG.player = "p2"
        print ( "start p: " .. _myG.player)
        startGame ()
        return true
    end    

    local fairyBg = display.newImageRect( "images/fairy-bg.jpg", 768, 1365 )
        fairyBg.x = display.contentCenterX
        fairyBg.y = display.contentCenterY
        --fairyBg:addEventListener( "tap", startGame )
        sceneGroup:insert( fairyBg)

    local fairySpriteOptions =
        {
            width = 115,
            height = 159,
            numFrames = 4
        }
    local fairySheet = graphics.newImageSheet( "images/Spritesheet-Fairy-AB.png", fairySpriteOptions )
    local fairyFrames = { start=1, count=4 }

    local p1Button = display.newSprite (fairySheet, fairyFrames )
    p1Button:setFrame (1)
    p1Button.x =  display.contentWidth *0.25
    p1Button.y = display.contentHeight *0.5
    sceneGroup:insert (p1Button)
    p1Button:addEventListener( "tap", chooseP1 )

    local p2Button = display.newSprite (fairySheet, fairyFrames )
    p2Button:setFrame (4)
    p2Button.x =  display.contentWidth *0.75
    p2Button.y = display.contentHeight *0.5
    sceneGroup:insert (p2Button)
    p2Button:addEventListener( "tap", chooseP2 )

    local startText = display.newText ("Pick your fairy to play!", 50, 50, "MountainsofChristmas-Regular", 75 )
    startText.y = display.contentHeight *0.8
    startText.x = display.contentWidth *0.5
    sceneGroup:insert( startText )

    local titleText = display.newText ("Fairy Sisters", 50, 50, "MountainsofChristmas-Regular", 150 )
    titleText.y = display.contentHeight *0.25
    titleText.x = display.contentWidth *0.5
    sceneGroup:insert( titleText )     

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
