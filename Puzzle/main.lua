-- Drag and drop

local hitArea = display.newRect( 200, 100, 50, 75 )
hitArea.x = 200; hitArea.y = 100
hitArea:setFillColor( 1, 1, 1, 0.25 )

local item = display.newRect( 100, 100, 50, 75 )
-- store the initial coordinates for later use
item.xOrig = 100; item.yOrig = 100
item:setFillColor( 0, 0, 1, 1 )
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

-- Create drag and drop event function

local function dragItem( event )
  local target = event.target
  local phase = event.phase

  -- If a touch has started on the screen
  if ( phase == "began" ) then
    display.getCurrentStage():setFocus( target )
    target.isFocus = true
    -- x0 is cX offset
    target.x0 = event.x - target.x
    target.y0 = event.y - target.y
    target.xStart = target.x
    target.yStart = target.y
    target:toFront()
  elseif ( target.isFocus ) then
    if( phase == "moved") then
      target.x = event.x - target.x0
      target.y = event.y - target.y0
    elseif ( phase == "ended" or phase == "cancelled" ) then
      display.getCurrentStage():setFocus( nil )
      target.isFocus = false
      -- Detect collision with hit area
      if ( hasCollided( target, hitArea) ) then
        --snap in place
        transition.to( target, {time=50, x=hitArea.x, y=hitArea.y} )
      else
        -- move back to original position
        transition.to( event.target, {time=50, x=target.xOrig, y=target.yOrig} )
      end
    end
  end
  return true
end

-- Create pieces

local m1 = graphics.newMask( "images/puzzle-mask.png" )
local m2 = graphics.newMask( "images/puzzle-mask.png" )

-- display.newImageRect( [parentGroup,] filename, [baseDirectory] width, height )
local p1 = display.newImageRect( "images/mermaid.jpg", 1024, 768 )
p1.x = display.contentWidth*0.5
p1.y = display.contentHeight*0.5
p1:setMask( m1 )
p1.maskRotation = -90
p1.maskX = 10
p1.maskY = 0
p1:addEventListener( "touch", dragItem )

local p2 = display.newImageRect( "images/mermaid.jpg", 1024, 768 )
p2.x = display.contentWidth*0.5
p2.y = display.contentHeight*0.5
p2:setMask( m2 )
p2.maskX = 0
p2.maskY = 150
p2:addEventListener( "touch", dragItem )