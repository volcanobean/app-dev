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

-- Begin global settings, adjust as needed

-- Blocks
_myG.blockCount = 5
_myG.blockWidth = 600
_myG.blockHeight = 250
_myG.blockMargin = 15

-- Adjust y position of ribbons
_myG.ribbonY1 = 320
_myG.ribbonY2 = 585
_myG.ribbonY3 = 850

-- Set whether ribbon images should repeat, ie. scroll continuiosly
_myG.ribbonLooping = true

-- Now that our variables are set, let's start the game.
composer.gotoScene( "start-screen" )