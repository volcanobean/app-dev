--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:54555bab193eee88467578415c0f3a1a:b9e5042f3d6ff46eec18042abbfcb5ab:f1cad4016a2bbc5db9d2b04b058d1cff$
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
            -- rope-left
            x=2*mW,
            y=2*mW,
            width=34*mW,
            height=505*mW,

            sourceX = 3*mW,
            sourceY = 0,
            sourceWidth = 37*mW,
            sourceHeight = 505*mW
        },
        {
            -- rope-right
            x=38*mW,
            y=2*mW,
            width=24*mW,
            height=505*mW,

            sourceX = 1*mW,
            sourceY = 0,
            sourceWidth = 25*mW,
            sourceHeight = 505*mW
        },
    },
    
    sheetContentWidth = 64*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["rope-left"] = 1,
    ["rope-right"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
