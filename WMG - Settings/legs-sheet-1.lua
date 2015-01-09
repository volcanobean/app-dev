--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b890d3a352a5708dd84cd8e92435d705:f24d90148b67a085c85b8adff53341f8:741e39ba1d0d714dad191e57c57f7355$
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
            -- legs-bermuda
            x=424*mW,
            y=367*mW,
            width=326*mW,
            height=349*mW,

            sourceX = 92*mW,
            sourceY = 24*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-bigfoot
            x=2*mW,
            y=662*mW,
            width=361*mW,
            height=330*mW,

            sourceX = 83*mW,
            sourceY = 55*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-dancer
            x=2*mW,
            y=2*mW,
            width=480*mW,
            height=331*mW,

            sourceX = 17*mW,
            sourceY = 46*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-prisoner
            x=484*mW,
            y=2*mW,
            width=376*mW,
            height=363*mW,

            sourceX = 97*mW,
            sourceY = 16*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-weeezard
            x=2*mW,
            y=335*mW,
            width=420*mW,
            height=325*mW,

            sourceX = 64*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
        {
            -- legs-yeehaw
            x=752*mW,
            y=367*mW,
            width=265*mW,
            height=343*mW,

            sourceX = 130*mW,
            sourceY = 18*mW,
            sourceWidth = 512*mW,
            sourceHeight = 396*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["legs-bermuda"] = 1,
    ["legs-bigfoot"] = 2,
    ["legs-dancer"] = 3,
    ["legs-prisoner"] = 4,
    ["legs-weeezard"] = 5,
    ["legs-yeehaw"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
