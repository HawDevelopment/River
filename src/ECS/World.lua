--[[
    World.
    
    World contains all the systems in the world and runs them.
    
    HawDevelopment
    19/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Scheduler = require(Package.Internal.Scheduler)

local World = {}

local WORLDS = {}
local GLOBAL_ID = 1
local CLASS_META_TABLE = { __index = World }

function World:add(system: Types.System, whentocall: string?)
    whentocall = whentocall or "update"
    
    if self.systems[whentocall][system] then
        error("[World] System already exists!")
    end
    if self.running then
        if whentocall == "start" and self.started then
            Scheduler:Enque({
                name = "Call",
                object = system,
            })
        elseif whentocall == "stop" and self.done then
            Scheduler:Enque({
                name = "Call",
                object = system,
            })
        end
    end
    self.systems[whentocall][system] = true
end

function World:__update(dt)
    for value, _ in pairs(self.systems.update) do
        Scheduler:Handle({
            name = "Call",
            object = value,
            dt = dt,
        })
    end
end

function World:start()
    self.started = true
    self.running = true
    WORLDS[self.id] = self
    
    for value, _ in pairs(self.systems.start) do
        Scheduler:Handle({
            name = "Call",
            object = value,
        })
    end
end

function World:stop()
    self.done = true
    self.started = false
    
    for value, _ in pairs(self.systems.stop) do
        Scheduler:Handle({
            name = "Call",
            object = value,
        })
    end
    WORLDS[self.id] = nil
end

local RunService = game:GetService("RunService")

RunService:BindToRenderStep("River-World", Enum.RenderPriority.First.Value, function(dt)
    for _, value in pairs(WORLDS) do
        value:__update(dt)
    end
end)

return function ()
    local world = setmetatable({
        id = GLOBAL_ID,
        systems = { start = {}, update = {}, stop = {} },
        ClassName = "World",
        started = false,
        done = false,
        running = false,
    }, CLASS_META_TABLE) :: Types.World
    
    GLOBAL_ID += 1
    
    return world
end
