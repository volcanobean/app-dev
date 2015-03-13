--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fe74a883b73db05557c5c93380246b00:756a95b06de4af4e952edca70f00cbe1:fdc86dec307cef64ae0388a068a7ce5a$
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
            -- torso-loon
            x=2*mW,
            y=324*mW,
            width=286*mW,
            height=354*mW,

            sourceX = 122*mW,
            sourceY = 20*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-sweater-bottom
            x=2*mW,
            y=2*mW,
            width=340*mW,
            height=320*mW,

            sourceX = 89*mW,
            sourceY = 48*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["torso-loon"] = 1,
    ["torso-sweater-bottom"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
