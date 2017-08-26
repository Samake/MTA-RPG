NPCManager_S = inherit(Singleton)

function NPCManager_S:constructor()

	self.npcClasses = {}
	self.npcSkins = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NPCManager_S was loaded.")
	end
end


function NPCManager_S:init()
	self.m_RequestNPCSkins = bind(self.requestNPCSkins, self)
	addEvent("REQUESTNPCSKINS", true)
	addEventHandler("REQUESTNPCSKINS", root, self.m_RequestNPCSkins)
	
	
	self.m_AddNPC = bind(self.addNPC, self)
	addEvent("ADDTESTNPC", true)
	addEventHandler("ADDTESTNPC", root, self.m_AddNPC)
end


function NPCManager_S:update()
	for index, npcClass in pairs(self.npcClasses) do
		if (npcClass) then
			npcClass:update()
		end
	end
end


function NPCManager_S:addNPC(x, y, z)
	if (x) and (y) and (z) then
		local npcSettings = {}
		npcSettings.id = "NPC_" .. self:getFreeID()
		npcSettings.x = x
		npcSettings.y = y
		npcSettings.z = z
		npcSettings.rx = 0
		npcSettings.ry = 0
		npcSettings.rz = math.random(0, 360)

		if (not self.npcClasses[self:getFreeID()]) then
			self.npcClasses[self:getFreeID()] = NPC_S:new(npcSettings)
		end
	end
end


function NPCManager_S:deleteNPC(player)
	if (isElement(player)) then
	
	end
end


function NPCManager_S:getFreeID()
	for index, npcClass in pairs(self.npcClasses) do
		if (not npcClass) then
			return index
		end
	end
	
	return #self.npcClasses + 1
end


function NPCManager_S:requestNPCSkins()
	if (isElement(client)) then
		self.npcSkins = {}
		
		for index, npcClass in pairs(self.npcClasses) do
			if (npcClass) then
				if (not self.npcSkins[tostring(npcClass.id)]) then
					self.npcSkins[tostring(npcClass.id)] = {}
					self.npcSkins[tostring(npcClass.id)].model = npcClass.model
					self.npcSkins[tostring(npcClass.id)].head = npcClass.headID
					self.npcSkins[tostring(npcClass.id)].torso = npcClass.torsoID
					self.npcSkins[tostring(npcClass.id)].leg = npcClass.legID
					self.npcSkins[tostring(npcClass.id)].feet = npcClass.feetID
				end
			end
		end
		
		triggerClientEvent("SENDNPCSKINS", root, self.npcSkins)
	end
end


function NPCManager_S:clear()
	removeEventHandler("REQUESTNPCSKINS", root, self.m_RequestNPCSkins)
	removeEventHandler("ADDTESTNPC", root, self.m_AddNPC)
	
	for index, npcClass in pairs(self.npcClasses) do
		if (npcClass) then
			npcClass:delete()
			npcClass = nil
		end
	end
end


function NPCManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("NPCManager_S was deleted.")
	end
end