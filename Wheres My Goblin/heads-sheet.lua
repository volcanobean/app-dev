--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d30ab6aff7d6a93875bf1c74f503469a:dcfbdd281a933279e7247f69bb3d0c45:b7a99079db8de5a3ff6948a2803acac4$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local cW = display.contentWidth
--local mW = 0.0013020833*cW
local mW = 0.0013022*cW

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- head-cheshire
            x=308*mW,
            y=240*mW,
            width=287*mW,
            height=241*mW,

            sourceX = 116*mW,
            sourceY = 33*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-classic
            x=376*mW,
            y=2*mW,
            width=367*mW,
            height=236*mW,

            sourceX = 87*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-fool
            x=534*mW,
            y=715*mW,
            width=265*mW,
            height=250*mW,

            sourceX = 113*mW,
            sourceY = 46*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-gentleman
            x=745*mW,
            y=2*mW,
            width=277*mW,
            height=255*mW,

            sourceX = 122*mW,
            sourceY = 36*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-goggles
            x=2*mW,
            y=2*mW,
            width=372*mW,
            height=189*mW,

            sourceX = 68*mW,
            sourceY = 94*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-grump
            x=2*mW,
            y=193*mW,
            width=304*mW,
            height=265*mW,

            sourceX = 103*mW,
            sourceY = 17*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-helmet
            x=290*mW,
            y=483*mW,
            width=244*mW,
            height=230*mW,

            sourceX = 137*mW,
            sourceY = 41*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-hood
            x=288*mW,
            y=715*mW,
            width=244*mW,
            height=257*mW,

            sourceX = 147*mW,
            sourceY = 40*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-skicap
            x=2*mW,
            y=715*mW,
            width=284*mW,
            height=270*mW,

            sourceX = 101*mW,
            sourceY = 6*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-tongue
            x=2*mW,
            y=460*mW,
            width=286*mW,
            height=253*mW,

            sourceX = 134*mW,
            sourceY = 47*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["head-cheshire"] = 1,
    ["head-classic"] = 2,
    ["head-fool"] = 3,
    ["head-gentleman"] = 4,
    ["head-goggles"] = 5,
    ["head-grump"] = 6,
    ["head-helmet"] = 7,
    ["head-hood"] = 8,
    ["head-skicap"] = 9,
    ["head-tongue"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
