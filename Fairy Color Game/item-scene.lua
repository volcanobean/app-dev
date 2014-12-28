-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local _myG = composer.myGlobals


-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

    print("item-scene p:" .. _myG.player)

    -- START your game code here:
    
    local function startGame()
        composer.gotoScene( "gameplay", { effect="fade" } )
    end  

   

    local fairyBg = display.newImageRect( "images/item-bg.jpg", 1365, 768 )
    fairyBg.x = display.contentCenterX
    fairyBg.y = display.contentCenterY
    --fairyBg:addEventListener( "tap", startGame )
    sceneGroup:insert( fairyBg)

local fairySpriteOptions =
        {
            width = 267,
            height = 366,
            numFrames = 4
        }
    local fairySheet = graphics.newImageSheet( "images/pickplayer-spritesheet.png", fairySpriteOptions )
    local fairyFrames = { start=1, count=4 }


    local fairy = display.newSprite( fairySheet, fairyFrames )
    fairy.x = display.contentWidth *0.25
    fairy.y = display.contentHeight *0.30
    sceneGroup:insert( fairy )

    if _myG.player == "p1" then 
        fairy:setFrame(1)  
    elseif _myG.player == "p2" then
        fairy:setFrame (2)
    elseif _myG.player == "p3" then
        fairy:setFrame (3)
    elseif _myG.player == "p4" then
        fairy:setFrame (4)        
    end 

    local startText = display.newText ("This will be much more informative later.", 50, 50, "MountainsofChristmas-Regular", 60 )
    startText.y = display.contentHeight *0.75
    startText.x = display.contentWidth *0.5
    sceneGroup:insert( startText )

    local playText = display.newText("Play", 50, 50, "MountainsofChristmas-Regular", 200)
    playText.y = display.contentHeight *0.35
    playText.x = display.contentWidth *0.70
    sceneGroup:insert ( playText )


    playText:addEventListener( "tap", startGame )   

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
