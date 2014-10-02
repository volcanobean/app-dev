-- local variables, adjust these settings as needed
local blockCount = 5
local blockWidth = 500
local blockHeight = blockWidth/1.5
local blockMargin = 15


-- more local variables, don't touch
local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonY = 600
local ribbonStartX = ribbonX -- store starting X value for future reference
local activeBlock = 1
local activeBlockSnap = ribbonX


-- DEBUG
local ribbonXText = display.newText( "Ribbon X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )
local ribbonStartXText = display.newText( "Ribbon Start X: " .. ribbonStartX, display.contentCenterX, 100, native.systemFont, 30 )
local activeBlockText = display.newText( "Active Block: " .. activeBlock, display.contentCenterX, 150, native.systemFont, 30 )
local activeBlockSnapText = display.newText( "Active Block Snap: " .. activeBlockSnap, display.contentCenterX, 200, native.systemFont, 30 )


-- Hit Check - rectangle-based collision detection
local function hasCollided( obj1, obj2 )
   if ( obj1 == nil ) or ( obj2 == nil ) then  -- make sure the objects exists
      return false
   end
   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
   return (left or right) and (up or down)
end


-- Generate Block End values
-- Since we can't dynamically generate variable names, we create a table/array to store and retrieve values
local blockEnd = {}
-- our first block end requires a different formula than the others because it starts with a positive X value and not at 0
blockEnd[1] = (blockWidth/2 + blockMargin - ribbonStartX) * -1
print( blockEnd[1] )
-- starting with block 2 generate block end values, for use in finding the current active block based on parent group's x position
for i=2, blockCount do
    blockEnd[i] = blockEnd[1] - ((blockWidth + blockMargin) * (i - 1))
    print( blockEnd[i] )
end


-- Generate Block Center values
local blockSnap = {}
for i=1, blockCount do
    blockSnap[i] = blockEnd[i] + (blockWidth/2) + blockMargin;
    print( blockSnap[i] )
end


-- Active block check, compare ribbon's current x pos to block end positions to determine active block
local function getActiveBlock( currentX )
    for i=1, blockCount do
        -- first block needs conditions to be checked
        if ( i == 1 ) and ( currentX > blockEnd[1] ) then
            activeBlock =  i
            activeBlockSnap = blockSnap[i]
        -- all other blocks follow same pattern
        elseif ( i ~= 1 ) and ( currentX < blockEnd[i-1] ) and ( currentX > blockEnd[i] ) then
            activeBlock = i
            activeBlockSnap = blockSnap[i]
        end
    end
    -- debug
    activeBlockText.text = "Active Block: " .. activeBlock
    activeBlockSnapText.text = "Active Block Snap: " .. activeBlockSnap
end


-- Event function for ribbon interaction
local function ribbonScroll( event )
    -- ON PRESS:
    if ( event.phase == "began" ) then
        -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        -- get touch position offset
        event.target.offset = event.x - event.target.x
    -- ON MOVE:
    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then  
            -- START DRAG:
            event.target.x = event.x - event.target.offset
            -- Check for active block
            getActiveBlock( event.target.x )
            --debug
            ribbonXText.text = "Ribbon X: " .. event.target.x

        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- snap to nearest block
            transition.to( event.target, { time=150, x=activeBlockSnap } )        
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false 
        end
    end
    -- for event functions, always return true to prevent touch propagation to underlying objects
    return true  
end


-- Create hit area for center of screen
--display.newRect( parent, x, y, width, height )
local centerHitArea = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerHitArea:setFillColor( 0, 1, 1, 0.25 )


-- Create scrollable ribbon group
local ribbon = display.newGroup()
ribbon:addEventListener( "touch", ribbonScroll )
ribbon.x = ribbonX -- use variables from top
ribbon.y = ribbonY -- use variables from top


-- Create blocks - Generate blocks based on block count
local block = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    block[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    block[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    -- Add to group, x, y values are relative to top, left
    ribbon:insert( block[i] )
end

