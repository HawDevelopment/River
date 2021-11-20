--[[
    Pool.
    
    A pool is a table containg ids as keys and data as values.
    Used for storing data.
    
    HawDevelopment
    18/11/2021
--]]

local Types = require(script.Parent.Parent.Types)

function Pool(name: string): Types.Pool
    return {
        name = name,
        data = {} :: { [number]: any },
        ClassName = "Pool"
    }
end

return Pool