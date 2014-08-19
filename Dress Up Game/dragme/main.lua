local torsoHitArea = display.newRect( display.contentCenterX, 120, 150, 155 )
torsoHitArea:setFillColor( 0, 1, 1, 0.25 )

local legsHitArea = display.newRect( display.contentCenterX, 265, 150, 130 )
legsHitArea:setFillColor( 0, 1, 0, 0.25 )


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
    -- x0 is current X pos?
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
      if ( hasCollided( target, torsoHitArea) ) then
        --snap in place
        transition.to( target, {time=50, x=torsoHitArea.x, y=torsoHitArea.y} )
        print ( "Dragged to Torso ")
        print ( target.image )
      elseif ( hasCollided( target, legsHitArea) ) then
        transition.to( target, {time=50, x=legsHitArea.x, y=legsHitArea.y} )
        print ( "Dragged to Legs ")
        print ( target.image )
      else
        -- move back to original position
        transition.to( event.target, {time=50, x=target.xOrig, y=target.yOrig} )
      end
    end
  end
  return true
end


local item = display.newRect( 40, 80, 50, 75 )
-- store the initial coordinates for later use
item.xOrig = 40; item.yOrig = 80
item:setFillColor( 0, 0, 1, 1 )

item:addEventListener( "touch", dragItem )



-- Function to create a closet item

local function newClosetItem( itemGroup, itemNumber, xPos, yPos)
  --itemID = display.newRect( itemDrawer, xPos, yPos, 40, 40 )
  local itemID = itemGroup .. itemNumber
  local itemThumb = "images/" .. itemID .. "_th.png"
  local buttonName = itemGroup .. "Btn" .. itemNumber
  print ( buttonName )
  local buttonName = display.newImage( itemThumb, xPos, yPos )
  buttonName.xOrig = xPos; buttonName.yOrig = yPos
  buttonName.image = "images/" .. itemID .. ".png"
  buttonName:addEventListener( "touch", dragItem )

end

-- Create closet items

newClosetItem( "torso", "01", 40, 40 )
newClosetItem( "torso", "02", 40, 80 )
newClosetItem( "torso", "03", 40, 120 )