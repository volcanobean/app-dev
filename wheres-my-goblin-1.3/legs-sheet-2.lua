--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e192f972ffb11b1c86f22f687c83027c:cd9bab7532c9b956179fcaec46f0eb79:741e39ba1d0d714dad191e57c57f7355$
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
            -- legs-bigfoot
            x=2*mW,
            y=2*mW,
            width=361*mW,
            height=330*mW,

            sourceX = 83*mW,
            sourceY = 55*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-kilt-bottom
            x=365*mW,
            y=2*mW,
            width=223*mW,
            height=248*mW,

            sourceX = 155*mW,
            sourceY = 31*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-kilt-top
            x=2*mW,
            y=679*mW,
            width=276*mW,
            height=341*mW,

            sourceX = 114*mW,
            sourceY = 33*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-knight-bottom
            x=269*mW,
            y=334*mW,
            width=253*mW,
            height=341*mW,

            sourceX = 122*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-skates
            x=280*mW,
            y=677*mW,
            width=280*mW,
            height=337*mW,

            sourceX = 123*mW,
            sourceY = 47*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-traveler
            x=524*mW,
            y=252*mW,
            width=286*mW,
            height=331*mW,

            sourceX = 112*mW,
            sourceY = 50*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-yeehaw
            x=2*mW,
            y=334*mW,
            width=265*mW,
            height=343*mW,

            sourceX = 130*mW,
            sourceY = 18*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["legs-bigfoot"] = 1,
    ["legs-kilt-bottom"] = 2,
    ["legs-kilt-top"] = 3,
    ["legs-knight-bottom"] = 4,
    ["legs-skates"] = 5,
    ["legs-traveler"] = 6,
    ["legs-yeehaw"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
