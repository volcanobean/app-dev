--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fe74a883b73db05557c5c93380246b00:756a95b06de4af4e952edca70f00cbe1:fdc86dec307cef64ae0388a068a7ce5a$
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
            -- torso-chef
            x=2*mW,
            y=2*mW,
            width=321*mW,
            height=423*mW,

            sourceX = 99*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-hoodie-bottom
            x=664*mW,
            y=2*mW,
            width=332*mW,
            height=347*mW,

            sourceX = 95*mW,
            sourceY = 30*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-napolean
            x=325*mW,
            y=2*mW,
            width=337*mW,
            height=388*mW,

            sourceX = 105*mW,
            sourceY = 13*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-suit
            x=2*mW,
            y=427*mW,
            width=334*mW,
            height=403*mW,

            sourceX = 91*mW,
            sourceY = 17*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-sweater-top
            x=338*mW,
            y=623*mW,
            width=286*mW,
            height=378*mW,

            sourceX = 118*mW,
            sourceY = 23*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-wizard-bottom
            x=664*mW,
            y=351*mW,
            width=290*mW,
            height=270*mW,

            sourceX = 117*mW,
            sourceY = 71*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
        {
            -- torso-wizard-top
            x=626*mW,
            y=623*mW,
            width=383*mW,
            height=344*mW,

            sourceX = 65*mW,
            sourceY = 18*mW,
            sourceWidth = 512*mW,
            sourceHeight = 512*mW
        },
    },
    
    sheetContentWidth = 1024*mW,
    sheetContentHeight = 1024*mW
}

SheetInfo.frameIndex =
{

    ["torso-chef"] = 1,
    ["torso-hoodie-bottom"] = 2,
    ["torso-napolean"] = 3,
    ["torso-suit"] = 4,
    ["torso-sweater-top"] = 5,
    ["torso-wizard-bottom"] = 6,
    ["torso-wizard-top"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
