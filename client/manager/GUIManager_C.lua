GUIManager_C = inherit(Singleton)

function GUIManager_C:constructor()

	self.showGUI = true
	self.isCursorOnAnyGUI = false

	self:init()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was loaded.")
	end
end


function GUIManager_C:init()
	if (not self.guiWorld) then
		self.guiWorld = GUIWorld_C:new()
	end
	
	if (not self.guiIngame) then
		self.guiIngame = GUIIngame_C:new()
	end
end


function GUIManager_C:update(deltaTime)
	if (self.showGUI == true) then
	
		self.isCursorOnAnyGUI = false
		
		if (self.guiWorld) then
			self.guiWorld:update()
		end
		
		if (self.guiIngame) then
			self.guiIngame:update()
		end
	end
end


function GUIManager_C:showGUI(bool)
	self.showGUI = bool
end


function GUIManager_C:isGUIShown()
	return self.showGUI
end


function GUIManager_C:setCursorOnGUIElement(bool)
	self.isCursorOnAnyGUI = bool
end


function GUIManager_C:isCursorOnGUIElement()
	return self.isCursorOnAnyGUI
end


function GUIManager_C:clear()
	if (self.guiIngame) then
		self.guiIngame:delete()
		self.guiIngame = nil
	end
	
	if (self.guiWorld) then
		self.guiWorld:delete()
		self.guiWorld = nil
	end
end


function GUIManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was deleted.")
	end
end