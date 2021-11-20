-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local River = require(ReplicatedStorage.River) :: River

-- local Component = River.Component
-- local System = River.System
-- local Entity = River.Entity
-- local Query = River.Query
-- local Tag = River.Tag
-- local World = River.World

-- local Position = Component(River.Type("Vector3"))
-- local Player = Tag("Player")

-- for i = 1, 100000 do
--     Entity({
--         Position = Position(Vector3.new(0, 0, 0)),
--         Player,
--     })
--     if i % 1000 == 0 then
--         print(i)
--     end
-- end

-- local PlayerQuery = Query(Player)

-- local updateposition = System(function(players: any)
--     for i = 1, #players do
--         local player = players[i]
--         player.Position = player.Position + Vector3.new(0, 0, 1)
--     end
-- end)
-- updateposition:add(PlayerQuery)

-- local printposition = System(function(players: any)
--     local player = players[10]
--     print(player.Position)
-- end)
-- printposition:add(PlayerQuery)

-- local world = World()
-- world:add(updateposition)
-- world:add(printposition)
-- world:start()
