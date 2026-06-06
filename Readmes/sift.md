# Sift

Sift is a Luau table helper library for immutable-style updates. This project pins `Sift = "csqrl/sift@0.0.11"` in [../wally.toml](../wally.toml).

Use Sift for React state, reducer-like state updates, undo/redo history, or predictable transformations that need new table references. Use plain table mutation for local or performance-sensitive code that does not need immutable references.

## Import

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)
```

## Common Operations

Dictionary:

- `Sift.Dictionary.merge(dict, updates)`
- `Sift.Dictionary.mergeDeep(dict, updates)`
- `Sift.Dictionary.set(dict, key, value)`
- `Sift.Dictionary.removeKey(dict, key)`
- `Sift.None` to remove keys during merge operations.

Array:

- `Sift.Array.push(array, item)`
- `Sift.Array.removeValue(array, item)`
- `Sift.Array.removeIndex(array, index)`
- `Sift.Array.map(array, callback)`
- `Sift.Array.filter(array, callback)`
- `Sift.Array.concat(left, right)`

Set:

- `Sift.Set.fromArray(array)`
- `Sift.Set.toArray(set)`
- `Sift.Set.add(set, item)`
- `Sift.Set.has(set, item)`
- `Sift.Set.union(left, right)`
- `Sift.Set.intersection(left, right)`

## Local Examples

This project includes examples at [../src/Examples/Sift/SiftExamples.luau](../src/Examples/Sift/SiftExamples.luau). Use that file for quick behavior checks and sample operations instead of copying long examples into this guide.

The package source under `Packages/_Index/csqrl_sift@0.0.11/sift/src/` is also useful when confirming exact operation names.

## Rules

- Do not mutate React state tables directly; return a new table from the setter.
- Use `mergeDeep` for nested updates that preserve existing nested keys. Rebuild the nested structure explicitly when replacement is simpler.
- Keep hot-path code simple and measure before replacing direct mutation with many table copies.
- Avoid mixing immutable and mutating updates in the same state owner.

## Links

- Docs: https://cxmeel.github.io/sift/
- GitHub: https://github.com/cxmeel/sift
- Wally: https://wally.run/package/csqrl/sift
