-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local theBg = display.newGroup()
local theBgW = display.contentWidth+1000
print( "stage W:", display.contentWidth )
print( "bg W:", theBgW )

local centerEdge = display.newRect( theBg, cX, cY, 50, cH )
centerEdge:setFillColor( 1, 1, 0, 1 ) -- yellow

local leftEdge = display.newRect( theBg, -500, cY, 50, cH )
leftEdge:setFillColor( 0, 1, 1, 1 ) -- blue

local leftEdgeX = 512

local rightEdge = display.newRect( theBg, cW+500, cY, 50, cH )
rightEdge:setFillColor( 1, 0, 1, 1 ) -- pink

local rightEdgeX = -512

print( "theBg x:", theBg.x )

local thePlayer = display.newRect( cX, cY, 150, 150 )

local eventX
local eventY

local function moveRight()
	local pX = thePlayer.x
	if ( thePlayer.x < eventX) then
		print("moving right")
		transition.to( thePlayer, { time=200, x=pX+50, onComplete=moveRight })
	end
end

local function moveLeft()
	local pX = thePlayer.x
	if ( thePlayer.x > eventX) then
		print("moving left")
		transition.to( thePlayer, { time=200, x=pX-50, onComplete=moveLeft })
	end
end

local function moveBg( event )
	print ("tapped stage - X: " .. event.x .. ", Y: " .. event.y )
	eventX = event.x
	eventY = event.y
	if( thePlayer.x < event.x ) then
		print( "Tap to right of player" )
		moveRight()
	elseif( thePlayer.x > event.x ) then
		print( "Tap to left of player" )
		moveLeft()
	end
	return true
end

stageHit:addEventListener( "tap", moveBg )
