--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d43988ec2958b0eaf2547c2e7ba04dec:c949275da3fffa1b5f2b87c427b58910:8896903440eaed2e047bd863648d6120$
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
            -- letter-c
            x=2*mW,
            y=90*mW,
            width=82*mW,
            height=86*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 82*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-g
            x=86*mW,
            y=90*mW,
            width=82*mW,
            height=86*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 82*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-i
            x=170*mW,
            y=168*mW,
            width=27*mW,
            height=81*mW,

            sourceX = 0,
            sourceY = 2*mW,
            sourceWidth = 27*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-n
            x=169*mW,
            y=2*mW,
            width=78*mW,
            height=81*mW,

            sourceX = 0,
            sourceY = 2*mW,
            sourceWidth = 78*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-o
            x=2*mW,
            y=2*mW,
            width=85*mW,
            height=86*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 85*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-r
            x=170*mW,
            y=85*mW,
            width=77*mW,
            height=81*mW,

            sourceX = 0,
            sourceY = 2*mW,
            sourceWidth = 77*mW,
            sourceHeight = 86*mW
        },
        {
            -- letter-u
            x=89*mW,
            y=2*mW,
            width=78*mW,
            height=84*mW,

            sourceX = 0,
            sourceY = 2*mW,
            sourceWidth = 78*mW,
            sourceHeight = 86*mW
        },
    },
    
    sheetContentWidth = 256*mW,
    sheetContentHeight = 256*mW
}

SheetInfo.frameIndex =
{

    ["letter-c"] = 1,
    ["letter-g"] = 2,
    ["letter-i"] = 3,
    ["letter-n"] = 4,
    ["letter-o"] = 5,
    ["letter-r"] = 6,
    ["letter-u"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
