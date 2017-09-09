Player_C = inherit(Singleton)

function Player_C:constructor()
	
	self.player = getLocalPlayer()
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.maxSlots = 10
	
	self.maxLife = 0
	self.currentLife = 0
	self.maxMana = 0
	self.currentMana = 0
	
	self.class = "UNKNOWN"
	self.rank = "UNKNOWN"
	self.level = 1
	self.currentXP = 0
	self.maxXP = 0
	self.money = 0
	
	self.stamina = 0
	self.currentStamina = 0
	
	self.intelligence = 0
	self.currentIntelligence = 0
	
	self.armor = 0
	self.currentArmor = 0
	
	self.critChance = 0
	self.currentCritChance = 0
	
	self.oldEquippedSlots = {}
	self.equippedSlots = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Player_C was loaded.")
	end
end


function Player_C:init()
	self.m_GetServerData = bind(self.getServerData, self)
	addEvent("SYNCPLAYERDATA", true)
	addEventHandler("SYNCPLAYERDATA", root, self.m_GetServerData)
	
	self.m_PlayerSit = bind(self.playerSit, self)
	bindKey(Bindings["SIT"], "down", self.m_PlayerSit)
	
	self.m_ShowInventory = bind(self.showInventory, self)
	bindKey(Bindings["INVENTORY"], "down", self.m_ShowInventory)
	
	if (self.player) then
		if (not self.inventory) then
			self.inventory = Inventory_C:new(self.player)
		end
	end
	
	triggerServerEvent("CONNECTPLAYER", root)
end


function Player_C:update(deltaTime)
	if (self.player) and (isElement(self.player)) then
		self:updateCoords()
		self:checkChanges()
	end
end


function Player_C:updateCoords()
	self.playerPos = self.player:getPosition()
	
	if (self.playerPos) then
		self.x = self.playerPos.x
		self.y = self.playerPos.y
		self.z = self.playerPos.z
	end
	
	self.playerRot = self.player:getRotation()
	
	if (self.playerRot) then
		self.rx = self.playerRot.x
		self.ry = self.playerRot.y
		self.rz = self.playerRot.z
	end
end


function Player_C:playerSit()
	triggerServerEvent("PLAYERSITDOWN", root)
end


function Player_C:showInventory()
	GUIManager_C:getSingleton():showGUI(not GUIManager_C:getSingleton():isShowGUI())
	GUIManager_C:getSingleton():showInventory(not GUIManager_C:getSingleton():isShowInventory())
end


function Player_C:getPlayerClass()
	return self
end


function Player_C:getServerData(playerTable)
	if (playerTable) then
		if (playerTable.equippedSlots) then
			self.oldEquippedSlots = self.equippedSlots
			self.equippedSlots = playerTable.equippedSlots
		end
		
		if (playerTable.rank) then
			self.rank = playerTable.rank
		end
		
		if (playerTable.level) then
			self.level = playerTable.level
		end
		
		if (playerTable.currentXP) then
			self.currentXP = playerTable.currentXP
		end
		
		if (playerTable.maxXP) then
			self.maxXP = playerTable.maxXP
		end
		
		if (playerTable.maxLife) then
			self.maxLife = playerTable.maxLife
		end
		
		if (playerTable.currentLife) then
			self.currentLife = playerTable.currentLife
		end
		
		if (playerTable.maxMana) then
			self.maxMana = playerTable.maxMana
		end
		
		if (playerTable.currentMana) then
			self.currentMana = playerTable.currentMana
		end
		
		if (playerTable.money) then
			self.money = playerTable.money
		end
		
		if (playerTable.class) then
			self.class = playerTable.class
		end
		
		if (playerTable.stamina) then
			self.stamina = playerTable.stamina
		end
		
		if (playerTable.currentStamina) then
			self.currentStamina = playerTable.currentStamina
		end
		
		if (playerTable.intelligence) then
			self.intelligence = playerTable.intelligence
		end
		
		if (playerTable.currentIntelligence) then
			self.currentIntelligence = playerTable.currentIntelligence
		end
		
		if (playerTable.armor) then
			self.armor = playerTable.armor
		end
		
		if (playerTable.currentArmor) then
			self.currentArmor = playerTable.currentArmor
		end
		
		if (playerTable.critChance) then
			self.critChance = playerTable.critChance
		end
		
		if (playerTable.currentCritChance) then
			self.currentCritChance = playerTable.currentCritChance
		end
	end
end


function Player_C:checkChanges()
	self:checkSlotChanges()
end


function Player_C:checkSlotChanges()
	for index, slot in pairs(self.oldEquippedSlots) do
		if (slot) then
			if (self.equippedSlots[index]) then
				if (self.equippedSlots[index] ~= slot) then
					triggerEvent("UPDATEQUICKSLOTS", root)
					return
				end
			end
		end
	end
end


function Player_C:getMaxLife()
	return self.maxLife
end


function Player_C:getCurrentLife()
	return self.currentLife
end


function Player_C:getMaxMana()
	return self.maxMana
end


function Player_C:getCurrentMana()
	return self.currentMana
end


function Player_C:getPlayerSlots()
	return self.equippedSlots
end


function Player_C:getRank()
	return self.rank
end	


function Player_C:getLevel()
	return self.level
end


function Player_C:getCurrentXP()
	return self.currentXP
end


function Player_C:getMaxXP()
	return self.maxXP
end


function Player_C:getInventory()
	return self.inventory
end


function Player_C:getName()
	return self.player:getName()
end


function Player_C:getMoney()
	return self.money
end


function Player_C:getClass()
	return self.class
end


function Player_C:getStamina()
	return self.stamina
end


function Player_C:getCurrentStamina()
	return self.currentStamina
end


function Player_C:getIntelligence()
	return self.intelligence
end


function Player_C:getCurrentIntelligence()
	return self.currentIntelligence
end


function Player_C:getArmor()
	return self.armor
end


function Player_C:getCurrentArmor()
	return self.currentArmor
end


function Player_C:getCritChance()
	return self.critChance
end


function Player_C:getCurrentCritChance()
	return self.currentCritChance
end


function Player_C:clear()
	unbindKey(Bindings["SIT"], "down", self.m_PlayerSit)
	unbindKey(Bindings["INVENTORY"], "down", self.m_ShowInventory)
	
	if (self.inventory) then
		self.inventory:delete()
		self.inventory = nil
	end
	
	removeEventHandler("SYNCPLAYERDATA", root, self.m_GetServerData)
end


function Player_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Player_C was deleted.")
	end
end