--[[
    Tag.
    
    Tags are a way to identify entities.
    This makes it easy to get specific entities.
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Pools = require(Package.Pools)

local GLOBAL_ID = 1

return function (name: string): Types.Tag
    local tag = {
        id = GLOBAL_ID,
        name = name,
        entities = {},
        built = {},
        ClassName = "Tag",
    } :: Types.Tag
    GLOBAL_ID += 1
    
    Pools.Tag.data[tag.id] = tag
    
    return tag
end