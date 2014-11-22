---------------------------------------------------------------------------------
--
-- missing-poster.lua
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
function scene:create( event )
    local sceneGroup = self.view

    -- game title
    local titleText = display.newText( "Where's My Goblin?", display.contentCenterX, 100, native.systemFont, 40 )
    sceneGroup:insert( titleText )

    -- create Next button
    local function nextScene()
        composer.gotoScene( "gameplay", "fade", 400 )
    end
    
    local nextBtn = display.newText( "--next--", display.contentCenterX, 900, native.systemFont, 30 )
    nextBtn:addEventListener( "tap", nextScene )
    sceneGroup:insert( nextBtn )

    -- Randomize function

    _myG.matchBlocks = {}
    _myG.matchBlocks[1] = 1
    _myG.matchBlocks[2] = 1
    _myG.matchBlocks[3] = 1
    local matchBlocksText = display.newText( "Head: " .. _myG.matchBlocks[1] .. ", Body: " .. _myG.matchBlocks[2] .. ", Legs: " .. _myG.matchBlocks[3], 575, 1000, native.systemFont, 30 )
    sceneGroup:insert( matchBlocksText )

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

    local randomizeBtn = display.newText( "--RANDOMIZE--", display.contentCenterX, 150, native.systemFont, 30 )
    randomizeBtn:addEventListener( "tap", randomizeBlocks )
    sceneGroup:insert( randomizeBtn )

    -- Generate random goblin values on first scene load
    randomizeBlocks()
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
