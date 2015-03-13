display.setStatusBar( display.HiddenStatusBar )

local perspective = require ( "perspective" )
local camera = perspective.createView()


local cW = display.contentWidth 
local cH = display.contentHeight
local cX = display.contentCenterX
local cY = display.contentCenterY

local stageHit = display.newRect( cX, cY, cW, cH )
stageHit:setFillColor( 0, 0, 0, 0.01 )

local worldLayer = display.newGroup()

local background = display.newImage( worldLayer, "images/bg.jpg", 0, 0, 2000, 4000 ) 
background.x = display.contentWidth * 0.5
background.y = display.contentHeight * 0.5

local ball = display.newCircle( worldLayer, 100, 100, 50, 50 )
ball:setFillColor(0,1,0)
ball.x = display.contentWidth * 0.5
ball.y = display.contentHeight * 0.5


local function ballMove (event)
   transition.to ( ball, { time=1000, x=event.x, y=event.y })
end  

stageHit:addEventListener( "tap", ballMove ) 

camera:add ( worldLayer )
camera:setFocus ( ball )
camera:setBounds( 258, 508, 0, 4000 )
camera:track() 



