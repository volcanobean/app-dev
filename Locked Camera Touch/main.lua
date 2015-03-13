-- ==
--      lockedCamera() - Follows target exactly.
-- ==

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

--[[
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
]]--

--rectangle-based collision detection

local function hasCollided( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end
   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
   return (left or right) and (up or down)
end

--circle-based collision detection
local function hasCollidedCircle( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end

   local dx = obj1.x - obj2.x
   local dy = obj1.y - obj2.y

   local distance = math.sqrt( dx*dx + dy*dy )
   local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

   if ( distance < objectSize ) then
      return true
   end
   return false
end

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local require = require -- localize global require function?
local perspective = require("perspective")
local camera = perspective.createView()

local bgH = 1536
local bgW = 2500
local bgImage = display.newImageRect( "bg-grid-2500x1536.png", bgW, bgH )
bgImage.alpha = 0.25
bgImage.x = cX
bgImage.y = cY

local stage3 = display.newRect(cX, cY, 400, 800)
stage3:setFillColor( 0, 0, 1, 0.5 )

local stage2 = display.newRect(cX, cY, 300, 650)
stage2:setFillColor( 0, 1, 0, 0.5 )

local stage1 = display.newRect(cX, cY, 200, 500)
stage1:setFillColor( 1, 0, 0, 0.5 )


camera:add( stage3, 4)
camera:add( stage2, 5)
camera:add( stage1, 6)
camera:add( bgImage, 3)

camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3) -- Here we set parallax for each layer in descending order

local blocker = {}
blocker[1] = display.newRect( 0, 0, 400, 400 )
blocker[1]:setFillColor( 0, 1, 0, 1 )
--physics.addBody( blocker, "static", { density=1, friction=0.1, bounce=0.2 } )

blocker[2] = display.newRect( 400, 0, 100, 400 )
blocker[2]:setFillColor( 1, 1, 0, 1 )
--physics.addBody( blocker2, "static", { density=1, friction=0.1, bounce=0.2 } )

camera:add( blocker[1], 1)
camera:add( blocker[2], 1)

local player = display.newCircle( cX, cY, 40 )
--physics.addBody( player, "dynamic" )

camera:add(player, 2)

print( "player c bounds: " .. player.contentBounds.xMin )

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
local pSpeed = 30

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

-- Color glowballs to collect

local colorGlow = {}

-- Define creation of Glow

local function createGlow( number )
  colorGlow[number] = display.newCircle( 0, 0, 10 )
  colorGlow[number].x = math.random( 20, 2980 )
  colorGlow[number].y = math.random( 10, 980 )
  local r = math.random( 0, 100 )
  local g = math.random( 0, 100 )
  local b = math.random( 0, 100 )
  colorGlow[number]:setFillColor( r/100, g/100, b/100 )
  --physics.addBody( colorGlow[number], "static" 
  camera:add( colorGlow[number], 1)
end

-- Generate actual Glow objects

for i=1, 15 do
  createGlow(i)
  --Moving Glow
  local function moveGlow()
      transition.to( colorGlow[i], { time=math.random(1000, 20000), x=math.random(50, 700), y=math.random(80, 1000), onComplete=moveGlow })
  end
  moveGlow()
  --colorGlow[i]:addEventListener( "enterFrame", glowCollision )
end 

-- glow collision detection

local function glowHitCheck( event )
   for i = 1,table.maxn( colorGlow ) do
      if ( colorGlow[i] ~= nil and hasCollided( player, colorGlow[i]) ) then
         colorGlow[i]:setFillColor(1, 0, 0, 1)
         --display.remove( colorGlow[i] )
      end
   end
   return true
end

-- block collision detection

local function blockHitCheck( event )
   for i = 1,table.maxn( blocker ) do
      if ( blocker[i] ~= nil and hasCollided( player, blocker[i]) ) then
         blocker[i]:setFillColor(1, 0, 0, 1)
         --display.remove( blocker[i] )
      end
   end
   return true
end


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

   -- Check for collisions

   glowHitCheck(event)
   blockHitCheck(event)

   

end

-- add this enterFrame code to player object later?
Runtime:addEventListener( "enterFrame", movePlayer )

-- camera functions

camera.damping = 10 -- A bit more fluid tracking
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
camera:setBounds(-512, 2000, 0, 780)
