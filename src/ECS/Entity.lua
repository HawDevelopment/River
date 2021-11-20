--[[
    Entity.
    
    An enitity is simbly a number, holding an id for some data.
    Each entity must be made from some a table of components, and should be used with luau types.
    Entities are stored in a pool.
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Pools = require(Package.Pools)
local Scheduler = require(Package.Internal.Scheduler)

local GLOBAL_ID = 1

return function (tab: { [string | number]: Types.Queryable }): Types.Entity
    local enitity = GLOBAL_ID
    GLOBAL_ID += 1
    
    local poolenity = {
        id = enitity,
        ref = tab,
        ClassName = "Entity"
    } :: Types.EntityIdentifier
    
    Pools.Entity.data[enitity] = poolenity
    Scheduler:Handle({
        name = "Bind",
        object = poolenity,
    })
    
    return enitity
end
