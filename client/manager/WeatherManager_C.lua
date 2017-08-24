WeatherManager_C = inherit(Singleton)

function WeatherManager_C:constructor()

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_C was loaded.")
	end
end


function WeatherManager_C:init()
	RainManager_C:new()
	
	triggerServerEvent("SUBSCRIBEWEATHER", root)
end


function WeatherManager_C:update(deltaTime)
	RainManager_C:getSingleton():update(self.delta)
end


function WeatherManager_C:clear()
	delete(RainManager_C:getSingleton())
end


function WeatherManager_C:destructor()
	self:clear()
	
	triggerServerEvent("UNSUBSCRIBEWEATHER", root)
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("WeatherManager_C was deleted.")
	end
end