---------------------------------------------------------------------------------
--
-- talking.lua
--
---------------------------------------------------------------------------------

-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.

print ("start of talking")
local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

-- Forward declarations

local mac
local npc
local talk = {}
local textBox
local text

-- -----------------------------------------------------------------------------------------------------------------
-- "scene:create()"
-- -----------------------------------------------------------------------------------------------------------------

-- Initialize the scene here.

function scene:create( event )
    local sceneGroup = self.view

    mac = display.newImageRect( sceneGroup, "images/portrait-mac.png", 507, 726 )
    mac.offScreenX = -300
    mac.onScreenX = cX-300
    mac.y = cY+85

    npc = display.newImageRect( sceneGroup, "images/portrait-tomato-fairy.png", 507, 726 )
    npc.offScreenX = cW+300
    npc.onScreenX = cX+310
    npc.y = cY+50

    textBox = display.newRect( sceneGroup, cX, cH, cW, 175 )
    textBox.anchorY = 1
    textBox:setFillColor( 0,0,0,0.8 )

    text = display.newText( sceneGroup, "Text here.", cX, cH, cW-100, 150, native.systemFont, 40 )
    text.anchorY = 1

    -- transition functions

    function mac.enterScreen()
        transition.to( mac, { time=300, x=mac.onScreenX, transition=easing.outSine })
    end

    function mac.exitScreen()
        transition.to( mac, { time=200, x=mac.offScreenX })
    end

    function npc.enterScreen()
        transition.to( npc, { time=300, x=npc.onScreenX, transition=easing.outSine  })
    end

    function npc.exitScreen()
        transition.to( npc, { time=200, x=npc.offScreenX  })
    end

    function textBox.fadeIn()
        transition.to( textBox, { time=200, alpha=1 })
    end

    function textBox.fadeOut()
        transition.to( textBox, { time=200, alpha=0 })
    end

    function text.fadeIn()
        transition.to( text, { time=200, alpha=1 })
    end

    function text.fadeOut()
        transition.to( text, { time=200, alpha=0 })
    end

    -- build talk scenes

    function talk.level1()
        text.text = "Oh no! I'm late!"
        mac.enterScreen()
        text.fadeIn()
    end

    function talk.level2()
        text.text = "I'm so sorry to hear about your tomato plants."
        mac.enterScreen()
        npc.enterScreen()
        timer.performWithDelay( 300, text.fadeIn )
    end

    function talk.level3()
        text.text = "Help! My tea party has no color!"
        mac.enterScreen()
        timer.performWithDelay( 400, npc.enterScreen )
        timer.performWithDelay( 600, text.fadeIn )
    end

end

-- -----------------------------------------------------------------------------------------------------------------
-- "scene:show()"
-- -----------------------------------------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view

    if ( event.phase == "will" ) then -- Called when the scene is still off screen (but is about to come on screen).

        -- set initial character positions

        mac.x = mac.offScreenX
        npc.x = npc.offScreenX
        textBox.alpha = 0
        text.alpha = 0

    elseif ( event.phase == "did" ) then -- Called when the scene is now on screen.

        -- play scene based on current level

        textBox.fadeIn()
        if _myG.currentLevel == 1 then
            talk.level1()
        elseif _myG.currentLevel == 2 then
            talk.level2()
        elseif _myG.currentLevel == 3 then
            talk.level3()
        end

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

    elseif ( event.phase == "did" ) then -- Called immediately after scene goes off screen.

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
