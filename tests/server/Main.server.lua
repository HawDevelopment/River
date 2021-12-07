-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local River = require(ReplicatedStorage.River) :: River

-- local System = River.System
-- local World = River.World
-- local Query = River.Query
-- local Collectible = River.Collectible

-- local tag, _ = Collectible("Part")

-- local updateposition = System(function(parts: any)
-- 	for i = 1, #parts do
-- 		local part = parts[i].Instance
-- 		part.Position = part.Position + Vector3.new(0, 0, 0.1)
-- 	end
-- end)
-- updateposition:add(Query(tag))

-- local world = World()
-- world:add(updateposition)
-- world:start()
