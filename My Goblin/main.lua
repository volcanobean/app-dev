--
-- Abstract: Where's My Goblin?
-- Version: 1.1
-- Copyright (C) 2014-2015 Volcano Bean, LLC. All Rights Reserved.
------------------------------------------------------------

-- Load Corona Profiler

--profiler = require "Profiler"
--profiler.startProfiler({ time=10000, delay=1000, mode=3 })

-- hide device status bar

display.setStatusBar( display.HiddenStatusBar )

-- load composer, go to first scene

local composer = require( "composer" )

-- Create a table for my global variables, which will be shared between scenes/lua files.

composer.myGlobals = {}

-- Assign shorter variable name to myGlobals table to save on typing.

local _myG = composer.myGlobals

-- Now that our variables are set, let's start the game.

--composer.gotoScene( "logos" )
composer.gotoScene( "start-screen" )
--composer.gotoScene( "goblin-slider" )