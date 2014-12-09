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

-- shorter variable name for contentWidth
-- all scale/size values will be a percentage of the contentWidth, so a 512w rectangle on a 768w display (512/768) would be: cW*0.667
-- mW is multiplierWidth for converting existing values easier ( 768 divided by 100 to get a percentage for multiplying instead of dividing)

local cW = display.contentWidth
local cH = display.contentHeight
local mW = 0.0013020833*cW

-- Begin global settings
-- Block and ribbon values. Adjust as needed

_myG.blockCount = 10
_myG.blockWidth = 512*mW
_myG.blockMargin = 90*mW

_myG.blockHeight1 = 312*mW
_myG.blockHeight2 = 540*mW
_myG.blockHeight3 = 396*mW

_myG.ribbonY1 = 245*mW
_myG.ribbonY2 = 555*mW
_myG.ribbonY3 = 710*mW

-- Now that our variables are set, let's start the game.

composer.gotoScene( "start-screen" )