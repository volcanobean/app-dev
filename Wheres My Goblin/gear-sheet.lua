--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4ec8876f330d6ea7a8486705573ff660:5dca45b8ca3dc94bbc7ac137c1aa0926:c82b0a3d3bdba5ab3e6e218c8a63fac8$
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
            -- gear-1
            x=2,
            y=225,
            width=171,
            height=170,

        },
        {
            -- gear-2
            x=32,
            y=2,
            width=171,
            height=170,

        },
        {
            -- gear-3
            x=205,
            y=2,
            width=171,
            height=170,

        },
        {
            -- gear-4
            x=175,
            y=174,
            width=171,
            height=170,

        },
        {
            -- gear-handle
            x=2,
            y=2,
            width=28,
            height=221,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["gear-1"] = 1,
    ["gear-2"] = 2,
    ["gear-3"] = 3,
    ["gear-4"] = 4,
    ["gear-handle"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
