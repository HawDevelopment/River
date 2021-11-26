# Example

Now that you have learned how to use the API, you can use it to create your own systems!
Here we have to systems, one for updating the position of entities, and the other for printing the position of the entities.

```lua
local River = require(game.ReplicatedStorage.River)

local System = River.System
local Query = River.Query
local Component = River.Component
local Type = River.Type
local Entity = River.Entity
local World = River.World

local Position = Component(Type("Vector3"))

local MyEntity = Entity({
    Position = Position(Vector3.new(0, 0, 0))
})

local QueryPosition = Query(Position)

local UpdatePosition = System(function(entities)
    for _, entity in pairs(entities) do
        entity.Position += Vector3.new(0, 0, 1)
    end
end)

local PrintPosition = System(function(entities)
    for _, entity in pairs(entities) do
        print(entity.Position)
    end
end)

UpdatePosition:add(QueryPosition)
PrintPosition:add(QueryPosition)

local world = World()

world:add(UpdatePosition, "update")
world:add(PrintPosition, "update")

world:start()
```
