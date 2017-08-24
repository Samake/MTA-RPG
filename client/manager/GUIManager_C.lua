GUIManager_C = inherit(Singleton)

function GUIManager_C:constructor()

	self.camera = nil
	
	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was loaded.")
	end
end


function GUIManager_C:init()

end


function GUIManager_C:update(deltaTime)

end


function GUIManager_C:clear()

end


function GUIManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was deleted.")
	end
end