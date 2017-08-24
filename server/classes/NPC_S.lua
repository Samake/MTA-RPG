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
	self.tolerance = 1.0
	
	self.headID = 1
	self.torsoID = 1
	self.legID = 2
	self.feetID = 1
	
	self.state = "idle"

	self:init()
	self:triggerShaderSettings()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("NPC_S " .. self.id .. " was loaded.")
	end
end


function NPC_S:init()
	if (not self.model) then
		self.model = createPed (self.skinID, self.x, self.y, self.z, self.rz, true)
		
		if (self.model) then
			self.model:setDimension(self.dimension)
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
		self:updateCoords()
		self:updatePosition()
		
		if (self.state == "run") then
			self:correctPosition()
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
		self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
		
		if (self.distance <= self.tolerance) then
			self:jobIdle()
		end
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


function NPC_S:setTargetPosition(x, y, z)
	if (self.model) and (isElement(self.model)) then
			if (self.model == client) and (x) and (y) and (z) then
			self.targetX = x
			self.targetY = y
			self.targetZ = z
			
			local rotZ = findRotation(self.x, self.y, self.targetX, self.targetY)
			self.model:setRotation(self.rx, self.ry, rotZ, "default", true)
			
			self.distance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			self.minDistance = getDistanceBetweenPoints2D(self.x, self.y, self.targetX, self.targetY)
			
			self:jobRun()
		end
	end
end


function NPC_S:jobIdle()
	if (self.model) and (isElement(self.model)) then
		self.model:setAnimation()
		self.targetX = nil
		self.targetY = nil
		self.targetZ = nil
		self.state = "idle"
	end
end


function NPC_S:jobRun()
	if (self.model) and (isElement(self.model)) then
		self.model:setAnimation("ped", "run_player")
		self.state = "run"
	end
end


function NPC_S:clear()
	self:jobIdle()
	
	if (self.model) then
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