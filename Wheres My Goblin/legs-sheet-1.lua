--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8d1d824bf3a77426c8248ac5520ce276:47040aeb8f2af6f8f0d05fc359d76d7e:741e39ba1d0d714dad191e57c57f7355$
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
            -- legs-1
            x=2*mW,
            y=2*mW,
            width=315*mW,
            height=373*mW,

            sourceX = 108*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-10
            x=319*mW,
            y=2*mW,
            width=358*mW,
            height=364*mW,

            sourceX = 82*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-2
            x=2*mW,
            y=377*mW,
            width=315*mW,
            height=373*mW,

            sourceX = 111*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-3
            x=679*mW,
            y=2*mW,
            width=338*mW,
            height=367*mW,

            sourceX = 121*mW,
            sourceY = 12*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-4
            x=679*mW,
            y=371*mW,
            width=338*mW,
            height=367*mW,

            sourceX = 77*mW,
            sourceY = 12*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-5
            x=319*mW,
            y=368*mW,
            width=358*mW,
            height=364*mW,

            sourceX = 88*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["legs-1"] = 1,
    ["legs-10"] = 2,
    ["legs-2"] = 3,
    ["legs-3"] = 4,
    ["legs-4"] = 5,
    ["legs-5"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
