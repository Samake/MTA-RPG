LootTable = {}

-- money
LootTable[1] = {itemID = 1, name = "Money", description = "", icon = nil, stats = nil, chance = 100, quality = nil, costs = 1, color = {r = 180, g = 180, b = 180}, class = nil, stackable = false, instance = LootMoney_S}

-- money
LootTable[2] = {itemID = 2, name = "Heal Potion", description = "", icon = "Icons|Items|1", stats = {health = 30, mana = 0}, chance = 100, quality = "normal", costs = 25, color = {r = 180, g = 180, b = 180}, class = nil, stackable = true, instance = LootPotion_S}
LootTable[3] = {itemID = 3, name = "Mana Potion", description = "", icon = "Icons|Items|2", stats = {health = 0, mana = 30}, chance = 100, quality = "normal", costs = 25, color = {r = 180, g = 180, b = 180}, class = nil, stackable = true, instance = LootPotion_S}


-- clothes
LootTable[100] = {itemID = 100, name = "Normal Hat", description = "", icon = "Icons|Items|3", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[101] = {itemID = 101, name = "Advanced Hat", description = "", icon = "Icons|Items|3", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[102] = {itemID = 102, name = "Good Hat", description = "", icon = "Icons|Items|3", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 45, g = 45, b = 220}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[103] = {itemID = 103, name = "Fantastic Hat", description = "", icon = "Icons|Items|3", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[104] = {itemID = 104, name = "Epic Hat", description = "", icon = "Icons|Items|3", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, class = nil, stackable = false, instance = LootClothes_S}

-- jewelry

-- weapons


function getRandomLoot()
	local tableLength = 0
	
	for index, lootContainer in pairs(LootTable) do
		if (lootContainer) then
			tableLength = tableLength + 1
		end
	end
	
	local randomID = math.random(2, tableLength)
	
	local currentID = 0
	
	for index, lootContainer in pairs(LootTable) do
		if (lootContainer) then
			currentID = currentID + 1
			
			if (currentID == randomID) then
				return lootContainer
			end
		end
	end
end