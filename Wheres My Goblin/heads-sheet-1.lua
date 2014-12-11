--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:af9f2ed8716df29fba6cf57ea5b8c7ee:6436282a909f24794df0f854452169ba:df20e5a99330c3aec1aa6a51b5b12b0e$
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
            -- head-cheshire
            x=317*mW,
            y=315*mW,
            width=313*mW,
            height=265*mW,

            sourceX = 109*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-fool
            x=315*mW,
            y=582*mW,
            width=291*mW,
            height=275*mW,

            sourceX = 109*mW,
            sourceY = 38*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-gentleman
            x=632*mW,
            y=548*mW,
            width=305*mW,
            height=281*mW,

            sourceX = 116*mW,
            sourceY = 32*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-grump
            x=2*mW,
            y=274*mW,
            width=313*mW,
            height=273*mW,

            sourceX = 100*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-helmet
            x=737*mW,
            y=2*mW,
            width=274*mW,
            height=258*mW,

            sourceX = 126*mW,
            sourceY = 37*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-hood
            x=737*mW,
            y=262*mW,
            width=269*mW,
            height=284*mW,

            sourceX = 135*mW,
            sourceY = 29*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-skicap
            x=409*mW,
            y=2*mW,
            width=326*mW,
            height=311*mW,

            sourceX = 85*mW,
            sourceY = 1*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-tongue
            x=2*mW,
            y=549*mW,
            width=311*mW,
            height=274*mW,

            sourceX = 127*mW,
            sourceY = 33*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-zzz1
            x=2*mW,
            y=2*mW,
            width=405*mW,
            height=270*mW,

            sourceX = 70*mW,
            sourceY = 37*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["head-cheshire"] = 1,
    ["head-fool"] = 2,
    ["head-gentleman"] = 3,
    ["head-grump"] = 4,
    ["head-helmet"] = 5,
    ["head-hood"] = 6,
    ["head-skicap"] = 7,
    ["head-tongue"] = 8,
    ["head-zzz1"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
