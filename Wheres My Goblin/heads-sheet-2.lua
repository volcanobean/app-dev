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
            -- head-hood
            x=2*mW,
            y=2*mW,
            width=269*mW,
            height=284*mW,

            sourceX = 135*mW,
            sourceY = 29*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["head-hood"] = 1,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
