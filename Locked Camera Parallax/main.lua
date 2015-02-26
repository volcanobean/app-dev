-- ==
--      lockedCamera() - Follows target exactly.
-- ==

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY


local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local require = require -- localize global require function?
local perspective = require("perspective")
local camera = perspective.createView()

local bgH = 1536
local bgW = 2500
local bgImage = display.newImageRect( "bg-grid-2500x1536.png", bgW, bgH )
bgImage.alpha = 0.5
bgImage.x = cX
bgImage.y = cY

local stage3 = display.newRect(cX, 0, 400, 800)
stage3:setFillColor( 0, 0, 1, 0.5 )

local stage2 = display.newRect(cX, 0, 300, 650)
stage2:setFillColor( 0, 1, 0, 0.5 )

local stage1 = display.newRect(cX, 0, 200, 500)
stage1:setFillColor( 1, 0, 0, 0.5 )


camera:add( stage3, 3)
camera:add( stage2, 4)
camera:add( stage1, 5)
camera:add( bgImage, 2)

camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3) -- Here we set parallax for each layer in descending order


local player = display.newCircle( cX, cY, 20 )
player:setFillColor(0,1,0)

camera:add(player, 1)

-- set initial variables
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
local pSpeed = 16

local distA
local distB
local distC
local rateX
local rateY

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
      player:translate( rateX, 0 )
   end

   -- vertical movement
   if vertMove==true then
      player:translate( 0, rateY )
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

Runtime:addEventListener( "enterFrame", movePlayer )

-- camera functions

camera.damping = 10 -- A bit more fluid tracking
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
camera:setBounds(-512, 2000, 0, 780)
