--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d98f3aa5667613577145328669cba342:1/1$
--
-- local Subheader = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Subheader:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Subheader:getFrameIndex("sprite")}} )
--

local Subheader = {}

Subheader.sheet =
{
    frames = {
    
        {
            -- Animation1
            x=592,
            y=104,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation2
            x=297,
            y=104,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation3
            x=297,
            y=53,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation4
            x=592,
            y=2,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation5
            x=297,
            y=2,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation6
            x=2,
            y=155,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation7
            x=2,
            y=104,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation8
            x=2,
            y=53,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation9
            x=2,
            y=2,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation10
            x=592,
            y=53,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation11
            x=297,
            y=155,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
        {
            -- Animation12
            x=592,
            y=104,
            width=293,
            height=49,

            sourceX = 6,
            sourceY = 4,
            sourceWidth = 303,
            sourceHeight = 53
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 256
}

Subheader.frameIndex =
{

    ["Animation1"] = 1,
    ["Animation2"] = 2,
    ["Animation3"] = 3,
    ["Animation4"] = 4,
    ["Animation5"] = 5,
    ["Animation6"] = 6,
    ["Animation7"] = 7,
    ["Animation8"] = 8,
    ["Animation9"] = 9,
    ["Animation10"] = 10,
    ["Animation11"] = 11,
    ["Animation12"] = 12,
}


function Subheader:newSequence()
    return { 
     name = "turn",  --name of animation sequence
     start = 1,  --starting frame index
     count = 12,  --total number of frames to animate consecutively before stopping or looping
     time = 700,  --optional, in milliseconds; if not supplied, the sprite is frame-based
     loopCount = 2,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
     loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
    }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
end

function Subheader:getSheet()
    return self.sheet;
end

function Subheader:getFrameIndex(name)
    return self.frameIndex[name];
end

return Subheader
