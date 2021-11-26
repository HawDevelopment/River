--[[
    Query.
    
    A query is a way to get data from entities.
    Querys are stored in a pool.
    Should only (really) be used by systems.
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Pools = require(Package.Pools)
local Cleanup = require(Package.Internal.Cleanup)
local Scheduler = require(Package.Internal.Scheduler)

local Query = {}

local GLOBAL_ID = 1
local CLASS_META_TABLE = { __index = Query }
local COLLECT_IN_INIT = true

function Query:get(update: boolean)
    if update then
        self.resources = self:__update()
    end
    return self.resources
end

function Query:__collect()
    if self.ref.ClassName then
        -- A single resource.
        self.collected = self.ref
    else
        -- A table of resources.
        for key, ref in pairs(self.ref) do
            self.collected[key] = ref
        end
    end
end

function Query:__update()
    local pool = Pools.Query.data[self.id]
    
    if not pool then
        Cleanup(self)
        return warn("[Query] Could not find pool! Id: " .. tostring(self.id))
    end
    
    if not COLLECT_IN_INIT then
        self:collect()
    end
    
    -- Now insert them into the pool.
    self.resources = Scheduler:Handle({
        name = "Query",
        id = self.id,
        resources = self.collected,
        object = self :: Types.Query,
    })
    return self.resources
end

return function (toquery: Types.Queryable | { [string | number]: Types.Queryable }): Types.Query
    local query = setmetatable({
        id = GLOBAL_ID,
        ref = toquery,
        resources = {},
        collected = {},
        ClassName = "Query"
    }, CLASS_META_TABLE) :: Types.Query
    GLOBAL_ID += 1
    
    Pools.Query.data[query.id] = query
    
    if COLLECT_IN_INIT then
        query:__collect()
    end
    task.defer(function ()
        if Pools.Query.data[query.id] then
            query:__update()
        end
    end)
    
    return query
end
