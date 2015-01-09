--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ac7013b1d1c19c5218f46ee7b3c892cb:0db299d9745cfcf06939dabfc4122134:246703efdebcd2225ad8f2bcf38b9d09$
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
            -- torso-bomb
            x=396*mW,
            y=2*mW,
            width=397*mW,
            height=351*mW,

            sourceX = 27*mW,
            sourceY = 15*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-knight
            x=2*mW,
            y=2*mW,
            width=392*mW,
            height=412*mW,

            sourceX = 60*mW,
            sourceY = 11*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-napolean
            x=2*mW,
            y=416*mW,
            width=337*mW,
            height=388*mW,

            sourceX = 105*mW,
            sourceY = 13*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-sweater
            x=341*mW,
            y=416*mW,
            width=340*mW,
            height=378*mW,

            sourceX = 89*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["torso-bomb"] = 1,
    ["torso-knight"] = 2,
    ["torso-napolean"] = 3,
    ["torso-sweater"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
