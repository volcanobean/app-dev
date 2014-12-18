local background = display.newRect( display.contentCenterX, display.contentCenterY,  display.contentWidth, display.contentHeight )
background:setFillColor( 1, 1, 1, 0.15)

local leafOptions =
	{ 
		width = 50, 
		height = 27, 
		numFrames = 2 
	}
local leafSheet = graphics.newImageSheet( "images/leaf.png", leafOptions )
local leafSeq =
{
    { name="spin", frames={ 1, 2 }, time=300, loopCount=0 },
}
--[[
local leaf = display.newSprite( leafSheet, leafSeq )
leaf.x = 200
leaf.y = 200
leaf:setFillColor( 1, 0, 0, 1)
leaf:setSequence( "spin" )
leaf:play()
]]--

leaf = {}

local function createLeaf( number )
    leaf[number] = display.newSprite( leafSheet, leafSeq )
    leaf[number]:setSequence( "spin" )
    leaf[number]:play()
    leaf[number].x = math.random( 10, 700 )
    leaf[number].y = math.random( 0, 30 )
    local leafScale = math.random( 1, 2 )
    leaf[number]:scale( leafScale, leafScale )
    local r
    local g
    local b
    local colorNumber = math.random( 1, 4 )
    if colorNumber == 1 then
    	-- red
    	r = 1
    	g = 0
    	b = 0
    elseif colorNumber == 2 then
    	-- red orange
    	r = 1
    	g = 0.5 
    	b = 0
    elseif colorNumber == 3 then
    	-- yellow orange
    	r = 1
    	g = 0.65 
    	b = 0.25
    else
    	r = 1
    	g = 0
    	b = 0
    end
    leaf[number]:setFillColor( r, g, b, 1 )
    --leafGroup:insert( createLeaf[number] )
end

for i=1, 30 do
	createLeaf(i)
	local startX = leaf[i].x
	local startY = leaf[i].y
	local fallTime = math.random( 2000, 4000 )
	local function moveLeaf()
		transition.to( leaf[i], { time=fallTime, x=startX-math.random( 100, 150 ), y=startY+math.random( 600, 700 ) })
		transition.to( leaf[i], { delay=fallTime, time=1, x=startX, y=startY, onComplete=moveLeaf }) 
	end
	moveLeaf()
end