--[[
    Cleanup.
    
    "Destroys" objects.
    Returns true if the object was cleanedup.
    
    HawDevelopment
    19/11/2021
--]]

type Identifier = table & {
    id: number;
    ref: any?;
    ClassName: string;
}

return function (value: any): boolean
    if type(value) == "table" then
        -- Cast to Identifier.
        value = value :: Identifier
        if value.ref then
            value.ref = nil
        end
        return true
    elseif typeof(value) == "Instance" then
        value = value :: Instance
        if value:IsA("RBXScriptConnection") then
            value:Disconnect()
        else
            value:Destroy()
        end
        return true
    end
    
    return false
end