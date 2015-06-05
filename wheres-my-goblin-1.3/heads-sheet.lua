--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d525f7b5be1294a460a6c9165dcf4ea7:67b1ae482245abe260f172e33a4ce1ad:b7a99079db8de5a3ff6948a2803acac4$
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
            -- head-cheshire
            x=2*mW,
            y=480*mW,
            width=287*mW,
            height=241*mW,

            sourceX = 116*mW,
            sourceY = 33*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-classic-bottom
            x=817*mW,
            y=751*mW,
            width=191*mW,
            height=88*mW,

            sourceX = 166*mW,
            sourceY = 44*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-classic-top
            x=376*mW,
            y=2*mW,
            width=367*mW,
            height=220*mW,

            sourceX = 87*mW,
            sourceY = 60*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-fool-bottom
            x=576*mW,
            y=751*mW,
            width=239*mW,
            height=204*mW,

            sourceX = 136*mW,
            sourceY = 46*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-fool-top
            x=745*mW,
            y=259*mW,
            width=264*mW,
            height=236*mW,

            sourceX = 113*mW,
            sourceY = 60*mW,
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
            x=347*mW,
            y=224*mW,
            width=304*mW,
            height=265*mW,

            sourceX = 103*mW,
            sourceY = 17*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-helmet
            x=291*mW,
            y=491*mW,
            width=244*mW,
            height=230*mW,

            sourceX = 137*mW,
            sourceY = 41*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-hood-bottom
            x=537*mW,
            y=491*mW,
            width=206*mW,
            height=210*mW,

            sourceX = 147*mW,
            sourceY = 40*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-hood-top
            x=745*mW,
            y=497*mW,
            width=240*mW,
            height=252*mW,

            sourceX = 150*mW,
            sourceY = 45*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-skicap-bottom
            x=817*mW,
            y=841*mW,
            width=179*mW,
            height=125*mW,

            sourceX = 151*mW,
            sourceY = 70*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-skicap-top
            x=2*mW,
            y=723*mW,
            width=284*mW,
            height=269*mW,

            sourceX = 101*mW,
            sourceY = 7*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-tongue
            x=288*mW,
            y=723*mW,
            width=286*mW,
            height=253*mW,

            sourceX = 134*mW,
            sourceY = 47*mW,
            sourceWidth = 512*mW,
            sourceHeight = 313*mW
        },
        {
            -- head-viking
            x=2*mW,
            y=193*mW,
            width=343*mW,
            height=285*mW,

            sourceX = 97*mW,
            sourceY = 0,
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
    ["head-classic-bottom"] = 2,
    ["head-classic-top"] = 3,
    ["head-fool-bottom"] = 4,
    ["head-fool-top"] = 5,
    ["head-gentleman"] = 6,
    ["head-goggles"] = 7,
    ["head-grump"] = 8,
    ["head-helmet"] = 9,
    ["head-hood-bottom"] = 10,
    ["head-hood-top"] = 11,
    ["head-skicap-bottom"] = 12,
    ["head-skicap-top"] = 13,
    ["head-tongue"] = 14,
    ["head-viking"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
