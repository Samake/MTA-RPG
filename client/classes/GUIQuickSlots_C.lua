GUIQuickSlots_C = inherit(Class)

function GUIQuickSlots_C:constructor(id)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIQuickSlots_C was loaded.")
	end
end


function GUIQuickSlots_C:init()
	if (not self.guiSlots) then
		self.guiSlots = dxQuickSlots:new(0.2, 0.89, 0.6, 0.1)
		self.guiSlots:setPostGUI(true)
		self.guiSlots:setAlpha(180)
	end
end


function GUIQuickSlots_C:update(deltaTime)
	if (self.guiSlots) then
		self.guiSlots:update()
		
		GUIManager_C:getSingleton():setCursorOnGUIElement(self.guiSlots:isCursorInside())
	end
end


function GUIQuickSlots_C:clear()
	if (self.guiSlots) then
		self.guiSlots:delete()
		self.guiSlots = nil
	end
end


function GUIQuickSlots_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("GUIQuickSlots_C was deleted.")
	end
end