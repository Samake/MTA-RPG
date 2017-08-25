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
	if (not self.quickSlots) then
		self.quickSlots = GUIQuickSlots_C:new()
	end
end


function GUIManager_C:update(deltaTime)
	if (self.showGUI == true) then
		if (self.quickSlots) then
			self.quickSlots:update()
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
	if (self.quickSlots) then
		self.quickSlots:delete()
		self.quickSlots = nil
	end
end


function GUIManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was deleted.")
	end
end