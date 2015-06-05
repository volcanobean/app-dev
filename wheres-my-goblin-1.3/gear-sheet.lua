--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:21e6326ec72a1c9a1ecb4d3058b90abe:423e561160d85d7a20d0f65633d0550c:7e74f066b082c8b087d0148203bd67f2$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local cW = display.contentWidth
local mW = 0.0013022*cW

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- gear-1
            x=40*mW,
            y=2*mW,
            width=222*mW,
            height=225*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 222*mW,
            sourceHeight = 225*mW
        },
        {
            -- gear-2
            x=264*mW,
            y=2*mW,
            width=222*mW,
            height=225*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 222*mW,
            sourceHeight = 225*mW
        },
        {
            -- gear-3
            x=40*mW,
            y=229*mW,
            width=222*mW,
            height=225*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 222*mW,
            sourceHeight = 225*mW
        },
        {
            -- gear-4
            x=264*mW,
            y=229*mW,
            width=222*mW,
            height=225*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 222*mW,
            sourceHeight = 225*mW
        },
        {
            -- gear-handle
            x=2*mW,
            y=2*mW,
            width=36*mW,
            height=287*mW

        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["gear-1"] = 1,
    ["gear-2"] = 2,
    ["gear-3"] = 3,
    ["gear-4"] = 4,
    ["gear-handle"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
