-- Create drag and drop event function

local function dragItem( event )
	local target = event.target
	local phase = event.phase

	-- ON TOUCH:

	if ( phase == "began" ) then
    	display.getCurrentStage():setFocus( target )
   		-- set focus to true to avoid unintended swiping, etc from triggering drag
    	target.isFocus = true
	    -- x0 is current X pos?
	    target.x0 = event.x - target.x
	    target.y0 = event.y - target.y
	    target.xStart = target.x
	    target.yStart = target.y
	    target:toFront()
	elseif ( target.isFocus ) then

		-- START DRAG: 

    	if ( phase == "moved") then
    		target.x = event.x - target.x0
    		target.y = event.y - target.y0

    	-- ON DROP:

    	elseif ( phase == "ended" or phase == "cancelled" ) then
	    	display.getCurrentStage():setFocus( nil )
	    	target.isFocus = false  

		    -- If clothing item is dropped on correct body area 
		    if ( target.category == "torso" ) and ( hasCollided( target, torsoHitArea ) ) then
		        --snap in place
		        transition.to( target, {time=50, x=torsoHitArea.x, y=torsoHitArea.y} )
		        torso:setFrame( target.number )
		        iconSwap( target.name )
		        print( "Dragged to Torso" )
		        current.torso.item = target.number
		    elseif ( target.category == "legs" ) and ( hasCollided( target, legsHitArea ) ) then
		      	transition.to( target, {time=50, x=legsHitArea.x, y=legsHitArea.y} )
		      	legs:setFrame( target.number )
		        iconSwap( target.name )
		      	current.legs.item = target.number
		      	print( "Dragged to Legs" )
		    else
		    	-- if not dropped on body, move clothing button back to original position
		    	transition.to( event.target, {time=50, x=target.xOrig, y=target.yOrig} )
		    end
		end
	end
	return true
end

local myButton = display.newRect( 200, 200, 200, 200 )
myButton:addEventListener( "touch", dragItem )
xOrig = myButton.x
yOrig = myButton.y

local myGroup = display.newGroup()
local myGroupArea = display.newRect( myGroup, 200, 200, 400, 400 )
myGroupArea:setFillColor( 1, 1, 1, 0.25 )

myGroup:insert( myButton )

local function moveGroup( event )
	transition.to( myGroup, { time=500 ,transition=easing.outSine, y=500 } )
end

local moveButton = display.newText( "Move Group", display.contentCenterX, 30, native.systemFont, 24 )
moveButton:addEventListener( "tap", moveGroup )

local groupVar = 1

local function changeGroup( event )
	if (groupVar == 1 ) then
		display.currentStage:insert( myButton )
		groupVar = 2
		print ("Button added to stage.")
	else
		myGroup:insert( myButton )
		groupVar = 1
		print ("Button added to group")
		myButton.x = xOrig
		myButton.y = yOrig
	end
	return true
end

local groupButton = display.newText( "Change Group", 600, 30, native.systemFont, 24 )
groupButton:addEventListener( "tap",changeGroup )