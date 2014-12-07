-- Begin global settings
-- Block and ribbon values. Adjust as needed

local blockCount = 6
local blockWidth = 512 -- replace with % instead of pixels later (responsive)
local blockMargin = 90

local blockHeight1 = 312
local blockHeight2 = 540
local blockHeight3 = 396

local ribbonY1 = 245
local ribbonY2 = 555
local ribbonY3 = 710

local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
bg:setFillColor( 1, 1, 1, 1 )

-- Banner sprites

local bannerUpY = -500
local bannerDownY = 425
local matchUpY = -925
local matchDownY = 0

local banner = display.newImageRect( "images/banner.png", 569, 1004 ) -- PoT - upscaling smaller 512w image to 569w
banner.x = display.contentWidth*0.5
banner.y = bannerDownY

-- Add goblin match pieces to banner

local mScale = 0.83 -- single variable to scale all goblin banner parts larger or smaller

local headMatchCount = blockCount
local headMatchSheetInfo = require("match-heads-sheet") -- hacky bs
local headMatchSheet = graphics.newImageSheet( "images/heads-sheet.png", headMatchSheetInfo:getSheet() )
local headMatchFrames = { start=1, count=blockCount }
local headMatch = display.newSprite( headMatchSheet, headMatchFrames )
--headMatch = display.newImageRect( headMatchSheet, 1, blockWidth*mScale, blockHeight2*mScale )
headMatch.x = display.contentCenterX
headMatch.y = 380*mScale
headMatch:setFrame( 6 )

local torsoMatchCount = blockCount
local torsoMatchSheet = graphics.newImageSheet( "images/torso-sheet.png", { width=blockWidth*mScale, height=blockHeight2*mScale, numFrames=torsoMatchCount, sheetContentWidth=blockWidth*mScale, sheetContentHeight=blockHeight2*torsoMatchCount*mScale } )
local torsoMatchFrames = { start=1, count=blockCount }
local torsoMatch = display.newSprite( torsoMatchSheet, torsoMatchFrames )
torsoMatch.x = display.contentCenterX
torsoMatch.y = 690*mScale

local legMatchCount = blockCount
local legMatchSheet = graphics.newImageSheet( "images/legs-sheet.png", { width=blockWidth*mScale, height=blockHeight3*mScale, numFrames=legMatchCount, sheetContentWidth=blockWidth*mScale, sheetContentHeight=blockHeight3*legMatchCount*mScale } )
local legMatchFrames = { start=1, count=blockCount }
local legMatch = display.newSprite( legMatchSheet, legMatchFrames )
legMatch.x = display.contentCenterX
legMatch.y = 845*mScale

local matchBlocksGroup = display.newGroup()
matchBlocksGroup:insert( legMatch )
matchBlocksGroup:insert( torsoMatch )
matchBlocksGroup:insert( headMatch )
matchBlocksGroup.y = matchUpDown

