--[[
    Pools.
    
    Pools is a list of internal pools.
    Can be used for outside reads and writes. (BUT ISNT ADVISED!)
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent

local Pool = require(Package.Internal.Pool)
local Types = require(Package.Types)

export type Pools = {
    Component: Types.Pool,
    Entity: Types.Pool,
    Query: Types.Pool,
    Tag: Types.Pool,
}

return {
    Component = Pool("Component"),
    Entity = Pool("Entity"),
    Query = Pool("Query"),
    Tag = Pool("Tag"),
} :: Pools
