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
		npcSettings.skinID = 0
		npcSettings.x = x
		npcSettings.y = y
		npcSettings.z = z
		npcSettings.rx = 0
		npcSettings.ry = 0
		npcSettings.rz = math.random(0, 360)
		npcSettings.model = createPed(npcSettings.skinID, npcSettings.x, npcSettings.y, npcSettings.z, npcSettings.rz, true)
		npcSettings.level = math.random(1, 3)
		npcSettings.life = 1000
		npcSettings.name = "Enemy"
		
		if (npcSettings.model) then
			npcSettings.id = tostring(npcSettings.model)
			
			if (not self.npcClasses[npcSettings.id]) then
				self.npcClasses[npcSettings.id] = NPCEnemy_S:new(npcSettings)
			end
		end
	end
end


function NPCManager_S:deleteNPC(id)
	if (id) then
		if (self.npcClasses[id]) then
			self.npcClasses[id]:delete()
			self.npcClasses[id] = nil
		end
	end
end


function NPCManager_S:requestNPCSkins()
	if (isElement(client)) then
		self.npcSkins = {}
		
		for index, npcClass in pairs(self.npcClasses) do
			if (npcClass) then
				if (not self.npcSkins[npcClass.id]) then
					self.npcSkins[npcClass.id] = {}
					self.npcSkins[npcClass.id].model = npcClass.model
					self.npcSkins[npcClass.id].head = npcClass.headID
					self.npcSkins[npcClass.id].torso = npcClass.torsoID
					self.npcSkins[npcClass.id].leg = npcClass.legID
					self.npcSkins[npcClass.id].feet = npcClass.feetID
				end
			end
		end
		
		triggerClientEvent("SENDNPCSKINS", root, self.npcSkins)
	end
end


function NPCManager_S:getNPCClass(npc)
	if (npc) and (isElement(npc)) then
		if (self.npcClasses) then
			if (self.npcClasses[tostring(npc)]) then
				return self.npcClasses[tostring(npc)]
			end
		end
	end
	
	return nil
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