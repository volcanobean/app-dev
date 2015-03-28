--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3d9c9c435092f142b0d3e2020401d47d:dbd225582290c5ff97c6cbf025d6d8b1:89ca8dc4fc3562f95f90e84bfc98c4a2$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- fairy-down
            x=101,
            y=152,
            width=90,
            height=142,

            sourceX = 44,
            sourceY = 8,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- fairy-forward
            x=2,
            y=159,
            width=88,
            height=145,

            sourceX = 42,
            sourceY = 3,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- fairy-hover
            x=2,
            y=2,
            width=97,
            height=155,

            sourceX = 35,
            sourceY = 9,
            sourceWidth = 175,
            sourceHeight = 175
        },
        {
            -- fairy-up
            x=101,
            y=2,
            width=96,
            height=148,

            sourceX = 19,
            sourceY = 12,
            sourceWidth = 175,
            sourceHeight = 175
        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["fairy-down"] = 1,
    ["fairy-forward"] = 2,
    ["fairy-hover"] = 3,
    ["fairy-up"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
