--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:44e55ed8c3452a3eb580f0e545c7897d:392d4e44b5f147f8c166c4e6cc756e15:0449541957276c65ebed4795a3c6c447$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--
local mScale = 0.83 

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- head-cheshire
            x=398*mScale,
            y=2*mScale,
            width=373*mScale,
            height=238*mScale,

            sourceX = 73*mScale,
            sourceY = 60*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-gentleman
            x=2*mScale,
            y=517*mScale,
            width=302*mScale,
            height=312*mScale,

            sourceX = 117*mScale,
            sourceY = 0,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-googles
            x=2*mScale,
            y=2*mScale,
            width=394*mScale,
            height=201*mScale,

            sourceX = 66*mScale,
            sourceY = 93*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-grump
            x=306*mScale,
            y=517*mScale,
            width=313*mScale,
            height=272*mScale,

            sourceX = 100*mScale,
            sourceY = 24*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-helmet
            x=329*mScale,
            y=242*mScale,
            width=274*mScale,
            height=258*mScale,

            sourceX = 126*mScale,
            sourceY = 37*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-skicap
            x=2*mScale,
            y=205*mScale,
            width=325*mScale,
            height=310*mScale,

            sourceX = 85*mScale,
            sourceY = 2*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
    },
    
    sheetContentWidth = 1024*mScale,
    sheetContentHeight = 1024*mScale
}

SheetInfo.frameIndex =
{

    ["head-cheshire"] = 1,
    ["head-gentleman"] = 2,
    ["head-googles"] = 3,
    ["head-grump"] = 4,
    ["head-helmet"] = 5,
    ["head-skicap"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
