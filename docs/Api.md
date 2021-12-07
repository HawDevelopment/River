# River

Houses all the components of River.
Contains:

-   Component
-   Entity
-   System
-   Query
-   Tag
-   Type
-   World
-   Collectible
-   Pools
-   Internal:
    -   Scheduler

## Component

Component is the way you define how data should look.
The data is defined using [Types](/#Types).

### Constructor

`River::Component(comp: { [string | number]: Type } | Type) -> Component`

Create a new component.

```lua
local Component = River.Component
local Type = River.Type

Component({
    Name = Type("string"),
    Age = Type("number"),
})

-- OR

Component(Type("Vector3"))
```

### Call

`Component(value: { [string | number]: any } | any, typecheck: boolean) -> { [string | number] }`

Typechecks the value and returns it as a ComponentValue.

```lua
local Component = River.Component
local Type = River.Type

local MyComponent = Component({
    Name = Type("string"),
    Age = Type("number"),
})

MyComponent({
    Name = "John",
    Age = 42,
})
```

## Entity

Entity is the way to create data. Use [Component Values](./#call) to define how data should look.

### Constructor

`River::Entity(tab: { [string | number]: Queryable }) -> number`

Takes a list of either [Component Values](./#call),
or [Tags](./#tag) and returns the id of the entity.

!!! note ""

    The data passed to the Entity constructor MUST be a list.

```lua
local Type = River.Type
local Component = River.Component
local Entity = River.Entity

local MyComponent = Component({
    Name = Type("string"),
    Age = Type("number"),
})

local MyEntity = Entity({
    Person = MyComponent({
        Name = "John",
        Age = 42,
    }),
})
```

## Query

Queries is the way to get entities. Use [Components](./component) and [Tags](./#tag) specify them.

### Constructor

`River::Query(toquery: {[string | number]: Queryable} | Queryable) -> Query`

Takes a list or a single [Component](./#component) or [Tag](./#tag) and creates a Query.

```lua
local Component = River.Component
local Entity = River.Entity
local Query = River.Query

local MyComponent = Component({
    Name = Type("string"),
    Age = Type("number"),
})

-- Create your entities, or later...

local MyQuery = Query(MyComponent)
-- OR
local MyQuery = Query({
    Person = MyComponent
})
```

### Get

`Query:get(update: boolean) -> any`

Returns the list of entities the Query has gotten. If `update` is true, then it will force update the list.

```lua
local Query = River.Query

-- Create your entities

local MyQuery = Query(...)

local MyEntities = MyQuery:get()
-- FORCE UPDATE
local MyEntities = MyQuery:get(true)
```

## System

Systems is the way to change data on your entities. Use [Queries](./#query) to find entities.

### Constructor

`River::System(func: (...Query) -> nil) -> System`

Takes a function that takes a vararg of [Queries](./#query) and creates a System.

```lua
local System = River.System


local MySystem = System(function(query1, query2, ...)
    -- Do stuff
    -- NOTE: We havent added the queried yet!
end)
```

### Add

`System:add(query: Query) -> System`

Takes a [Query](./#query) and adds it to the System, the system function will be called with it.

```lua
local System = River.System
local Query = River.Query

local MyQuery = Query(...)

local MySystem = System(function(query)
    -- Do stuff with MyQuery
end)
MySystem:add(MyQuery)
```

### Call

`System:call() -> ...`

Calls the system. Any returns in the system function will be returned.

!!! danger

    The function is ran synchronously, and does NOT have any error handling.
    Consider using Promise.

## Tag

Tag is a way to easily specify a list of entities.

### Constructor

`River::Tag(name: string): Tag`

Takes a string and creates a Tag.

```lua
local Tag = River.Tag
local Entity = River.Entity
local Query = River.Query

local MyTag = Tag("MyTag")

local MyEntity = Entity({
    MyTag = MyTag,
})

local MyQuery = Query(MyTag)
-- OR
local MyQuery = Query({
    MyTag = MyTag
})
```

## Type

Type is the way to define what the data is. Used in [Components](./#component).

### Constructor

`River::Type(name: string) -> Type`

```lua
local Component = River.Component
local Type = River.Type

local MyComponent = Component({
    Name = Type("string"),
    Age = Type("number"),
})
```

### Call

`Type(value: any) -> boolean`

Takes a value and returns wether or not it is of the type.

```lua
local Type = River.Type

local MyStringType = Type("string")

print(MyStringType("Hello")) -> true
print(MyStringType(42)) -> false
```

### List of Types

Heres a list of all the types currently available: (Open an issue if you want to add one)

-   `string`
-   `number`
-   `boolean`
-   `table`
-   `vector`
-   `CFrame`
-   `Vector3`
-   `Vector2`
-   `UDim`
-   `UDim2`
-   `Instance`
-   `Color3`
-   `EnumItem`
-   `Enum`
-   `function`
-   `any`

---

-   `Component`
-   `Entity`
-   `System`
-   `Query`
-   `Tag`
-   `Type`

## World

Worlds are a way to organize your [Systems](./#system).

### Constructor

`River::World() -> World`

Creates a new World.

```lua
local World = River.World

local MyWorld = World()
```

### Add

`World:add(system: System, whentocall: string?)`

Takes a system and when to call it (`start`, `update` and `stop`) and adds it to the World.

```lua
local World = River.World

-- Create your system

local MyWorld = World()
MyWorld:add(MySystem, "start") -- Will be ran on start
MyWorld:add(MySystem, "update") -- Will be ran every frame
MyWorld:add(MySystem, "stop") -- Will be ran on stop
-- NOTE: The world isnt started yet!
```

### Start

`World:start()`

Calls all Systems bound to `start` and adds the world to the updater.
The updater will call all systems bound to `update` on every render step.

```lua
local World = River.World

-- Create your system

local MyWorld = World()
MyWorld:add(MySystem, "start")

MyWorld:start()
```

### Stop

`World:stop()`

Calls all Systems bound to `stop` and removes the world from the updater.
The updater will call all systems bound to `update` on every render step.

```lua
local World = River.World

-- Create your system

local MyWorld = World()
MyWorld:add(MySystem, "stop")

MyWorld:stop()
```

## Collectible

Collectible is a way to interface with Roblox CollectionService. It creates a tag to easily use in [Worlds](./#world) or [Systems](./#system).

### Constructor

`River::Collectible(tag: string, data: { [any]: any }?) -> Tag, Collectible`

Takes a tag and creates a river tag object that can be [queried](./#query) for. If the data paramater is giver, then any entities created will have that table copied with it. Also, returns a Collectible object.

The tag returns a list of entities, the entity looks like this:

-   Data: The data that was given to the constructor. Note that its deep copied.
-   Instance: The roblox instance that have the given tag.
-   (It also has the tag from the constructor, so it can be queried for)

```lua
local Collectible = River.Collectible
local Query = River.Query

local tag, collectible = Collectible("MyTag")

-- The tag can be queried for, and used to change data
local MyQuery = Query(tag)
```

### Setup

`Collectible:setup(inst: Instance)`

Creates an entity for the instance, and tags its if it hasnt.

```lua
local Collectible = River.Collectible

local tag, collectible = Collectible("MyTag")

collectible:setup(workspace.Part)
```

### Remove

`Collectible:remove(inst: Instance)`

Removes the entity of the instance. Note that it doesnt untag the instance!

```lua
local Collectible = River.Collectible

local tag, collectible = Collectible("MyTag")

collectible:setup(workspace.Part)

-- Were dont with it now and should remove it!
collectible:remove(workspace.Part)
```

## Pools

Pools is the place where River stores all its data.

The pools are broken into smaller internal pools:

-   `Component`
-   `Entity`
-   `Query`
-   `Tag`

Internal pools have a property called `data`, where ids are mapped to values.

!!! danger "Internal"

    Pools is used internally, and should be used with caution.

```lua
local Pools = River.Pools
local Entity = River.Entity

-- Create a component

local MyEntityID = Entity({
    Person = MyComponent
})

-- NOTE: Entity is not cleaned!
local MyEntity = Pools.Entity.data[MyEntityID]
```

## Internal - Scheduler

The scheduler is used to get data and handle internal stuff in River.
However, you can use it to do stuff. (See source code)

!!! danger "Internal"

    Scheduler is used internally, and should be used with caution.
