NPC_S = inherit(Class)

function NPC_S:constructor(npcSettings)
	
	self.id = npcSettings.id
	self.model = nil
	self.x = npcSettings.x
	self.y = npcSettings.y
	self.z = npcSettings.z
	self.rx = npcSettings.rx
	self.ry = npcSettings.ry
	self.rz = npcSettings.rz
	
	self.skinID = 0
	self.dimension = 0
	
	self.targetX = nil
	self.targetY = nil
	self.targetZ = nil
	
	self.minDistance = 0
	self.distance = 0
	self.tolerance = 3.0
	
	self.headID = 1
	self.torsoID = 1
	self.legID = 2
	self.feetID = 1
	
	self.state = "idle"
	
	self.actionRadius = 10
	self.enemy = nil
	
	self.isAlive = true
	
	self.deadCount = 0
	self.currentCount = 0

	self:init()
	self:triggerShaderSettings()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("NPC_S " .. self.id .. " was loaded.")
	end
end


function NPC_S:init()
	if (not self.model) then
		self.model = createPed (self.skinID, self.x, self.y, self.z, self.rz, true)
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
		end
	end
end


function NPC_S:triggerShaderSettings()
	self.npcSkins = {}
	self.npcSkins[tostring(self.id)] = {}
	self.npcSkins[tostring(self.id)].model = self.model
	self.npcSkins[tostring(self.id)].head = self.headID
	self.npcSkins[tostring(self.id)].torso = self.torsoID
	self.npcSkins[tostring(self.id)].leg = self.legID
	self.npcSkins[tostring(self.id)].feet = self.feetID

	triggerClientEvent("SENDNPCSKINS", root, self.npcSkins)
end


function NPC_S:update()
	if (self.model) and (isElement(self.model)) then
		if (self.isAlive == true) then
			self:updateCoords()
			self:updatePosition()
			
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
		else
			self.currentCount = getTickCount()

			if (self.currentCount > self.deadCount + Settings.deadBodyRemoveTime) then
				NPCManager_S:getSingleton():deleteNPC(self.id)
			end
		end
	end
end


function NPC_S:updateCoords()
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


function NPC_S:updatePosition()
	if (self.targetX) and (self.targetY) and (self.targetZ) then
		if (self.distance <= self.tolerance) then
			self:jobIdle()
		else
			self:jobRunToEnemy()
		end
	end
end


function NPC_S:updateEnemyValues()
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


function NPC_S:correctPosition()
	if (self.model) and (isElement(self.model)) then
		if (self.distance <= self.minDistance) then
			self.minDistance = self.distance
		else
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.model:setRotation(self.rx, self.ry, rotZ, "default", true)
		end
	end
end


function NPC_S:setTargetPosition()
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


function NPC_S:jobIdle()
	if (self.model) and (isElement(self.model)) then
		self.model:setAnimation()
		self.state = "idle"
	end
end


function NPC_S:jobRunToEnemy()
	if (self.model) and (isElement(self.model)) then
		self.model:setAnimation("ped", "run_player")
		self.state = "runToEnemy"
	end
end


function NPC_S:onColShapeHit(element, dimension)
	if (isElement(element)) and (not self.enemy) then
		if (element:getType() == "player") then
			self.enemy = element
			self:setTargetPosition()
		end
	end
end	


function NPC_S:onColShapeLeave(element, dimension)
	if (isElement(element)) and (self.enemy) then
		if (element:getType() == "player") then
			if (self.enemy == element) then
				self.enemy = nil
			end
		end
	end
end


function NPC_S:onPedWasted()
	if (self.isAlive == true) then
		self.isAlive = false
		self.deadCount = getTickCount()
	end
end


function NPC_S:clear()
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


function NPC_S:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		sendMessage("NPC_S " .. self.id .. " was deleted.")
	end
end