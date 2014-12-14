--
-- Abstract: Fairy Color Game
--
------------------------------------------------------------

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- load composer

local composer = require( "composer" )

-- Create a table for my global variables, which will be shared between scenes/lua files.

composer.myGlobals = {}

-- go to first scene
composer.gotoScene( "start-screen" )



--[[
-- Code to have Corona display the font names found

local fonts = native.getFontNames()
count = 0

-- Count the number of total fonts

for i,fontname in ipairs(fonts) do
    count = count+1
end

print( "\rFont count = " .. count )
local name = "ristmas"     -- part of the Font name we are looking for
name = string.lower( name )

-- Display each font in the terminal console

for i, fontname in ipairs(fonts) do
    j, k = string.find( string.lower( fontname ), name )

    if( j ~= nil ) then

        print( "fontname = " .. tostring( fontname ) )

    end
end
]]--
