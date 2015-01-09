--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b890d3a352a5708dd84cd8e92435d705:f24d90148b67a085c85b8adff53341f8:741e39ba1d0d714dad191e57c57f7355$
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
            -- legs-buccaneer
            x=2*mW,
            y=2*mW,
            width=312*mW,
            height=363*mW,

            sourceX = 96*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-kilt
            x=2*mW,
            y=367*mW,
            width=307*mW,
            height=343*mW,

            sourceX = 114*mW,
            sourceY = 31*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-knight
            x=311*mW,
            y=367*mW,
            width=253*mW,
            height=341*mW,

            sourceX = 122*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-traveler
            x=316*mW,
            y=2*mW,
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

    ["legs-buccaneer"] = 1,
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
