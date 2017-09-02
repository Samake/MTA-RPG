LightManager_S = inherit(Singleton)

function LightManager_S:constructor()
	
	self.lightClasses = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_S was loaded.")
	end
end


function LightManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBECLIENT", true)
	addEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)
	
	self.m_AddLight = bind(self.addLight, self)
	addEvent("ADDLIGHT", true)
	addEventHandler("ADDLIGHT", root, self.m_AddLight)
end


function LightManager_S:subscribeClient()
	if (client) then
		for index, lightClass in pairs(self.lightClasses) do
			if (lightClass) then
				local lightProperties = {}
				lightProperties.id = lightClass.id
				lightProperties.radius = lightClass.radius
				lightProperties.color = lightClass.color
				lightProperties.isFlickering = lightClass.isFlickering
				lightProperties.isPulsating = lightClass.isPulsating
	
				triggerClientEvent(client, "ADDLIGHTCLIENT", client, lightProperties)
			end
		end
	end
end


function LightManager_S:addLight(lightProperties)
	if (lightProperties) then
		lightProperties.id = self:getFreeID()
		lightProperties.radius = 15
		lightProperties.color = {r = math.random(90, 220), g = math.random(90, 220), b = math.random(90, 220)}
		
		-- for test only
		local randomVar = math.random(1, 10)
		
		if (randomVar > 8) then
			lightProperties.isFlickering = true
		else
			lightProperties.isFlickering = false
			
			if (randomVar < 2) then
				lightProperties.isPulsating = true
			else
				lightProperties.isPulsating = false
			end
		end
		
		if (not self.lightClasses[lightProperties.id]) then
			self.lightClasses[lightProperties.id] = Light_S:new(lightProperties)
			
			for index, client in pairs(TriggerManager_S:getSingleton():getClients()) do
				if (client) then
					triggerClientEvent(client, "ADDLIGHTCLIENT", client, lightProperties)
				end
			end
		end
	end
end


function LightManager_S:deleteLight(id)
	if (id) then
		if (self.lightClasses[id]) then
			self.lightClasses[id]:delete()
			self.lightClasses[id] = nil
		end
		
		for index, client in pairs(TriggerManager_S:getSingleton():getClients()) do
			if (client) then
				triggerClientEvent(client, "DELETELIGHTCLIENT", client, id)
			end
		end
	end 
end


function LightManager_S:update()
	for index, lightClass in pairs(self.lightClasses) do
		if (lightClass) then
			lightClass:update()
		end
	end
end


function LightManager_S:getFreeID()
	for index, lightClass in pairs(self.lightClasses) do
		if (not lightClass) then
			return index
		end
	end
	
	return #self.lightClasses + 1
end


function LightManager_S:clear()
	removeEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)
	removeEventHandler("ADDLIGHT", root, self.m_AddLight)

	for index, lightClass in pairs(self.lightClasses) do
		if (lightClass) then
			lightClass:delete()
			lightClass = nil
		end
	end
end


function LightManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_S was deleted.")
	end
end