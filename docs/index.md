---
hide:
    - toc
    - navigation
---

<link rel="stylesheet" href="assets/index.css">

<section class="river-home">
    <h1> Get your game data with speed. </h1>
River is a fast and simple ECS made specifically with data in mind.
Make your games faster and easier to manage. It has a simple syntax and lets you use Luau type system. River gets your data right when you want it. It's reactive and can plug into any framework. River can query over 1 million entities in milliseconds!
    <nav>
        <a href="https://github.com/HawDevelopment/River">Github</a>
        <a href="./GetStarted/">Get Started</a>
        <a href="./Api/">Api</a>
    </nav>
</section>

---

Simple syntax
River is easy to learn, so you don't have to worry about the implementation. It makes you use the best standards and lets you use the data how you want.

```lua
local MyComponent = Component({
	Name = Type("string"),
	Age = Type("number"),
})
local MyEntity = Entity(MyComponent({
	Name = "Dave",
	Age = 69,
}))
```

---

Easily change your data
River makes it easy to mutate your data and lets you get the data you want.

```lua
local Position = Component(Type("Vector3"))
local updateposition = System(function(entities)
	for _, entity in pairs(entities) do
		entity.Position += Vector3.new(0, 1, 0)
	end
end)
updateposition:add(Query(Positon))
```

---

Run when you want
Never worry about race conditions again. You can let River handle the calling or do it yourself.

```lua
updateposition:call()
-- Or
local world = World()
world:add(updateposition, "update")
world:start()
```

---

### Are you ready?

Read how to [Get Started](./GetStarted/) with River here!
