LootManager_S = inherit(Singleton)

function LootManager_S:constructor()

	self.lootClasses = {}
	
	self.maxLootDistance = Settings.maxLootDistance
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LootManager_S was loaded.")
	end
end


function LootManager_S:init()
	self.m_GetAllLootForPlayer = bind(self.getAllLootForPlayer, self)
	addEvent("GETALLLOOTFORPLAYER", true)
	addEventHandler("GETALLLOOTFORPLAYER", root, self.m_GetAllLootForPlayer)
	
end


function LootManager_S:addLoot(playerClass, money, x, y, z)
	if (playerClass) and (money) and (x) and (y) and (z) then
		self:addMoneyLoot(playerClass, money, x, y, z)
		
		local randomLoot = getRandomLoot()
		
		if (randomLoot) then
			if (randomLoot.instance) then
				local chance = math.random(0, 1000) / 10
				local dropChance = randomLoot.chance
				
				if (EventManager_S:getSingleton():isDoubleDropEvent() == true) then
					dropChance = dropChance * 2
				end

				if (chance < dropChance) then
					local lootSettings = {}
					lootSettings.id = self:getFreeID()
					lootSettings.x = x + (math.random(-1000, 1000) / 1000)
					lootSettings.y = y + (math.random(-1000, 1000) / 1000)
					lootSettings.z = z
					lootSettings.playerClass = playerClass
					lootSettings.itemContainer = randomLoot
					
					if (not self.lootClasses[lootSettings.id]) then
						self.lootClasses[lootSettings.id] = randomLoot.instance:new(lootSettings)
					end
				end
			end
		end
	end
end


function LootManager_S:getAllLootForPlayer()
	if (client) and (isElement(client)) then
		for index, lootClass in pairs(self.lootClasses) do
			if (lootClass) then
				local lootPos = lootClass:getPosition()
				local playerPos = client:getPosition()
				
				if (lootPos) and (playerPos) then

					if (getDistanceBetweenPoints2D(lootPos.x, lootPos.y, playerPos.x, playerPos.y) <= self.maxLootDistance) then
						lootClass:pickupItem(lootClass:getObject())
					end
				end
			end
		end
	end
end


function LootManager_S:addMoneyLoot(playerClass, money, x, y, z)
	if (playerClass) and (money) and (x) and (y) and (z) then
		local moneySettings = {}
		moneySettings.id = self:getFreeID()
		moneySettings.x = x + (math.random(-1000, 1000) / 1000)
		moneySettings.y = y + (math.random(-1000, 1000) / 1000)
		moneySettings.z = z
		moneySettings.money = money
		moneySettings.playerClass = playerClass
		
		if (not self.lootClasses[moneySettings.id]) then
			if (LootTable[1].instance) then
				self.lootClasses[moneySettings.id] = LootTable[1].instance:new(moneySettings)
			end
		end
	end
end


function LootManager_S:deleteLoot(id)
	if (id) then
		if (self.lootClasses[id]) then
			self.lootClasses[id]:delete()
			self.lootClasses[id] = nil
		end
	end
end


function LootManager_S:update()
	for index, lootClass in pairs(self.lootClasses) do
		if (lootClass) then
			lootClass:update()
		end
	end
end


function LootManager_S:getFreeID()
	for index, lootClass in pairs(self.lootClasses) do
		if (not lootClass) then
			return index
		end
	end
	
	return #self.lootClasses + 1
end


function LootManager_S:clear()
	removeEventHandler("GETALLLOOTFORPLAYER", root, self.m_GetAllLootForPlayer)
	
	for index, lootClass in pairs(self.lootClasses) do
		if (lootClass) then
			lootClass:delete()
			lootClass = nil
		end
	end
end


function LootManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LootManager_S was deleted.")
	end
end