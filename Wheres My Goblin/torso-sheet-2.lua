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
            -- torso-10
            x=2*mW,
            y=2*mW,
            width=379*mW,
            height=472*mW,

            sourceX = 60*mW,
            sourceY = 40*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-2
            x=383*mW,
            y=2*mW,
            width=379*mW,
            height=472*mW,

            sourceX = 60*mW,
            sourceY = 40*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-5
            x=2*mW,
            y=476*mW,
            width=342*mW,
            height=381*mW,

            sourceX = 92*mW,
            sourceY = 39*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-6
            x=346*mW,
            y=476*mW,
            width=342*mW,
            height=381*mW,

            sourceX = 86*mW,
            sourceY = 39*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-8
            x=690*mW,
            y=476*mW,
            width=332*mW,
            height=341*mW,

            sourceX = 96*mW,
            sourceY = 9*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["torso-10"] = 1,
    ["torso-2"] = 2,
    ["torso-5"] = 3,
    ["torso-6"] = 4,
    ["torso-8"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
