-- Block settings - adjust these settings as needed

local scrollGroupX = 0
local scrollGroupXText = display.newText( "X: " .. scrollGroupX, display.contentCenterX, 50, native.systemFont, 30 )

local blockGroup1 
local blockGroup2

local blockCount = 3
local blockWidth = 300
local blockHeight = 250
local blockMargin = 15

local ribbonX = (display.contentWidth - blockWidth)/2 - blockMargin
local ribbonStartX = ribbonX -- store starting X value for future reference

local blockGroupWidth = (blockWidth+blockMargin)*blockCount
local blockGroupCenter = ribbonStartX - ( blockGroupWidth/2 - blockWidth/2 - blockMargin/2 )

local blockGroupText = display.newText( "Start X: " .. ribbonStartX .. ", Width: " .. blockGroupWidth .. ", Center: " .. blockGroupCenter, display.contentCenterX, 90, native.systemFont, 30 )


-- Event function for ribbon drag/scroll interactions

local function scrollMe( event )
    -- ON PRESS:
    if ( event.phase == "began" ) then
        -- set focus to target so corona will track finger even when it leaves the target area (as long as finger is still touching screen)
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        
        -- get touch position offset to prevent awkward snapping of ribbon to user's finger
        event.target.offset = event.x - event.target.x
        scrollGroupXText.text = "X: " .. event.target.x

    -- ON MOVE:
    elseif ( event.target.isFocus ) then
        if ( event.phase == "moved" ) then
            -- START DRAG:
            event.target.x = event.x - event.target.offset
            -- debug
            scrollGroupXText.text = "X: " .. event.target.x

            -- group swap
            if ( event.target.x > blockGroupCenter ) then
                -- invert blockGroup2 to the left
                blockGroup2.x = -blockGroupWidth
            elseif ( event.target.x < blockGroupCenter ) then
                -- move blockGroup2 back to the right
               blockGroup2.x = blockGroupWidth
            end

        -- ON RELEASE: 
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            -- remove button focus once finger is lifted from screen
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
        end
    end
    -- for event functions, always return true to prevent touch propagation to underlying objects
    return true  
end

-- Create guide for center of screen

--display.newRect( parent, x, y, width, height )
local centerRule = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerRule:setFillColor( 0, 1, 1, 0.25 )

local scrollGroup = display.newGroup()
scrollGroup:addEventListener( "touch", scrollMe )
scrollGroup.y = 400
scrollGroup.x = ribbonX
--scrollGroup.x = (display.contentWidth - blockWidth)/2

-- block groups inside scroll group
blockGroup1 = display.newGroup()
scrollGroup:insert( blockGroup1 )
blockGroup1.x = 0
--blockGroup1.x = blockGroupWidth/2

blockGroup2 = display.newGroup()
scrollGroup:insert( blockGroup2 )
blockGroup2.x = -blockGroupWidth
--blockGroup2.x = blockGroupWidth/2 + blockGroupWidth
--blockGroup2.x = blockWidth/2 * -1

local blocks1 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    blocks1[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    blocks1[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    blocks1[i]:setFillColor( 0, 1, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroup1:insert( blocks1[i] )
end

local blocks2 = {}
for i=1, blockCount do
    -- Automatically calculate block layout within parent group based on height, width and margin values.
    blocks2[i] = display.newRect( blockWidth/2, 0, blockWidth, blockHeight )
    blocks2[i].x = (( blockMargin + blockWidth ) * i) - blockWidth/2
    blocks2[i]:setFillColor( 1, 0, 1, 0.25 )
    -- Add to group, x, y values are relative to top, left
    blockGroup2:insert( blocks2[i] )
end