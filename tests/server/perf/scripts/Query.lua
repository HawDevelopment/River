
local River = require(game.ReplicatedStorage.River) :: River

local Entity = River.Entity
local Query = River.Query
local Component = River.Component
local Tag = River.Tag
local Type = River.Type
local Pools = River.Pools

local TestComponent = Component(Type("string"))
local TestTag = Tag("TestTag")

return {
    {
        Name = "Stress Call - Component",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Query.data)
        end,
        Run = function()
            Query(TestComponent("Test"))
        end,
        Stop = function()
            table.clear(Pools.Query.data)
        end
    },
    {
        Name = "Stress Call - Tag",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Query.data)
        end,
        Run = function()
            Query(TestTag)
        end,
        Stop = function()
            table.clear(Pools.Query.data)
        end
    },
    {
        Name = "Stress Call - With Entity",
        Calls = 10000,
        Pre = function()
            table.clear(Pools.Entity.data)
            table.clear(Pools.Query.data)
            Entity({
                MyComponent = TestComponent("Hello"),
                MyTag = TestTag
            })
        end,
        Run = function()
            Query({
                Components = TestComponent,
                Tags = TestTag
            })
        end,
        Stop = function()
            table.clear(Pools.Entity.data)
            table.clear(Pools.Query.data)
        end
    },
    {
        Name = "Stress Query Get",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Query.data)
            return Query(TestComponent)
        end,
        Run = function(query)
            query:get()
        end,
        Stop = function()
            table.clear(Pools.Query.data)
        end
    },
    {
        Name = "Stress Query Get - Force update",
        Calls = 1000000,
        Pre = function()
            table.clear(Pools.Query.data)
            return Query(TestComponent)
        end,
        Run = function(query)
            query:get(true)
        end,
        Stop = function()
            table.clear(Pools.Query.data)
        end
    }
}
