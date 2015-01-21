-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local theBox = display.newRect( 500, 500, 200, 200 )

local function boxTap( event )
  print("Tapped")
	return true
end

local startX
local endX
local startTime
local endTime

-- Event function for ribbon drag/scroll interactions

local function boxTouch( event )
    local target = event.target
    local phase = event.phase

  	-- If a touch has started on the screen
  	if ( phase == "began" ) then
    	display.getCurrentStage():setFocus( target )
    	target.isFocus = true
        startX = event.x
        startTime = event.time
    	print( "began")
  	elseif ( target.isFocus ) then
    	if( phase == "moved") then
      		print( "moved")
            endX = event.x
    	elseif ( phase == "ended" or phase == "cancelled" ) then
            endX = event.x
            endTime = event.time
      		display.getCurrentStage():setFocus( nil )
      		target.isFocus = false
            --print( event.time )
            local totalTime = endTime - startTime
            print( "totalTime: ", totalTime )
            if( startX == endX  ) then
                print("Tapped")
            elseif ( totalTime < 200 ) and ( startX ~= endX ) then
      		    print( "ended - SWIPE")
            else
                print( "ended")
            end
      	end
	end
  	return true
end

--theBox:addEventListener( "tap", boxTap )

theBox:addEventListener( "touch", boxTouch )