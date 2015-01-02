--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a3836c3ca62930c8ed4235860e6e2f05:b1e38414fffc5357b314a5c2791dbe45:9be72cfdfb498c52f993450e885586e4$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local cW = display.contentWidth
local mW = 0.0013020833*cW

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- yay-arm
            x=175*mW,
            y=2*mW,
            width=63*mW,
            height=186*mW,

        },
        {
            -- yay-body
            x=152*mW,
            y=190*mW,
            width=98*mW,
            height=220*mW,

        },
        {
            -- yay-head-1
            x=2*mW,
            y=2*mW,
            width=171*mW,
            height=115*mW,

            sourceX = 10*mW,
            sourceY = 6*mW,
            sourceWidth = 194*mW,
            sourceHeight = 125*mW
        },
        {
            -- yay-head-2
            x=2*mW,
            y=119*mW,
            width=148*mW,
            height=122*mW,

            sourceX = 45*mW,
            sourceY = 2*mW,
            sourceWidth = 194*mW,
            sourceHeight = 125*mW
        },
        {
            -- yay-head-3
            x=2*mW,
            y=243*mW,
            width=148*mW,
            height=122*mW,

            sourceX = 1*mW,
            sourceY = 1*mW,
            sourceWidth = 194*mW,
            sourceHeight = 125*mW
        },
    },
    
    sheetContentWidth = 256*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["yay-arm"] = 1,
    ["yay-body"] = 2,
    ["yay-head-1"] = 3,
    ["yay-head-2"] = 4,
    ["yay-head-3"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
