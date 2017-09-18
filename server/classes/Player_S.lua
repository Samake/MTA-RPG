Player_S = inherit(Class)

function Player_S:constructor(playerSettings)
	
	self.id = playerSettings.id
	self.player = playerSettings.player
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.skinID = 0
	self.dimension = 0
	
	self.targetX = nil
	self.targetY = nil
	self.targetZ = nil
	
	self.minDistance = 0
	self.distance = 0
	self.tolerance = 1.0
	
	self.headID = 1
	
	self.maxLife = 1000
	self.currentLife = 99999999999
	self.maxMana = 100
	self.currentMana = 99999999999
	
	self.lifeRegeneration = 0
	self.manaRegeneration = 0
	
	self.rank = "Beginner"
	self.class = "Fighter"
	self.level = 1
	self.currentXP = 1
	self.maxXP = 1000
	
	self.baseStamina = 100
	self.stamina = self.baseStamina
	self.currentStamina = self.baseStamina
	
	self.baseIntelligence = 100
	self.intelligence = self.baseIntelligence
	self.currentIntelligence = self.baseIntelligence
	
	self.baseArmor = 100
	self.armor = self.baseArmor
	self.currentArmor = self.baseArmor
	
	self.baseCritChance = 5
	self.critChance = self.baseCritChance
	self.currentCritChance = self.baseCritChance
	
	self.money = 0
	
	self.critChance = 15
	self.levelCaps = LevelCaps[1]
	self.levelModifier = self.levelCaps.modifier
	
	self.playerTable = {}
	self.equippedSlots = {}
	
	self.state = "idle"
	
	self.isClientConnected = false
	self.isSitting = false
	
	self.currentTick = 0
	self.healTick = 0
	
	self.headClothes = nil
	self.torsoClothes = nil
	self.legClothes = nil
	self.feetClothes = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.player:getName() .. " was loaded.")
	end
end


function Player_S:init()
	self.m_SetTargetPosition = bind(self.setTargetPosition, self)
	addEvent("SETPLAYERTARGET", true)
	addEventHandler("SETPLAYERTARGET", root, self.m_SetTargetPosition)
	
	self.m_ConnectPlayer = bind(self.connectPlayer, self)
	addEvent("CONNECTPLAYER", true)
	addEventHandler("CONNECTPLAYER", root, self.m_ConnectPlayer)
	
	self.m_TogglePlayerSit = bind(self.togglePlayerSit, self)
	addEvent("PLAYERSITDOWN", true)
	addEventHandler("PLAYERSITDOWN", root, self.m_TogglePlayerSit)
	
	self.m_UpdatePlayerClothesAndEquipment = bind(self.updatePlayerClothesAndEquipment, self)
	addEvent("UPDATEPLAYERCLOTHES", true)
	addEventHandler("UPDATEPLAYERCLOTHES", root, self.m_UpdatePlayerClothesAndEquipment)
	
	
	-- only temp will be deleted later
	if (self.player) then
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
		if (not self.inventory) then
			self.inventory = Inventory_S:new(self.player)
		end
		
		self.player:spawn(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.z, self.skinID, 0, self.dimension)
		
		self.equippedSlots[1] = Attacks["Default"]["Punch"]
		self.equippedSlots[2] = Attacks["Default"]["Kick"]
		self.equippedSlots[3] = Attacks["Default"]["Punch3"]
		self.equippedSlots[4] = Attacks["Default"]["Punch4"]
		self.equippedSlots[5] = Attacks["Default"]["Punch5"]
		
		AttackManager_S:getSingleton():setPlayerAttacks(self.player, self.equippedSlots)
		
		self.healTick = getTickCount()
	end
	
	-- !!!!!!!!only for testing!!!!!!!!
	self.isTestLoot = false
	self.startTick = getTickCount()
	-- !!!!!!!!only for testing!!!!!!!!
end

-- !!!!!!!!only for testing!!!!!!!!
function Player_S:addTestLoot()
	if (self.inventory) then
		for i = 1, 48, 1 do
			self.inventory:addItem(self.player, getRandomLoot())
		end
		
		self.isTestLoot = true
	end
end
-- !!!!!!!!only for testing!!!!!!!!


function Player_S:update()
	if (self.player) and (isElement(self.player)) then
		self.currentTick = getTickCount()
		
		-- !!!!!!!!only for testing!!!!!!!!
		if (self.currentTick > self.startTick + 3000) then
			if (self.isTestLoot == false) then
				self:addTestLoot()
			end
		end
		-- !!!!!!!!only for testing!!!!!!!!
		
		self:updateCoords()
		self:updatePosition()
		self:updateItemStats()
		self:updatePlayerStats()
		
		if (self.state == "run") then
			self:correctPosition()
		elseif (self.state == "sit") then
			
		end
		
		if (self.isSitting == true) then
			if (self.state ~= "sit") then
				self:jobStartSit()
			end
		elseif (self.isSitting == false) then
			if (self.state == "sit") then
				self:jobStopSit()
			end
		end
		
		self:syncPlayerData()
	end
end


function Player_S:updateItemStats()
	if (self.levelCaps.modifier) then
		self.stamina = self.baseStamina * self.levelCaps.modifier
		self.currentStamina = self.stamina
		
		self.intelligence = self.baseIntelligence * self.levelCaps.modifier
		self.currentIntelligence = self.intelligence
		
		self.armor = self.baseArmor * self.level * self.levelCaps.modifier
		self.currentArmor = self.armor
		
		self.critChance = self.baseCritChance
		self.currentCritChance = self.critChance
		
		if (self.inventory:getSlotHead()) then
			if (self.inventory:getSlotHead().stats) then
				if (self.inventory:getSlotHead().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotHead().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotHead().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotHead().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotHead().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotHead().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotHead().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotHead().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotTorso()) then
			if (self.inventory:getSlotTorso().stats) then
				if (self.inventory:getSlotTorso().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotTorso().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotTorso().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotTorso().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotTorso().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotTorso().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotTorso().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotTorso().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotLegs()) then
			if (self.inventory:getSlotLegs().stats) then
				if (self.inventory:getSlotLegs().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotLegs().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLegs().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotLegs().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLegs().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotLegs().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLegs().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotLegs().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotFeet()) then
			if (self.inventory:getSlotFeet().stats) then
				if (self.inventory:getSlotFeet().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotFeet().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotFeet().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotFeet().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotFeet().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotFeet().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotFeet().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotFeet().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotLeftHand()) then
			if (self.inventory:getSlotLeftHand().stats) then
				if (self.inventory:getSlotLeftHand().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotLeftHand().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftHand().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotLeftHand().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftHand().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotLeftHand().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftHand().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotLeftHand().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotRighthand()) then
			if (self.inventory:getSlotRighthand().stats) then
				if (self.inventory:getSlotRighthand().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotRighthand().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRighthand().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotRighthand().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRighthand().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotRighthand().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRighthand().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotRighthand().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotLeftRing()) then
			if (self.inventory:getSlotLeftRing().stats) then
				if (self.inventory:getSlotLeftRing().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotLeftRing().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftRing().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotLeftRing().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftRing().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotLeftRing().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotLeftRing().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotLeftRing().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotRightRing()) then
			if (self.inventory:getSlotRightRing().stats) then
				if (self.inventory:getSlotRightRing().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotRightRing().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRightRing().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotRightRing().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRightRing().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotRightRing().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotRightRing().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotRightRing().stats.crit
				end
			end
		end
		
		if (self.inventory:getSlotChain()) then
			if (self.inventory:getSlotChain().stats) then
				if (self.inventory:getSlotChain().stats.stamina) then
					self.currentStamina = self.currentStamina + self.inventory:getSlotChain().stats.stamina * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotChain().stats.intelligence) then
					self.currentIntelligence = self.currentIntelligence + self.inventory:getSlotChain().stats.intelligence * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotChain().stats.armor) then
					self.currentArmor = self.currentArmor + self.inventory:getSlotChain().stats.armor * self.levelCaps.modifier
				end
				
				if (self.inventory:getSlotChain().stats.crit) then
					self.currentCritChance = self.currentCritChance + self.inventory:getSlotChain().stats.crit
				end
			end
		end
		
		self.currentStamina = math.floor(self.currentStamina + 0.5)
		self.currentIntelligence = math.floor(self.currentIntelligence + 0.5)
		self.currentArmor = math.floor(self.currentArmor + 0.5)
		self.currentCritChance = math.floor(self.currentCritChance + 0.5)
	end
end


function Player_S:updatePlayerStats()
	local delay
	
	if (self.isSitting == true) then
		delay = 400
	else
		delay = 800
	end
	
	if (LevelCaps[self.level + 1]) then
		self.levelCaps = LevelCaps[self.level + 1]
	end
	
	self.maxXP = self.levelCaps.xp
	self.maxLife = math.floor((1000 + (10 * self.currentStamina * self.levelCaps.modifier)) + 0.5)
	self.maxMana = math.floor((100 + (self.currentIntelligence * self.levelCaps.modifier)) + 0.5)
	
	if (self.currentTick > self.healTick + delay) then
		self.lifeRegeneration = (self.maxLife / 400) * Settings.selfHealFactor
		self.manaRegeneration = (self.maxMana / 400) * Settings.selfHealFactor
		
		local lifeValue, manaValue
		
		if (self.isSitting == true) then
			lifeValue = self.lifeRegeneration * 3
			manaValue = self.manaRegeneration * 3
		else
			lifeValue = self.lifeRegeneration
			manaValue = self.manaRegeneration
		end
		
		if (self.currentLife < self.maxLife) then
			self:changeLife(lifeValue)
			
			if (self.isSitting == true) then
				Text3DManager_S:sendText(self.player, "+" .. string.format("%.1f", lifeValue), self.x, self.y, self.z + 0.5, 220, 90, 90, 0.4)
			end
		elseif (self.currentLife > self.maxLife) then
			self.currentLife = self.maxLife
		end
		
		if (self.currentMana < self.maxMana) then
			self:changeMana(manaValue)
			
			if (self.isSitting == true) then
				Text3DManager_S:sendText(self.player, "+" .. string.format("%.1f", manaValue), self.x, self.y, self.z + 0.5, 90, 90, 220, 0.4)
			end
		elseif (self.currentMana > self.maxMana) then
			self.currentMana = self.maxMana
		end
		
		self.healTick = getTickCount()
	end
end


function Player_S:updatePlayerClothesAndEquipment(player)
	if (player) and (player == self.player) then
		if (self.headClothes) then
			if (self.inventory:getSlotHead()) then
				if (self.inventory:getSlotHead().clothes) then
					if (self.headClothes.index ~= self.inventory:getSlotHead().clothes.index) 
						or (self.headClothes.texture ~= self.inventory:getSlotHead().clothes.texture)
						or (self.headClothes.model ~= self.inventory:getSlotHead().clothes.model)
					then
						self.player:addClothes(self.inventory:getSlotHead().clothes.texture, self.inventory:getSlotHead().clothes.model, 16)
						self.headClothes = self.inventory:getSlotHead().clothes
					end
				end
			else
				self.player:removeClothes(16)
				self.headClothes = nil
			end
		else
			if (self.inventory:getSlotHead()) then
				if (self.inventory:getSlotHead().clothes) then
					self.player:addClothes(self.inventory:getSlotHead().clothes.texture, self.inventory:getSlotHead().clothes.model, 16)
					self.headClothes = self.inventory:getSlotHead().clothes
				end
			end
		end
		
		if (self.torsoClothes) then
			if (self.inventory:getSlotTorso()) then
				if (self.inventory:getSlotTorso().clothes) then
					if (self.torsoClothes.index ~= self.inventory:getSlotTorso().clothes.index) 
						or (self.torsoClothes.texture ~= self.inventory:getSlotTorso().clothes.texture)
						or (self.torsoClothes.model ~= self.inventory:getSlotTorso().clothes.model)
					then
						self.player:addClothes(self.inventory:getSlotTorso().clothes.texture, self.inventory:getSlotTorso().clothes.model, 0)
						self.torsoClothes = self.inventory:getSlotTorso().clothes
					end
				end
			else
				self.player:removeClothes(0)
				self.torsoClothes = nil
			end
		else
			if (self.inventory:getSlotTorso()) then
				if (self.inventory:getSlotTorso().clothes) then
					self.player:addClothes(self.inventory:getSlotTorso().clothes.texture, self.inventory:getSlotTorso().clothes.model, 0)
					self.torsoClothes = self.inventory:getSlotTorso().clothes
				end
			end
		end
		
		if (self.legClothes) then
			if (self.inventory:getSlotLegs()) then

			end
		else
			if (self.inventory:getSlotLegs()) then

			end
		end
		
		if (self.feetClothes) then
			if (self.inventory:getSlotFeet()) then

			end
		else
			if (self.inventory:getSlotFeet()) then

			end
		end
	end
end


function Player_S:updateCoords()
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


function Player_S:updatePosition()
	if (self.targetX) and (self.targetY) and (self.targetZ) then
		self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
		
		if (self.distance <= self.tolerance) then
			self:jobIdle()
		end
	end
end


function Player_S:correctPosition()
	if (self.player) and (isElement(self.player)) then
		if (self.distance <= self.minDistance) then
			self.minDistance = self.distance
		else
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.player:setRotation(self.rx, self.ry, rotZ, "default", true)
		end
	end
end


function Player_S:togglePlayerSit()
	if (client) and (isElement(client)) then
		if (client == self.player) then
			self.isSitting = not self.isSitting
		end
	end
end


function Player_S:syncPlayerData()
	if (self.isClientConnected == true) then
		self.playerTable.equippedSlots = self.equippedSlots
		self.playerTable.rank = self.rank
		self.playerTable.level = self.level
		self.playerTable.currentXP = self.currentXP
		self.playerTable.maxXP = self.maxXP
		self.playerTable.maxLife = self.maxLife
		self.playerTable.currentLife = self.currentLife
		self.playerTable.maxMana = self.maxMana
		self.playerTable.currentMana = self.currentMana
		self.playerTable.money = self.money
		self.playerTable.class = self.class
		self.playerTable.stamina = self.stamina
		self.playerTable.currentStamina = self.currentStamina
		self.playerTable.intelligence = self.intelligence
		self.playerTable.currentIntelligence = self.currentIntelligence
		self.playerTable.armor = self.armor
		self.playerTable.currentArmor = self.currentArmor
		self.playerTable.critChance = self.critChance
		self.playerTable.currentCritChance = self.currentCritChance

		triggerClientEvent(self.player, "SYNCPLAYERDATA", self.player, self.playerTable)
	end
end


function Player_S:connectPlayer()
	if (client) and (isElement(client)) then
		if (client == self.player) then
			self.isClientConnected = true
		end
	end
end


function Player_S:setTargetPosition(x, y, z)
	if (self.isSitting == false) then
		if (self.player) and (isElement(self.player)) then
				if (self.player == client) and (x) and (y) and (z) then
				self.targetX = x
				self.targetY = y
				self.targetZ = z
				
				local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
				self.player:setRotation(self.rx, self.ry, rotZ, "default", true)
				
				self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
				self.minDistance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
				
				self:jobRun()
			end
		end
	end
end


function Player_S:jobIdle()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation()
		self.targetX = nil
		self.targetY = nil
		self.targetZ = nil
		self.state = "idle"
	end
end


function Player_S:jobRun()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation(Animations["Player"]["Run"].block, Animations["Player"]["Run"].anim, -1, true, true, true, false, 250)
		self.state = "run"
	end
end


function Player_S:jobStartSit()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation(Animations["Player"]["SitDown"].block, Animations["Player"]["SitDown"].anim, -1, false, false, true, true, 250)
		self.state = "sit"
		self.targetX = nil
		self.targetY = nil
		self.targetZ = nil
	end
end


function Player_S:jobStopSit()
	if (self.player) and (isElement(self.player)) then
		self.player:setAnimation(Animations["Player"]["StandUp"].block, Animations["Player"]["StandUp"].anim, -1, false, false, true, false, 250)
		self.state = "idle"
	end
end


function Player_S:getPlayer()
	return self.player
end


function Player_S:changeLife(value)
	if (value) then
		self.currentLife = self.currentLife + value
		
		if (self.currentLife > self.maxLife) then
			self.currentLife = self.maxLife
		end
		
		if (self.currentLife < 0) then
			self.currentLife = 0
		end
	end
end


function Player_S:setLife(value)
	if (value) then
		self.currentLife = value
		
		if (self.currentLife > self.maxLife) then
			self.currentLife = self.maxLife
		end
		
		if (self.currentLife < 0) then
			self.currentLife = 0
		end
	end
end


function Player_S:getLife()
	return self.currentLife
end


function Player_S:changeMana(value)
	if (value) then
		self.currentMana = self.currentMana + value
		
		if (self.currentMana > self.maxMana) then
			self.currentMana = self.maxMana
		end
		
		if (self.currentMana < 0) then
			self.currentMana = 0
		end
	end
end


function Player_S:levelUp()
	self.level = self.level + 1
	self.currentXP = math.abs(self.currentXP - self.maxXP)

	NotificationManager_S:sendPlayerNotification(self.player, "#AAAAEE Level up! New level is #44EE44" .. self.level .. "#AAAAEE !")
end


function Player_S:setMana(value)
	if (value) then
		self.currentMana =  value
		
		if (self.currentMana > self.maxMana) then
			self.currentMana = self.maxMana
		end
		
		if (self.currentMana < 0) then
			self.currentMana = 0
		end
	end
end


function Player_S:getMana()
	return self.currentMana
end


function Player_S:changeXP(value)
	if (value) then
		self.currentXP = self.currentXP + value
		
		if (math.floor(self.currentXP + 0.5) >= self.maxXP) then
			self:levelUp()
		end
		
		if (self.currentXP < 0) then
			self.currentXP = 0
		end
	end
end


function Player_S:setXP(value)
	if (value) then
		self.currentXP =  value
		
		if (self.currentXP > self.maxXP) then
			self.currentXP = self.maxXP
		end
		
		if (self.currentXP < 0) then
			self.currentXP = 0
		end
	end
end


function Player_S:getXP()
	return self.currentXP
end


function Player_S:changeMoney(value)
	if (value) then
		self.money = self.money + value
	end
end


function Player_S:setMoney(value)
	if (value) then
		self.money = value
	end
end


function Player_S:getMoney()
	return self.money
end


function Player_S:setCritChance(value)
	if (value) then
		self.currentCritChance =  value
		
		if (self.currentCritChance > 100) then
			self.currentCritChance = 100
		end
		
		if (self.currentCritChance < 0) then
			self.currentCritChance = 0
		end
	end
end


function Player_S:getLevelModifier()
	return self.levelModifier
end


function Player_S:getLevel()
	return self.level
end


function Player_S:getCritChance()
	return self.currentCritChance
end


function Player_S:getInventory()
	return self.inventory
end


function Player_S:clear()
	AttackManager_S:getSingleton():deletePlayerAttacks(self.player)
	
	removeEventHandler("SETPLAYERTARGET", root, self.m_SetTargetPosition)
	removeEventHandler("CONNECTPLAYER", root, self.m_ConnectPlayer)
	removeEventHandler("PLAYERSITDOWN", root, self.m_TogglePlayerSit)
	removeEventHandler("UPDATEPLAYERCLOTHES", root, self.m_UpdatePlayerClothesAndEquipment)
	
	if (self.inventory) then
		self.inventory:delete()
		self.inventory = nil
	end
	
	self:jobIdle()
end


function Player_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.player:getName() .. " was deleted.")
	end
end