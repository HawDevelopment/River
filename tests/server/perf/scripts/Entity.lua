
local River = require(game.ReplicatedStorage.River) :: River

local Entity = River.Entity
local Component = River.Component
local Type = River.Type
local Pools = River.Pools

local TestComponent = Component(Type("string"))

return {
    {
        Name = "Stress Call - Argument",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Entity.data)
        end,
        Run = function()
            Entity({
                MyComponent = TestComponent("Hello")
            })
        end,
        Stop = function()
            table.clear(Pools.Entity.data)
        end
    },
    {
        Name = "Stress Call - No Argument",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Entity.data)
        end,
        Run = function()
            Entity({})
        end,
        Stop = function()
            table.clear(Pools.Entity.data)
        end
    },
    {
        Name = "Stress Component",
        Calls = 1000,
        Pre = function()
            table.clear(Pools.Entity.data)
            table.clear(Pools.Component.data)
            local values = {}
            for _ = 1, 100 do
                table.insert(values, Component(Type("string"))("Hello"))
            end
            return values
        end,
        Run = function(values)
            Entity(values)
        end,
        Stop = function()
            table.clear(Pools.Entity.data)
            table.clear(Pools.Component.data)
        end
    },
}
