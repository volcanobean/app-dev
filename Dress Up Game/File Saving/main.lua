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

local saveCharacter = function( event )
	print ( event.target.id  .. " released" )
	writeFileData( event.target.id )
end

local deleteCharacter = function ( event )
	print ( "File deleted, for pretend" )
	-- deleteFileData( event.target.id )
end

-- create buttons

local saveBtn1 = widget.newButton
{
	id = "button1",
	--defaultFile = "buttonGray.png",
	--overFile = "buttonBlue.png",
	label = "Character Slot 1",
	font = native.systemFont,
	fontSize = 28,
	onEvent = saveCharacter,
}

local deleteBtn1 = widget.newButton
{
	id = "delete1",
	--defaultFile = "buttonGray.png",
	--overFile = "buttonBlue.png",
	label = "Delete X",
	font = native.systemFont,
	fontSize = 28,
	onEvent = deleteCharacter,
}

-- button placement
saveBtn1.x = 160; saveBtn1.y = 240
deleteBtn1.x = 160; deleteBtn1.y = 280


-- Creating Save Files
-- The io library is the standard Lua library to create, write, and read files.

-- Create a new function to Write a new file or save an existing file.
function writeFileData( saveID )

	-- Here is our pretend save data:
	local saveData = "My app state data from " .. saveID

	-- The absolute path for a file can be found using this function:
	-- system.pathForFile( filename [, baseDirectory] )
	-- The baseDirectory argument is optional, but we choose "system.DocumentsDirectory" because that is where files will be allowed to persist between app launches.
	local filePath = system.pathForFile( "mySaveData" .. saveID .. ".txt", system.DocumentsDirectory )

	-- io.open() — this function opens the file for writing (or reading).
	-- The "w" argument indicates write mode and tells Corona to create (write) a new file, or overwrite the file if it already exists.
	local file = io.open( filePath, "w" )

	-- The file:write() method will write the specified string to the file handle.
	file:write( saveData )
	print ( "Created mySaveData" .. saveID .. ".txt" )

	-- Do NOT forget to call io.close() and ends the I/O process.
	io.close( file )
	file = nil

end