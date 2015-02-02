--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fe74a883b73db05557c5c93380246b00:756a95b06de4af4e952edca70f00cbe1:fdc86dec307cef64ae0388a068a7ce5a$
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
            -- torso-bomb
            x=363*mW,
            y=473*mW,
            width=397*mW,
            height=351*mW,

            sourceX = 27*mW,
            sourceY = 15*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-druid
            x=396*mW,
            y=2*mW,
            width=363*mW,
            height=469*mW,

            sourceX = 81*mW,
            sourceY = 4*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-hoodie-top
            x=761*mW,
            y=2*mW,
            width=248*mW,
            height=324*mW,

            sourceX = 144*mW,
            sourceY = 70*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-knight-bottom
            x=363*mW,
            y=826*mW,
            width=205*mW,
            height=192*mW,

            sourceX = 157*mW,
            sourceY = 116*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-knight-top
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
            -- torso-traveler
            x=2*mW,
            y=416*mW,
            width=359*mW,
            height=450*mW,

            sourceX = 83*mW,
            sourceY = 21*mW,
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
    ["torso-druid"] = 2,
    ["torso-hoodie-top"] = 3,
    ["torso-knight-bottom"] = 4,
    ["torso-knight-top"] = 5,
    ["torso-traveler"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
