NPCEnemy_S = inherit(NPC_S)

function NPCEnemy_S:constructor(npcSettings)
	
	self.id = npcSettings.id
	self.model = nil
	self.x = npcSettings.x
	self.y = npcSettings.y
	self.z = npcSettings.z
	self.rx = npcSettings.rx
	self.ry = npcSettings.ry
	self.rz = npcSettings.rz
	self.model = npcSettings.model
	
	self.level = npcSettings.level
	self.maxLife = npcSettings.life
	self.currentLife = npcSettings.life
	
	self.name = npcSettings.name
	
	self.skinID = npcSettings.skinID
	self.dimension = 0
	
	self.targetX = nil
	self.targetY = nil
	self.targetZ = nil
	
	self.minDistance = 0
	self.distance = 0
	self.tolerance = 3.0
	
	self.headID = 2
	self.torsoID = 2
	self.legID = 2
	self.feetID = 1
	
	self.state = "idle"
	
	self.actionRadius = 10
	self.enemy = nil
	
	self.isAlive = true
	
	self.deadCount = 0
	self.currentCount = 0
	
	self.attackerClass = nil
	self.attacker = nil
	
	self.xpReward = 100
	self.moneyReward = 1
	
	self.isPedEnemy = true

	self:init()
	self:triggerShaderSettings()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("NPCEnemy_S " .. self.id .. " was loaded.")
	end
end


function NPCEnemy_S:init()
	self.actionCol = createColSphere (self.x, self.y, self.z, self.actionRadius)
	
	if (self.model) and (self.actionCol) then
		self.m_OnColShapeHit = bind(self.onColShapeHit, self)
		self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
		
		addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		
		self.model:setDimension(self.dimension)
		self.actionCol:setDimension(self.dimension)
		
		self.actionCol:attach(self.model)
		
		self.m_OnPedWasted = bind(self.onPedWasted, self)
		addEvent("onPedWasted", true)
		addEventHandler("onPedWasted", self.model, self.m_OnPedWasted)
		
		self.xpReward = self.xpReward * self.level
		self.maxLife = self.maxLife * self.level 
		self.currentLife = self.maxLife
	end
end


function NPCEnemy_S:triggerShaderSettings()
	self.npcSkins = {}
	self.npcSkins[tostring(self.id)] = {}
	self.npcSkins[tostring(self.id)].model = self.model
	self.npcSkins[tostring(self.id)].head = self.headID
	self.npcSkins[tostring(self.id)].torso = self.torsoID
	self.npcSkins[tostring(self.id)].leg = self.legID
	self.npcSkins[tostring(self.id)].feet = self.feetID

	triggerClientEvent("SENDNPCSKINS", root, self.npcSkins)
end


function NPCEnemy_S:update()
	if (self.model) and (isElement(self.model)) then
		if (self.isAlive == true) then
			self:updateCoords()
			self:updatePosition()
			self:updateElemenData()
			
			if (self.targetX) and (self.targetY) and (self.targetZ) then
				self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			end
			
			if (self.state == "runToEnemy") then
				self:correctPosition()
			elseif (self.state == "idle") then
				if (self.enemy) then
					self:updateEnemyValues()
				end
			end
			
			if (self.currentLife <= 0) then
				self.model:kill()
			end
		else
			self.currentCount = getTickCount()

			if (self.currentCount > self.deadCount + Settings.deadBodyRemoveTime) then
				NPCManager_S:getSingleton():deleteNPC(self.id)
			end
		end
	end
end


function NPCEnemy_S:updateCoords()
	self.modelPos = self.model:getPosition()
	
	if (self.modelPos) then
		self.x = self.modelPos.x
		self.y = self.modelPos.y
		self.z = self.modelPos.z
	end
	
	self.modelRot = self.model:getRotation()
	
	if (self.modelRot) then
		self.rx = self.modelRot.x
		self.ry = self.modelRot.y
		self.rz = self.modelRot.z
	end
end


function NPCEnemy_S:updateElemenData()
	self.model:setData("NPC:LEVEL", self.level, true)
	self.model:setData("NPC:NAME", self.name, true)
	
	local lifeValue = (1 / self.maxLife) * self.currentLife
	self.model:setData("NPC:LIFEVALUE", lifeValue, true)
end


function NPCEnemy_S:updatePosition()
	if (self.targetX) and (self.targetY) and (self.targetZ) then
		if (self.distance <= self.tolerance) then
			self:jobIdle()
		else
			self:jobRunToEnemy()
		end
	end
end


function NPCEnemy_S:updateEnemyValues()
	if (self.enemy) and (isElement(self.enemy)) then
		local enemyPos = self.enemy:getPosition()
		
		if (enemyPos) then
			self.targetX = enemyPos.x
			self.targetY = enemyPos.y
			self.targetZ = enemyPos.z
		end
		
		local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
		self.model:setRotation(self.rx, self.ry, rotZ, "default", true)
	end
end


function NPCEnemy_S:correctPosition()
	if (self.model) and (isElement(self.model)) then
		if (self.distance <= self.minDistance) then
			self.minDistance = self.distance
		else
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.model:setRotation(self.rx, self.ry, rotZ, "default", true)
		end
	end
end


function NPCEnemy_S:setTargetPosition()
	if (self.enemy) and (isElement(self.enemy)) then
	
		local enemyPos = self.enemy:getPosition()
		
		if (enemyPos) then
			self.targetX = enemyPos.x
			self.targetY = enemyPos.y
			self.targetZ = enemyPos.z
			
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.model:setRotation(self.rx, self.ry, rotZ, "default", true)
			
			self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			self.minDistance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			
			self:jobRunToEnemy()
		end
	end
end


function NPCEnemy_S:jobIdle()
	if (self.state ~= "idle") then
		if (self.model) and (isElement(self.model)) then
			self.model:setAnimation()
			self.state = "idle"
		end
	end
end


function NPCEnemy_S:jobRunToEnemy()
	if (self.state ~= "runToEnemy") then
		if (self.model) and (isElement(self.model)) then
			self.model:setAnimation(Animations["NPC"]["Run"].block, Animations["NPC"]["Run"].anim, -1, true, true, true, false, 250)
			self.state = "runToEnemy"
		end
	end
end


function NPCEnemy_S:onColShapeHit(element, dimension)
	if (isElement(element)) and (not self.enemy) then
		if (element:getType() == "player") then
			self.enemy = element
			self:setTargetPosition()
		end
	end
end	


function NPCEnemy_S:onColShapeLeave(element, dimension)
	if (isElement(element)) and (self.enemy) then
		if (element:getType() == "player") then
			if (self.enemy == element) then
				self.enemy = nil
			end
		end
	end
end


function NPCEnemy_S:onPedWasted()
	if (self.isAlive == true) then
		self.isAlive = false
		self.deadCount = getTickCount()
		
		if (self.attackerClass) then
			RewardManager_S:giveXPReward(self.attackerClass, self.xpReward, self.x, self.y, self.z)
			RewardManager_S:giveLootReward(self.attackerClass, self.moneyReward, self.level, self.x, self.y, self.z)
		end
	end
end


function NPCEnemy_S:changeLife(value)
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


function NPCEnemy_S:setLife(value)
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


function NPCEnemy_S:getLife()
	return self.currentLife
end


function NPCEnemy_S:setAttacker(class)
	if (class) then
		self.attackerClass = class
		
		if (self.attackerClass) then
			self.attacker = self.attackerClass.player
		end
	end
end


function NPCEnemy_S:getAttacker()
	return self.attacker
end


function NPCEnemy_S:isPedAlive()
	return self.isAlive
end


function NPCEnemy_S:isEnemy()
	return self.isPedEnemy
end


function NPCEnemy_S:clear()
	self:jobIdle()
	
	if (self.actionCol) then
		removeEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		removeEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
			
		self.actionCol:destroy()
		self.actionCol = nil
	end
	
	if (self.model) then
		removeEventHandler("onPedWasted", self.model, self.m_OnPedWasted)
		self.model:destroy()
		self.model = nil
	end	
end


function NPCEnemy_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("NPCEnemy_S " .. self.id .. " was deleted.")
	end
end