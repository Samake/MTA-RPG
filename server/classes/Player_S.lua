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
	self.torsoID = 1
	self.legID = 1
	self.feetID = 1
	
	self.maxLife = 1000
	self.currentLife = 1000
	self.maxMana = 100
	self.currentMana = 100
	
	self.lifeRegeneration = 0
	self.manaRegeneration = 0
	
	self.rank = "Beginner"
	self.class = "Fighter"
	self.level = 1
	self.currentXP = 0
	self.maxXP = 1000
	
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
end


function Player_S:update()
	if (self.player) and (isElement(self.player)) then
		self.currentTick = getTickCount()
		
		self:updateCoords()
		self:updatePosition()
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
	self.maxLife = 1000 * self.levelCaps.modifier
	self.maxMana = 100 * self.levelCaps.modifier
	
	
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
				Text3DManager_S:sendText(self.player, "+" .. lifeValue .. " Life" , self.x, self.y, self.z + 0.5, 220, 90, 90, 0.4)
			end
		end
		
		if (self.currentMana < self.maxMana) then
			self:changeMana(manaValue)
			
			if (self.isSitting == true) then
				Text3DManager_S:sendText(self.player, "+" .. manaValue .. " Mana" , self.x, self.y, self.z + 0.5, 90, 90, 220, 0.4)
			end
		end
		
		self.healTick = getTickCount()
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
	
	Text3DManager_S:sendText(self.player, "Level up!", self.x, self.y, self.z + 1.0, 220, 120, 180, 3)
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
		self.critChance =  value
		
		if (self.critChance > 100) then
			self.critChance = 100
		end
		
		if (self.critChance < 0) then
			self.critChance = 0
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
	return self.critChance
end


function Player_S:getInventory()
	return self.inventory
end


function Player_S:clear()
	AttackManager_S:getSingleton():deletePlayerAttacks(self.player)
	
	removeEventHandler("SETPLAYERTARGET", root, self.m_SetTargetPosition)
	removeEventHandler("CONNECTPLAYER", root, self.m_ConnectPlayer)
	removeEventHandler("PLAYERSITDOWN", root, self.m_TogglePlayerSit)
	
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