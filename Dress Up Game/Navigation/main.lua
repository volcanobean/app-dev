-- 
-- Project: Dres Up Game
--
-- Date: July 17, 2014
-- Version: 1.0
--
-- File dependencies: none
--
-- 7-18-14: Started Pseudo Code to outline app functionality
---------------------------------------------------------------------------------------

-- load "titleScreen" scene. (Using the Composer scene management library)
-- titleScreen should have: game title, background image, multiple character slots, copyright info, help icon


-- Require the widget library, this loads Corona's button functions
local widget = require( "widget" )

local titleText = display.newText( "Cosplay Engine", 0, 0, native.systemFont, 18 )
titleText.x = display.contentCenterX; titleText.y = 70

-- These are the functions triggered by the buttons

local buttonHandler = function( event )
	status = "id = " .. event.target.id .. ", phase = " .. event.phase
	print ( status )
end

-- create buttons

local button1 = widget.newButton
{
	id = "button1",
	--defaultFile = "buttonGray.png",
	--overFile = "buttonBlue.png",
	label = "Slot 1 Label",
	font = native.systemFont,
	fontSize = 28,
	onEvent = buttonHandler,
}

local button2 = widget.newButton
{
	id = "button2",
	label = "Slot 2 Label",
	font = native.systemFont,
	fontSize = 28,
	onEvent = buttonHandler,
}

local button3 = widget.newButton
{
	id = "button3",
	label = "Slot 3 Label",
	font = native.systemFont,
	fontSize = 28,
	onEvent = buttonHandler,
}

-- button placement
button1.x = 160; button1.y = 240
button2.x = 160; button2.y = 320
button3.x = 160; button3.y = 400

-- User clicks on chosen slot
-- If character data is present, get character data, else start new character

-- load Character scene
-- character scene should have: base figure, clothing type category links, current clothing options (based on category)


