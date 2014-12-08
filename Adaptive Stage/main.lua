--
-- Abstract: Where's My Goblin?
--
-- Version: 1.0
--
-- Copyright (C) 2014 Volcano Bean, LLC. All Rights Reserved.
------------------------------------------------------------

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- load composer, go to first scene
local composer = require( "composer" )

-- Create a table for my global variables, which will be shared between scenes/lua files.
composer.myGlobals = {}
-- Assign shorter variable name to myGlobals table to save on typing.
local _myG = composer.myGlobals

-- Begin global settings
-- Block and ribbon values. Adjust as needed

_myG.blockCount = 6
_myG.blockWidth = 512 -- replace with % instead of pixels later (responsive)
_myG.blockMargin = 90

_myG.blockHeight1 = 312
_myG.blockHeight2 = 540
_myG.blockHeight3 = 396

_myG.ribbonY1 = 245
_myG.ribbonY2 = 555
_myG.ribbonY3 = 710

-- Now that our variables are set, let's start the game.
composer.gotoScene( "start-screen" )


-- Scale factor
-- This value specifies the scale threshold above which Corona will use images in that suffix set.
-- The following code can help you determine the proper values:

-- print( "Scale factor: " .. display.pixelWidth / display.actualContentWidth )

-- Code to have Corona display the font names found


--
local fonts = native.getFontNames()

count = 0

-- Count the number of total fonts
for i,fontname in ipairs(fonts) do
    count = count+1
end

print( "\rFont count = " .. count )

local name = "agic"     -- part of the Font name we are looking for

name = string.lower( name )

-- Display each font in the terminal console
for i, fontname in ipairs(fonts) do
    j, k = string.find( string.lower( fontname ), name )

    if( j ~= nil ) then

        print( "fontname = " .. tostring( fontname ) )

    end
end
---------------------------------------------------------


