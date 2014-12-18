---------------------------------------------------------------------------------
--
-- start-screen.lua
--
---------------------------------------------------------------------------------

print ("start of logos")
local composer = require( "composer" )
local scene = composer.newScene()

local _myG = composer.myGlobals

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY
local mW = 0.0013020833*cW

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
-- Initialize the scene here.
function scene:create( event )
    local sceneGroup = self.view

    -- build logo elements

    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, 1366*mW )
    sceneGroup:insert( background )

    local pinkCircle = display.newCircle( cX, cY-92*mW , 121*mW ) --420,121
    pinkCircle:setFillColor( 0.949, 0.475, 0.604, 1 )
    sceneGroup:insert( pinkCircle )

    local unicorgi = display.newImageRect( "images/unicorgi.png", 235*mW, 332*mW )
    unicorgi.x = 398*mW
    unicorgi.y = cY-125*mW --387
    sceneGroup:insert( unicorgi )

    local circleMask = display.newImageRect( "images/logo-circle-mask.png", 768*mW, 512*mW )
    circleMask.x = cX
    circleMask.y = cY+87*mW
    sceneGroup:insert( circleMask )

    local textY = cY+98*mW --610
    local textSize = 110*mW

    local letterU = display.newText( "U", 155*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterU:setFillColor( 1, 0.368, 0.368, 1 )
    local letterN = display.newText( "N", 235*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterN:setFillColor( 1, 0.639, 0.368, 1 )
    local letterI = display.newText( "I", 290*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterI:setFillColor( 0.416, 1, 0.373, 1 )
    local letterC = display.newText( "C", 345*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterC:setFillColor( 0.392, 0.976, 0.682, 1 )
    local letterO = display.newText( "O", 425*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterO:setFillColor( 0.369, 1, 0.909, 1 )
    local letterR = display.newText( "R", 505*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterR:setFillColor( 0.475, 0.384, 0.761, 1 )
    local letterG = display.newText( "G", 582*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterG:setFillColor( 1, 0.447, 0.369, 1)
    local letterI2 = display.newText( "I", 639*mW, textY, "HelveticaLTStd-Blk", textSize )
    letterI2:setFillColor( 1, 0.639, 0.368, 1 )

    sceneGroup:insert( letterU )
    sceneGroup:insert( letterN )
    sceneGroup:insert( letterI )
    sceneGroup:insert( letterC )
    sceneGroup:insert( letterO )
    sceneGroup:insert( letterR )
    sceneGroup:insert( letterG )
    sceneGroup:insert( letterI2 )

    local function gotoStart( event ) 
        composer.gotoScene( "start-screen" )
        return true
    end

    background:addEventListener( "tap", gotoStart )
  
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

        -- pre-load next scene

        print ( "loading start-screen" )
        composer.loadScene( "start-screen" )
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
