--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e15b0696c9a1e28b768a24a6fdb60eb9:b107b169826e74d7c186ed926211de31:df20e5a99330c3aec1aa6a51b5b12b0e$
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
            -- head-cheshire
            x=1286,
            y=548,
            width=626,
            height=530,

            sourceX = 218,
            sourceY = 70,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-gentleman
            x=546,
            y=1462,
            width=610,
            height=562,

            sourceX = 232,
            sourceY = 64,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-goggles
            x=4,
            y=430,
            width=792,
            height=402,

            sourceX = 130,
            sourceY = 186,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-grump
            x=1160,
            y=1388,
            width=626,
            height=546,

            sourceX = 200,
            sourceY = 46,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-hood
            x=4,
            y=1462,
            width=538,
            height=568,

            sourceX = 270,
            sourceY = 58,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-skicap
            x=4,
            y=836,
            width=652,
            height=622,

            sourceX = 170,
            sourceY = 2,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-tongue
            x=660,
            y=836,
            width=622,
            height=548,

            sourceX = 254,
            sourceY = 66,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-zzz1
            x=906,
            y=4,
            width=810,
            height=540,

            sourceX = 140,
            sourceY = 74,
            sourceWidth = 1024,
            sourceHeight = 626
        },
        {
            -- head-zzz2
            x=4,
            y=4,
            width=898,
            height=422,

            sourceX = 80,
            sourceY = 144,
            sourceWidth = 1024,
            sourceHeight = 626
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["head-cheshire"] = 1,
    ["head-gentleman"] = 2,
    ["head-goggles"] = 3,
    ["head-grump"] = 4,
    ["head-hood"] = 5,
    ["head-skicap"] = 6,
    ["head-tongue"] = 7,
    ["head-zzz1"] = 8,
    ["head-zzz2"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
