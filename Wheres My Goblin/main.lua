--
-- Abstract: Where's My Goblin?
--
-- Version: 1.0
--
-- Copyright (C) 2014-2015 Volcano Bean, LLC. All Rights Reserved.
------------------------------------------------------------

-- hide device status bar

display.setStatusBar( display.HiddenStatusBar )

-- load composer, go to first scene

local composer = require( "composer" )

-- Create a table for my global variables, which will be shared between scenes/lua files.

composer.myGlobals = {}

-- Assign shorter variable name to myGlobals table to save on typing.

local _myG = composer.myGlobals


-- Now that our variables are set, let's start the game.

composer.gotoScene( "logos" )
--composer.gotoScene( "start-screen" )