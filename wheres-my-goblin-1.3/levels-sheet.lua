--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:0aa4782e14fb44e3ab0a0566973e3616:d3b405d33219fe85a0f89e70a179151c:f295a5e41bd228871f9553b08109f893$
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
            -- easy
            x=134*mW,
            y=442*mW,
            width=91*mW,
            height=56*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 91*mW,
            sourceHeight = 56*mW
        },
        {
            -- hard
            x=42*mW,
            y=2*mW,
            width=88*mW,
            height=55*mW,

        },
        {
            -- levels-easy
            x=134*mW,
            y=2*mW,
            width=219*mW,
            height=95*mW,

            sourceX = 1*mW,
            sourceY = 33*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-hard
            x=134*mW,
            y=99*mW,
            width=219*mW,
            height=94*mW,

            sourceX = 2*mW,
            sourceY = 34*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-med
            x=134*mW,
            y=195*mW,
            width=218*mW,
            height=98*mW,

            sourceX = 2*mW,
            sourceY = 29*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-post
            x=2*mW,
            y=2*mW,
            width=38*mW,
            height=450*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 38*mW,
            sourceHeight = 450*mW
        },
        {
            -- levels-spin-2
            x=216*mW,
            y=296*mW,
            width=174*mW,
            height=125*mW,

            sourceX = 10*mW,
            sourceY = 27*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-3
            x=355*mW,
            y=2*mW,
            width=98*mW,
            height=131*mW,

            sourceX = 54*mW,
            sourceY = 8*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-4
            x=455*mW,
            y=2*mW,
            width=27*mW,
            height=158*mW,

            sourceX = 104*mW,
            sourceY = 4*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-5
            x=355*mW,
            y=135*mW,
            width=97*mW,
            height=159*mW,

            sourceX = 72*mW,
            sourceY = 0,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-6
            x=42*mW,
            y=296*mW,
            width=172*mW,
            height=144*mW,

            sourceX = 22*mW,
            sourceY = 20*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- medium
            x=2*mW,
            y=454*mW,
            width=130*mW,
            height=56*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 130*mW,
            sourceHeight = 56*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["easy"] = 1,
    ["hard"] = 2,
    ["levels-easy"] = 3,
    ["levels-hard"] = 4,
    ["levels-med"] = 5,
    ["levels-post"] = 6,
    ["levels-spin-2"] = 7,
    ["levels-spin-3"] = 8,
    ["levels-spin-4"] = 9,
    ["levels-spin-5"] = 10,
    ["levels-spin-6"] = 11,
    ["medium"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
