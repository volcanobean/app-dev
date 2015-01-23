--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f70ccca80b59e93e24a483c2b61979b3:e366a73acaafc2692fdc8bd686242990:6072724af51ccca8f1db8629b596b05c$
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
            -- sprout-1
            x=2*mW,
            y=438*mW,
            width=18*mW,
            height=67*mW,

            sourceX = 161*mW,
            sourceY = 212*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-2
            x=456*mW,
            y=2*mW,
            width=36*mW,
            height=104*mW,

            sourceX = 146*mW,
            sourceY = 175*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-3
            x=208*mW,
            y=2*mW,
            width=86*mW,
            height=138*mW,

            sourceX = 94*mW,
            sourceY = 146*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-4
            x=355*mW,
            y=138*mW,
            width=135*mW,
            height=130*mW,

            sourceX = 46*mW,
            sourceY = 146*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-5
            x=208*mW,
            y=142*mW,
            width=145*mW,
            height=135*mW,

            sourceX = 38*mW,
            sourceY = 147*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-6
            x=154*mW,
            y=290*mW,
            width=147*mW,
            height=139*mW,

            sourceX = 33*mW,
            sourceY = 150*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-7
            x=303*mW,
            y=2*mW,
            width=151*mW,
            height=134*mW,

            sourceX = 33*mW,
            sourceY = 145*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- sprout-final
            x=2*mW,
            y=290*mW,
            width=150*mW,
            height=146*mW,

            sourceX = 35*mW,
            sourceY = 143*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
        {
            -- vb-fire
            x=2*mW,
            y=2*mW,
            width=204*mW,
            height=286*mW,

            sourceX = 1*mW,
            sourceY = 1*mW,
            sourceWidth = 207*mW,
            sourceHeight = 289*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["sprout-1"] = 1,
    ["sprout-2"] = 2,
    ["sprout-3"] = 3,
    ["sprout-4"] = 4,
    ["sprout-5"] = 5,
    ["sprout-6"] = 6,
    ["sprout-7"] = 7,
    ["sprout-final"] = 8,
    ["vb-fire"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
