-- ==
--      lockedCamera() - Follows target exactly.
-- ==

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

-- Create camera function

local xDirection

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

local function playerMover( obj )
   if( obj.step == nil ) then 
      obj.step = 1
   end

   if( obj.step == 1 ) then
      if( obj.x < 300 ) then
         obj.x = obj.x + 2
      else
         obj.step = 2
      end
   elseif( obj.step == 2 ) then
      if( obj.y < 150 ) then
         obj.y = obj.y + 2
      else
         obj.step = 3
      end
   elseif( obj.step == 3 ) then
      if( obj.x > 100 ) then
         obj.x = obj.x - 2
      else
         obj.step = 4
      end
   elseif( obj.step == 4 ) then
      if( obj.y > 100 ) then
         obj.y = obj.y - 2
      else
         obj.step = 1
      end
   end      
end

pStartX = player.x
pStartY = player.y

local function stageTap( event )
   print( "------" )
   print( "Stage tapped." )
   print( "Event coordinates: ", event.x, event.y ) 
   local playerScreenX, playerScreenY = player:localToContent( 0, 0 )
   local newX = event.x - playerScreenX
   print( "Player screen coordinates: ", playerScreenX, playerScreenY )
   local playerLocalX, playerLocalY = player:contentToLocal( 0, 0 )
   print( "Player local coordinates: ", playerLocalX, playerLocalY )
   --transition.to( player, {time=400, x=playerScreenX + newX, y=event.y})
   print( "player.x: " .. player.x )
   print( "worldLayer.x: " .. worldLayer.x )
   if( pStartX < event.x ) then
      print( "Tap to right of player" )
      xDirection = "right"
      player:translate( 100, 0 )
      --moveRight()
   elseif( pStartX > event.x ) then
      print( "Tap to left of player" )
      xDirection = "left"
      player:translate( -100, 0 )
      --moveLeft()
   elseif( pStartX == event.x ) then
      print( "x center")
   end
   if( pStartY < event.y ) then
      print( "Tap below player" )
      --moveRight()
   elseif( pStartY > event.y ) then
      print( "Tap above player" )
      --moveLeft()
   elseif( pStartY == event.y ) then
      print( "y center")
   end
   return true
end

stageHit:addEventListener( "tap", stageTap )

--player.enterFrame = playerMover

--Runtime:addEventListener( "enterFrame", player )
lockedCamera( player, worldLayer )
