--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ee64b3c093b1c015b3542689d19d33f3:8649f155b1ee4a107052f35f7a448ad6:81aad88cedae2198d48186096928dacc$
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
            -- settings-about
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
            -- settings-audio
            x=160*mW,
            y=2*mW,
            width=156*mW,
            height=180*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-home
            x=160*mW,
            y=184*mW,
            width=154*mW,
            height=184*mW,

            sourceX = 1*mW,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-menu
            x=316*mW,
            y=184*mW,
            width=155*mW,
            height=150*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-mute
            x=318*mW,
            y=2*mW,
            width=156*mW,
            height=180*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
        {
            -- settings-replay
            x=2*mW,
            y=190*mW,
            width=156*mW,
            height=186*mW,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 156*mW,
            sourceHeight = 187*mW
        },
    },
    
    sheetContentWidth = 512*mW,
    sheetContentHeight = 512*mW
}

SheetInfo.frameIndex =
{

    ["settings-about"] = 1,
    ["settings-audio"] = 2,
    ["settings-home"] = 3,
    ["settings-menu"] = 4,
    ["settings-mute"] = 5,
    ["settings-replay"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
