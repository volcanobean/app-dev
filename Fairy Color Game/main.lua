display.setStatusBar( display.HiddenStatusBar )

local physics = require "physics"
physics.start()
physics.setGravity(0,0)

-- main character

local fairy = display.newImage( "images/fairy.png" )
fairy.x = display.contentWidth *0.5
fairy.y = display.contentHeight *0.60
physics.addBody( fairy, "dynamic" )

-- Color glowballs to collect

local colorGlow = {}

--Moving fairy--

local function touchScreen( event )
	if event.phase == "began"  then
	transition.to( fairy, { time=1000, x=event.x, y=event.y })
	end
end

Runtime:addEventListener( "touch", touchScreen )

-- Define creation of Glow

local function createGlow( number )
	colorGlow[number] = display.newImage( "images/blueglow.png" )
	colorGlow[number].x = math.random( 50, 700 )
	colorGlow[number].y = math.random( 50, 500 )
	local r = math.random( 0, 100 )
    local g = math.random( 0, 100 )
    local b = math.random( 0, 100 )
    colorGlow[number]:setFillColor( r/100, g/100, b/100 )
	physics.addBody( colorGlow[number], "static" )
	--colorGlow[number]:addEventListener( , listener )
end

--Fairy catching the Glow

local function onCollision( event )
	event.target:removeSelf()
end	

--Runtime:addEventListener( "collision", onCollision )

-- Generate actual Glow objects

for i=1, 12 do
	createGlow(i)
	--Moving Glow
	local function moveGlow()
		transition.to(colorGlow[i], { time=math.random(2000, 3000), x=math.random(50, 700), y=math.random(80, 500), onComplete=moveGlow })
	end
	moveGlow()
	colorGlow[i]:addEventListener( "collision", onCollision )
end 

