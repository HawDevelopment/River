# Calling Systems

Whenever you want to change any data on your entities in your game, you will need systems.
A systems is just a function with queries as arguments.
But, theres something missing! How do we get the data? Using Queries. Queries are a way to get all the entities with a certain Component or Tag.

### Creating a Query

Query is just a list or a single Component or Tag. The query will get all the entities associated with it.

!!! danger "Using Queries"

    When creating a query its a good idea to use the same query systems that need them.
    Lets say if that you have two systems, `UpdatePositon` and `PrintPositon`. Then i should only create one query for both.

```lua
local Query = River.Query
local Component = River.Component
local Tag = River.Tag
local Entity = River.Entity

local MyComponent = Component(Type("string"))
local MyTag = Tag("MyTag")

-- Create som data that can be gotten
local MyEntity = Entity({
    MyComponent = MyComponent("Hello World"),
    MyTag = MyTag,
})

-- Then to get the data we use query
-- Either with a component or a tag, or both.
local MyQuery = Query(MyComponent)
-- Same as
local MyQuery = Query(MyTag)

-- Or do it like this
local MyQuery = Query({
    MyComponent = MyComponent,
    MyTag = MyTag,
})
```

### Creating a System

Systems are just functions with queries as arguments.

```lua
-- We defined all the data above

local MyQuery = Query(MyComponent)

local MySystem = System(function(query)
    -- Note! We don't index the query!
    for _, entity in pairs(queries) do
        print(entity.MyComponent)
    end
end)

-- If you have a query with multiple components, you can use a table
local MyQuery = Query({
    MyComponent = MyComponent,
    MyTag = MyTag,
})

local MySystem = System(function(query)
    -- Note: We DO index the query!
    for _, entity in pairs(queries.MyQuery) do
        print(entity.MyComponent)
    end
end)
```

### Adding Queries

Before the system can run, you will need to add the queries to the system.
You do this with the `:add` method.

```lua
local MySystem = System(function(query)
    for _, entity in pairs(queries) do
        print(entity.MyComponent)
    end
end)

MySystem:add(MyQuery)
```

### Calling a System

Theres two ways of calling a system either with the `:call` method, or the World object.
Lets start with the `:call` method.
Note that `:call` will return anything the system function returns.

```lua
-- MySystem is defined above
MySystem:call() -- Its that easy
```

Lets try it with the World object.
When adding a system to a world, you will need to also pass when it should be called. Theres 3 options: `update`, `start` and `stop`. (They are self explanatory)

```lua
-- MySystem is defined above
local World = River.World

local MyWorld = World()

-- This system will be called every frame
world:add(MySystem, "update")

-- Remember to start the world
MyWorld:start()
-- You can also stop it
MyWorld:stop()
```
