# 🎯 Guida Sift - Gestione Dati Immutabili

## Cos'è Sift?

**Sift** è una libreria per gestire dati immutabili in Luau/Roblox, ispirata da Immutable.js e Redux. Ti permette di modificare strutture dati complesse senza mutare gli oggetti originali.

### ⚠️ Stato del Progetto
- Sift **non è più mantenuto attivamente** dal 2024
- È comunque **stabile e sicuro** da usare
- La versione `0.0.11` è l'ultima disponibile
- **Nessuna alternativa matura** esiste al momento

## 🚀 Installazione

### 1. Installa tramite Wally

```bash
wally install
```

Il package è già aggiunto al `wally.toml`:
```toml
sift = "csqrl/sift@0.0.11"
```

### 2. Testa l'installazione

Dopo l'installazione, il test viene eseguito automaticamente dal file `src/startup/Server.server.luau` all'avvio del server. Il file richiede `SiftExamples` da `ReplicatedStorage.Shared.Examples.Sift.SiftExamples` e chiama `runAllExamples()` e `testImmutability()` per verificare il funzionamento di Sift.

## 📚 Esempi Pratici

### Importare Sift

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.sift)
```

### 🔧 Dictionary (Oggetti)

```lua
local player = {
    name = "Mario",
    level = 5,
    coins = 100
}

-- ✅ Immutabile - Crea nuovo oggetto
local playerWithCoins = Sift.Dictionary.merge(player, {
    coins = 150
})

print(player.coins)        -- 100 (originale non modificato)
print(playerWithCoins.coins) -- 150 (nuovo oggetto)
```

### 📋 Array (Liste)

```lua
local inventory = {"Sword", "Shield", "Potion"}

-- ✅ Immutabile - Crea nuovo array
local newInventory = Sift.Array.push(inventory, "Magic Ring")

print(#inventory)    -- 3 (originale non modificato)
print(#newInventory) -- 4 (nuovo array)
```

## 🔥 Integrazione con React

```lua
local useState = React.useState

local function PlayerComponent()
    local playerState, setPlayerState = useState({
        name = "Player",
        health = 100,
        coins = 0
    })

    local function addCoins(amount)
        setPlayerState(function(currentState)
            -- Usa Sift per creare nuovo stato immutabile
            return Sift.Dictionary.merge(currentState, {
                coins = currentState.coins + amount
            })
        end)
    end

    -- Il componente si re-renderizza automaticamente
    return React.createElement("TextLabel", {
        Text = string.format("Coins: %d", playerState.coins)
    })
end
```

## 🏷️ Operazioni Principali

### Dictionary
- `merge(dict, updates)` - Unisce proprietà
- `mergeDeep(dict, updates)` - Merge ricorsivo
- `set(dict, key, value)` - Imposta singola proprietà
- `removeKey(dict, key)` - Rimuove proprietà
- `Sift.None` - Marker per rimuovere con merge

### Array
- `push(array, item)` - Aggiunge elemento
- `remove(array, item)` - Rimuove per valore
- `removeIndex(array, index)` - Rimuove per indice
- `map(array, func)` - Trasforma elementi
- `filter(array, func)` - Filtra elementi
- `concat(array1, array2)` - Unisce array

### Set
- `fromArray(array)` - Crea set da array
- `toArray(set)` - Converte set in array
- `add(set, item)` - Aggiunge elemento
- `has(set, item)` - Controlla presenza
- `union(set1, set2)` - Unisce set

## 💡 Perché Usare Sift?

### ✅ Vantaggi
1. **Debugging facile** - Stato precedente sempre disponibile
2. **Undo/Redo** - Storico delle modifiche
3. **React-friendly** - Ottimizza re-rendering
4. **Predictable** - Nessun side effect nascosto
5. **Hot-reload safe** - Stato non si corrompe

### ⚠️ Considerazioni
1. **Performance** - Crea nuovi oggetti (overhead memoria)
2. **Learning curve** - Approccio diverso dalla programmazione tradizionale
3. **Non mantenuto** - Nessun nuovo update/fix

## 🔧 Best Practices

### 1. Usa con React State
```lua
-- ✅ Buono
setPlayerState(function(currentState)
    return Sift.Dictionary.merge(currentState, updates)
end)

-- ❌ Evita mutazioni dirette  
currentState.health = newHealth
```

### 2. Oggetti Nested
```lua
-- ✅ Usa mergeDeep per strutture complesse
local newState = Sift.Dictionary.mergeDeep(gameState, {
    player = {
        stats = {
            strength = 15
        }
    }
})
```

### 3. Performance-Critical Code
```lua
-- Per codice che deve essere velocissimo, 
-- considera mutazione diretta con attenzione
if isPerformanceCritical then
    -- Mutazione diretta (attento ai side effects!)
    player.health = newHealth
else
    -- Sift per tutto il resto
    player = Sift.Dictionary.set(player, "health", newHealth)
end
```

## 📁 File del Progetto

- `src/Examples/Sift/SiftExamples.luau` - Esempi completi e test di immutabilità
- `src/startup/Server.server.luau` - Chiamata ai test di Sift all'avvio del server

## 🔗 Risorse

- [Documentazione Sift](https://cxmeel.github.io/sift/)
- [Repository GitHub](https://github.com/cxmeel/sift)
- [Wally Package](https://wally.run/package/csqrl/sift)

## 🤔 Alternative Future

Quando Sift diventerà obsoleto, considera:
1. **Custom utility functions** - Implementa solo quello che serve
2. **Matter ECS** - Ha utilità immutabili integrate 
3. **Fusion** - Framework reattivo con immutabilità
4. **Fork di Sift** - La comunità potrebbe mantenere una versione

Per ora, **Sift rimane la scelta migliore** per dati immutabili in Roblox! 🚀