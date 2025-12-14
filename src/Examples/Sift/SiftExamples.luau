local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sift = require(ReplicatedStorage.Packages.Sift)

--[[
	SiftExamples.mod.sh.luau
	Esempi pratici di Sift per dati immutabili in Roblox
]]

local SiftExamples = {}

-- ============================
-- ESEMPI DICTIONARY (Oggetti)
-- ============================

function SiftExamples.dictionaryExamples()
	print("🔧 === SIFT DICTIONARY EXAMPLES ===")

	-- Stato iniziale
	local player = {
		name = "Mario",
		level = 5,
		coins = 100,
		stats = {
			strength = 10,
			speed = 8,
		},
	}

	print("Original player:", game.HttpService:JSONEncode(player))

	-- 1. Merge - Unire proprietà (immutabile)
	local playerWithNewCoins = Sift.Dictionary.merge(player, {
		coins = 150,
		level = 6,
	})
	print("After coins+level update:", game.HttpService:JSONEncode(playerWithNewCoins))
	print("Original unchanged:", player.coins) -- Rimane 100!

	-- 2. MergeDeep - Merge ricorsivo per oggetti nested
	local playerWithNewStats = Sift.Dictionary.mergeDeep(player, {
		stats = {
			strength = 12, -- Solo strength cambia, speed rimane 8
		},
	})
	print("After deep merge stats:", game.HttpService:JSONEncode(playerWithNewStats))

	-- 3. Set - Impostare una singola chiave
	local playerWithNewName = Sift.Dictionary.set(player, "name", "Luigi")
	print("After name change:", playerWithNewName.name)

	-- 4. Remove - Rimuovere proprietà
	local playerWithoutCoins = Sift.Dictionary.removeKey(player, "coins")
	print("After removing coins:", game.HttpService:JSONEncode(playerWithoutCoins))

	-- 5. None - Rimuovere usando merge
	local playerCleanup = Sift.Dictionary.merge(player, {
		coins = Sift.None, -- Rimuove la proprietà coins
	})
	print("Using Sift.None to remove:", game.HttpService:JSONEncode(playerCleanup))

	print("✅ Dictionary examples completed\n")
end

-- ============================
-- ESEMPI ARRAY (Liste)
-- ============================

function SiftExamples.arrayExamples()
	print("📋 === SIFT ARRAY EXAMPLES ===")

	local inventory = { "Sword", "Shield", "Potion" }
	print("Original inventory:", table.concat(inventory, ", "))

	-- 1. Push - Aggiungere elementi
	local inventoryWithItem = Sift.Array.push(inventory, "Magic Ring")
	print("After adding item:", table.concat(inventoryWithItem, ", "))
	print("Original unchanged:", table.concat(inventory, ", "))

	-- 2. Remove - Rimuovere per valore
	local inventoryWithoutPotion = Sift.Array.removeValue(inventory, "Potion")
	print("After removing Potion:", table.concat(inventoryWithoutPotion, ", "))

	-- 3. RemoveIndex - Rimuovere per indice
	local inventoryWithoutFirst = Sift.Array.removeIndex(inventory, 1)
	print("After removing first item:", table.concat(inventoryWithoutFirst, ", "))

	-- 4. Map - Trasformare elementi
	local uppercaseInventory = Sift.Array.map(inventory, function(item)
		return string.upper(item)
	end)
	print("Uppercase inventory:", table.concat(uppercaseInventory, ", "))

	-- 5. Filter - Filtrare elementi
	local longItemNames = Sift.Array.filter(inventory, function(item)
		return string.len(item) > 5
	end)
	print("Items with >5 characters:", table.concat(longItemNames, ", "))

	-- 6. Concat - Unire array
	local newItems = { "Bow", "Arrow" }
	local fullInventory = Sift.Array.concat(inventory, newItems)
	print("Full inventory:", table.concat(fullInventory, ", "))

	-- 7. Shuffle - Mescolare ordine
	local shuffled = Sift.Array.shuffle(inventory)
	print("Shuffled:", table.concat(shuffled, ", "))

	print("✅ Array examples completed\n")
end

-- ============================
-- ESEMPI PRATICI PER GIOCHI
-- ============================

function SiftExamples.gameStateExamples()
	print("🎮 === GAME STATE EXAMPLES ===")

	-- Stato complesso di un gioco
	local gameState = {
		player = {
			name = "Player1",
			health = 100,
			level = 1,
			inventory = { "Starter Sword" },
			achievements = {},
		},
		world = {
			currentArea = "Forest",
			enemiesDefeated = 0,
			chestsOpened = {},
		},
		ui = {
			inventoryOpen = false,
			selectedItem = nil,
		},
	}

	-- Esempio: Giocatore raccoglie un item
	local stateAfterLoot = Sift.Dictionary.mergeDeep(gameState, {
		player = {
			inventory = Sift.Array.push(gameState.player.inventory, "Health Potion"),
		},
	})

	-- Esempio: Giocatore subisce danni

	-- Esempio: Aprire inventario UI

	-- Esempio: Multiple updates in una volta
	local stateAfterBattle = Sift.Dictionary.mergeDeep(gameState, {
		player = {
			health = 75,
			inventory = Sift.Array.push(gameState.player.inventory, "Enemy Drop"),
			achievements = Sift.Array.push(gameState.player.achievements, "First Victory"),
		},
		world = {
			enemiesDefeated = gameState.world.enemiesDefeated + 1,
		},
	})

	print("Original player inventory:", table.concat(gameState.player.inventory, ", "))
	print("After loot:", table.concat(stateAfterLoot.player.inventory, ", "))
	print("After battle:", table.concat(stateAfterBattle.player.inventory, ", "))
	print("Enemies defeated after battle:", stateAfterBattle.world.enemiesDefeated)

	print("✅ Game state examples completed\n")
end

-- ============================
-- ESEMPI SET (Insiemi)
-- ============================

function SiftExamples.setExamples()
	print("🏷️ === SIFT SET EXAMPLES ===")

	-- Set per tracciare achievements unici
	local achievements = Sift.Set.fromArray({ "FirstKill", "Explorer", "Collector" })
	print("Initial achievements:", table.concat(Sift.Set.toArray(achievements), ", "))

	-- Aggiungere achievement
	local withNewAchievement = Sift.Set.add(achievements, "MasterCrafter")
	print("After adding achievement:", table.concat(Sift.Set.toArray(withNewAchievement), ", "))

	-- Controllare se contiene
	local hasExplorer = Sift.Set.has(achievements, "Explorer")
	local hasMaster = Sift.Set.has(achievements, "MasterCrafter")
	print("Has Explorer:", hasExplorer) -- true
	print("Has MasterCrafter:", hasMaster) -- false

	-- Union di set (tutti gli achievements)
	local serverAchievements = Sift.Set.fromArray({ "GlobalEvent", "Collector", "Veteran" })
	local allAchievements = Sift.Set.union(achievements, serverAchievements)
	print("All achievements:", table.concat(Sift.Set.toArray(allAchievements), ", "))

	-- Intersection (achievements comuni)
	local commonAchievements = Sift.Set.intersection(achievements, serverAchievements)
	print("Common achievements:", table.concat(Sift.Set.toArray(commonAchievements), ", "))

	print("✅ Set examples completed\n")
end

-- ============================
-- FUNZIONE PRINCIPALE
-- ============================

function SiftExamples.runAllExamples()
	print("🚀 Starting Sift Examples...\n")

	SiftExamples.dictionaryExamples()
	SiftExamples.arrayExamples()
	SiftExamples.setExamples()
	SiftExamples.gameStateExamples()

	print("🎉 All Sift examples completed!")
	print("💡 Remember: All operations create NEW objects, originals are never modified!")
end

-- Utility per testing
function SiftExamples.testImmutability()
	print("🧪 === TESTING IMMUTABILITY ===")

	local original = { name = "Test", value = 42 }
	local modified = Sift.Dictionary.set(original, "value", 999)

	print("Original value:", original.value) -- 42
	print("Modified value:", modified.value) -- 999
	print("Immutability working:", original.value ~= modified.value) -- true
end

return SiftExamples
