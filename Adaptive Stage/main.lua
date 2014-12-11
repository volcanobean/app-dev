-- adaptive stage

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

local myStage = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
myStage:setFillColor( 1, 1, 1, 0.25 )

-- bg image width is based on screen width, bg image height is based on a proportional percentage of that same screen width
local bgTest = display.newImageRect( "images/forest-bg.jpg", display.contentWidth, display.contentWidth*1.77865)
bgTest.x = display.contentCenterX
bgTest.y = display.contentCenterY

--local myPxRect = display.newRect( display.contentCenterX, display.contentCenterY, 300, 100 )

--local myAdpRect = display.newRect( display.contentCenterX, display.contentCenterY+150, display.contentWidth*0.8, 100 )

-- debug
local stageHW = display.newText( display.contentWidth .. ' x ' .. display.contentHeight, display.contentCenterX, 50, native.systemFont, 30 )

local bottomHugger = display.newGroup()
bottomHugger.x = display.contentCenterX
--bottomHugger.y = display.contentHeight - 30
bottomHugger.anchorY = 0
bottomHugger.y = display.contentHeight - 30


local topH = display.newRect( display.contentCenterX, 0, display.contentWidth, 20 )
topH:setFillColor( 0, 1, 1, 1 )

local bottomH = display.newRect( display.contentCenterX, 0, display.contentWidth, 40 )
bottomH:setFillColor( 1, 0, 1, 1 )
bottomH.anchorY = 1
bottomH.y = display.contentHeight



--768 x 1366

--1.77865