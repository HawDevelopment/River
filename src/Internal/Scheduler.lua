--[[
    Scheduler.
     
    Handles how resourcer are gotten.
    
    HawDevelopment
    19/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Pools = require(Package.Pools)

export type Scheduler = {
    Handle: (operation: Operation) -> nil,
}
export type QueryOperation = {
    name: string,
    id: number,
    resources: { [any]: any },
    object: Types.Query<any>
}
export type BindOperation = {
    name: string,
    object: Types.EntityIdentifier
}
export type CallOperation = {
    name: string,
    object: Types.System,
    dt: number,
}
type Operation = QueryOperation | BindOperation | CallOperation

local CACHE_CLEAR_TIMES = {
    Entity = 1200,
    Component = 600,
    Tag = 600,
    Query = 100,
    Args = 100,
}
local CACHE_CLEAR_INTERVAL = {}
for key, _ in pairs(CACHE_CLEAR_TIMES) do
    CACHE_CLEAR_INTERVAL[key] = 0
end

local Scheduler = {}

local Cache = {
    Entity = {},
    Component = {},
    Tag = {},
    Args = {},
    Query = {},
}

function QueryObject(resource: Types.Queryable, key: any?): any
    local object
    if resource.ClassName == "Entity" then
        object = Pools.Entity.data[resource.id]
    elseif resource.ClassName == "Component" then
        local comp = Pools.Component.data[resource.id]
        for id, _ in ipairs(comp.entities :: { any }) do
            if not comp.built[id] then
                comp.built[id] = Pools.Entity.data[id].ref[key]
            end
        end
        for id, _ in ipairs(comp.built :: { any }) do
            if not comp.entities[id] then
                comp.built[id] = nil
            end
        end
        object = comp.built
    elseif resource.ClassName == "Tag" then
        local tag = Pools.Tag.data[resource.id]
        for id, _ in ipairs(tag.entities :: { any }) do
            if not tag.built[id] then
                local built = {}
                for name, value in pairs((Cache.Entity[id] or Pools.Entity.data[id]).ref :: { any }) do
                    built[name] = value.ref
                end
                tag.built[id] = built
            end
        end
        for id, _ in ipairs(tag.built :: { any }) do
            if not tag.entities[id] then
                tag.built[id] = nil
            end
        end
        object = tag.built
        
    elseif resource.ClassName == "Query" then
        local resource = resource :: Types.Query<any>
        object = resource:__update()
    else
        error("[Scheduler] Could not get object with name: " .. tostring(resource.ClassName))
    end
    return object
end

function Scheduler:Handle(operation: Operation): { [any]: any } | nil
    debug.profilebegin("Scheduler.Handle")
    if operation.name == "Query" then
        -- We want to get all the resources.
        -- And then insert them into a table or pool.
        
        -- If the query is alrady cache, then we should return the cached value.
        local operation = operation :: QueryOperation 
        if Cache.Query[operation.id] then
            debug.profileend()
            return Cache.Query[operation.id]
        end
        
        local objects = operation.resources :: { [any]: Types.Queryable } | Types.Queryable
        local resources
        if objects.ClassName then
            -- This is a single resource.
            resources = Cache[objects.ClassName][objects.id] or QueryObject(objects :: Types.Queryable, nil)
            Cache[objects.ClassName][objects.id] = resources
        else
            -- A table of resources.
            resources = {}
            for key, resource in pairs(objects) do
                local object = Cache[resource.ClassName][resource.id] or QueryObject(resource, key)
                if not Cache[resource.ClassName][resource.id] then
                    Cache[resource.ClassName][resource.id] = object
                end
                resources[key] = object
            end
        end
        Cache.Query[operation.id] = resources
        return resources
    elseif operation.name == "Bind" then
        -- Adds an object to a pool.
        local operation = operation :: BindOperation
        for _, object in pairs(operation.object.ref :: { [any]: Types.Bindable }) do
            if type(object) == "table" and object.ClassName then
                if object.entities then
                    object.entities[operation.object.id] = true
                end
                if object.ClassName == "Tag" then
                    local tag = Pools.Tag.data[object.id]
                    if not tag.built[operation.object.id] then
                        local built = {}
                        for name, value in pairs(operation.object.ref :: { any }) do
                            built[name] = value.ref
                        end
                        tag.built[operation.object.id] = built
                    end
                elseif object.ClassName == "ComponentValue" then
                    local comp = Pools.Component.data[object.id]
                    if not comp.built[operation.object.id] then
                        comp.built[operation.object.id] = operation.object.ref
                    end
                end
            end
        end
        
    elseif operation.name == "Call" then
        -- Update queries.
        local operation = operation :: CallOperation
        debug.profilebegin("Scheduler.Call")
        local args
        if Cache.Args[operation.object.id] then
            args = Cache.Args[operation.object.id]
            args[#args] = operation.dt
        else
            args = {}
            args[#operation.object.queries + 1] = operation.dt
            for _, value in ipairs(operation.object.queries) do
                table.insert(args, 1, value:__update())
            end
            Cache.Args[operation.object.id] = args
        end
        -- Call the system with the queries.
        task.spawn(operation.object.func, unpack(args))
        debug.profileend()
    end
    debug.profileend()
end

function Scheduler:__update(dt: number): nil
    for key, value in pairs(CACHE_CLEAR_INTERVAL) do
        local time = value + dt * 60
        CACHE_CLEAR_INTERVAL[key] = time
        if time >= CACHE_CLEAR_TIMES[key] then
            table.clear(Cache[key])
            CACHE_CLEAR_INTERVAL[key] = 0
        end
    end
end

local RunService = game:GetService("RunService")
RunService:BindToRenderStep("River-Scheduler", Enum.RenderPriority.First.Value, function(dt)
    Scheduler:__update(dt)
end)

return Scheduler