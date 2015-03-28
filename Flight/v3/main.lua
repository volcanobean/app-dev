-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

-- set H and W of background area

local bgH = 2048
local bgW = 2048

-- generate min/max positions for camera's setBounds() function

local bgMinX = cX - bgW*0.5 + cW*0.5
local bgMaxX = cX + bgW*0.5 - cW*0.5
local bgMinY = cY - bgH*0.5 + cH*0.5
local bgMaxY = cY + bgH*0.5 - cH*0.5

local player
local pSpeed = 15
local playerSpeed = pSpeed
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

--[[
local blocker = {}
blocker[1] = display.newRect( bg2, 0, 0, 400, 300 )
blocker[1]:setFillColor( 0, 1, 0, 1 )
physics.addBody( blocker[1], "static", { density=1, friction=0.1, bounce=0.2 } )

blocker[2] = display.newRect( bg2, 400, 0, 100, 300 )
blocker[2]:setFillColor( 1, 1, 0, 1 )
physics.addBody( blocker[2], "static", { density=1, friction=0.1, bounce=0.2 } )
]]--

--[[
local bgSample1 = display.newImageRect( bg1, "images/bg-sample-1.png", bgW, bgH )
bgSample1.x = cX
bgSample1.y = cY

local bgSample2 = display.newImageRect( bg2, "images/bg-sample-2.png", bgW, bgH )
bgSample2.x = cX
bgSample2.y = cY

local bgSample3 = display.newImageRect( bg3, "images/bg-sample-3.png", bgW, bgH )
bgSample3.x = cX
bgSample3.y = cY

local bgSample4 = display.newImageRect( bg4, "images/bg-sample-4.png", bgW, bgH )
bgSample4.x = cX
bgSample4.y = cY

local bgSample5 = display.newImageRect( bg5, "images/bg-sample-5.png", bgW, bgH )
bgSample5.x = cX
bgSample5.y = cY
]]--

-- player

-- sprite sheet

local playerSheetInfo = require("fairy-sheet")
local playerSheet = graphics.newImageSheet( "images/fairy-sheet.png", playerSheetInfo:getSheet() )
local playerFrames = { start=1, count=4 }

--local yayHead = display.newSprite( yaySheet, yayHeadSequence )

local player = display.newSprite( playerSheet, playerFrames )
player:setFrame(3)
bg2:insert(player)
player.x = cX
player.y = cY
local playerShape = { 25,-50, 25,50, -25,50, -25,-50 }
physics.addBody( player, "dynamic", {shape=playerShape} )
player.isFixedRotation = true
player.domAxis = "horizontal"

--[[
-- Color glowballs to collect

local colorGlow = {}

-- Glow audio

local chimeFX = audio.loadSound( "audio/magic-chime-02.mp3" )

local function sparkle()
    audio.play( chimeFX )
end

local function onCollision( event )
    event.target:removeSelf()
    sparkle()
end 

-- Define creation of Glow

local function createGlow( number )
  colorGlow[number] = display.newCircle( bg2, 0, 0, 10 )
  colorGlow[number] = display.newImageRect( bg2, "images/color-sparkle.png", 100, 99)
  colorGlow[number].x = math.random( 20, 2980 )
  colorGlow[number].y = math.random( 10, 980 )
  local r = math.random( 0, 100 )
  local g = math.random( 0, 100 )
  local b = math.random( 0, 100 )
  colorGlow[number]:setFillColor( r/100, g/100, b/100 )
  physics.addBody( colorGlow[number], "static", { radius=20, isSensor=true })
  colorGlow[number]:addEventListener( "collision", onCollision )
end

-- Generate actual Glow objects

for i=1, 15 do
  createGlow(i)
  --Moving Glow
  local function moveGlow()
      transition.to( colorGlow[i], { time=math.random(1000, 20000), x=math.random(50, 700), y=math.random(80, 1000), onComplete=moveGlow })
  end
  moveGlow()
end 

-- dusk motes

local motes = {}
local motesBig = {}

-- Define creation of motes

local whichMote = motes[1]

local function removeMote()
  whichMote:removeSelf()
  return true
end

local function moteShake(event)
  print("mote tap")
  transition.to( event.target, {time=100, x=event.x+10} )
  transition.to( event.target, {delay=100, time=100, x=event.x-10} )
  transition.to( event.target, {delay=200, time=100, x=event.x+10} )
  transition.to( event.target, {delay=300, time=100, x=event.x-10} )
  transition.to( event.target, {delay=300, time=100, x=event.x-10} )
  if horzDir == "right" then
    transition.to( event.target, {delay=400, time=200, x=event.x+500} )
  else
    transition.to( event.target, {delay=400, time=200, x=event.x-500} )
  end
  whichMote = event.target
  timer.performWithDelay( 600, removeMote )
  return true
end

local function createMote( number )
  motes[number] = display.newImageRect( bg2, "images/dusk-mote.png", 45, 43)
  motes[number].x = math.random( 20, 2980 )
  motes[number].y = math.random( 10, 980 )
  local moteShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
  physics.addBody( motes[number], "static", {shape=moteShape} )
  motes[number]:addEventListener( "tap", moteShake )
end

local function createBigMote( number )
  motesBig[number] = display.newImageRect( bg2, "images/dusk-mote.png", 75, 70)
  motesBig[number].x = math.random( 20, 2980 )
  motesBig[number].y = math.random( 10, 980 )
  local moteShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
  physics.addBody( motesBig[number], "static", {shape=moteShape} )
  --motes[number]:addEventListener( "collision", onCollision )
end

-- Generate actual mote objects

for i=1, 6 do
  createMote(i)
  --Moving Glow
  local function moveMote()
    transition.to( motes[i], { time=math.random(1000, 20000), x=math.random(50, 700), y=math.random(80, 1000), onComplete=moveMote })
  end
  moveMote()
end 

for i=1, 1 do
  createBigMote(i)
  --Moving Glow
  local function moveMote()
      transition.to( motesBig[i], { time=math.random(1000, 20000), x=math.random(50, 700), y=math.random(80, 1000), onComplete=moveMote })
  end
  moveMote()
end 

]]--

local function getSprite()
  if touching == true then
    -- if moving
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

  -- which is "dominant axis"? Horz or vert?
  -- for use in logic to decide whether to play horz or vert quick turn animation
  if (pathAngle >= 0 and pathAngle <= 65)
    or (pathAngle <= 0 and pathAngle >= -65 ) 
    or (pathAngle >= -180 and pathAngle <= -115)
    or (pathAngle <= 180 and pathAngle >= 115 ) then
    -- if angle is between 315-360,0-45 or 135-225 we're vertical
    player.domAxis = "horizontal"
  elseif (pathAngle >= 66 and pathAngle <= 114)
    or (pathAngle <= -66 and pathAngle >= -114 ) then
    -- if angle if between 45-135 or 225-315 we're horizontal
    player.domAxis = "vertical"
  end

  -- debug
  --angleText.text = pathAngle
  --axisText.text = player.domAxis

  -- get per/frame rate of travel for each axis
  travelTime = distC/playerSpeed
  rateX = distA/travelTime
  rateY = distB/travelTime

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
  print(horzDir)

  -- get vertical direction (up/down/center) 
  if pStageY > tapStageY then
    vertDir = "up"
  elseif pStageY < tapStageY then
    vertDir = "down"
  elseif pStageY == tapStageY then
    vertDir = "center"
  end
  print(vertDir)

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
local endX
local startY
local endY

local function stageTouch(event)
  if event.phase == "began" then
    touching = true
    startTime = event.time
    --getPath(event.x, event.y)
    tapStageX = event.x
    tapStageY = event.y

    startX = event.x
    endX = event.x
  elseif event.phase == "moved" then
    --getPath(event.x, event.y)
    tapStageX = event.x
    tapStageY = event.y
    endX = event.x
  elseif event.phase == "ended" or event.phase == "cancelled" then
    touching = false
    endTime = event.time
    endX = event.x
    totalTime = endTime - startTime
    if ( totalTime < 400 ) and ( startX < endX+10 and startX > endX-10 ) then
      -- this is a tap
    end
  end
  return true
end

theStage:addEventListener("touch", stageTouch)

local function playerMove()
  -- on user touch
  if touching == true then

    getPath()

    -- horizontal movement
    if horzMove == true then
      if pStageX < tapStageX-10 or pStageX > tapStageX+10 then
        playerSpeed = pSpeed
        player.x = player.x + rateX
      end
    end

    -- vertical movement
    if vertMove == true then
       if pStageY < tapStageY-10 or pStageY > tapStageY+10 then
        playerSpeed = pSpeed
        player.y = player.y + rateY
      end
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


-- camera functions

-- setBounds() takes the dimensions of a rectangle as arguments, then clamps tracking to these bounds.
-- x1 is the min position the camera can be, x2 is the max, the same is true of y1 and y2.
-- Dimensions are given as "center of the screen can be at most/must be at least this value".

camera.damping = 10 -- A bit more fluid tracking
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
--camera:setBounds(x1, x2, y1, y2)
camera:setBounds( bgMinX, bgMaxX, bgMinY, bgMaxY)