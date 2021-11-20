--[[
    Component.
    
    Components are a way to specify the data that should be stored in an Entity.
    Each key of a Component must be a string or number.
    Each value of a Component must be a type. 
    Components are stored in a pool.
    
    HawDevelopment
    18/11/2021
--]]

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Pools = require(Package.Pools)

function TypeCheckTable(origin, new)
    if type(origin) == "function" then
        local succes = origin(new)
        if not succes then
            return false, "[ComponentType] Could not match values from origin and incoming!"
        end
    elseif type(origin) == "table" then
        for key, value in pairs(origin) do
            if not new[key] then
                return false, "[ComponentType] Could not find key: " .. tostring(key) .. " in value!"
            end
            if type(new[key]) ~= "table" or (new[key].id) then
                -- Typecheck the value
                if not value(new[key]) then
                    return false, "[ComponentType] Could not match values in key: "
                        .. tostring(key)
                        .. "! Origin type: "
                        .. type(value) .. " New type: " .. type(new[key])
                end
            else
                -- Recursively check the table
                local success, message = TypeCheckTable(value, new[key])
                if not success then
                    return false, message
                end
            end
        end
    else
        error("[ComponentType] Invalid origin type!")
    end
    return true
end

local GLOBAL_ID = 1
local TYPE_CHECK = true
local CLASS_META_TABLE = {
    __call = function(self, value: any, typecheck: boolean): any
        if typecheck and TYPE_CHECK then
            local success, message = TypeCheckTable(self.ref, value)
            if not success then
                error(message .. " (typecheck)", 2)
            end
        end
        return {
            id = self.id,
            ref = value,
            ClassName = "ComponentValue"
        }
    end
}

return function (comptab: Types.Type | { [string | number]: Types.Type}): Types.Component
    local component = setmetatable({
        id = GLOBAL_ID,
        ref = comptab,
        entities = {},
        built = {},
        ClassName = "Component"
    }, CLASS_META_TABLE) :: Types.Component
    GLOBAL_ID += 1
    
    Pools.Component.data[component.id] = component
    
    return component
end