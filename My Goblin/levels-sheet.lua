--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cbd576eb383cf0082cbbae87decf5f43:d5bbe6ad953c0f9f71658d1af340f96d:f295a5e41bd228871f9553b08109f893$
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
            -- levels-easy
            x=42*mW,
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
            x=263*mW,
            y=2*mW,
            width=219*mW,
            height=94*mW,

            sourceX = 2*mW,
            sourceY = 34*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-med
            x=263*mW,
            y=98*mW,
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
            x=42*mW,
            y=99*mW,
            width=174*mW,
            height=125*mW,

            sourceX = 10*mW,
            sourceY = 27*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-3
            x=392*mW,
            y=258*mW,
            width=98*mW,
            height=131*mW,

            sourceX = 54*mW,
            sourceY = 8*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-4
            x=483*mW,
            y=98*mW,
            width=27*mW,
            height=158*mW,

            sourceX = 104*mW,
            sourceY = 4*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-5
            x=42*mW,
            y=344*mW,
            width=97*mW,
            height=159*mW,

            sourceX = 72*mW,
            sourceY = 0,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
        {
            -- levels-spin-6
            x=218*mW,
            y=198*mW,
            width=172*mW,
            height=144*mW,

            sourceX = 22*mW,
            sourceY = 20*mW,
            sourceWidth = 223*mW,
            sourceHeight = 164*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["levels-easy"] = 1,
    ["levels-hard"] = 2,
    ["levels-med"] = 3,
    ["levels-post"] = 4,
    ["levels-spin-2"] = 5,
    ["levels-spin-3"] = 6,
    ["levels-spin-4"] = 7,
    ["levels-spin-5"] = 8,
    ["levels-spin-6"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
