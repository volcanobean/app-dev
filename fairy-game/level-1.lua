---------------------------------------------------------------------------------
--
-- level-1.lua
--
---------------------------------------------------------------------------------

-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.

print ("start of scene1")
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



-- set H and W of background area

local bgH = 2048
local bgW = 2048

-- generate min/max positions for camera's setBounds() function

local bgMinX = cX - bgW*0.5 + cW*0.5
local bgMaxX = cX + bgW*0.5 - cW*0.5
local bgMinY = cY - bgH*0.5 + cH*0.5
local bgMaxY = cY + bgH*0.5 - cH*0.5

local player
--local pSpeed = 20
local gravity = 5
--local playerSpeed = pSpeed
local theStage
local touching = false

-- set initial variables
local horzDir
local vertDir
local horzMove = true
local vertMove = true

local pStageX
local pStageY
local tapStageX
local tapStageY

local distA
local distB
local distC
local rateX
local rateY
local pathAngle = 0

local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--physics.setDrawMode( "hybrid" )  --overlays collision outlines on normal display objects
--physics.setDrawMode( "normal" )  --the default Corona renderer, with no collision outlines
--physics.setDrawMode( "debug" )   --shows collision engine outlines only

-- stage

local theStage = display.newRect( cX, cY, cW, cH)
theStage.isVisible = false
theStage.isHitTestable = true

-- camera

local require = require -- localize global require function?
local perspective = require("perspective")
local camera = perspective.createView()

-- Here we set parallax for each layer in descending order
-- layer 1 (1) will move more, layer 5 (0.6) will move less
camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)
--camera:setParallax(1, 0.9, 0.7, 0.5, 0.3)

local staticGroup = display.newGroup()

-- debug

--local angleText = display.newText( "0", cX, 50, native.systemFont, 30 )
--local axisText = display.newText( "horizontal", cX, 100, native.systemFont, 30 )

--[[
local txt1 = display.newText( staticGroup, "0, 0", cX, 150, native.systemFont, 30 )
local txt2 = display.newText( staticGroup, "0, 0", cX, 200, native.systemFont, 30 )
local txt3 = display.newText( staticGroup, "center", cX, 150, native.systemFont, 30 )
local txt4 = display.newText( staticGroup, "center", cX, 200, native.systemFont, 30 )
]]--

-- background

local bg1 = display.newGroup() -- foreground, objects in front of player
local bg2 = display.newGroup() -- middle ground, player and collidable objects
local bg3 = display.newGroup() -- background 
local bg4 = display.newGroup() -- more background
local bg5 = display.newGroup() -- extreme background

camera:add(bg1, 1)
camera:add(bg2, 2)
camera:add(bg3, 3)
camera:add(bg4, 4)
camera:add(bg5, 5)

local bgGrid = display.newImageRect( bg2, "images/bg-grid-2048x2048.png", 2048, 2048 )
bgGrid.x = cX
bgGrid.y = cY

-- player

-- sprite sheet

local playerSheetInfo = require("fairy-sheet")
local playerSheet = graphics.newImageSheet( "images/fairy-sheet.png", playerSheetInfo:getSheet() )
local playerFrames = { start=1, count=4 }

--local yayHead = display.newSprite( yaySheet, yayHeadSequence )

player = display.newSprite( playerSheet, playerFrames )
player:setFrame(3)
bg2:insert(player)
player.x = cX
player.y = cY
local playerShape = { 25,-50, 25,50, -25,50, -25,-50 }
physics.addBody( player, "dynamic", {shape=playerShape} )
player.isFixedRotation = true
player.domAxis = "horizontal"

player.moveSpeed = 15                 -- Current movement speed, default is 0, no movement
player.linearDamping = 0.9             -- Linear damping rate, 0 is dead stop, increase for a more gradual deceleration
player.linearAcceleration = 1.25     -- Linear acceleration rate, increase speed of movement by 5%
player.linearMax = 30                -- Max linear velocity, to cap accelration
player.linearMin = player.moveSpeed  -- Min linear velocity, to cap deceleration
player.boost = false

local function getSprite()
  if touching == true then
    -- if moving

    -- which is "dominant axis"? Horz or vert?
    -- for use in logic to decide whether to play horz or vert quick turn animation
    if (pathAngle >= 0 and pathAngle <= 65) or (pathAngle <= 0 and pathAngle >= -65 ) or (pathAngle >= -180 and pathAngle <= -115) or (pathAngle <= 180 and pathAngle >= 115 ) then
      -- if angle is between 315-360,0-45 or 135-225 we're vertical
      player.domAxis = "horizontal"
      -- tilt player slightly at certain angles for smoother animation
      if(pathAngle <= -45 and pathAngle >= -65) then
        player.rotation = -20
      elseif (pathAngle <= -115 and pathAngle >= -135) then
        player.rotation = 20
      elseif(pathAngle <= 65 and pathAngle >= 45) then
        player.rotation = 20
      elseif(pathAngle <= 135 and pathAngle >= 115) then
        player.rotation = -20
      else
        player.rotation = 0
      end
    elseif (pathAngle >= 66 and pathAngle <= 114) or (pathAngle <= -66 and pathAngle >= -114 ) then
      -- if angle if between 45-135 or 225-315 we're horizontal
      player.domAxis = "vertical"
      player.rotation = 0
    end

    if player.domAxis == "vertical" then
      if vertDir == "up" then
        player:setFrame(4)
      elseif vertDir == "down" then
        player:setFrame(1)
      end
    elseif player.domAxis == "horizontal" then
      -- play move
      player:setFrame(2)
    end
  elseif touching == false then
    -- if not moving, play hover
    player:setFrame(3)
    player.rotation = 0
  end
end

local function getPath()
  -- get content (stage) coordinates for player and for stage tap
  pStageX, pStageY = player:localToContent(0, 0)

  -- get distance from point to point
  distA = tapStageX - pStageX
  distB = tapStageY - pStageY
  distC = math.sqrt(distA*distA + distB*distB) -- a2+b2=c2 (finding "C")

  -- get angle of line created by two points, converted from radians to degrees
  -- 1 radian = 57.2957795 degrees
  --pathAngle = (distB/distA)*57.2957795
  pathAngle = math.atan2(distB, distA)*180/3.14

  -- debug
  --angleText.text = pathAngle
  --axisText.text = player.domAxis

  if player.boost == true then
    player.moveSpeed = player.moveSpeed * player.linearAcceleration
    player.moveSpeed = math.min(player.moveSpeed, player.linearMax)
  elseif player.boost == false then
    player.moveSpeed = player.moveSpeed * player.linearDamping
    player.moveSpeed = math.max(player.moveSpeed, player.linearMin)
  end

  -- get per/frame rate of travel for each axis
  travelTime = distC/player.moveSpeed
  rateX = distA/travelTime
  rateY = distB/travelTime

  --debug

  --txt1.text = distA
  --txt2.text = distB
    --[[
  txt3.text = horzDir
  txt4.text = vertDir
  ]]--
end

local startTime
local endTime
local totalTime = 0
local startX
local startY
local endX
local endY

local function dashRight()
  transition.to(player, {time=150,x=player.x+400})
end

local function stageTouch(event)
  if event.phase == "began" then
    touching = true

    startTime = event.time

    tapStageX = event.x
    tapStageY = event.y

    startX = event.x
    startY = event.y
    endX = event.x
    endY = event.y
  elseif event.phase == "moved" then
    tapStageX = event.x
    tapStageY = event.y

    endX = event.x
    endY = event.y
  elseif event.phase == "ended" or event.phase == "cancelled" then
    touching = false
    endTime = event.time

    endX = event.x
    endY = event.y
    totalTime = endTime - startTime

    -- SWIPING
    if ( totalTime < 200 ) then
      local difX = endX - startX
      local difY = endY - startY

      if endX > startX and difX > difY then
        print( "Swipe RIGHT")
        player.xScale = 1
        transition.to(player, {time=200,x=player.x+400})
      elseif endX < startX and difX < difY then 
        print( "Swipe LEFT")
        player.xScale = -1
        transition.to(player, {time=200,x=player.x-400})
      elseif endY > startY and difY > difX then
        print( "Swipe DOWN")
        transition.to(player, {time=200,y=player.y+400})
      elseif endY < startY and difY < difX then
        print( "Swipe UP")
        transition.to(player, {time=200,y=player.y-400})
      end

    end
  end
  return true
end

theStage:addEventListener("touch", stageTouch)

-- enter frame movement function

local function playerMove()
  -- on user touch
  if touching == true then

    getPath()

    -- horizontal movement
    if horzMove == true then
      if pStageX < tapStageX-10 or pStageX > tapStageX+10 then
        --playerSpeed = pSpeed
        player.x = player.x + rateX
        --player:applyForce(rateX,0)
      end
    end

    -- vertical movement
    if vertMove == true then
       if pStageY < tapStageY-10 or pStageY > tapStageY+10 then
        --playerSpeed = pSpeed
        player.y = player.y + rateY
        --player:applyForce(0,rateY)
      end
    end

    -- get horzontal direction (left/right/center)
    if pStageX < tapStageX then
      horzDir = "right"
      player.xScale = 1
    elseif pStageX > tapStageX then
      horzDir = "left"
      player.xScale = -1
    elseif pStageX == tapStageX then
      horzDir = "center"
    end
    --print(horzDir)

    -- get vertical direction (up/down/center) 
    if pStageY > tapStageY then
      vertDir = "up"
    elseif pStageY < tapStageY then
      vertDir = "down"
    elseif pStageY == tapStageY then
      vertDir = "center"
    end

    -- if the player has reached (or passed) the tap x position, stop horz movement
    if horzDir == "right" and pStageX > tapStageX then
      horzMove = false
    elseif horzDir == "left" and pStageX < tapStageX then
      horzMove = false
    elseif horzDir == "center" then
      horzMove = false
    else
      horzMove = true
    end

    -- if the player has reached (or passed) the tap y position, stop vert movement
    if vertDir == "up" and pStageY < tapStageY then
      vertMove = false
    elseif vertDir == "down" and pStageY > tapStageY then
      vertMove = false
    elseif vertDir == "center" then
      vertMove = false
    else
      vertMove = true
    end

    -- Check for collisions (add functions here)
  end

  -- display appropriate sprite based on current movement
  getSprite()

end

Runtime:addEventListener("enterFrame", playerMove)

-- other stuff

local function boostButton(event)
  if event.phase == "began" then
    player.boost = true
  elseif event.phase == "moved" then
    -- nuthin
  elseif event.phase == "ended" or event.phase == "cancelled" then
    player.boost = false
  end
  return true
end

local button = display.newCircle( 60, cH-60, 75 )
button:addEventListener( "touch", boostButton )


-- camera functions

-- setBounds() takes the dimensions of a rectangle as arguments, then clamps tracking to these bounds.
-- x1 is the min position the camera can be, x2 is the max, the same is true of y1 and y2.
-- Dimensions are given as "center of the screen can be at most/must be at least this value".

camera.damping = 10 -- A bit more fluid tracking
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
camera:setBounds( bgMinX, bgMaxX, bgMinY, bgMaxY) -- camera:setBounds(x1, x2, y1, y2)

--

local titleTxt = display.newText( "Level 1", cX, 100, native.systemFont, 75 )

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
