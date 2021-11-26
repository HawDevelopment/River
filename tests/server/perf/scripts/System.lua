
local River = require(game.ReplicatedStorage.River) :: River

local Query = River.Query
local Component = River.Component
local System = River.System
local Type = River.Type
local Pools = River.Pools

local TestComponent = Component(Type("string"))

return {
    {
        Name = "Stress Call - Query",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Query.data)
            return Query(TestComponent)
        end,
        Run = function(query)
            local system = System(function() end)
            system:add(query)
        end,
        Stop = function()
            table.clear(Pools.Query.data)
        end
    },
    {
        Name = "Stress Call - No Arguments",
        Calls = 1000000,
        Run = function()
            System(function() end)
        end,
    },
    {
        Name = "Stress System Call",
        Calls = 1000000,
        Pre = function()
            return System(function() end)
        end,
        Run = function(system)
            system:call()
        end,
    }
}
