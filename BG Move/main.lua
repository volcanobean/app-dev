-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local theBg = display.newGroup()
local bgImage = display.newImageRect( theBg, "bg-grid.png", cW+1000, cH )
bgImage.x = cX
bgImage.y = cY

--local theBgW = display.contentWidth+1000
print( "stage W:", display.contentWidth )
--print( "bg W:", theBgW )

local centerEdge = display.newRect( theBg, cX, cY, 50, cH )
centerEdge:setFillColor( 1, 1, 0, 1 ) -- yellow

local leftEdge = display.newRect( theBg, -500, cY, 50, cH )
leftEdge:setFillColor( 0, 1, 1, 1 ) -- blue

local leftEdgeX = 512

local rightEdge = display.newRect( theBg, cW+500, cY, 50, cH )
rightEdge:setFillColor( 1, 0, 1, 1 ) -- pink

local rightEdgeX = -512

local thePlayer = display.newRect( cX, cY, 150, 150 )

local eventX
local eventY
local pX
local bX
local difX
local destX

local function moveRight()
	bX = theBg.x
	if ( theBg.x > destX ) then
		print("moving right")
		transition.to( theBg, { time=75, x=bX-25, onComplete=moveRight })
		print( destX .. " | " .. bX )
		-- move the player left
		--transition.to( thePlayer, { time=200, x=pX+50, onComplete=moveRight })
	end
end

local function moveLeft()
	bX = theBg.x
	if ( theBg.x < destX ) then
		print("moving left")
		transition.to( theBg, { time=75, x=bX+25, onComplete=moveLeft })
		print( destX .. " | " .. bX )
		--transition.to( thePlayer, { time=200, x=pX-50, onComplete=moveLeft })
	end
end

local function stageTap( event )
	print( "------" )
	print( "Stage tapped." )
	print( "X:" .. event.x .. ", Y:" .. event.y )
	eventX = event.x
	eventY = event.y
	pX = thePlayer.x
	bX = theBg.x
	difX = eventX - pX
	destX = bX - difX
	print( "On Tap:" )
	print( "eventX:", eventX )
	print( "pX: ", pX )
	print( "bX: ", bX )
	print( "difX: ", difX )
	print( "destX: ", destX )
	if( thePlayer.x < event.x ) then
		print( "Tap to right of player" )
		moveRight()
	elseif( thePlayer.x > event.x ) then
		print( "Tap to left of player" )
		moveLeft()
	end
	return true
end

stageHit:addEventListener( "tap", stageTap )
