WeatherManager_C = inherit(Singleton)

function WeatherManager_C:constructor()

	self.weatherTable = {}
	
	self.rainLevel = 0
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_C was loaded.")
	end
end


function WeatherManager_C:init()
	self.m_ReceiveWeatherData = bind(self.receiveWeatherData, self)
	addEvent("CLIENTWEATHERDATA", true)
	addEventHandler("CLIENTWEATHERDATA", root, self.m_ReceiveWeatherData)

	RainManager_C:new()
end


function WeatherManager_C:update(deltaTime)
	RainManager_C:getSingleton():update(self.delta)
end


function WeatherManager_C:receiveWeatherData(weatherTable)
	if (weatherTable) then
		self.weatherTable = weatherTable
		
		if (self.weatherTable.rainLevel) then
			self.rainLevel = self.weatherTable.rainLevel
		end
	end
end


function WeatherManager_C:getWeatherTable()
	return self.weatherTable
end


function WeatherManager_C:getRainLevel()
	return self.rainLevel
end


function WeatherManager_C:clear()
	removeEventHandler("CLIENTWEATHERDATA", root, self.m_ReceiveWeatherData)
	
	delete(RainManager_C:getSingleton())
end


function WeatherManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_C was deleted.")
	end
end