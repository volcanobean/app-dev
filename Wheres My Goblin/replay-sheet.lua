--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:70ddaba1e203d8d08ec198ca1403216f:7363b6781e9cc264e4222fa4e406967f:eb95963157756aeaec9625538cb07942$
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
            -- no-btn
            x=2*mW,
            y=274*mW,
            width=155*mW,
            height=183*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 155*mW,
            sourceHeight = 183*mW
        },
        {
            -- play-again
            x=2*mW,
            y=2*mW,
            width=505*mW,
            height=270*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 505*mW,
            sourceHeight = 270*mW
        },
        {
            -- yes-btn
            x=159*mW,
            y=274*mW,
            width=156*mW,
            height=180*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 180*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["no-btn"] = 1,
    ["play-again"] = 2,
    ["yes-btn"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
