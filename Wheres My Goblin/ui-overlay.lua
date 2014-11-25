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

-- local forward references should go here


-- -------------------------------------------------------------------------------


-- "scene:create()"
-- Initialize the scene here.

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    -- Randomize function

    _myG.matchBlocks = {}
    _myG.matchBlocks[1] = 1
    _myG.matchBlocks[2] = 1
    _myG.matchBlocks[3] = 1

    local signState = "goblin"
    local audioTimer

    local goblinText = display.newText( "", display.contentCenterX, 975, native.systemFont, 30 )  
    local activeRibbonsText = display.newText( "activeRibbons: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock, display.contentCenterX, 120, native.systemFont, 30 )
    local matchBlocksText = display.newText( "Head: " .. _myG.matchBlocks[1] .. ", Body: " .. _myG.matchBlocks[2] .. ", Legs: " .. _myG.matchBlocks[3], display.contentCenterX, 30, native.systemFont, 30 )

    -- Audio

    -- temp function for debuggin, sans actual audio
    local function stopAudio()
        goblinText.text = "" 
    end

    local function playAudio( audioVar )
        if ( audioVar == "wheresMyGoblin" ) then
            goblinText.text = "Where's my goblin?"
        elseif ( audioVar == "myGoblin" ) then
            goblinText.text = "That's my goblin!" 
        elseif ( audioVar == "notMyGoblin" ) then
            goblinText.text = "That's not my goblin." 
        end
        timer.performWithDelay( 1200, stopAudio )
    end
  

    local function randomizeBlocks()  
        print ( "Function start." )
        local ribbonCount = 3
        for i=1, ribbonCount do
            -- Generate a random number based on the total number of blocks
            local randomNum = math.random( _myG.blockCount )
            print( randomNum )
            _myG.matchBlocks[i] = randomNum
        end
        matchBlocksText.text = "Head: " .. _myG.matchBlocks[1] .. ", Body: " .. _myG.matchBlocks[2] .. ", Legs: " .. _myG.matchBlocks[3]
    end

    -- Generate missing goblin

    local randomizeBtn = display.newText( "--RANDOMIZE--", display.contentCenterX, 75, native.systemFont, 30 )
    randomizeBtn:addEventListener( "tap", randomizeBlocks )
    sceneGroup:insert( randomizeBtn )
    -- Generate random goblin values on first scene load
    randomizeBlocks()

    -- Load UI and goblin banner

    -- Sprite data

    local sequenceData =
    {
        { name="spinToCheck", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 4, 5, 1, 2, 2, 1 }, time=500, loopCount=1 },
        { name="spinToX", frames={ 6, 7, 8, 11, 9, 10, 6, 7, 8, 11, 15, 16, 12, 13, 13, 12 }, time=500, loopCount=1 },
        { name="spinFromCheck", frames={ 1, 2, 3, 11, 4, 5, 1, 2, 3, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 },
        { name="spinFromX", frames={ 12, 13, 14, 11, 15, 16, 12, 13, 14, 11, 9, 10, 6, 7, 7, 6 }, time=500, loopCount=1 }
    
    }

    local sheetInfo = require("sign-sheet")
    local myImageSheet = graphics.newImageSheet( "images/sign-sheet.png", sheetInfo:getSheet() )
    local signSprite = display.newSprite( myImageSheet, sequenceData )
    signSprite.x = 654
    signSprite.y = 931
    signSprite:setFrame(1) -- 1 refers to the first frame in the sequence (6), not the frame number
    sceneGroup:insert( signSprite )

    local shader = display.newRect( display.contentWidth*0.5, display.contentHeight*0.5, display.contentWidth, display.contentHeight )
    shader:setFillColor( 0, 0, 0, 1 ) -- can't start object with an alpha of 0 or corona will not render it
    transition.to( shader, { time=1, alpha=0 } )
    
    local bannerStartY = -500
    local banner = display.newImageRect( "images/banner-512w.png", 569, 1004 ) -- PoT - upscaling smaller 512w to 569w
    banner.x = display.contentWidth*0.5
    banner.y = bannerStartY
    -- local banner = display.newImage( "images/banner.png", display.contentWidth*0.5, 425 )

    local function bannerDown()
        transition.to( banner, { time=500, y=425, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0.5 } )
        timer.performWithDelay( 4000, playAudio( "wheresMyGoblin" ) )
    end

    local function bannerUp( event )
        transition.to( banner, { time=500, y=bannerStartY, transition=easing.outSine } )
        transition.to( shader, { time=300, alpha=0 } )
        if (signState == "X") then
            signSprite:setSequence( "spinFromX" )
            signSprite:play()
            signState = "goblin"
        end
        return true
    end

    local posterDrop = display.newRect( 100, 925, 200, 200 )
    posterDrop:setFillColor( 1, 1, 1, 1 )
    posterDrop:addEventListener( "tap", bannerDown )

    shader:addEventListener( "tap", bannerUp )

    local function compareGoblins( event )
        print "Checking goblins"
        activeRibbonsText.text = "activeRibbons: " .. _myG.ribbon[1].activeBlock .. ", " .. _myG.ribbon[2].activeBlock .. ", " .. _myG.ribbon[3].activeBlock
        -- if user has a match
        if ( _myG.matchBlocks[1] == _myG.ribbon[1].activeBlock ) and ( _myG.matchBlocks[2] == _myG.ribbon[2].activeBlock ) and  ( _myG.matchBlocks[3] == _myG.ribbon[3].activeBlock ) then
            signSprite:setSequence( "spinToCheck" )
        else
            signSprite:setSequence( "spinToCheck" )
            --[[
            signState = "X"
            signSprite:setSequence( "spinToX" )
            -- bannerDown commands but with delay. refactor?
            timer.performWithDelay( 1000, bannerDown )
            ]]--
        end
        signSprite:play()
        return true
    end

    signSprite:addEventListener( "tap", compareGoblins )

--end scene:create
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
