LootTable = {}

-- money
LootTable[1] = {id = 1, name = "Money", description = "", icon = nil, stats = nil, chance = 100, quality = nil, costs = 1, color = {r = 90, g = 220, b = 90}, class = nil, stackable = false, instance = LootMoney_S}

-- clothes
LootTable[2] = {id = 2, name = "Normal Hat", description = "", icon = "Icons|Items|1", stats = {stamina = 1, intelligence = 2, armor = 100, crit = 2}, chance = 95, quality = "normal", costs = 15, color = {r = 90, g = 90, b = 90}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[3] = {id = 3, name = "Advanced Hat", description = "", icon = "Icons|Items|1", stats = {stamina = 3, intelligence = 4, armor = 300, crit = 5}, chance = 75, quality = "advanced", costs = 100, color = {r = 90, g = 220, b = 90}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[4] = {id = 4, name = "Good Hat", description = "", icon = "Icons|Items|1", stats = {stamina = 8, intelligence = 9, armor = 600, crit = 9}, chance = 55, quality = "good", costs = 500, color = {r = 90, g = 90, b = 220}, class = nil, stackable = false, instance = LootClothes_S}
LootTable[5] = {id = 5, name = "Epic Hat", description = "", icon = "Icons|Items|1", stats = {stamina = 15, intelligence = 12, armor = 1200, crit = 15}, chance = 5, quality = "epic", costs = 7500, color = {r = 220, g = 165, b = 90}, class = nil, stackable = false, instance = LootClothes_S}

-- jewelry

-- weapons