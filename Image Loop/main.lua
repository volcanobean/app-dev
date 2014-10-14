local scrollGroupX = 0
local scrollGroupXText = display.newText( "X: " .. scrollGroupX, display.contentCenterX, 50, native.systemFont, 30 )

local blockGroup1 
local blockGroup2

local blockWidth = 900

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
            if ( event.target.x > 10 ) then
                -- invert blockGroup2 to the left
                blockGroup2.x = blockWidth/2 * -1
            elseif ( event.target.x < -120 ) then
                -- move blockGroup2 back to the right
                blockGroup2.x = blockWidth/2 + blockWidth
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
local centerArea = display.newRect( display.contentCenterX, 500, 10, 1000 )
centerArea:setFillColor( 0, 1, 1, 0.25 )

local scrollGroup = display.newGroup()
scrollGroup:addEventListener( "touch", scrollMe )
scrollGroup.y = 400
scrollGroup.x = 0
--scrollGroup.x = (display.contentWidth - blockWidth)/2

-- block groups inside scroll group
blockGroup1 = display.newGroup()
scrollGroup:insert( blockGroup1 )
blockGroup1.x = blockWidth/2

blockGroup2 = display.newGroup()
scrollGroup:insert( blockGroup2 )
blockGroup2.x = blockWidth/2 + blockWidth
--blockGroup2.x = blockWidth/2 * -1

-- colored block placeholders
local blockMock1 = display.newRect( 0, 0, blockWidth, 200 )
blockMock1:setFillColor( 0, 1, 1, 0.25 )
blockGroup1:insert( blockMock1 )

local blockMock2 = display.newRect( 0, 0, blockWidth, 200 )
blockMock2:setFillColor( 1, 0, 1, 0.25 )
blockGroup2:insert( blockMock2 )