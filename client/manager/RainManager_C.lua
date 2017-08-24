RainManager_C = inherit(Singleton)

function RainManager_C:constructor()

	self.camera = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RainManager_C was loaded.")
	end
end


function RainManager_C:init()

end


function RainManager_C:update(deltaTime)

end


function RainManager_C:clear()

end


function RainManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("RainManager_C was deleted.")
	end
end