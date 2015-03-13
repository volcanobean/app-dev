-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

-- set H and W of background area

local bgH = 1536
local bgW = 2500

-- generate min/max positions for camera's setBounds() function

local bgMinX = cX - bgW*0.5 + cW*0.5
local bgMaxX = cX + bgW*0.5 - cW*0.5
local bgMinY = cY - bgH*0.5 + cH*0.5
local bgMaxY = cY + bgH*0.5 - cH*0.5

local pSpeed = 16

local horzDir
local vertDir
local horzMove = false
local vertMove = false

local tapX
local tapY
local pX
local pY
local pDestX
local pDestY

local distA
local distB
local distC
local rateX
local rateY

-- stage

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit.isVisible = false
stageHit.isHitTestable = true

-- camera

local require = require -- localize global require function?
local perspective = require("perspective")
local camera = perspective.createView()

-- Here we set parallax for each layer in descending order
-- layer 1 (1) will move more, layer 5 (0.6) will move less
camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3)
--camera:setParallax(1, 0.9, 0.7, 0.5, 0.3)

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

--[[
local bgImage = display.newImageRect( bg1, "images/bg-grid-2500x1536.png", bgW, bgH )
bgImage.x = cX
bgImage.y = cY
print(bg1.x,bg1.y)
print(bgImage.x,bgImage.y)

local bgImage2 = display.newImageRect( bg4, "images/bg-grid-2500x1536.png", bgW, bgH )
bgImage2:setFillColor(0,1,1,0.5)
bgImage2.x = cX
bgImage2.y = cY
]]--

-- player

local player = display.newCircle( bg2, cX, cY, 40 )
player:setFillColor(1,0,0,1)

--[[
local zeroZero = display.newCircle( bg1, 0, 0, 20 )
zeroZero:setFillColor(1,0,0,1)

local center = display.newCircle( bg1, cX, cY, 20 )
center:setFillColor(0,1,0,1)
]]--

-- Movement functions

local function stageTap( event )

   -- get content (stage) coordinates for player
   pX, pY = player:localToContent( 0, 0 )
   tapX = event.x
   tapY = event.y

   -- get destination X and Y positions relative to the player's local position for use in enterFrame code
   local tapOffsetX = player.x - pX
   local tapOffsetY = player.y - pY
   pDestX = tapOffsetX + tapX
   pDestY = tapOffsetY + tapY

   -- get distance from point to point, generate travel time
   distA = tapX - pX
   distB = tapY - pY
   distC = math.sqrt(distA*distA + distB*distB) -- a2+b2=c2 (finding "C")
   travelTime = distC/pSpeed

   -- get per/frame rate of travel for each axis
   rateX = distA/travelTime
   rateY = distB/travelTime

   -- get horzontal direction (left/right/center)
   if pX < tapX then
      horzDir = "right"
   elseif pX > tapX then
      horzDir = "left"
   elseif pX == tapX then
      horzDir = "center"
   end
   print(horzDir)

   -- get vertical direction (up/down/center) variables
   if pY > tapY then
      vertDir = "up"
   elseif pY < tapY then
      vertDir = "down"
   elseif pY == tapY then
      vertDir = "center"
   end
   print(vertDir)

   -- allow movement
   horzMove=true
   vertMove=true
end

stageHit:addEventListener( "tap", stageTap )

-- Creat player movement function 

local function movePlayer(event)

   -- horizontal movement
   if horzMove==true then
      player.x = player.x + rateX
      --player:translate( rateX, 0 )
   end

   -- vertical movement
   if vertMove==true then
      player.y = player.y + rateY
      --player:translate( 0, rateY )
   end

   -- if we have reached (or passed) our target x position, stop horz movement
   if horzDir == "right" and player.x > pDestX then
      horzMove=false
   elseif horzDir == "left" and player.x < pDestX then
      horzMove=false
   elseif horzDir == "center" then
      horzMove=false
   end
   --print( "horzMove: ", horzMove )

   -- if we have reached (or passed) our target y position, stop vert movement
   if vertDir == "up" and player.y < pDestY then
      vertMove=false
   elseif vertDir == "down" and player.y > pDestY then
      vertMove=false
   elseif vertDir == "center" then
      vertMove=false
   end
   --print( "vertMove: ", vertMove )
  
end

-- add this enterFrame code to player object later?
Runtime:addEventListener( "enterFrame", movePlayer )

-- camera functions

-- setBounds() takes the dimensions of a rectangle as arguments, then clamps tracking to these bounds.
-- x1 is the min position the camera can be, x2 is the max, the same is true of y1 and y2.
-- Dimensions are given as "center of the screen can be at most/must be at least this value".

camera.damping = 10 -- A bit more fluid tracking
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
--camera:setBounds(x1, x2, y1, y2)
camera:setBounds( bgMinX, bgMaxX, bgMinY, bgMaxY)