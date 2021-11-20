--[[
    System.
    
    A system is a function with metadata.
    A system changes data of entities.
    Any data is gotten from a pool.
    Systems should be typed!
    
    HawDevelopment
    18/11/2021
--]]

local Types = require(script.Parent.Parent.Types)

local System = {}

local GLOBAL_ID = 1
local CLASS_META_TABLE = { __index = System }

function System:add(query: Types.Queryable): nil
    table.insert(self.queries, query)
    return nil
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