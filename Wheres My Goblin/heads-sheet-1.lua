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
            x=643,
            y=274,
            width=313,
            height=265,

            sourceX = 109,
            sourceY = 35,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-gentleman
            x=273,
            y=731,
            width=305,
            height=281,

            sourceX = 116,
            sourceY = 32,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-goggles
            x=2,
            y=215,
            width=396,
            height=201,

            sourceX = 65,
            sourceY = 93,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-grump
            x=580,
            y=694,
            width=313,
            height=273,

            sourceX = 100,
            sourceY = 23,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-hood
            x=2,
            y=731,
            width=269,
            height=284,

            sourceX = 135,
            sourceY = 29,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-skicap
            x=2,
            y=418,
            width=326,
            height=311,

            sourceX = 85,
            sourceY = 1,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-tongue
            x=330,
            y=418,
            width=311,
            height=274,

            sourceX = 127,
            sourceY = 33,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-zzz1
            x=453,
            y=2,
            width=405,
            height=270,

            sourceX = 70,
            sourceY = 37,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-zzz2
            x=2,
            y=2,
            width=449,
            height=211,

            sourceX = 40,
            sourceY = 72,
            sourceWidth = 512,
            sourceHeight = 313
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
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
