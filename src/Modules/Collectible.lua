--[[
    Collectible.
    
    Collectible is a way to easily import roblox collection service tags into River.
    
    HawDevelopment
    12/04/2021
--]]

local CollectionService = game:GetService("CollectionService")

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Type = require(Package.ECS.Type)
local Component = require(Package.ECS.Component)
local Pools = require(Package.Pools)
local Tag = require(Package.ECS.Tag)
local Entity = require(Package.ECS.Entity)

local InstanceComponent = Component(Type("Instance"))
local DataComponent = Component(Type("any"))

local Collectible = {}

local GLOBAL_ID = 0
local CLASS_META_TABLE = { __index = Collectible }

function Collectible:Destroy()
	for _, value in pairs(self.events) do
		value:Disconnect()
	end
end

function Copy(tab)
	local newtab = {}
	for key, value in pairs(tab) do
		newtab[key] = if type(value) == "table" then Copy(value) else value
	end
	return newtab
end

function Collectible:setup(inst: Instance)
	if not CollectionService:HasTag(inst, self.tag) then
		CollectionService:AddTag(inst, self.tag)
	end

	if not self.instances[inst] then
		self.instances[inst] = Entity({
			Data = if self.data then DataComponent(Copy(self.data)) else nil :: Types.Queryable,
			Instance = InstanceComponent(inst),
			self.taginstance,
		})
	end
end

function Collectible:remove(inst: Instance)
	if self.instances[inst] then
		Pools.Entity.data[self.instances[inst]] = nil
		self.instances[inst] = nil
	end
end

return function(tag: string, data: { [any]: any }): (Types.Tag, Types.Collectible)
	local collectible = setmetatable({
		id = GLOBAL_ID,
		tag = tag,
		data = data,
		taginstance = Tag(tag),
		events = {},
		instances = {},
	}, CLASS_META_TABLE) :: Types.Collectible
	GLOBAL_ID += 1

	collectible.events["TagAdd"] = CollectionService:GetInstanceAddedSignal(tag):Connect(function(inst: Instance)
		collectible:setup(inst)
	end)
	collectible.events["TagAdd"] = CollectionService:GetInstanceRemovedSignal(tag):Connect(function(inst: Instance)
		collectible:remove(inst)
	end)
	for _, inst in pairs(CollectionService:GetTagged(tag)) do
		collectible:setup(inst)
	end

	return collectible.taginstance, collectible
end
