--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:44e55ed8c3452a3eb580f0e545c7897d:392d4e44b5f147f8c166c4e6cc756e15:0449541957276c65ebed4795a3c6c447$
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
            x=398,
            y=2,
            width=373,
            height=238,

            sourceX = 73,
            sourceY = 60,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-gentleman
            x=2,
            y=517,
            width=302,
            height=312,

            sourceX = 117,
            sourceY = 0,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-googles
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
            x=306,
            y=517,
            width=313,
            height=272,

            sourceX = 100,
            sourceY = 24,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-helmet
            x=329,
            y=242,
            width=274,
            height=258,

            sourceX = 126,
            sourceY = 37,
            sourceWidth = 512,
            sourceHeight = 313
        },
        {
            -- head-skicap
            x=2,
            y=205,
            width=325,
            height=310,

            sourceX = 85,
            sourceY = 2,
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
