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

    -- Audio

    local unicorgiVO = audio.loadSound( "audio/unicorgi-vo.wav" )
    local introNote = audio.loadSound( "audio/unicorgi-intro-note.wav" )
    local introTone = audio.loadSound( "audio/unicorgi-intro-tone.wav" )
    local swooshFX = audio.loadSound( "audio/swipe.wav" )

    local function playUnicorgiVO()
        audio.play( unicorgiVO )
    end

    local function playIntroNote()
        audio.play( introNote )
    end

    local function playIntroTone()
        audio.play( introTone )
    end
    
    local function playSwooshFX()
        audio.play( swooshFX )
    end

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

    -- logo letter spritesheet

    local letterSheetInfo = require("letter-sheet")
    local letterSheet = graphics.newImageSheet( "images/letters.png", letterSheetInfo:getSheet() )
    local letterFrames  = { start=1, count=7 }

    local letterU = display.newSprite( letterSheet, letterFrames )
    letterU:setFrame(7)
    letterU:setFillColor( 1, 0.368, 0.368, 1 )
    letterU.x = 155*mW
    letterU.y = textY
    
    local letterN = display.newSprite( letterSheet, letterFrames )
    letterN:setFrame(4)
    letterN:setFillColor( 1, 0.639, 0.368, 1 )
    letterN.x = 235*mW
    letterN.y = textY
    
    local letterI = display.newSprite( letterSheet, letterFrames )
    letterI:setFrame(3)
    letterI:setFillColor( 0.416, 1, 0.373, 1 )
    letterI.x = 290*mW
    letterI.y = textY
    
    local letterC = display.newSprite( letterSheet, letterFrames )
    letterC:setFrame(1)
    letterC:setFillColor( 0.392, 0.976, 0.682, 1 )
    letterC.x = 345*mW
    letterC.y = textY-3*mW
    
    local letterO = display.newSprite( letterSheet, letterFrames )
    letterO:setFrame(5)
    letterO:setFillColor( 0.369, 1, 0.909, 1 )
    letterO.x = 425*mW
    letterO.y = textY-3*mW
    
    local letterR = display.newSprite( letterSheet, letterFrames )
    letterR:setFrame(6)
    letterR:setFillColor( 0.475, 0.384, 0.761, 1 )
    letterR.x = 506*mW
    letterR.y = textY

    local letterG = display.newSprite( letterSheet, letterFrames )
    letterG:setFrame(2)
    letterG:setFillColor( 1, 0.447, 0.369, 1)
    letterG.x = 582*mW
    letterG.y = textY-3*mW
    
    local letterI2 = display.newSprite( letterSheet, letterFrames )
    letterI2:setFrame(3)
    letterI2:setFillColor( 1, 0.639, 0.368, 1 )
    letterI2.x = 639*mW
    letterI2.y = textY

    sceneGroup:insert( letterI2 )
    sceneGroup:insert( letterG )
    sceneGroup:insert( letterO )
    sceneGroup:insert( letterR )
    sceneGroup:insert( letterC )
    sceneGroup:insert( letterI )
    sceneGroup:insert( letterU )
    sceneGroup:insert( letterN )

    local function gotoStart( event ) 
        composer.gotoScene( "start-screen" )
        return true
    end

    background:addEventListener( "tap", gotoStart )

    --animations

    -- hide and wait
    transition.to( pinkCircle, { time=0, alpha=0 })
    transition.to( circleMask, { time=0, alpha=0 })
    transition.to( unicorgi, { time=0, alpha=0 })
    transition.to( pinkCircle, { delay=600, time=0, alpha=1 })
    transition.to( circleMask, { delay=600, time=0, alpha=1 })
    -- show and animate
    transition.to( circleMask, { delay=600, time=0, xScale=0.1, yScale=0.1, y=cY-75*mW })
    transition.to( pinkCircle, { delay=600, time=0, xScale=0.1, yScale=0.1 })
    transition.to( circleMask, { delay=600, time=400, xScale=1.5, yScale=1.5, y=cY+177*mW, transition=easing.inQuad })
    transition.to( pinkCircle, { delay=600, time=400, xScale=1.5, yScale=1.5, transition=easing.inQuad })
    transition.to( circleMask, { delay=1000, time=200, xScale=1, yScale=1, y=cY+87*mW, transition=easing.outQuad })
    transition.to( pinkCircle, { delay=1000, time=200, xScale=1, yScale=1, transition=easing.outQuad })
    transition.to( unicorgi, { delay=1000, time=0, x=530*mW, y=cY+105*mW, alpha=1 })
    transition.to( unicorgi, { delay=1000, time=300, x=398*mW, y=cY-125*mW, transition=easing.outQuad })

    -- letters hide and wait
    transition.to( letterU, { time=0, alpha=0, x= -236*mW })
    transition.to( letterN, { time=0, alpha=0, x= -156*mW })
    transition.to( letterI, { time=0, alpha=0, x= -101*mW })
    transition.to( letterC, { time=0, alpha=0, x= -46*mW })
    transition.to( letterO, { time=0, alpha=0, x=815*mW })
    transition.to( letterR, { time=0, alpha=0, x=896*mW })
    transition.to( letterG, { time=0, alpha=0, x=973*mW })
    transition.to( letterI2, { time=0, alpha=0, x=1030*mW })
    -- letters show
    transition.to( letterU, { delay=1400, time=0, alpha=1, rotation= -360 })
    transition.to( letterN, { delay=1400, time=0, alpha=1, rotation= -360 })
    transition.to( letterI, { delay=1400, time=0, alpha=1, rotation= -360 })
    transition.to( letterC, { delay=1400, time=0, alpha=1, rotation= -360 })
    transition.to( letterO, { delay=1400, time=0, alpha=1, rotation=360 })
    transition.to( letterR, { delay=1400, time=0, alpha=1, rotation= -180 })
    transition.to( letterG, { delay=1400, time=0, alpha=1, rotation=360 })
    transition.to( letterI2, { delay=1400, time=0, alpha=1, rotation=359 })
    -- letters animated
    transition.to( letterU, { delay=1666, time=366, x=155*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterN, { delay=1733, time=366, x=235*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterI, { delay=1530, time=433, x=290*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterC, { delay=1400, time=460, x=345*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterO, { delay=1530, time=460, x=425*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterR, { delay=1366, time=400, x=506*mW, rotation= -360, transition=easing.outQuad })
    transition.to( letterG, { delay=1633, time=366, x=582*mW, rotation=0, transition=easing.outQuad })
    transition.to( letterI2, { delay=1800, time=366, x=639*mW, rotation=0, transition=easing.outQuad })

    -- just voice over
    
    timer.performWithDelay( 1200, playSwooshFX )
    timer.performWithDelay( 1600, playIntroTone )
    timer.performWithDelay( 2500, playUnicorgiVO )

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
