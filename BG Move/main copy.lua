-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

local stageHit = display.newRect( cX, cY, cW, cH)
stageHit:setFillColor( 0, 1, 0, 0.4 )

local theBg = display.newGroup()
local bgWidth = 2024
local bgImage = display.newImageRect( theBg, "bg-grid.png", bgWidth, cH )
bgImage.x = cX
bgImage.y = cY

--[[
local hitSpot = display.newCircle( theBg, 0, 0, 50 )
--hitSpot.alpha = 0
local hitSpotX, hitSpotY = hitSpot:localToContent( 0, 0 )

local function hitSpotPlay()
	print("hitSpotPlay")
	transition.to( hitSpot, {time=1, alpha=1, xScale=1, yScale=1 } )
	transition.to( hitSpot, {delay=1, time=400, alpha=0, xScale=2, yScale=2 } )
end
]]--

--local theBgW = display.contentWidth+1000
print( "stage W:", display.contentWidth )
--print( "bg W:", theBgW )

local centerEdge = display.newRect( theBg, cX, cY, 50, cH )
centerEdge:setFillColor( 1, 1, 0, 1 ) -- yellow

local leftEdge = display.newRect( theBg, -500, cY, 50, cH )
leftEdge:setFillColor( 0, 1, 1, 1 ) -- blue

print ( (bgWidth - cW)*0.5 )
print( (bgWidth - cW)*-0.5 ) 
local leftEdgeX = (bgWidth-cW)*0.5 --512, 500

local rightEdge = display.newRect( theBg, cW+500, cY, 50, cH )
rightEdge:setFillColor( 1, 0, 1, 1 ) -- pink

local rightEdgeX = (bgWidth-cW)*-0.5 -- -512

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
	-- set bgX to current background position at the start of each loop
	bgX = theBg.x
	pX = thePlayer.x
	print( "eventX: " .. eventX )
	print( "thePlayer.x: " .. thePlayer.x )
	print( "rightEdgeX: " .. rightEdgeX)
	print( "bgX: " .. bgX)
	print( "theBg.x: " .. theBg.x)
	print( "pX: " .. pX)
	print( "bgDestX: " .. bgDestX )

	-- if the bg or player has not reached the destination position yet
	if ( theBg.x > bgDestX ) then

		-- if the bg is not at the right most edge yet
		if ( theBg.x > rightEdgeX ) then
			-- move the background
			transition.to( theBg, { time=75, x=bgX-25, onComplete=moveRight })
			-- keep track of total distance traveled as it increases
			distanceTraveled = distanceTraveled + 25
			print( "** distanceTraveled: " .. distanceTraveled)
			--speed = distance*3
			--transition.to( theBg, { time=speed, x=bgX-distance })

		-- if the bg is at right most edge 
		-- and the player has not reached the destination
		elseif( thePlayer.x < eventX ) then
			-- calculate the remaining distance between player and destination
			distanceRemaining = distance - distanceTraveled
			print( "** BG hit right edge" )
			print( "thePlayer.x: " .. thePlayer.x )
			print( "eventX: " .. eventX )
			print( "*** distanceTraveled: " .. distanceTraveled)
			print( "*** distanceRemaining: " .. distanceRemaining )
			-- move player
			speed = distanceRemaining*3
			transition.to( thePlayer, { time=speed, x=pX+distanceRemaining })
		end
	end
end

local function moveLeft()
	bgX = theBg.x
	pX = thePlayer.x
	--[[
	if ( theBg.x < destX ) then
		print("moving left")
		transition.to( theBg, { time=75, x=bgX+25, onComplete=moveLeft })
		print( destX .. " | " .. bgX )
		--transition.to( thePlayer, { time=200, x=pX-50, onComplete=moveLeft })
	end
	]]--

	-- if the bg or player has not reached the destination position yet
	if ( theBg.x < bgDestX ) then
		-- if the bg is not at the left most edge yet
		if ( theBg.x < leftEdgeX ) then
			-- move the background
			transition.to( theBg, { time=75, x=bgX+25, onComplete=moveLeft })
		-- if the bg is at right most edge 
		-- and the player has not reached the destination

		elseif( thePlayer.x > eventX ) then
			-- move player
			transition.to( thePlayer, { time=75, x=pX-25, onComplete=moveLeft })
		end
	end

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
