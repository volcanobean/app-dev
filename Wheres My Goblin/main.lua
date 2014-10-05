--
-- Abstract: Where's My Goblin?
--
-- Version: 1.0
--
-- Copyright (C) 2014 Volcano Bean, LLC. All Rights Reserved.
------------------------------------------------------------

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- load composer
local composer = require( "composer" )

-- load first scene
composer.gotoScene( "mix-n-match" )
