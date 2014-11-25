--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1dc67fa550dd1f47c9fea36234e4b60e:28de2151bc6459d8266ce83da4128bf2:d4936ffbd187671d259a04bffb28ebe2$
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
            -- sign-check-1
            x=2,
            y=2,
            width=188,
            height=175,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-check-2
            x=192,
            y=179,
            width=146,
            height=179,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-check-3
            x=86,
            y=729,
            width=82,
            height=179,

            sourceX = 47,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-check-5
            x=382,
            y=2,
            width=82,
            height=187,

            sourceX = 61,
            sourceY = 0,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-check-6
            x=150,
            y=360,
            width=145,
            height=178,

            sourceX = 19,
            sourceY = 9,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-goblin-1
            x=192,
            y=2,
            width=188,
            height=175,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-goblin-2
            x=340,
            y=191,
            width=146,
            height=179,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-goblin-3
            x=170,
            y=729,
            width=82,
            height=179,

            sourceX = 47,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-goblin-5
            x=149,
            y=540,
            width=82,
            height=187,

            sourceX = 61,
            sourceY = 0,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-goblin-6
            x=2,
            y=537,
            width=145,
            height=178,

            sourceX = 19,
            sourceY = 9,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-middle
            x=466,
            y=2,
            width=27,
            height=184,

            sourceX = 85,
            sourceY = 3,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-x-1
            x=2,
            y=179,
            width=188,
            height=175,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-x-2
            x=2,
            y=356,
            width=146,
            height=179,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-x-3
            x=254,
            y=552,
            width=82,
            height=179,

            sourceX = 47,
            sourceY = 8,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-x-5
            x=2,
            y=717,
            width=82,
            height=187,

            sourceX = 61,
            sourceY = 0,
            sourceWidth = 188,
            sourceHeight = 187
        },
        {
            -- sign-x-6
            x=297,
            y=372,
            width=145,
            height=178,

            sourceX = 19,
            sourceY = 9,
            sourceWidth = 188,
            sourceHeight = 187
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["sign-check-1"] = 1,
    ["sign-check-2"] = 2,
    ["sign-check-3"] = 3,
    ["sign-check-5"] = 4,
    ["sign-check-6"] = 5,
    ["sign-goblin-1"] = 6,
    ["sign-goblin-2"] = 7,
    ["sign-goblin-3"] = 8,
    ["sign-goblin-5"] = 9,
    ["sign-goblin-6"] = 10,
    ["sign-middle"] = 11,
    ["sign-x-1"] = 12,
    ["sign-x-2"] = 13,
    ["sign-x-3"] = 14,
    ["sign-x-5"] = 15,
    ["sign-x-6"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
