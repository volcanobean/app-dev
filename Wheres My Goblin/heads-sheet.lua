--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fe5869029a1df66934dea85bcbdc8380:a9fde908063a73312783a5e60fc414c0:13305c6706f5985c6ad08badc402b12e$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- head-cheshire
            x=306,
            y=755,
            width=313,
            height=264,

            sourceX = 109,
            sourceY = 36,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-gentleman
            x=2,
            y=479,
            width=302,
            height=312,

            sourceX = 117,
            sourceY = 0,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-goggles
            x=2,
            y=2,
            width=394,
            height=201,

            sourceX = 66,
            sourceY = 93,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-grump
            x=2,
            y=205,
            width=313,
            height=272,

            sourceX = 100,
            sourceY = 24,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-helmet
            x=725,
            y=2,
            width=274,
            height=258,

            sourceX = 126,
            sourceY = 37,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-skicap
            x=398,
            y=2,
            width=325,
            height=310,

            sourceX = 85,
            sourceY = 2,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-tongue
            x=306,
            y=479,
            width=310,
            height=274,

            sourceX = 128,
            sourceY = 33,
            sourceWidth = 512,
            sourceHeight = 313
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
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
