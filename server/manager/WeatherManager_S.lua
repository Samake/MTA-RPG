WeatherManager_S = inherit(Singleton)

function WeatherManager_S:constructor()
	self.clientList = {}
	
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