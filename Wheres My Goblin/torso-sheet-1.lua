--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7c8e697c5cda772cbc84123f1e04279e:295983983142631486b72ef47eeabad7:246703efdebcd2225ad8f2bcf38b9d09$
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
            -- torso-1
            x=2*mW,
            y=2*mW,
            width=379*mW,
            height=472*mW,

            sourceX = 85*mW,
            sourceY = 40*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-3
            x=346*mW,
            y=476*mW,
            width=332*mW,
            height=341*mW,

            sourceX = 104*mW,
            sourceY = 9*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-4
            x=680*mW,
            y=2*mW,
            width=332*mW,
            height=341*mW,

            sourceX = 96*mW,
            sourceY = 9*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-7
            x=680*mW,
            y=345*mW,
            width=332*mW,
            height=341*mW,

            sourceX = 104*mW,
            sourceY = 9*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-9
            x=2*mW,
            y=476*mW,
            width=342*mW,
            height=381*mW,

            sourceX = 92*mW,
            sourceY = 39*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["torso-1"] = 1,
    ["torso-3"] = 2,
    ["torso-4"] = 3,
    ["torso-7"] = 4,
    ["torso-9"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
