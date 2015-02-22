-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local theBg = display.newGroup()

local bgH = 1536
local bgW = 2500
local bgImage = display.newImageRect( theBg, "bg-grid-2500x1536.png", bgW, bgH )
bgImage.x = cX
bgImage.y = cY

--local theBgW = display.contentWidth+1000
print( "stage W:", display.contentWidth )
--print( "bg W:", theBgW )

local centerEdge = display.newRect( theBg, cX, cY, 50, cH )
centerEdge:setFillColor( 1, 1, 0, 1 ) -- yellow

local leftEdge = display.newRect( theBg, -500, cY, 50, cH )
leftEdge:setFillColor( 0, 1, 1, 1 ) -- blue

print ( (bgW - cW)*0.5 )
print( (bgW - cW)*-0.5 ) 
local leftEdgeX = (bgW-cW)*0.5 --512, 500

local rightEdge = display.newRect( theBg, cW+500, cY, 50, cH )
rightEdge:setFillColor( 1, 0, 1, 1 ) -- pink

local rightEdgeX = (bgW-cW)*-0.5 -- -512

local thePlayer = display.newRect( cX, cY, 150, 150 )

local eventX
local eventY
local pX -- player.x
local pY -- player.y
local bgX -- bg.x
local bgY -- bg.y
local distance -- eventX - pX
local distanceTraveled = 0
local distanceRemaining = 0
local speed
local bgDestX

local function moveRight()

end

local function moveLeft()


end

local function stageTap( event )
	print( "------" )
	print( "Stage tapped." )
	-- reset variables on every new tap
	distanceTraveled = 0
	eventX = event.x
	eventY = event.y
	pX = thePlayer.x
	bgX = theBg.x
	distance = eventX - pX
	bgDestX = bgX - distance
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
