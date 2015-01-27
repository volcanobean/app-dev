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
            -- legs-bermuda
            x=2*mW,
            y=656*mW,
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
            y=656*mW,
            width=312*mW,
            height=363*mW,

            sourceX = 96*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-dancer
            x=269*mW,
            y=323*mW,
            width=480*mW,
            height=331*mW,

            sourceX = 17*mW,
            sourceY = 46*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-prisoner
            x=330*mW,
            y=656*mW,
            width=376*mW,
            height=363*mW,

            sourceX = 97*mW,
            sourceY = 16*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-wizard-color
            x=415*mW,
            y=2*mW,
            width=369*mW,
            height=319*mW,

            sourceX = 114*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-wizard
            x=2*mW,
            y=2*mW,
            width=411*mW,
            height=293*mW,

            sourceX = 63*mW,
            sourceY = 76*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-yeehaw
            x=2*mW,
            y=297*mW,
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

    ["legs-bermuda"] = 1,
    ["legs-buccaneer"] = 2,
    ["legs-dancer"] = 3,
    ["legs-prisoner"] = 4,
    ["legs-wizard-color"] = 5,
    ["legs-wizard"] = 6,
    ["legs-yeehaw"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
