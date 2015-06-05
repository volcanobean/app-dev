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
            -- legs-bermuda
            x=2*mW,
            y=618*mW,
            width=326*mW,
            height=349*mW,

            sourceX = 92*mW,
            sourceY = 24*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-buccaneer
            x=708*mW,
            y=634*mW,
            width=312*mW,
            height=363*mW,

            sourceX = 96*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-dancer-bottom
            x=373*mW,
            y=301*mW,
            width=480*mW,
            height=331*mW,

            sourceX = 17*mW,
            sourceY = 46*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-dancer-top
            x=479*mW,
            y=2*mW,
            width=476*mW,
            height=297*mW,

            sourceX = 19*mW,
            sourceY = 78*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-knight-top
            x=2*mW,
            y=2*mW,
            width=62*mW,
            height=158*mW,

            sourceX = 228*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-prisoner
            x=330*mW,
            y=634*mW,
            width=376*mW,
            height=363*mW,

            sourceX = 97*mW,
            sourceY = 16*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-wizard-bottom
            x=2*mW,
            y=297*mW,
            width=369*mW,
            height=319*mW,

            sourceX = 114*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-wizard-top
            x=66*mW,
            y=2*mW,
            width=411*mW,
            height=293*mW,

            sourceX = 63*mW,
            sourceY = 76*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["legs-bermuda"] = 1,
    ["legs-buccaneer"] = 2,
    ["legs-dancer-bottom"] = 3,
    ["legs-dancer-top"] = 4,
    ["legs-knight-top"] = 5,
    ["legs-prisoner"] = 6,
    ["legs-wizard-bottom"] = 7,
    ["legs-wizard-top"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
