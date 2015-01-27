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
local mW = 0.0013022*cW

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- torso-chef
            x=363*mW,
            y=473*mW,
            width=321*mW,
            height=423*mW,

            sourceX = 99*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-druid
            x=2*mW,
            y=2*mW,
            width=363*mW,
            height=469*mW,

            sourceX = 81*mW,
            sourceY = 4*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-hoodie
            x=686*mW,
            y=407*mW,
            width=333*mW,
            height=365*mW,

            sourceX = 95*mW,
            sourceY = 30*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-loon
            x=367*mW,
            y=2*mW,
            width=286*mW,
            height=354*mW,

            sourceX = 122*mW,
            sourceY = 20*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-suit
            x=686*mW,
            y=2*mW,
            width=334*mW,
            height=403*mW,

            sourceX = 91*mW,
            sourceY = 17*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-traveler
            x=2*mW,
            y=473*mW,
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

    ["torso-chef"] = 1,
    ["torso-druid"] = 2,
    ["torso-hoodie"] = 3,
    ["torso-loon"] = 4,
    ["torso-suit"] = 5,
    ["torso-traveler"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
