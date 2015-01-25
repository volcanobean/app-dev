--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:12fcf9fab2b4b4b72463c647a309a631:9cc0845a6fcff152fec77bdc45d0ff97:741e39ba1d0d714dad191e57c57f7355$
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
            -- legs-kilt
            x=2*mW,
            y=334*mW,
            width=307*mW,
            height=343*mW,

            sourceX = 114*mW,
            sourceY = 31*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-knight
            x=2*mW,
            y=679*mW,
            width=253*mW,
            height=341*mW,

            sourceX = 122*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-traveler
            x=257*mW,
            y=679*mW,
            width=286*mW,
            height=331*mW,

            sourceX = 112*mW,
            sourceY = 50*mW,
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
    ["legs-kilt"] = 2,
    ["legs-knight"] = 3,
    ["legs-traveler"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
