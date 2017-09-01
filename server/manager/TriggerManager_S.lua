TriggerManager_S = inherit(Singleton)

function TriggerManager_S:constructor()
	
	self.clientList = {}
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("TriggerManager_S was loaded.")
	end
end


function TriggerManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBECLIENT", true)
	addEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)
	
	self.m_UnsubscribeClient = bind(self.unsubscribeClient, self)
	addEvent("UNSUBSCRIBECLIENT", true)
	addEventHandler("UNSUBSCRIBECLIENT", root, self.m_UnsubscribeClient)
end


function TriggerManager_S:subscribeClient()
	if (client) then
		if (not self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = client
		end
	end
end


function TriggerManager_S:unsubscribeClient()
	if (client) then
		if (self.clientList[tostring(client)]) then
			self.clientList[tostring(client)] = nil
		end
	end
end


function TriggerManager_S:getClients()
	return self.clientList
end


function TriggerManager_S:clear()
	removeEventHandler("SUBSCRIBESOUND", root, self.m_SubscribeClient)
	removeEventHandler("UNSUBSCRIBESOUND", root, self.m_UnsubscribeClient)
end


function TriggerManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("TriggerManager_S was deleted.")
	end
end