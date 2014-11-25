local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local starVertices = { 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, }

local star = display.newPolygon( 200, 200, starVertices )
--star.fill = { type="image", filename="mountains.png" }
star.strokeWidth = 10
star:setStrokeColor( 1, 0, 0 )

-- vertices = { x1,y1, x2,y2, x3,y3 }
local puzzlePieceVertices = { 0,0, 0,300, 100,300, 100,200, 200,200, 200,300, 300,300, 300,200, 400,200, 400,100, 300,100, 300,0  }
local puzzlePiece = display.newPolygon( halfW, halfH, puzzlePieceVertices )
puzzlePiece.strokeWidth = 2
puzzlePiece:setStrokeColor( 1, 0, 0 )