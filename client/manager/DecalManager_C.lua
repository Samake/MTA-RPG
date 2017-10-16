DecalManager_C = inherit(Singleton)

function DecalManager_C:constructor()
	
	self.player = getLocalPlayer()
	self.playerPos = nil
	
	self.decalClasses = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DecalManager_C was loaded.")
	end
end


function DecalManager_C:init()
	self.m_AddDecal = bind(self.addDecal, self)
	addEvent("ADDDECALCLIENT", true)
	addEventHandler("ADDDECALCLIENT", root, self.m_AddDecal)
end


function DecalManager_C:addDecal(decalProperties)
	if (decalProperties) then
		decalProperties.id = self:getFreeID()

		if (not self.decalClasses[decalProperties.id]) then
			self.decalClasses[decalProperties.id] = Decal_C:new(decalProperties)
		end
	end
end


function DecalManager_C:deleteDecal(id)
	if (id) then
		if (self.decalClasses[id]) then
			self.decalClasses[id]:delete()
			self.decalClasses[id] = nil
		end
	end 
end


function DecalManager_C:update()
	if (self.player) and (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
	end
	
	for index, decalClass in pairs(self.decalClasses) do
		if (decalClass) then
			decalClass:update()
		end
	end
end


function DecalManager_C:getFreeID()
	for index, decalClass in pairs(self.decalClasses) do
		if (not decalClass) then
			return index
		end
	end
	
	return #self.decalClasses + 1
end


function DecalManager_C:clear()
	removeEventHandler("ADDDECALCLIENT", root, self.m_AddDecal)

	for index, decalClass in pairs(self.decalClasses) do
		if (decalClass) then
			decalClass:delete()
			decalClass = nil
		end
	end
end


function DecalManager_C:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("DecalManager_C was deleted.")
	end
end