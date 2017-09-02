GUIManager_C = inherit(Singleton)

function GUIManager_C:constructor()

	self.isGUIShown = true
	self.isInventoryShown = false
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
	
	if (not self.guiInventory) then
		self.guiInventory = GUIInventory_C:new()
	end
end


function GUIManager_C:update(deltaTime)
	self.isCursorOnAnyGUI = false
	
	if (self.isGUIShown == true) then
		if (self.guiWorld) then
			self.guiWorld:update(deltaTime)
		end
		
		if (self.guiIngame) then
			self.guiIngame:update(deltaTime)
		end
	elseif (self.isInventoryShown == true) then
		if (self.guiInventory) then
			self.guiInventory:update(deltaTime)
		end
	end
end


function GUIManager_C:showGUI(bool)
	self.isGUIShown = bool
	--self:showInventory(not self.isGUIShown)
end


function GUIManager_C:isShowGUI()
	return self.isGUIShown
end


function GUIManager_C:showInventory(bool)
	self.isInventoryShown = bool
	--self:showGUI(not self.isInventoryShown)
end


function GUIManager_C:isShowInventory()
	return self.isInventoryShown
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
	
	if (self.guiInventory) then
		self.guiInventory:delete()
		self.guiInventory = nil
	end
end


function GUIManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("GUIManager_C was deleted.")
	end
end