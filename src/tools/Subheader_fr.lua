--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8870b6f2cdace24249142ef15ec06133:1/1$
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
            -- Questions2a
            x=2,
            y=519,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2b
            x=2,
            y=472,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2c
            x=2,
            y=425,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2d
            x=2,
            y=378,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2e
            x=2,
            y=331,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2f
            x=2,
            y=284,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2g
            x=2,
            y=237,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2h
            x=2,
            y=190,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2i
            x=2,
            y=143,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2j
            x=2,
            y=96,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2k
            x=2,
            y=49,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
        {
            -- Questions2l
            x=2,
            y=2,
            width=474,
            height=45,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 488,
            sourceHeight = 53
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["Questions2a"] = 1,
    ["Questions2b"] = 2,
    ["Questions2c"] = 3,
    ["Questions2d"] = 4,
    ["Questions2e"] = 5,
    ["Questions2f"] = 6,
    ["Questions2g"] = 7,
    ["Questions2h"] = 8,
    ["Questions2i"] = 9,
    ["Questions2j"] = 10,
    ["Questions2k"] = 11,
    ["Questions2l"] = 12,
}


function SheetInfo:newSequence()
    return { 
   		name = "turn",  --name of animation sequence
   		start = 1,  --starting frame index
   		count = 12,  --total number of frames to animate consecutively before stopping or looping
   		time = 700,  --optional, in milliseconds; if not supplied, the sprite is frame-based
   		loopCount = 2,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
   		loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
   	}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
end

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
