--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2d535b71cba6af640f154e637e49edc4:c07f7c7b8dd5acd1ea708ed9c24a7570:df20e5a99330c3aec1aa6a51b5b12b0e$
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
            y=518*mW,
            width=313*mW,
            height=265*mW,

            sourceX = 109*mW,
            sourceY = 35*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-classic
            x=2*mW,
            y=2*mW,
            width=403*mW,
            height=259*mW,

            sourceX = 71*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-fool
            x=632*mW,
            y=591*mW,
            width=291*mW,
            height=275*mW,

            sourceX = 109*mW,
            sourceY = 38*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-gentleman
            x=2*mW,
            y=263*mW,
            width=305*mW,
            height=281*mW,

            sourceX = 116*mW,
            sourceY = 32*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-goggles
            x=309*mW,
            y=315*mW,
            width=396*mW,
            height=201*mW,

            sourceX = 65*mW,
            sourceY = 93*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-grump
            x=2*mW,
            y=546*mW,
            width=313*mW,
            height=273*mW,

            sourceX = 100*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-helmet
            x=735*mW,
            y=2*mW,
            width=274*mW,
            height=258*mW,

            sourceX = 126*mW,
            sourceY = 37*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-skicap
            x=407*mW,
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
            x=707*mW,
            y=315*mW,
            width=311*mW,
            height=274*mW,

            sourceX = 127*mW,
            sourceY = 33*mW,
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
    ["head-classic"] = 2,
    ["head-fool"] = 3,
    ["head-gentleman"] = 4,
    ["head-goggles"] = 5,
    ["head-grump"] = 6,
    ["head-helmet"] = 7,
    ["head-skicap"] = 8,
    ["head-tongue"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
