--[[
    Types.
    
    A list of types used for type checking.
    
    HawDevelopment
    18/11/2021
--]]

export type Query = {
    id: number,
    ref: Queryable | { [string | number]: Queryable },
    resources: { [any]: any },
    collected: Queryable | { [string | number]: Queryable },
    ClassName: string,
    resources: { [any]: any },
    
    collect: (self: Query) -> nil,
    __update: (self: Query) -> { [any]: any },
}
export type Entity = number
export type System = { 
    id: number,
    func: (...Queryable) -> nil,
    queries: { [number]: Query },
    ClassName: string,
    
    add: (self: System, query: Queryable) -> nil,
}
export type Component = WithMeta<{
    id: number,
    ref: Type | { [string | number]: Type },
    entities: { any },
    built: { any },
    ClassName: string
}, {
    __call: (value: any, typecheck: boolean?) -> any
}>

export type Tag = {
    id: number,
    name: string,
    entities: { [number]: Entity },
    built: { [any]: any },
    ClassName: string,
}
export type Type = WithMeta<{
    id: number,
    combination: string,
    ClassName: string
}, {
    __call: (self: Type, value: any) -> boolean
}>
export type World = {
    id: number,
    systems: { start: {}, update: {}, stop: {} },
    ClassName: string,
    started: boolean,
    done: boolean,
    running: boolean,
    
    start: (self: World) -> nil,
    stop: (self: World) -> nil,
    add: (self: World, system: System, whentocall: string?) -> nil,
}

export type Queryable = Component | EntityIdentifier | System | Tag | Query
export type Bindable = Component | Tag

-- Pool types
export type EntityIdentifier = {
    id: number,
    ref: { [string | number]: Queryable },
    ClassName: string
}
export type Pool = {
    name: string,
    data: { [any]: any},
    ClassName: string,
}

return nil