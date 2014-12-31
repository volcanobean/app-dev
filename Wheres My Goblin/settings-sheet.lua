--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:34fd497a37d788ed6ed5de6291abb32a:ce70113939587779caf0f86a9c259202:81aad88cedae2198d48186096928dacc$
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
            -- settings-audio
            x=158*mW,
            y=190*mW,
            width=156*mW,
            height=180*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-down
            x=316*mW,
            y=2*mW,
            width=155*mW,
            height=141*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 142*mW
        },
        {
            -- settings-home
            x=2*mW,
            y=190*mW,
            width=154*mW,
            height=184*mW,

            sourceX = 1*mW,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-replay
            x=2*mW,
            y=2*mW,
            width=156*mW,
            height=186*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-up
            x=316*mW,
            y=145*mW,
            width=155*mW,
            height=141*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 142*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["settings-audio"] = 1,
    ["settings-down"] = 2,
    ["settings-home"] = 3,
    ["settings-replay"] = 4,
    ["settings-up"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
