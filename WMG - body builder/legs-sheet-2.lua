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
            -- legs-bigfoot
            x=2,
            y=2,
            width=361,
            height=330,

            sourceX = 83,
            sourceY = 55,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-kilt
            x=2,
            y=334,
            width=307,
            height=343,

            sourceX = 114,
            sourceY = 31,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-knight
            x=2,
            y=679,
            width=253,
            height=341,

            sourceX = 122,
            sourceY = 35,
            sourceWidth = 512,
            sourceHeight = 396
        },
        {
            -- legs-traveler
            x=257,
            y=679,
            width=286,
            height=331,

            sourceX = 112,
            sourceY = 50,
            sourceWidth = 512,
            sourceHeight = 396
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
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
