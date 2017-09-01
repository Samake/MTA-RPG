LightManager_S = inherit(Singleton)

function LightManager_S:constructor()
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_S was loaded.")
	end
end


function LightManager_S:init()
	self.m_SubscribeClient = bind(self.subscribeClient, self)
	addEvent("SUBSCRIBECLIENT", true)
	addEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)
	
end


function LightManager_S:subscribeClient()
	if (client) then

	end
end


function LightManager_S:update()

end


function LightManager_S:clear()
	removeEventHandler("SUBSCRIBECLIENT", root, self.m_SubscribeClient)

end


function LightManager_S:destructor()
	self:clear()

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("LightManager_S was deleted.")
	end
end