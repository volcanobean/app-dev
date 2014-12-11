--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:c30a7385912aebf71d6746a9baec9f3a:a9fde908063a73312783a5e60fc414c0:0449541957276c65ebed4795a3c6c447$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

-- single variable to scale all goblin banner parts larger or smaller, must match value found in ui-overlay

local mScale = 0.83 

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- head-cheshire
            x=306*mScale,
            y=755*mScale,
            width=313*mScale,
            height=264*mScale,

            sourceX = 109*mScale,
            sourceY = 36*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-gentleman
            x=2*mScale,
            y=479*mScale,
            width=302*mScale,
            height=312*mScale,

            sourceX = 117*mScale,
            sourceY = 0,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-goggles
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
            x=2*mScale,
            y=205*mScale,
            width=313*mScale,
            height=272*mScale,

            sourceX = 100*mScale,
            sourceY = 24*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-helmet
            x=725*mScale,
            y=2*mScale,
            width=274*mScale,
            height=258*mScale,

            sourceX = 126*mScale,
            sourceY = 37*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-skicap
            x=398*mScale,
            y=2*mScale,
            width=325*mScale,
            height=310*mScale,

            sourceX = 85*mScale,
            sourceY = 2*mScale,
            sourceWidth = 512*mScale,
            sourceHeight = 313*mScale
        },
        {
            -- head-tongue
            x=306*mScale,
            y=479*mScale,
            width=310*mScale,
            height=274*mScale,

            sourceX = 128*mScale,
            sourceY = 33*mScale,
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
    ["head-goggles"] = 3,
    ["head-grump"] = 4,
    ["head-helmet"] = 5,
    ["head-skicap"] = 6,
    ["head-tongue"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
