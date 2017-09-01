Debug_C = inherit(Singleton)

function Debug_C:constructor()
	
	self.player = getLocalPlayer()
	self.playerPos = nil
	self.playerRot = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Debug_C was loaded.")
	end
end


function Debug_C:init()
	self.m_SpawnTestNPC = bind(self.spawnTestNPC, self)
	bindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
	
	self.m_SpawnTestLight = bind(self.spawnTestLight, self)
	bindKey(Bindings["SPAWNTESTLIGHT"], "down", self.m_SpawnTestLight)
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #44EE44 enabled #EEEEEE!")
end


function Debug_C:spawnTestNPC()
	if (self.player) and (isElement(self.player)) then
		if (self.playerPos) and (self.playerRot) then
			local x, y, z = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.x, self.playerRot.y, self.playerRot.z, 15, 0, 0.3)
			
			triggerServerEvent("ADDTESTNPC", root, x, y, z)
		end
	end
end


function Debug_C:spawnTestLight()
	if (self.player) and (isElement(self.player)) then
		if (self.playerPos) and (self.playerRot) then
		
		end
	end
end


function Debug_C:update(deltaTime)
	if (self.player) and (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
	end
end


function Debug_C:clear()
	unbindKey(Bindings["SPAWNTESTNPC"], "down", self.m_SpawnTestNPC)
	unbindKey(Bindings["SPAWNTESTLIGHT"], "down", self.m_SpawnTestLight)
	
	NotificationManager_C:getSingleton():addNotification("#EEEEEE Debug mode #EE4444 disabled #EEEEEE!")
end


function Debug_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("Debug_C was deleted.")
	end
end