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

local worldLayer = display.newGroup()
--local stationaryLayer = display.newGroup() -- separate group for UI, etc

local bgH = 1536
local bgW = 2500
local bgImage = display.newImageRect( worldLayer, "bg-grid-2500x1536.png", bgW, bgH )
bgImage.x = cX
bgImage.y = cY

local tmp = display.newCircle( worldLayer, 250, 100, 10 )
tmp:setFillColor(1,1,0)

local tmp = display.newCircle( worldLayer, 250, 110, 10 )
tmp:setFillColor(0,1,1)

local player = display.newCircle( worldLayer, cX, cY, 20 )
player:setFillColor(0,1,0)

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
local pSpeed = 6

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

   -- get distance from point to point, generate travel time
   distA = tapX - pX
   distB = tapY - pY
   distC = math.sqrt(distA*distA + distB*distB) -- a2+b2=c2 (finding "C")
   travelTime = distC/pSpeed

   -- get destination X and Y positions relative to the player's local position for use in enterFrame code
   local tapOffsetX = player.x - pX
   local tapOffsetY = player.y - pY
   pDestX = tapOffsetX + tapX
   pDestY = tapOffsetY + tapY

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

-- Create camera function

local function lockedCamera( target, world  )   
   -- record initial position of target object
   -- store it in our world group (which will also contain our target object)
   world.lx = target.x
   world.ly = target.y

   -- Create enterFrame method and attach it to our world group
   world.enterFrame = function( event )
      -- calculate delta movement relative to stored target location
      local dx = target.x - world.lx
      local dy = target.y - world.ly

      if(dx) then -- if dx is not nil

         -- add condition to check for bg X boundaries
         -- only move if not at edge

         --if( xDirection == "right" and world.x > -1000) or ( xDirection == "left" and world.x < 1000)then
            -- move target (and world) based on deltas
            world:translate(-dx,0)
            -- set lx to new current position
            world.lx = target.x
         --end
      end
      if(dy) then -- if dy is not nil

         -- add condition to check for bg Y boundaries
         -- only move if not at edge

         -- move target (and world) based on deltas
         world:translate(0,-dy)
         -- set ly to new current position
         world.ly = target.y
      end
      return true
   end

   -- Begin enterFrame code (runs on every frame)
   Runtime:addEventListener( "enterFrame", world )
end

lockedCamera( player, worldLayer )
