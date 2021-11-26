--[[
    Exposes the API
    HawDevelopment
    18/11/2021
--]]

local ECS = script.ECS
local Types = require(script.Types)
local Pools = require(script.Pools) -- Used in types
local Scheduler = require(script.Internal.Scheduler) -- Used in types


export type River = {
    Entity: (tab: { [string | number]: Types.Queryable }) -> Types.Entity,
    Component: (comptab: Types.Type | { [string | number]: Types.Type }) -> Types.Component,
    Query: (toquery: Types.Queryable | { [string | number]: Types.Queryable }) -> Types.Query,
    System: (func: (...Types.Query) -> nil) -> Types.System,
    Tag: (name: string) -> Types.Tag,
    Type: (combination: string) -> Types.Type,
    World: () -> Types.World,
    Pools: Pools.Pools,
    Types: ModuleScript,
    Internal: {
        Scheduler: Scheduler.Scheduler,
    }
}

return {
    -- ECS
    Entity = require(ECS.Entity),
    Component = require(ECS.Component),
    System = require(ECS.System),
    Query = require(ECS.Query),
    Tag = require(ECS.Tag),
    Type = require(ECS.Type),
    Types = script.Types,
    World = require(ECS.World),
    Pools = Pools,
    
    -- Internal (SHOULD NOT BE USED!)
    Internal = {
        Scheduler = Scheduler,
    }
} :: River