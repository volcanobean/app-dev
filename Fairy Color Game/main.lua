--
-- Abstract: Fairy Color Game
--
------------------------------------------------------------

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- load composer, go to first scene
local composer = require( "composer" )

print( "main loaded" ) 
composer.gotoScene( "gameplay" )
