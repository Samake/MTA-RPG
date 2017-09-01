LightManager_C = inherit(Singleton)

function LightManager_C:constructor()
	
	self.lightClasses = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_C was loaded.")
	end
end


function LightManager_C:init()
	self.m_AddLight = bind(self.addLight, self)
	addEvent("ADDLIGHTCLIENT", true)
	addEventHandler("ADDLIGHTCLIENT", root, self.m_AddLight)
	
	self.m_DeleteLight = bind(self.deleteLight, self)
	addEvent("DELETELIGHTCLIENT", true)
	addEventHandler("DELETELIGHTCLIENT", root, self.m_DeleteLight)
end


function LightManager_C:addLight(lightProperties)
	if (lightProperties) then
		if (not self.lightClasses[lightProperties.id]) then
			self.lightClasses[lightProperties.id] = Light_C:new(lightProperties)
		end
	end
end


function LightManager_C:deleteLight(id)
	if (id) then
		if (self.lightClasses[id]) then
			self.lightClasses[id]:delete()
			self.lightClasses[id] = nil
		end
	end 
end


function LightManager_C:update()
	for index, lightClass in pairs(self.lightClasses) do
		if (lightClass) then
			lightClass:update()
		end
	end
end


function LightManager_C:clear()
	removeEventHandler("ADDLIGHTCLIENT", root, self.m_AddLight)
	removeEventHandler("DELETELIGHTCLIENT", root, self.m_DeleteLight)

	for index, lightClass in pairs(self.lightClasses) do
		if (lightClass) then
			lightClass:delete()
			lightClass = nil
		end
	end
end


function LightManager_C:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_C was deleted.")
	end
end