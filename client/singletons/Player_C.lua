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
	
	self.equippedSlots = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Player_C was loaded.")
	end
end


function Player_C:init()
	self.m_SpawnTestNPC = bind(self.spawnTestNPC, self)
	bindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
	
	for i = 1, self.maxSlots do
		if (not self.equippedSlots[i]) then
			--self.equippedSlots[i] = Attacks["Default"]["Punch"]
		end
	end
	
	self.equippedSlots[1] = Attacks["Default"]["Punch"]
end


function Player_C:spawnTestNPC()
	if (self.player) and (isElement(self.player)) then
		self:updateCoords()
		
		local x, y, z = getAttachedPosition(self.x, self.y, self.z, self.rx, self.ry, self.rz, 15, 0, 1)
		
		triggerServerEvent("ADDTESTNPC", root, x, y, z)
	end
end


function Player_C:update(deltaTime)
	if (self.player) and (isElement(self.player)) then
		self:updateCoords()
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


function Player_C:getPlayerClass()
	return self
end


function Player_C:getPlayerSlots()
	return self.equippedSlots
end	

function Player_C:clear()
	unbindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
end


function Player_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Player_C was deleted.")
	end
end