--rectangle-based collision detection

local function hasCollided( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end
   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
   return (left or right) and (up or down)
end

-- movement code

if horzMove == true then
	-- default player movement
	player.x = player.x + rateX
	-- if player collides with a blocker or pusher
	if horzBlock == true then
		player.x = player.x - rateX
	elseif horzPush == true then
		player.x = player.x + pushX
	end
end

if vertMove == true then
	-- default player movement
	player.y = player.y + rateY
	-- if player collides with a blocker or pusher
	if vertBlock == true then
		player.y = player.y - rateY
	elseif vertPush == true then
		player.y = player.y + pushY
	end
end