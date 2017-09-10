LootTable = {}

-- money
LootTable[1] = {itemID = 1, name = "Money", description = "Ordinary means of payment.", icon = nil, stats = nil, chance = 100, quality = nil, costs = 1, color = {r = 220, g = 180, b = 90}, slot = nil, class = nil, stackable = false, instance = LootMoney_S}

-- potions
LootTable[2] = {itemID = 2, name = "Heal Potion", description = "Useful healing potion that will restore your life by 30%.", icon = "Icons|Items|1", stats = {health = 30, mana = 0}, chance = 100, quality = "normal", costs = 25, color = {r = 220, g = 90, b = 90}, slot = nil, class = nil, stackable = true, instance = LootPotion_S}
LootTable[3] = {itemID = 3, name = "Mana Potion", description = "Useful mana potion that will restore your mana by 30%.", icon = "Icons|Items|2", stats = {health = 0, mana = 30}, chance = 100, quality = "normal", costs = 25, color = {r = 90, g = 90, b = 220}, slot = nil, class = nil, stackable = true, instance = LootPotion_S}

-- clothes
-- ## HATS ## --
LootTable[100] = {itemID = 100, name = "Hat of Stamina", description = "This hat increases your stamina by a big amount. This will have great affect to your life points.", icon = "Icons|Items|3", stats = {stamina = 3, intelligence = 0, armor = 100, crit = 0}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[101] = {itemID = 101, name = "Hat of Stamina", description = "This hat increases your stamina by a big amount. This will have great affect to your life points.", icon = "Icons|Items|3", stats = {stamina = 6, intelligence = 0, armor = 300, crit = 0}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[102] = {itemID = 102, name = "Hat of Stamina", description = "This hat increases your stamina by a big amount. This will have great affect to your life points.", icon = "Icons|Items|3", stats = {stamina = 9, intelligence = 0, armor = 600, crit = 0}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[103] = {itemID = 103, name = "Hat of Stamina", description = "This hat increases your stamina by a big amount. This will have great affect to your life points.", icon = "Icons|Items|3", stats = {stamina = 12, intelligence = 0, armor = 900, crit = 0}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[104] = {itemID = 104, name = "Hat of Stamina", description = "This hat increases your stamina by a big amount. This will have great affect to your life points.", icon = "Icons|Items|3", stats = {stamina = 15, intelligence = 0, armor = 1200, crit = 0}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

LootTable[105] = {itemID = 105, name = "Hat of Intelligence", description = "This hat increases your intelligence by a big amount. This will have great affect to your mana points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 3, armor = 100, crit = 0}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[106] = {itemID = 106, name = "Hat of Intelligence", description = "This hat increases your intelligence by a big amount. This will have great affect to your mana points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 6, armor = 300, crit = 0}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[107] = {itemID = 107, name = "Hat of Intelligence", description = "This hat increases your intelligence by a big amount. This will have great affect to your mana points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 9, armor = 600, crit = 0}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[108] = {itemID = 108, name = "Hat of Intelligence", description = "This hat increases your intelligence by a big amount. This will have great affect to your mana points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 12, armor = 900, crit = 0}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[109] = {itemID = 109, name = "Hat of Intelligence", description = "This hat increases your intelligence by a big amount. This will have great affect to your mana points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 15, armor = 1200, crit = 0}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

LootTable[110] = {itemID = 110, name = "Hat of Critical", description = "This hat increases your crit chance by a big amount. This will have great affect to your critical attack points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 0, armor = 100, crit = 3}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[111] = {itemID = 111, name = "Hat of Critical", description = "This hat increases your crit chance by a big amount. This will have great affect to your critical attack points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 0, armor = 300, crit = 6}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[112] = {itemID = 112, name = "Hat of Critical", description = "This hat increases your crit chance by a big amount. This will have great affect to your critical attack points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 0, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[113] = {itemID = 113, name = "Hat of Critical", description = "This hat increases your crit chance by a big amount. This will have great affect to your critical attack points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 0, armor = 900, crit = 12}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[114] = {itemID = 114, name = "Hat of Critical", description = "This hat increases your crit chance by a big amount. This will have great affect to your critical attack points.", icon = "Icons|Items|3", stats = {stamina = 0, intelligence = 0, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

LootTable[115] = {itemID = 115, name = "Hat of Armory", description = "This hat increases your armor by a big amount. This will have great affect by reducing your incoming damage.", icon = "Icons|Items|3", stats = {stamina = 1, intelligence = 1, armor = 200, crit = 1}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[116] = {itemID = 116, name = "Hat of Armory", description = "This hat increases your armor by a big amount. This will have great affect by reducing your incoming damage.", icon = "Icons|Items|3", stats = {stamina = 2, intelligence = 2, armor = 600, crit = 2}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[117] = {itemID = 117, name = "Hat of Armory", description = "This hat increases your armor by a big amount. This will have great affect by reducing your incoming damage.", icon = "Icons|Items|3", stats = {stamina = 4, intelligence = 4, armor = 1200, crit = 4}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[118] = {itemID = 118, name = "Hat of Armory", description = "This hat increases your armor by a big amount. This will have great affect by reducing your incoming damage.", icon = "Icons|Items|3", stats = {stamina = 6, intelligence = 6, armor = 1800, crit = 6}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[119] = {itemID = 119, name = "Hat of Armory", description = "This hat increases your armor by a big amount. This will have great affect by reducing your incoming damage.", icon = "Icons|Items|3", stats = {stamina = 8, intelligence = 8, armor = 2400, crit = 8}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

LootTable[120] = {itemID = 120, name = "Hat of Mixery", description = "This hat increases all your stats by medium amount. This will have semi affect to all of your activities.", icon = "Icons|Items|3", stats = {stamina = 2, intelligence = 2, armor = 150, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[121] = {itemID = 121, name = "Hat of Mixery", description = "This hat increases all your stats by medium amount. This will have semi affect to all of your activities.", icon = "Icons|Items|3", stats = {stamina = 3, intelligence = 3, armor = 400, crit = 3}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[122] = {itemID = 122, name = "Hat of Mixery", description = "This hat increases all your stats by medium amount. This will have semi affect to all of your activities.", icon = "Icons|Items|3", stats = {stamina = 5, intelligence = 5, armor = 800, crit = 5}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[123] = {itemID = 123, name = "Hat of Mixery", description = "This hat increases all your stats by medium amount. This will have semi affect to all of your activities.", icon = "Icons|Items|3", stats = {stamina = 8, intelligence = 8, armor = 1000, crit = 8}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}
LootTable[124] = {itemID = 124, name = "Hat of Mixery", description = "This hat increases all your stats by medium amount. This will have semi affect to all of your activities.", icon = "Icons|Items|3", stats = {stamina = 10, intelligence = 10, armor = 1500, crit = 10}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "head", class = nil, stackable = false, instance = LootClothes_S}

-- ## JACKETS ## --
LootTable[200] = {itemID = 200, name = "Normal Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[201] = {itemID = 201, name = "Advanced Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[202] = {itemID = 202, name = "Good Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[203] = {itemID = 203, name = "Fantastic Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}
LootTable[204] = {itemID = 204, name = "Epic Jacket", description = "This is a test description!", icon = "Icons|Items|4", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "torso", class = nil, stackable = false, instance = LootClothes_S}

-- ## TROUSERS ## --
LootTable[300] = {itemID = 300, name = "Normal Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 180, g = 180, b = 180}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[301] = {itemID = 301, name = "Advanced Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 45, g = 180, b = 45}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[302] = {itemID = 302, name = "Good Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[303] = {itemID = 303, name = "Fantastic Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 12, intelligence = 10, armor = 900, crit = 11}, chance = 15, quality = "fantastic", costs = 4000, color = {r = 150, g = 65, b = 255}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}
LootTable[304] = {itemID = 304, name = "Epic Trouser", description = "This is a test description!", icon = "Icons|Items|5", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 255, g = 90, b = 45}, slot = "legs", class = nil, stackable = false, instance = LootClothes_S}

-- ## SHOES ## --
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