local composer = require( "composer" )
local _myG = composer.myGlobals

local bbTestVar = display.newText( "This string is from the body-builder.lua file.", display.contentCenterX, 50, native.systemFont, 30 )

local cW = display.contentWidth
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

------------------------------------------------------------------
-- SPRITES
------------------------------------------------------------------

---- LEGS

-- Sprite sheets

local legsSheetInfo = require("legs-sheet-1")
local legsSheet = graphics.newImageSheet( "images/legs-1.png", legsSheetInfo:getSheet() )
local legsFrames =  { start=1, count=7 }

local legsSheetInfo2 = require("legs-sheet-2")
local legsSheet2 = graphics.newImageSheet( "images/legs-2.png", legsSheetInfo2:getSheet() )
local legsFrames2 =  { start=1, count=4 }

-- Sprites

local legsA = {}
local legsB = {}
local legCount
local tableVar

-- Create our sprites and populate our tables

for i=1, 2 do
	-- We need to run all this code twice to create duplicate groups for the purpose of allowing our ribbons to loop
	if i == 1 then
		tableVar = legsA
	elseif i == 2 then
		tableVar = legsB
	end

	-- total leg count will vary based on other game data like skill level, so we determine the array number incrementally
	-- if a leg is not included in a certain level, the incrementing will still allow the array to build out correctly
	legCount = 1

	-- legs-bermuda
	tableVar[legCount] = display.newSprite( legsSheet, legsFrames )
	tableVar[legCount]:setFrame(1)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-buccanner
	tableVar[legCount] = display.newSprite( legsSheet, legsFrames )
	tableVar[legCount]:setFrame(2)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-dancer
	tableVar[legCount] = display.newSprite( legsSheet, legsFrames )
	tableVar[legCount]:setFrame(3)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-prisoner
	tableVar[legCount] = display.newSprite( legsSheet, legsFrames )
	tableVar[legCount]:setFrame(4)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-wizard - original (blue)
	local legsWizardBase = display.newSprite( legsSheet, legsFrames )
	legsWizardBase:setFrame(6)

	local legsWizardColor = display.newSprite( legsSheet, legsFrames )
	legsWizardColor:setFrame(5)

	tableVar[legCount] = display.newGroup()
	tableVar[legCount]:insert( legsWizardColor )
	tableVar[legCount]:insert( legsWizardBase )
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-wizard - green
	local legsWizardBase2 = display.newSprite( legsSheet, legsFrames )
	legsWizardBase2:setFrame(6)

	local legsWizardColor2 = display.newSprite( legsSheet, legsFrames )
	legsWizardColor2:setFrame(5)
	legsWizardColor2:setFillColor( 0, 1, 0, 1 ) -- green

	tableVar[legCount] = display.newGroup()
	tableVar[legCount]:insert( legsWizardColor2 )
	tableVar[legCount]:insert( legsWizardBase2 )
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-yeehaw
	tableVar[legCount] = display.newSprite( legsSheet, legsFrames )
	tableVar[legCount]:setFrame(7)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-bigfoot
	tableVar[legCount] = display.newSprite( legsSheet2, legsFrames2 )
	tableVar[legCount]:setFrame(1)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-kilt
	tableVar[legCount] = display.newSprite( legsSheet2, legsFrames2 )
	tableVar[legCount]:setFrame(2)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-knight
	tableVar[legCount] = display.newSprite( legsSheet2, legsFrames2 )
	tableVar[legCount]:setFrame(3)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

	-- legs-traveler
	tableVar[legCount] = display.newSprite( legsSheet2, legsFrames2 )
	tableVar[legCount]:setFrame(4)
	tableVar[legCount].x = (( _myG.blockMargin + _myG.blockWidth ) * legCount ) - _myG.blockWidth*0.5
	legCount = legCount+1

end

---- TORSO

local torsoSheetInfo = require("torso-sheet-1")
local torsoSheet = graphics.newImageSheet( "images/torso-1.png", torsoSheetInfo:getSheet() )
local torsoFrames =  { start=1, count=6 }

local torsoSheetInfo2 = require("torso-sheet-2")
local torsoSheet2 = graphics.newImageSheet( "images/torso-2.png", torsoSheetInfo2:getSheet() )
local torsoFrames2 =  { start=1, count=4 }

---- HEAD

local headSheetInfo = require("heads-sheet")
local headSheet = graphics.newImageSheet( "images/heads.png", headSheetInfo:getSheet() )
local headFrames = { start=1, count=10 }


-- shuffle sort test
--[[
local t = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
print( t[1] .. ', ' .. t[2] .. ', ' .. t[3] .. ', ' .. t[4] .. ', ' .. t[5] .. ', ' .. t[6] .. ', ' .. t[7] .. ', ' .. t[8] .. ', ' .. t[9] .. ', ' .. t[10])

for i = 10, 2, -1 do -- backwards
    local r = math.random(i) -- select a random number between 1 and i
    t[i], t[r] = t[r], t[i] -- swap the randomly selected item to position i
end

print( t[1] .. ', ' .. t[2] .. ', ' .. t[3] .. ', ' .. t[4] .. ', ' .. t[5] .. ', ' .. t[6] .. ', ' .. t[7] .. ', ' .. t[8] .. ', ' .. t[9] .. ', ' .. t[10])
]]--