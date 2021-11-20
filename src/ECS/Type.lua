--[[
    Type.
    
    Types are used to define the values of components.
    
    HawDevelopment
    18/11/2021
--]]

local Types = require(script.Parent.Parent.Types)

local function CreatePrimitive(name)
    return function (value)
        return typeof(value) == name
    end
end

local CombinationToFunc = {
    -- Primitives
    ["string"] = CreatePrimitive("string"),
    ["number"] = CreatePrimitive("number"),
    ["boolean"] = CreatePrimitive("boolean"),
    ["CFrame"] = CreatePrimitive("CFrame"),
    ["Vector3"] = CreatePrimitive("Vector3"),
    ["Vector2"] = CreatePrimitive("Vector2"),
    ["UDim"] = CreatePrimitive("UDim"),
    ["UDim2"] = CreatePrimitive("UDim2"),
    ["Instance"] = CreatePrimitive("Instance"),
    ["Color3"] = CreatePrimitive("Color3"),
    ["EnumItem"] = CreatePrimitive("EnumItem"),
    ["Enum"] = CreatePrimitive("Enum"),
    ["function"] = CreatePrimitive("function"),
    ["any"] = function (_)
        return true
    end,
    
    -- ECS
    ["Component"] = function(value)
        return value.ClassName == "Component" and value.ref ~= nil
    end,
    ["Entity"] = function(value)
        return type(value) == "number" or value.ClassName == "Entity"
    end,
    
    -- I know i have sinned
    ["Query"] = function(value) return value.ClassName == "Query" end,
    ["Tag"] = function(value) return value.ClassName == "Tag" end,
    ["Type"] = function(value) return value.ClassName == "Type" end
}

local CHACHE = {}
local GLOBAL_ID = 1
local CLASS_META_TABLE = {
    __call = function(self, value: any): any
        return CombinationToFunc[self.name](value)
    end,
}

return function (combination: string): Types.Type
    if CHACHE[combination] then
        return CHACHE[combination]
    end
    if not CombinationToFunc[combination] then
        error("Type combination not found: " .. combination .. "\n (Note: This type could not be supported yet!)", 2)
    end
    
    local type = setmetatable({
        id = GLOBAL_ID,
        combination = combination,
        ClassName = "Type"
    }, CLASS_META_TABLE) :: Types.Type
    CHACHE[combination] = type
    
    return type
end