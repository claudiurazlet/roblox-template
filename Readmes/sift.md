# Sift guide (immutable data helpers)

## What is Sift?

**Sift** is a Luau/Roblox library for working with immutable data, inspired by ideas from Immutable.js and Redux. It helps you update complex tables by creating new values instead of mutating the originals.

### Project status

- Sift is not actively maintained anymore
- It is still stable to use for many projects
- This repo pins version `0.0.11`

## Installation

### 1) Install via Wally

```bash
wally install
```

The dependency is already present in [`wally.toml`](../wally.toml):

```toml
sift = "csqrl/sift@0.0.11"
```

### 2) Verify it works

This repo contains examples under [`src/Examples/Sift/SiftExamples.luau`](../src/Examples/Sift/SiftExamples.luau). You can run them from the server entry point if you want to validate behavior.

## Practical examples

### Import Sift

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
```

### Dictionary (tables)

```lua
local player = {
    name = "Mario",
    level = 5,
    coins = 100,
}

-- Immutable: creates a new table
local playerWithCoins = Sift.Dictionary.merge(player, {
    coins = 150,
})

print(player.coins) -- 100 (original unchanged)
print(playerWithCoins.coins) -- 150 (new table)
```

### Array (lists)

```lua
local inventory = { "Sword", "Shield", "Potion" }

-- Immutable: creates a new array
local newInventory = Sift.Array.push(inventory, "Magic Ring")

print(#inventory) -- 3 (original unchanged)
print(#newInventory) -- 4 (new array)
```

## React integration (example)

```lua
local useState = React.useState

local function PlayerComponent()
    local playerState, setPlayerState = useState({
        name = "Player",
        health = 100,
        coins = 0,
    })

    local function addCoins(amount)
        setPlayerState(function(currentState)
            return Sift.Dictionary.merge(currentState, {
                coins = currentState.coins + amount,
            })
        end)
    end

    return React.createElement("TextLabel", {
        Text = string.format("Coins: %d", playerState.coins),
    })
end
```

## Main operations (cheat sheet)

### Dictionary

- `merge(dict, updates)`
- `mergeDeep(dict, updates)`
- `set(dict, key, value)`
- `removeKey(dict, key)`
- `Sift.None` (marker to remove keys via merge)

### Array

- `push(array, item)`
- `remove(array, item)`
- `removeIndex(array, index)`
- `map(array, func)`
- `filter(array, func)`
- `concat(array1, array2)`

### Set

- `fromArray(array)`
- `toArray(set)`
- `add(set, item)`
- `has(set, item)`
- `union(set1, set2)`

## Why use Sift?

Pros:

1. Easier debugging (previous state still exists)
2. Undo/redo patterns become simpler
3. React-friendly (change detection via new references)
4. More predictable code (fewer hidden side effects)

Considerations:

1. Performance: creates new tables (memory overhead)
2. Learning curve: different mindset vs direct mutation

## Best practices

### With React state

```lua
setPlayerState(function(currentState)
    return Sift.Dictionary.merge(currentState, updates)
end)

-- Avoid direct mutation:
-- currentState.health = newHealth
```

### Nested objects

```lua
local newState = Sift.Dictionary.mergeDeep(gameState, {
    player = {
        stats = {
            strength = 15,
        },
    },
})
```

## Links

- Docs: https://cxmeel.github.io/sift/
- GitHub: https://github.com/cxmeel/sift
- Wally: https://wally.run/package/csqrl/sift