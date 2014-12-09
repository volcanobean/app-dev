--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e15b0696c9a1e28b768a24a6fdb60eb9:b107b169826e74d7c186ed926211de31:df20e5a99330c3aec1aa6a51b5b12b0e$
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
            -- head-helmet
            x=2,
            y=2,
            width=274,
            height=258,

            sourceX = 126,
            sourceY = 37,
            sourceWidth = 512,
            sourceHeight = 313
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["head-helmet"] = 1,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
