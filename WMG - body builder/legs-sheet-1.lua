--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:12fcf9fab2b4b4b72463c647a309a631:9cc0845a6fcff152fec77bdc45d0ff97:741e39ba1d0d714dad191e57c57f7355$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- legs-bermuda
            x=2,
            y=656,
            width=326,
            height=349,

            sourceX = 92,
            sourceY = 24,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-buccaneer
            x=708,
            y=656,
            width=312,
            height=363,

            sourceX = 96,
            sourceY = 1,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-dancer
            x=269,
            y=323,
            width=480,
            height=331,

            sourceX = 17,
            sourceY = 46,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-prisoner
            x=330,
            y=656,
            width=376,
            height=363,

            sourceX = 97,
            sourceY = 16,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-wizard-color
            x=415,
            y=2,
            width=369,
            height=319,

            sourceX = 114,
            sourceY = 44,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-wizard
            x=2,
            y=2,
            width=411,
            height=293,

            sourceX = 63,
            sourceY = 76,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-yeehaw
            x=2,
            y=297,
            width=265,
            height=343,

            sourceX = 130,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 396
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
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
