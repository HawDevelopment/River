# Defining and Creating Data

In River theres only one way to create data, entities. Entities only create data, they dont define it. For defining data you will need to use Components.
Lets get some examples going.

### Creating a Component

Components are simply a single or a list of Types. Types are a way to define your the types of your data.
Types can be any for of data, `string`, `number`, `table`, `Vector3`, etc.

```lua
local Type = River.Type
local Component = River.Component

-- Creating a single type
local MyComponent = Component(Type("string"))

-- Creating a list of types
local MyListComponent = Component({
    Name = Type("string"),
    Age = Type("number"),
})
```

### Creating an Entity

Components are just patters for creating data. With entities you can create data.

```lua
local Entity = River.Entity

local MyEntity = Entity({
    MyComponent = MyComponent("Hello World"),
    MyListComponent = MyListComponent({
        Name = "John",
        Age = 32,
    }),
})
```

And thats it! You can now define and create data!
