-- local variables, adjust these settings as needed
local blockCount = 5
local blockWidth = 600
local blockHeight = blockWidth/1.5
local blockMargin = 15
--local ribbonLength = (blockWidth + blockMargin)*blockCount
local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonY = 600
-- store strating X value for future reference
local ribbonStartX = ribbonX
--local ribbonEndX = (ribbonLength - display.contentWidth + blockMargin) * -1
local activeBlock = 1
local activeBlockCenter


-- DEBUG
local ribbonXText = display.newText( "Ribbon X: " .. ribbonX, display.contentCenterX, 50, native.systemFont, 30 )
local ribbonStartXText = display.newText( "Ribbon Start X: " .. ribbonStartX, display.contentCenterX, 100, native.systemFont, 30 )
--local ribbonLengthText = display.newText( "Ribbon Length: " .. ribbonLength, display.contentCenterX, 150, native.systemFont, 30 )
local activeBlockText = display.newText( "ActiveBlock: " .. activeBlock, display.contentCenterX, 200, native.systemFont, 30 )


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


-- Generate Block End Values
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


-- Active block check
local function getActiveBlock( currentX )
    if ( currentX < blockEnd[3] ) and ( currentX > blockEnd[4] ) then
        activeBlock = 4
    elseif ( currentX < blockEnd[2] ) and ( currentX > blockEnd[3] ) then
        activeBlock = 3
    elseif ( currentX < blockEnd[1] ) and ( currentX > blockEnd[2] ) then
        activeBlock = 2
    elseif ( currentX > blockEnd[1] ) then
        activeBlock = 1
    end
    -- debug
    activeBlockText.text = "ActiveBlock: " .. activeBlock
end


-- Event function for icon button interaction
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

            -- Scroll constraints:
                -- Snap to beginning
                --if ( event.target.x > ribbonStart ) then
                --    transition.to( event.target, { time=0, x=ribbonStart } ) 
                --end
                -- Snap to end
                --if ( event.target.x < ribbonEnd ) then
                --    transition.to( event.target, { time=0, x=ribbonEnd } ) 
                --end
        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then        
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false 
        end
    end
    -- on event functions, always return true to prevent touch propagation to underlying objects
    return true  
end


-- Create hit area for center of screen
--display.newRect( parent, x, y, width, height )
local centerHitArea = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerHitArea:setFillColor( 0, 1, 1, 0.25 )


-- Create scrollable ribbon group
local ribbon = display.newGroup()
ribbon:addEventListener( "touch", ribbonScroll )
ribbon.x = ribbonX
ribbon.y = ribbonY


-- Automatically calculate block layout within parent group based on height, width and margin values.
local function createBlock( blockName, blockNum )
    local blockName = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    blockName.x = (( blockMargin + blockWidth ) * blockNum) - blockWidth/2
    -- Add to group with a separate function so that x, y values are relative to top, left
    blockName.group = ribbon
    blockName.group:insert( blockName )
end


-- Generate actual blocks using For loop, once for each block in the blockCount variable
-- for i=minVal, max value do
for i=1, blockCount do
    local blockTitle = "block" .. i
    --print ( blockTitle )
    createBlock( blockTitle, i )
end