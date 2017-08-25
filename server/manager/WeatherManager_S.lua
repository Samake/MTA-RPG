WeatherManager_S = inherit(Singleton)

function WeatherManager_S:constructor()
	self.clientList = {}
	
	self.hour = 0
	self.minute = 0
	self.nextHour = 0
	self.valueModifier = 0
	
	self.weatherTable = {}
	
	self.rainLevel = 0
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_S was loaded.")
	end
end


function WeatherManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBEWEATHER", true)
	addEventHandler("SUBSCRIBEWEATHER", root, self.m_SubscribeClient)
	
	self.m_UnsubscribeClient = bind(self.unsubscribeClient, self)
	addEvent("UNSUBSCRIBEWEATHER", true)
	addEventHandler("UNSUBSCRIBEWEATHER", root, self.m_UnsubscribeClient)
end


function WeatherManager_S:subscribeClient()
	if (client) then
		if (not self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = client
		end
	end
end


function WeatherManager_S:unsubscribeClient()
	if (client) then
		if (self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = nil
		end
	end
end


function WeatherManager_S:update(deltaTime)
	self.hour, self.minute = getTime()
	
	self.nextHour = self.hour + 1
			
	if (self.nextHour > 23) then
		self.nextHour = 0
	end
	
	self.valueModifier = (1 / 60) * (self.minute + 1)
	
	self.currentWeather = WeatherTable[self.hour]
	self.nextWeather = WeatherTable[self.nextHour]
	
	if (self.currentWeather) and (self.nextWeather) then
		self:calculateRainLevel()
	end
	
	self:sendToSubscribers()
end


function WeatherManager_S:calculateRainLevel()
	local rl1 = self.currentWeather.rainLevel
	local rl2 = self.nextWeather.rainLevel
	
	local rainLevelVar = math.abs(rl1 - rl2) * self.valueModifier
	
	if (rl1 < rl2) then 
		self.rainLevel = rl1 + rainLevelVar
	else 
		self.rainLevel = rl1 - rainLevelVar
	end
end


function WeatherManager_S:sendToSubscribers()
	self.weatherTable.rainLevel = self.rainLevel
	
	for index, client in pairs(self.clientList) do
		if (client) then
			triggerClientEvent(client, "CLIENTWEATHERDATA", client, self.weatherTable)
		end
	end

end


function WeatherManager_S:clear()
	removeEventHandler("SUBSCRIBEWEATHER", root, self.m_SubscribeClient)
	removeEventHandler("UNSUBSCRIBEWEATHER", root, self.m_UnsubscribeClient)
end


function WeatherManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_S was deleted.")
	end
end