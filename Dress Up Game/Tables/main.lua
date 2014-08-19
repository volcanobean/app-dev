-- 
-- Project: Dress Up Game
--
-- File dependencies: none

---------------------------------------------------------------------------------------

-- TABLES

---------------------------------------------------------------------------------------

-- Create table for current user/stage values

local current = {}
current.name = "Current Character"
current.torso = {}
current.torso.item = 0
current.torso.color = { 1, 1, 1, 1 }
current.torso.color2 = { 1, 1, 1, 1 }
current.legs = {}
current.legs.item = 0
current.legs.color = { 1, 1, 1, 1 }

-- Create table for values to be stored in save slot 01

local save01 = {}
save01.name = "Character 1"
save01.torso = {}
save01.torso.item = 0
save01.torso.color = { 1, 1, 1, 1 }
save01.legs = {}
save01.legs.item = 0
save01.legs.color = { 1, 1, 1, 1 }

-- DEBUG character table data

local function printCharacter( event )
	print ( "Name: " .. current.name )
	print ( "Torso: " .. current.torso.item .. ", Color: " .. unpack(current.torso.color) )
	print ( "Legs: " .. current.legs.item .. ", Color: " .. unpack(current.legs.color) )
	return true
end

local printBtn = display.newText( "Print Data", 40, 460, native.systemFont, 13)
printBtn:addEventListener( "tap", printCharacter )


local function saveCharacter()
	-- overwrite save01 table values with current table values
	save01.name = current.name
	save01.torso.item = current.torso.item
	save01.legs.item = current.legs.item
	-- print values
	print ( "Name: " .. save01.name )
	print ( "Torso: " .. save01.torso.item .. ", Color: " .. unpack(save01.torso.color) )
	print ( "Legs: " .. save01.legs.item .. ", Color: " .. unpack(save01.legs.color) )
	return true
end

local saveBtn = display.newText( "Save Data", 140, 460, native.systemFont, 13)
saveBtn:addEventListener( "tap", saveCharacter )


---------------------------------------------------------------------------------------

-- STAGE setup

---------------------------------------------------------------------------------------

-- ** Clothing Category **

local currentCategory = "torso"
local currentCategoryText = display.newText( currentCategory, 30, 120, native.systemFont, 13 )

local nameDisplay = display.newText( current.name, display.contentCenterX, 30, native.systemFont, 13 )

-- Create hit areas for each section

local torsoHitArea = display.newRect( display.contentCenterX, 120, 150, 155 )
torsoHitArea:setFillColor( 0, 1, 1, 0.25 )

local legsHitArea = display.newRect( display.contentCenterX, 265, 150, 130 )
legsHitArea:setFillColor( 0, 1, 0, 0.25 )

-- Set current category

local function setCategory ( event )
	currentCategory = event.target.category
	currentCategoryText.text = event.target.category
	print ( "Category: " .. currentCategory )
	return true -- stops processing of further events
end


---------------------------------------------------------------------------------------

-- SPRITE image sheets

---------------------------------------------------------------------------------------

-- Image sheets for full-size clothing graphics

local legsSheet = graphics.newImageSheet( "images/legs_sheet.png", { width=200, height=200, numFrames=3, sheetContentWidth=600, sheetContentHeight=200 } )
local legsFrames =  { start=1, count=3 }

local torsoSheet = graphics.newImageSheet( "images/torso_sheet.png", { width=200, height=200, numFrames=3, sheetContentWidth=600, sheetContentHeight=200 } )
local torsoFrames = { start=1, count=3 }


-- Sprites for full-size clothing graphics

local legs = display.newSprite( legsSheet, legsFrames )
legs.x = display.contentCenterX; legs.y = 260
legs:setFrame(1)
legs.category = "legs"

local torso = display.newSprite( torsoSheet, torsoFrames )
torso.x = display.contentCenterX; torso.y = 120
torso:setFrame(1)
torso.category = "torso"

legs:addEventListener( "tap", setCategory )
torso:addEventListener( "tap", setCategory )

-- Image sheets for small clothing buttons

local legsBtnSheet = graphics.newImageSheet( "images/legs_sheet.png", { width=40, height=40, numFrames=3, sheetContentWidth=120, sheetContentHeight=40 } )
local legsBtnFrames = { start=1, count=3 }

local torsoBtnSheet = graphics.newImageSheet( "images/torso_sheet.png", { width=40, height=40, numFrames=3, sheetContentWidth=120, sheetContentHeight=40 } )
local torsoBtnFrames = { start=1, count=3 }


-- Create listener function to change category based on which item was tapped.




---------------------------------------------------------------------------------------

-- CLOSET - icons, sliders, etc

---------------------------------------------------------------------------------------
--[[
local closetIcons = display.newGroup()
closetIcons.x = 30; closetIcons.y = 235
local closetIconsArea = display.newRect( closetIcons, 0, 0, 60, 200 )
closetIconsArea:setFillColor( 1, 1, 1, 0.11 )

local torsoIcon = display.newImage( closetIcons, "images/tshirt_icon_40x40.png" )
torsoIcon.x = 0; torsoIcon.y = -70
torsoIcon.category = "torso"

local legsIcon = display.newImage( closetIcons, "images/pants_icon_40x40.png" )
legsIcon.x = 0; legsIcon.y = -10
legsIcon.category = "legs"

-- Drawers for sliding closet items

local backMask = display.newContainer( 60, 60 )
backMask.x = 30; backMask.y = 165
local backMaskArea = display.newRect( backMask, 0, 0, 300, 300 )
backMaskArea:setFillColor( 1, 1, 1, 0.5)

local backIcon = display.newImage( "images/back_icon_40x40.png" )
backIcon.x = 60; backIcon.y = 0
backIcon.category = "back"

local drawerMask = display.newContainer( 60, 200 )
drawerMask.x = 30; drawerMask.y = 295
local drawerMaskArea = display.newRect( closetIcons, 0, 0, 300, 300 )
drawerMaskArea:setFillColor( 1, 1, 1, 0.5)

-- Closet items

local torsoDrawer = display.newGroup()
torsoDrawer.x = 60; torsoDrawer.y = 0
local torsoDrawerArea = display.newRect( torsoDrawer, 0, 0, 60, 200 )
torsoDrawerArea:setFillColor( 1, 1, 1, 0.15 )

local legsDrawer = display.newGroup()
legsDrawer.x = 60; legsDrawer.y = 0
local legsDrawerArea = display.newRect( legsDrawer, 0, 0, 60, 200 )
legsDrawerArea:setFillColor( 1, 1, 1, 0.15 )

--drawerMask:insert( torsoDrawer )
drawerMask:insert( legsDrawer )
drawerMask:insert( drawerMaskArea )
backMask:insert( backIcon )


-- Open close functions --

local function openDrawers( event )
	--print ( event.target.category )s
	if event.target.category == "legs" then
		transition.to( legsDrawer, { time=300 ,transition=easing.outSine, x=0 } )	
	elseif event.target.category == "torso" then
		transition.to( torsoDrawer, { time=300 ,transition=easing.outSine, x=0 } )
	end
	setCategory(event)
	transition.to( closetIcons, { time=300 ,transition=easing.outSine, x=-60 } )
	transition.to( backIcon, { time=300 ,transition=easing.outSine, x=0 } )
	return true
end

local function closeDrawers( event )
	transition.to( closetIcons, { time=300 ,transition=easing.outSine, x=30 } )
	transition.to( torsoDrawer, { time=300 ,transition=easing.outSine, x=60 } )
	transition.to( legsDrawer, { time=300 ,transition=easing.outSine, x=60 } )
	transition.to( backIcon, { time=300 ,transition=easing.outSine, x=60 } )
	return true
end

backIcon:addEventListener ( "tap", closeDrawers )
torsoIcon:addEventListener( "tap", openDrawers )
legsIcon:addEventListener( "tap", openDrawers )  
]]


---------------------------------------------------------------------------------------

-- DRAG AND DROP

---------------------------------------------------------------------------------------

--rectangle-based collision detection

local function hasCollided( obj1, obj2 )
   if ( obj1 == nil ) or ( obj2 == nil ) then  -- make sure the objects exists
      return false
   end
   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
   return (left or right) and (up or down)
end

-- Button swap

-- create initial variable, to be filled later

local previousBtn


-- Create functon to track previous button. Hide/show new button as necessary.

local function iconSwap( currentBtn )
	if ( previousBtn ~= nil ) then
		-- if this not the first item dropped, ie. there IS a previous button,
		-- then show the previous button and return it to the drawer
		previousBtn.isVisible = true
		transition.to( previousBtn, {time=0, x=previousBtn.xOrig, y=previousBtn.yOrig} )
	end
	-- remember the value of the current button, so it can be made visible again the
	-- next time it is replaced
	previousBtn = currentBtn
	currentBtn.isVisible = false
end


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


-- Function to create a clothing item button

local function newItemBtn( itemGroup, itemNumber, xPos, yPos )
	local btnName = itemGroup .. "Btn" .. itemNumber
	local sheetVar
	local framesVar
	if itemGroup == "torso" then
		sheetVar = torsoBtnSheet
		framesVar = torsoBtnFrames
	elseif itemGroup == "legs" then
		sheetVar = legsBtnSheet
		framesVar = legsBtnFrames
	end
	local btnName = display.newSprite( sheetVar, framesVar )
	btnName.name = btnName
	btnName.category = itemGroup
	btnName.number = itemNumber
	btnName:setFrame( itemNumber )
	btnName.x = xPos
	btnName.y = yPos
	btnName.xOrig = xPos
	btnName.yOrig = yPos
	btnName:addEventListener( "touch", dragItem )
end


-- Create clothing item buttons

newItemBtn( "torso", "1", 40, 40 )
newItemBtn( "torso", "2", 40, 80 )
newItemBtn( "torso", "3", 40, 120 )

newItemBtn( "legs", "1", 40, 160 )
newItemBtn( "legs", "2", 40, 200 )
newItemBtn( "legs", "3", 40, 240 )


---------------------------------------------------------------------------------------

-- COLOR functions, buttons, etc.

---------------------------------------------------------------------------------------

-- Create group to hold all color buttons

local colorPicker = display.newGroup()
colorPicker.x = display.contentCenterX; colorPicker.y = 550

local colorPickerArea = display.newRect( colorPicker, 0, 0, 210, 110 )
colorPickerArea:setFillColor( 1, 1, 1, 0.15 )


-- Paint icon 

local paintIcon = display.newImage( "images/paint_icon_40x40.png", 295, 455 )


-- Set default value

local colorPickerVisible = true

local function onPaintTap()
	if colorPickerVisible == true then
		transition.to( colorPicker, { time=400 ,transition=easing.outSine, y=390 } )
		colorPickerVisible = false
	elseif colorPickerVisible == false then
		transition.to( colorPicker, { time=400 ,transition=easing.outSine, y=550 } )
		colorPickerVisible = true
	end
end

paintIcon:addEventListener( "tap", onPaintTap )


-- Color button function 

local function updateColor( event )
	if currentCategory == "torso" then 
		current.torso.color = event.target.color
		torso:setFillColor( unpack( current.torso.color ) ) 
	elseif currentCategory == "legs" then 
		current.legs.color = event.target.color
		legs:setFillColor( unpack( current.legs.color ) ) 
	end
	return true
end


-- Function to create a color button

local function newColorButton( buttonName, colorR, colorG, colorB, colorA, xPos, yPos )
	local buttonName = display.newRect( colorPicker, xPos, yPos, 40, 40 )
	buttonName.color = { colorR, colorG, colorB, colorA }
	buttonName:setFillColor( colorR, colorG, colorB, colorA )
	buttonName:addEventListener( "tap", updateColor )
end


-- Create color buttons. X and Y positions are relative to center of parent group, colorPicker

newColorButton( "clrBtn01", 1, 0, 1, 1, -75, -25 )
newColorButton( "clrBtn02", 1, 0, 0, 1, -25, -25 )
newColorButton( "clrBtn03", 0, 0.5, 1, 1, 25, -25 )
newColorButton( "clrBtn04", 0.5, 0, 0.5, 1, 75, -25 )
newColorButton( "clrBtn05", 1, 0.8, 0.8, 1, -75, 25 )
newColorButton( "clrBtn06", 0, 1, 0, 1, -25, 25 )
newColorButton( "clrBtn07", 1, 1, 0, 1, 25, 25 )
newColorButton( "clrBtn08", 1, 1, 1, 1, 75, 25 )
