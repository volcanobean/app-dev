---------------------------------------------------------------------------------
--
-- gameplay.lua
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

    -- START your game code here:

    local physics = require "physics"
    physics.start()
    physics.setGravity(0,0)

    -- main character
    --local player = "p1"
    print ("game p: " .. _myG.player)


    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor(0,0,0,1)
    sceneGroup:insert( background )

    local fairySpriteOptions =
    {
        width = 115,
        height = 158,
        numFrames = 8
    }
    local fairySheet = graphics.newImageSheet( "images/fairy-abcd-spritesheet.png", fairySpriteOptions )
    local fairyFrames = { start=1, count=8 }


    local fairy = display.newSprite( fairySheet, fairyFrames )
    fairy.x = display.contentWidth *0.90
    fairy.y = display.contentHeight *0.90
    physics.addBody( fairy, "dynamic" )
    sceneGroup:insert( fairy )

    if _myG.player == "p1" then 
        fairy:setFrame(1)  
    elseif _myG.player == "p2" then
        fairy:setFrame (3)
    elseif _myG.player == "p3" then
        fairy:setFrame (5)
    elseif _myG.player == "p4" then
        fairy:setFrame (7)        
    end 

    -- Obstacles -- 

    --local enemy = display.newRect( 450, 250, 200, 100 )
    --enemy:setFillColor(1, 0, 1, 1)
    --physics.addBody(enemy, "static", { bounce=5, density=5 } )

    -- Color glowballs to collect

    local colorGlow = {}

    --Moving fairy--

    local function touchScreen( event )
        transition.to( fairy, { time=1000, x=event.x, y=event.y })
        print("----")
        print ("Fairy:",fairy.x)
        print ("Event:",event.x)
        if _myG.player == "p1" then
            if (fairy.x > event.x) then
                fairy:setFrame (1) 
            elseif (fairy.x <= event.x) then
                fairy:setFrame (2)
            end
        elseif _myG.player == "p2" then 
            if (fairy.x > event.x) then
                fairy:setFrame (3) 
            elseif (fairy.x <= event.x) then
                fairy:setFrame (4)
            end

        elseif _myG.player == "p3" then 
            if (fairy.x > event.x) then
                fairy:setFrame (5) 
            elseif (fairy.x <= event.x) then
                fairy:setFrame (6)
            end
        elseif _myG.player == "p4" then 
            if (fairy.x > event.x) then
                fairy:setFrame (7) 
            elseif (fairy.x <= event.x) then
                fairy:setFrame (8)
            end        
        end 
        return true
    end

   background:addEventListener( "tap", touchScreen )

    -- Define creation of Glow

    local function createGlow( number )
        colorGlow[number] = display.newImage( "images/blueglow.png" )
        colorGlow[number].x = math.random( 25, 900 )
        colorGlow[number].y = math.random( 25, 475 )
        local r = math.random( 0, 100 )
        local g = math.random( 0, 100 )
        local b = math.random( 0, 100 )
        colorGlow[number]:setFillColor( r/100, g/100, b/100 )
        physics.addBody( colorGlow[number], "static" )
        --colorGlow[number]:addEventListener( , listener )
        sceneGroup:insert( colorGlow[number] )
    end

    --Fairy catching the Glow

    local mySound3 = audio.loadSound( "audio/magic-chime-02.mp3" )

    local function sparkle()
        audio.play( mySound3 )
    end

    local function onCollision( event )
        event.target:removeSelf()
        sparkle()
    end 

    --Runtime:addEventListener( "collision", onCollision )

    -- Generate actual Glow objects

    for i=1, 15 do
        createGlow(i)
        --Moving Glow
        local function moveGlow()
            transition.to( colorGlow[i], { time=math.random(10000, 40000), x=math.random(50, 700), y=math.random(80, 1000), onComplete=moveGlow })
        end
        moveGlow()
        colorGlow[i]:addEventListener( "collision", onCollision )
    end 

    local function replay (event)
        composer.gotoScene( "replay" )
        return true
    end

    local replayButton = 
    display.newRect(75, 35, 100, 50)
    sceneGroup:insert( replayButton )
    replayButton:addEventListener( "tap", replay )

    print( "gameplay loaded" ) 

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
