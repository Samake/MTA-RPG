LootTable = {}

-- money
LootTable[1] = {itemID = 1, name = "Money", description = "This is a test description!", icon = nil, stats = nil, chance = 100, quality = nil, costs = 1, color = {r = 220, g = 180, b = 90}, slot = nil, class = nil, stackable = false, instance = LootMoney_S}

-- money
LootTable[2] = {itemID = 2, name = "Heal Potion", description = "This is a test description!", icon = "Icons|Items|1", stats = {health = 30, mana = 0}, chance = 100, quality = "normal", costs = 25, color = {r = 220, g = 90, b = 90}, slot = nil, class = nil, stackable = true, instance = LootPotion_S}
LootTable[3] = {itemID = 3, name = "Mana Potion", description = "This is a test description!", icon = "Icons|Items|2", stats = {health = 0, mana = 30}, chance = 100, quality = "normal", costs = 25, color = {r = 90, g = 90, b = 220}, slot = nil, class = nil, stackable = true, instance = LootPotion_S}


-- clothes
LootTable[100] = {itemID = 100, name = "Normal Hat", description = "This is a test description!", icon = "Icons|Items|3", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[101] = {itemID = 101, name = "Advanced Hat", description = "This is a test description!", icon = "Icons|Items|3", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[102] = {itemID = 102, name = "Good Hat", description = "This is a test description!", icon = "Icons|Items|3", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[103] = {itemID = 103, name = "Fantastic Hat", description = "This is a test description!", icon = "Icons|Items|3", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[104] = {itemID = 104, name = "Epic Hat", description = "This is a test description!", icon = "Icons|Items|3", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

LootTable[200] = {itemID = 200, name = "Normal Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[201] = {itemID = 201, name = "Advanced Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[202] = {itemID = 202, name = "Good Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[203] = {itemID = 203, name = "Fantastic Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[204] = {itemID = 204, name = "Epic Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}

LootTable[300] = {itemID = 300, name = "Normal Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[301] = {itemID = 301, name = "Advanced Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[302] = {itemID = 302, name = "Good Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[303] = {itemID = 303, name = "Fantastic Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[304] = {itemID = 304, name = "Epic Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}

LootTable[400] = {itemID = 400, name = "Normal Shoes", description = "This is a test description!", icon = "Icons|Items|6", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "feet", class = nil, stackable = false, instance = LootClothes_S}
LootTable[401] = {itemID = 401, name = "Advanced Shoes", description = "This is a test description!", icon = "Icons|Items|6", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "feet", class = nil, stackable = false, instance = LootClothes_S}
LootTable[402] = {itemID = 402, name = "Good Shoes", description = "This is a test description!", icon = "Icons|Items|6", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "feet", class = nil, stackable = false, instance = LootClothes_S}
LootTable[403] = {itemID = 403, name = "Fantastic Shoes", description = "This is a test description!", icon = "Icons|Items|6", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "feet", class = nil, stackable = false, instance = LootClothes_S}
LootTable[404] = {itemID = 404, name = "Epic Shoes", description = "This is a test description!", icon = "Icons|Items|6", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "feet", class = nil, stackable = false, instance = LootClothes_S}

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