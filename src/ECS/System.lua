--[[
    System.
    
    A system is a function with metadata.
    A system changes data of entities.
    Any data is gotten from a pool.
    Systems should be typed!
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Scheduler = require(Package.Internal.Scheduler)

local System = {}

local GLOBAL_ID = 1
local CLASS_META_TABLE = { __index = System }

function System:add(query: Types.Query): nil
    table.insert(self.queries, query)
    return nil
end

function System:call(): nil
    Scheduler:Handle({
        name = "Call",
        object = self,
    } :: Scheduler.CallOperation)
end

return function (func: (...Types.Query) -> nil): Types.System
    local system = setmetatable({
        id = GLOBAL_ID,
        func = func,
        queries = {},
        ClassName = "System"
    }, CLASS_META_TABLE) :: Types.System
    GLOBAL_ID += 1
    
    return system
end