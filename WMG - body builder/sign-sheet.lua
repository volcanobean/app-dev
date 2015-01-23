--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fcad82d674a555aaa52379c771c6bf45:cfa4c303d16cd0eb7d3af2b2077b5163:6779c8eb6f0dc9e2bd19532932cb0930$
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
            -- sign-check-1
            x=2*mW,
            y=2*mW,
            width=187*mW,
            height=175*mW,

            sourceX = 0,
            sourceY = 12*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-check-2
            x=191*mW,
            y=179*mW,
            width=146*mW,
            height=179*mW,

            sourceX = 10*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-check-3
            x=86*mW,
            y=729*mW,
            width=82*mW,
            height=179*mW,

            sourceX = 47*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-check-5
            x=380*mW,
            y=2*mW,
            width=82*mW,
            height=187*mW,

            sourceX = 61*mW,
            sourceY = 0,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-check-6
            x=150*mW,
            y=360*mW,
            width=144*mW,
            height=178*mW,

            sourceX = 19*mW,
            sourceY = 9*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-goblin-1
            x=191*mW,
            y=2*mW,
            width=187*mW,
            height=175*mW,

            sourceX = 0,
            sourceY = 12*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-goblin-2
            x=339*mW,
            y=191*mW,
            width=146*mW,
            height=179*mW,

            sourceX = 10*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-goblin-3
            x=170*mW,
            y=729*mW,
            width=82*mW,
            height=179*mW,

            sourceX = 47*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-goblin-5
            x=148*mW,
            y=540*mW,
            width=82*mW,
            height=187*mW,

            sourceX = 61*mW,
            sourceY = 0,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-goblin-6
            x=2*mW,
            y=537*mW,
            width=144*mW,
            height=178*mW,

            sourceX = 19*mW,
            sourceY = 9*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-middle
            x=464*mW,
            y=2*mW,
            width=26*mW,
            height=184*mW,

            sourceX = 85*mW,
            sourceY = 3*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-x-1
            x=2*mW,
            y=179*mW,
            width=187*mW,
            height=175*mW,

            sourceX = 0,
            sourceY = 12*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-x-2
            x=2*mW,
            y=356*mW,
            width=146*mW,
            height=179*mW,

            sourceX = 10*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-x-3
            x=254*mW,
            y=552*mW,
            width=82*mW,
            height=179*mW,

            sourceX = 47*mW,
            sourceY = 8*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-x-5
            x=2*mW,
            y=717*mW,
            width=82*mW,
            height=187*mW,

            sourceX = 61*mW,
            sourceY = 0,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
        {
            -- sign-x-6
            x=296*mW,
            y=372*mW,
            width=144*mW,
            height=178*mW,

            sourceX = 19*mW,
            sourceY = 9*mW,
            sourceWidth = 188*mW,
            sourceHeight = 187*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["sign-check-1"] = 1,
    ["sign-check-2"] = 2,
    ["sign-check-3"] = 3,
    ["sign-check-5"] = 4,
    ["sign-check-6"] = 5,
    ["sign-goblin-1"] = 6,
    ["sign-goblin-2"] = 7,
    ["sign-goblin-3"] = 8,
    ["sign-goblin-5"] = 9,
    ["sign-goblin-6"] = 10,
    ["sign-middle"] = 11,
    ["sign-x-1"] = 12,
    ["sign-x-2"] = 13,
    ["sign-x-3"] = 14,
    ["sign-x-5"] = 15,
    ["sign-x-6"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
